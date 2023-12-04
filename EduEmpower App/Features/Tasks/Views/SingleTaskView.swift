//
//  SingleTaskView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import SwiftUI

struct SingleTaskView: View {
    @ObservedObject var viewModel: TasksViewModel = TasksViewModel()
    @State var task: varTask
    @State var showEditView: Bool = false
    @State var preferredTime: String? = nil
    @State var showingActionSheet = false
    

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(task.title)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.leading)
                
            Group {
                Text("Est. Duration: \(task.timeNeeded) minutes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Due date: \(viewModel.dateFormatter.string(from: task.dueDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(task.taskDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            
            Text("Assigned to:")
                .font(.headline)
            ForEach(task.members, id: \.id) { user in
                Text("\(user.fname)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if task.scheduled {
                Button(action: {}) {
                    Text("Scheduled")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.disabled(true)
            } else {
                Button(action: {
                    self.showingActionSheet = true
                }) {
                    Text("Auto Schedule")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Preferred time to complete this task"), message: Text("Select a time"), buttons: [
                        .default(Text("Morning")) { preferredTime = "morning"; TaskStore.shared.generate_events(task_id: task.id, server_id: task.server_id, preferredTime: self.preferredTime ?? "morning"); task.scheduled = true },
                        .default(Text("Afternoon")) { preferredTime = "afternoon"; TaskStore.shared.generate_events(task_id: task.id, server_id: task.server_id, preferredTime: self.preferredTime ?? "morning"); task.scheduled = true },
                        .default(Text("Evening")) { preferredTime = "evening"; TaskStore.shared.generate_events(task_id: task.id, server_id: task.server_id, preferredTime: self.preferredTime ?? "morning"); task.scheduled = true }
                    ])
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showEditView = true
                }) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .padding()
        .sheet(isPresented: $showEditView) {
            EditTaskView(task: $task)
        }
    }
}

//#Preview {
//    SingleTaskView()
//}
