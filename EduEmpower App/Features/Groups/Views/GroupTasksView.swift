//
//  GroupTasksView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/15/23.
//

import SwiftUI

struct GroupTasksView: View {
    let group: varGroup
    @Binding var task: [varTask]
    @ObservedObject var viewModel: TasksViewModel = TasksViewModel()
    
    @State var newTask: varTask = varTask( title: "", timeNeeded: 0, dueDate: Date(), taskDescription: "", members: [])
    @State var showingEditTaskView = false
    
    var body: some View {
//        ForEach(task.filter { $0.groupName == group.groupName }, id: \.id) { task in
            NavigationStack{
                List(viewModel.dummyTasks, id: \.id) { task in
                    GroupTaskListRow (group: group, task: $task)
                }
                .navigationTitle("Group Tasks")
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
//        }
    }
}

#Preview {
    TasksView()
}
