
import SwiftUI

struct TaskDetailView: View {
    let task: TaskItem

    // Acciones que ejecutará el ViewModel
    let onToggleCompletion: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    @State private var showingDeleteAlert = false

    var body: some View {
        Form {
            Section("Task information") {
                Text(task.title)
                    .font(.headline)

                Text(task.description)
            }

            Section("Priority") {
                Text(task.priority.rawValue)
                    .foregroundStyle(priorityColor)
            }

            Section("Status") {
                Text(task.isCompleted ? "Completed" : "Pending")

                Button(
                    task.isCompleted
                    ? "Mark as pending"
                    : "Mark as completed"
                ) {
                    onToggleCompletion()
                }
            }

            Section {
                Button("Edit task") {
                    onEdit()
                }

                Button("Delete task", role: .destructive) {
                    showingDeleteAlert = true
                }
            }
        }
        .navigationTitle("Task detail")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete task?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }

            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }

    // Color según la prioridad
    private var priorityColor: Color {
        switch task.priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}
