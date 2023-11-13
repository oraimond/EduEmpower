//
//  TasksView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI

struct TasksView: View {
    @ObservedObject var viewModel: TasksViewModel = TasksViewModel()
    
    @State var newTask: varTask = varTask( title: "", timeNeeded: 0, dueDate: Date(), taskDescription: "", members: [])
    @State var showingEditTaskView = false
    
    var body: some View {
        NavigationStack{
            List(viewModel.dummyTasks, id: \.id) { task in
                TaskListRow(task: task)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing) {
                    Button {
                        showingEditTaskView = true
                    } label: {
                        Image(systemName: "plus.square")
                    }
                }
            }
            .sheet(isPresented: $showingEditTaskView) {
                EditTaskView(task: $newTask)
            }
        }
    }
}

#Preview {
    TasksView()
}
