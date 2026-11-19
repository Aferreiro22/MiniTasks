import XCTest
@testable import MiniTasks

final class InMemoryTaskRepositoryTests: XCTestCase {

    // Comprueba que podemos guardar una tarea nueva
    func testSaveTaskAddsTask() throws {
        // Arrange: creamos un repositorio vacío
        let repository = InMemoryTaskRepository(tasks: [])

        let task = TaskItem(
            title: "Test task",
            description: "Testing repository",
            priority: .high
        )

        // Act: guardamos la tarea
        try repository.save(task)

        // Assert: comprobamos que se ha guardado
        let savedTasks = try repository.fetchAll()

        XCTAssertEqual(savedTasks.count, 1)
        XCTAssertEqual(savedTasks.first?.title, "Test task")
    }
    
    // Comprueba que podemos eliminar una tarea existente
    func testDeleteTaskRemovesTask() throws {
        
        // Arrange: crea una tarea
        let task = TaskItem(
            title: "Task to delete",
            description: "Testing delete",
            priority: .medium
        )

        let repository = InMemoryTaskRepository(tasks: [task])

        // Act: eliminamos la tarea
        try repository.delete(id: task.id)

        // Assert: comprobamos que el repositorio está vacío
        let remainingTasks = try repository.fetchAll()

        XCTAssertTrue(remainingTasks.isEmpty)
    }

    // Comprueba que se produce un error al ekiminar una tarea inexistente
    func testDeleteUnknownTaskThrowsError() {
        
        // Arrange: creamos un repositorio vacío y un identificador inexistente
        let repository = InMemoryTaskRepository(tasks: [])

        // Act y Assert: comprobamos que eliminar la tera produce un error
        XCTAssertThrowsError(
            try repository.delete(id: UUID())
        )
    }
}
