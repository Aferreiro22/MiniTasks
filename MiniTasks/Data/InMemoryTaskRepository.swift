import Foundation

// Repositorio que guarda las tareas en memoria.
final class InMemoryTaskRepository: TaskRepository {

    private var tasks: [TaskItem]

    // Podemos proporcionar tareas iniciales o utilizar las de ejemplo.
    init(tasks: [TaskItem] = InMemoryTaskRepository.sampleTasks) {
        self.tasks = tasks
    }

    // Devuelve todas las tareas.
    func fetchAll() throws -> [TaskItem] {
        return tasks
    }

    // Guarda una tarea o actualiza una que ya existe.
    func save(_ task: TaskItem) throws {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
    }

    // Elimina una tarea.
    func delete(id: UUID) throws {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            throw TaskRepositoryError.taskNotFound
        }

        tasks.remove(at: index)
    }

    // Datos iniciales para probar la aplicación.
    static let sampleTasks = [
        TaskItem(
            title: "Learn SwiftUI",
            description: "Study the basics of SwiftUI",
            priority: .high
        ),
        TaskItem(
            title: "Complete exercises",
            description: "Practice what I have learned",
            priority: .medium
        ),
        TaskItem(
            title: "Review notes",
            description: "Review previous lessons",
            priority: .low,
            isCompleted: true
        )
    ]
}
