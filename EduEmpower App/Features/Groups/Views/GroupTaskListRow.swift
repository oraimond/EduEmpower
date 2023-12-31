//
//  GroupTaskView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct GroupTaskListRow: View {
    let group: varGroup
    let task: varTask
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
