
import Foundation

//Define las operaciones que debe ofrecer cualquier repositorio
protocol TaskRepository {
    
    //Obtener todas las tareas
    func fetchAll() throws -> [TaskItem]
    
    //Guarda una tarea nueva o actualiza una existente
    func save(_ task: TaskItem) throws
    
    //Elimina una tarea mediante su UUID
    func delete(id: UUID) throws
}

// Posibles errores que puede producir el repositorio
enum TaskRepositoryError: LocalizedError {
    case taskNotFound
    
    var errorDescription: String? {
        switch self {
        case .taskNotFound:
            return "The task no longer exists"
        }
    }
    
}
