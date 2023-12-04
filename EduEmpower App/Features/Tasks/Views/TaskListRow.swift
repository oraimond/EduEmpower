//
//  TaskListRow.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import SwiftUI

struct TaskListRow: View {
    var task: varTask
    @ObservedObject var viewModel: TasksViewModel = TasksViewModel()
    @State private var presentingSingleTask = false
    
    var body: some View {
        NavigationLink(destination: SingleTaskView(task: task)) {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                Text("Est. Duration: \(task.timeNeeded) minutes")
                    .font(.footnote)
                Text("Due date: \(viewModel.dateFormatter.string(from: task.dueDate))")
                    .font(.footnote)
                //            Text(task.taskDescription)
                //                .font(.subheadline)
                Text("Assigned to:")
                    .font(.subheadline)
                HStack{
                    ForEach(task.members, id: \.id) { user in
                        Text(user.fname).font(.footnote)
                    }
                }
            }
        }
    }
}

//#Preview {
//    @ObservedObject var viewModel: TasksViewModel = TasksViewModel()
//    
//    TaskListRow(task: viewModel.dummyTasks[0])
//}
