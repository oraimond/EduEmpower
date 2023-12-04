//
//  GroupTasksView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/15/23.
//

import SwiftUI

struct GroupTasksView: View {
    @State var  group: varGroup
    @Binding var task: [varTask]
    @ObservedObject var viewModel: GroupViewModel = GroupViewModel()
    
    @State var newTask: varTask = varTask( title: "", timeNeeded: 0, dueDate: Date(), taskDescription: "", members: [])
    @State var showingEditTaskView = false
    @State var showingEditGroupView = false
    
    var body: some View {

            NavigationStack{
                List(viewModel.dummyTasks.filter { $0.group == group }, id: \.id) { task in
                    GroupTaskListRow (group: group, task: task)
                }
                .navigationTitle("Group Tasks")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingEditGroupView = true
                        }) {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    ToolbarItem(placement:.navigationBarTrailing) {
                        Button {
                            showingEditTaskView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }

                }
                .sheet(isPresented: $showingEditTaskView) {
                    EditGroupTaskView(group: group, task: $newTask)
                }
                .sheet(isPresented: $showingEditGroupView) {
                    EditGroupView(group: $group)
                }
            }
    }
}

#Preview {
    TasksView()
}
