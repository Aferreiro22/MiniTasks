import SwiftUI

// Vista que representa una tarea individual dentro de la lista
struct TaskRowView: View {

    let task: TaskItem

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isCompleted ? .green : .secondary)

            VStack(alignment: .leading, spacing: 5) {

                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)

                Text(task.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text(task.priority.rawValue)
                    .font(.caption)
                    .foregroundStyle(priorityColor)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    // Devuelve un color según la prioridad de la tarea
    private var priorityColor: Color {
        switch task.priority {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

