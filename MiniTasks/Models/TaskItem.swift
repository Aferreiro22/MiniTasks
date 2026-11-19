import Foundation

// Prioridad de una tarea
enum Priority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

// Filtro para mostrar todas las tareas, las pendientes o las completadas
enum TaskFilter: String, CaseIterable {
    case all = "All"
    case pending = "Pending"
    case completed = "Completed"
}

// Modelo que representa una tarea, independiente de SwiftUI
struct TaskItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var priority: Priority
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        priority: Priority,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.priority = priority
        self.isCompleted = isCompleted
    }
}
