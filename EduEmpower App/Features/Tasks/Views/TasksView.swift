//
//  TasksView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI

struct TasksView: View {
    @ObservedObject var viewModel: TasksViewModel = TasksViewModel()
    @ObservedObject var tasksStore: TaskStore = TaskStore.shared
    
    @State var showingEditTaskView = false
    @State var newTask: varTask?
    
    var body: some View {
        NavigationStack{
            List(tasksStore.tasks, id: \.id) { task in
                TaskListRow(task: task)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing) {
                    Button {
                        newTask = varTask()
                        showingEditTaskView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $newTask, onDismiss: { newTask = nil }) { task in
                EditTaskView(task: Binding.constant(task))
            }
        }
        .task {
            TaskStore.shared.fetchTasks()
        }
        .refreshable {
            TaskStore.shared.fetchTasks()
        }
    }
}

#Preview {
    TasksView()
}
