import SwiftUI

struct ContentView: View {

    // Conectamos la vista con el ViewModel
    @StateObject private var viewModel = MiniTasksViewModel()

    // Estados propios de la interfaz
    @State private var showingForm = false
    @State private var editingTaskID: UUID?
    @State private var searchText = ""
    @State private var path: [UUID] = []

    // Pedimos al ViewModel las tareas que debemos mostrar
    private var displayedTasks: [TaskItem] {
        viewModel.searchTasks(searchText: searchText)
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {

                // Buscador
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("Search tasks", text: $searchText)
                }
                .padding(10)
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

                // Filtro de tareas
                Picker("Filter tasks", selection: $viewModel.selectedFilter) {
                    ForEach(TaskFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Lista de tareas
                if displayedTasks.isEmpty {
                    ContentUnavailableView(
                        "No tasks found",
                        systemImage: "checklist",
                        description: Text("Try another filter or add a task.")
                    )
                } else {
                    List {
                        ForEach(displayedTasks) { task in
                            NavigationLink(value: task.id) {
                                TaskRowView(task: task)
                            }
                        }
                        .onDelete { offsets in
                            // Obtenemos los identificadores de las filas visibles
                            let ids = offsets.map { displayedTasks[$0].id }

                            for id in ids {
                                viewModel.deleteTask(id: id)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("MiniTasks")

            // Botón para crear una tarea
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editingTaskID = nil
                        showingForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }

            // Navegación al detalle
            .navigationDestination(for: UUID.self) { id in
                if let task = viewModel.task(withID: id) {
                    TaskDetailView(
                        task: task,
                        onToggleCompletion: {
                            viewModel.toggleCompletion(id: id)
                        },
                        onEdit: {
                            editingTaskID = id
                            showingForm = true
                        },
                        onDelete: {
                            viewModel.deleteTask(id: id)
                            path.removeLast()
                        }
                    )
                } else {
                    ContentUnavailableView(
                        "Task not found",
                        systemImage: "exclamationmark.circle"
                    )
                }
            }
        }

        // Presentación del formulario
        .sheet(isPresented: $showingForm, onDismiss: {
            editingTaskID = nil
        }) {
            NavigationStack {
                TaskFormView(
                    task: editingTaskID.flatMap {
                        viewModel.task(withID: $0)
                    },
                    onSave: { task in
                        viewModel.saveTask(task)
                    }
                )
            }
        }

        // Alerta de errores
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.clearError() } }
            )
        ) {
            Button("OK", role: .cancel) {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

