import SwiftUI

struct TaskFormView: View {

    // Permite cerrar el formulario
    @Environment(\.dismiss) private var dismiss

    // Si es nil, creamos una tarea nueva.
    // Si tiene datos, estamos editando una tarea.
    let task: TaskItem?

    // El formulario comunica la tarea al ViewModel.
    // Devuelve un mensaje si ocurre algún error.
    let onSave: (TaskItem) -> String?

    @State private var title: String
    @State private var taskDescription: String
    @State private var priority: Priority
    @State private var errorMessage: String?

    // Inicializamos los campos según sea una tarea nueva o existente.
    init(task: TaskItem?, onSave: @escaping (TaskItem) -> String?) {
        self.task = task
        self.onSave = onSave

        _title = State(initialValue: task?.title ?? "")
        _taskDescription = State(initialValue: task?.description ?? "")
        _priority = State(initialValue: task?.priority ?? .medium)
    }

    var body: some View {
        Form {
            Section("Task information") {
                TextField("Title", text: $title)

                TextField(
                    "Description",
                    text: $taskDescription,
                    axis: .vertical
                )
                .lineLimit(3...6)
            }

            Section("Priority") {
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle(task == nil ? "New task" : "Edit task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveTask()
                }
            }
        }
    }

    // Comprueba los datos y envía la tarea al ViewModel.
    private func saveTask() {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanTitle.isEmpty else {
            errorMessage = "The title cannot be empty."
            return
        }

        let newTask = TaskItem(
            id: task?.id ?? UUID(),
            title: cleanTitle,
            description: taskDescription,
            priority: priority,
            isCompleted: task?.isCompleted ?? false
        )

        if let error = onSave(newTask) {
            errorMessage = error
        } else {
            dismiss()
        }
    }
}

