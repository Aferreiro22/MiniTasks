
import XCTest
@testable import MiniTasks

final class MiniTasksViewModelTests: XCTestCase {

    // Comprueba que el ViewModel carga las tareas iniciales
    @MainActor
    func testViewModelLoadsInitialTasks() {
        // Arrange: creamos un repositorio con dos tareas
        let tasks = [
            TaskItem(
                title: "Task 1",
                description: "First task",
                priority: .high
            ),
            TaskItem(
                title: "Task 2",
                description: "Second task",
                priority: .low
            )
        ]

        let repository = InMemoryTaskRepository(tasks: tasks)

        // Act: creamos el ViewModel
        let viewModel = MiniTasksViewModel(repository: repository)

        // Assert: comprobamos que ha cargado las dos tareas
        XCTAssertEqual(viewModel.tasks.count, 2)
        XCTAssertEqual(viewModel.tasks.first?.title, "Task 1")
    }

    // Comprueba que el filtro muestra únicamente las tareas pendientes
    @MainActor
    func testFilterPendingTasks() {
        // Arrange: creamos una tarea pendiente y otra completada
        let pendingTask = TaskItem(
            title: "Pending task",
            description: "Not completed",
            priority: .high
        )

        let completedTask = TaskItem(
            title: "Completed task",
            description: "Already completed",
            priority: .low,
            isCompleted: true
        )

        let repository = InMemoryTaskRepository(
            tasks: [pendingTask, completedTask]
        )

        let viewModel = MiniTasksViewModel(repository: repository)

        // Act: seleccionamos el filtro de pendientes
        viewModel.selectedFilter = .pending

        // Assert: comprobamos que solo aparece la tarea pendiente
        XCTAssertEqual(viewModel.filteredTasks.count, 1)
        XCTAssertEqual(viewModel.filteredTasks.first?.title, "Pending task")
    }

    // Comprueba que el filtro muestra únicamente las tareas completadas
    @MainActor
    func testFilterCompletedTasks() {
        // Arrange: creamos una tarea pendiente y otra completada
        let pendingTask = TaskItem(
            title: "Pending task",
            description: "Not completed",
            priority: .high
        )

        let completedTask = TaskItem(
            title: "Completed task",
            description: "Already completed",
            priority: .low,
            isCompleted: true
        )

        let repository = InMemoryTaskRepository(
            tasks: [pendingTask, completedTask]
        )

        let viewModel = MiniTasksViewModel(repository: repository)

        // Act: seleccionamos el filtro de completadas
        viewModel.selectedFilter = .completed

        // Assert: comprobamos que solo aparece la tarea completada
        XCTAssertEqual(viewModel.filteredTasks.count, 1)
        XCTAssertEqual(viewModel.filteredTasks.first?.title, "Completed task")
    }

    // Comprueba que se puede guardar una tarea desde el ViewModel
    @MainActor
    func testSaveTaskAddsTaskToViewModel() {
        // Arrange: creamos un repositorio vacío y una tarea
        let repository = InMemoryTaskRepository(tasks: [])
        let viewModel = MiniTasksViewModel(repository: repository)

        let task = TaskItem(
            title: "New task",
            description: "Created from test",
            priority: .high
        )

        // Act: guardamos la tarea desde el ViewModel
        let error = viewModel.saveTask(task)

        // Assert: comprobamos que se ha guardado sin errores
        XCTAssertNil(error)
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "New task")
    }

    // Comprueba que se puede cambiar el estado de una tarea
    @MainActor
    func testToggleCompletionChangesTaskStatus() {
        // Arrange: creamos una tarea pendiente
        let task = TaskItem(
            title: "Test completion",
            description: "Testing task status",
            priority: .medium
        )

        let repository = InMemoryTaskRepository(tasks: [task])
        let viewModel = MiniTasksViewModel(repository: repository)

        // Act: marcamos la tarea como completada
        viewModel.toggleCompletion(id: task.id)

        // Assert: comprobamos que ha cambiado su estado
        XCTAssertTrue(viewModel.tasks.first?.isCompleted == true)
    }

    // Comprueba que se puede eliminar una tarea desde el ViewModel
    @MainActor
    func testDeleteTaskRemovesTaskFromViewModel() {
        // Arrange: creamos una tarea y un repositorio que la contiene
        let task = TaskItem(
            title: "Task to delete",
            description: "Testing deletion",
            priority: .medium
        )

        let repository = InMemoryTaskRepository(tasks: [task])
        let viewModel = MiniTasksViewModel(repository: repository)

        // Act: eliminamos la tarea
        viewModel.deleteTask(id: task.id)

        // Assert: comprobamos que ya no está en la lista
        XCTAssertTrue(viewModel.tasks.isEmpty)
    }

    // Comprueba que se pueden buscar tareas por su título
    @MainActor
    func testSearchTasksByTitle() {
        // Arrange: creamos dos tareas con títulos diferentes
        let tasks = [
            TaskItem(
                title: "Learn SwiftUI",
                description: "Study programming",
                priority: .high
            ),
            TaskItem(
                title: "Buy groceries",
                description: "Go to the supermarket",
                priority: .low
            )
        ]

        let repository = InMemoryTaskRepository(tasks: tasks)
        let viewModel = MiniTasksViewModel(repository: repository)

        // Act: buscamos una tarea por su título
        let results = viewModel.searchTasks(searchText: "SwiftUI")

        // Assert: comprobamos que encontramos la tarea correcta
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Learn SwiftUI")
    }

    // Comprueba que se pueden buscar tareas por su descripción
    @MainActor
    func testSearchTasksByDescription() {
        // Arrange: creamos dos tareas con descripciones diferentes
        let tasks = [
            TaskItem(
                title: "Task one",
                description: "Study programming",
                priority: .high
            ),
            TaskItem(
                title: "Task two",
                description: "Go shopping",
                priority: .low
            )
        ]

        let repository = InMemoryTaskRepository(tasks: tasks)
        let viewModel = MiniTasksViewModel(repository: repository)

        // Act: buscamos una tarea por su descripción
        let results = viewModel.searchTasks(searchText: "programming")

        // Assert: comprobamos que encontramos la tarea correcta
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Task one")
    }
}

