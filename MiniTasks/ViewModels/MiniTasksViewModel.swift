
import Foundation
import Combine

@MainActor
final class MiniTasksViewModel: ObservableObject {

    // Lista de tareas
    @Published private(set) var tasks: [TaskItem] = []

    // Filtro seleccionado
    @Published var selectedFilter: TaskFilter = .all

    // Mensaje de error, si ocurre alguno
    @Published var errorMessage: String?

    // Repositorio que proporciona los datos
    private let repository: any TaskRepository

    // Recibimos el repositorio por inicializador
    init(repository: any TaskRepository = InMemoryTaskRepository()) {
        self.repository = repository
        loadTasks()
    }

    // Devuelve las tareas según el filtro seleccionado
    var filteredTasks: [TaskItem] {
        searchTasks(searchText: "")
    }

    func searchTasks(searchText: String) -> [TaskItem] {
        // Primero aplicamos el filtro de estado.
        let statusFilteredTasks: [TaskItem]

        switch selectedFilter {
        case .all:
            statusFilteredTasks = tasks
        case .pending:
            statusFilteredTasks = tasks.filter { !$0.isCompleted }
        case .completed:
            statusFilteredTasks = tasks.filter { $0.isCompleted }
        }

        // Después aplicamos la búsqueda por título o descripción.
        let search = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !search.isEmpty else {
            return statusFilteredTasks
        }

        return statusFilteredTasks.filter { task in
            task.title.localizedStandardContains(search) ||
            task.description.localizedStandardContains(search)
        }
    }

    // Busca una tarea por su identificador
    func task(withID id: UUID) -> TaskItem? {
        tasks.first { $0.id == id }
    }

    // Guarda una tarea nueva o actualizada
    func saveTask(_ task: TaskItem) -> String? {
        do {
            try repository.save(task)
            try refreshTasks()
            errorMessage = nil
            return nil
        } catch {
            let message = error.localizedDescription
            errorMessage = message
            return message
        }
    }

    // Elimina una tarea
    func deleteTask(id: UUID) {
        do {
            try repository.delete(id: id)
            try refreshTasks()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Cambia entre tarea pendiente y completada
    func toggleCompletion(id: UUID) {
        guard var task = task(withID: id) else {
            errorMessage = TaskRepositoryError.taskNotFound.localizedDescription
            return
        }

        task.isCompleted.toggle()

        do {
            try repository.save(task)
            try refreshTasks()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Limpia el mensaje de error
    func clearError() {
        errorMessage = nil
    }

    // Carga inicial de tareas
    private func loadTasks() {
        do {
            try refreshTasks()
        } catch {
            tasks = []
            errorMessage = error.localizedDescription
        }
    }

    // Actualiza la lista desde el repositorio
    private func refreshTasks() throws {
        tasks = try repository.fetchAll()
    }
}

