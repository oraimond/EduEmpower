//
//  EditGroupTaskView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/15/23.
//

import SwiftUI

struct EditGroupTaskView: View {
    let group: varGroup
    @Binding var task: varTask // Pass in the selected Task

    @State var taskTitle: String
    @State var taskDuration: Int
    @State var taskDueDate: Date
    @State var taskDescription: String
    @State private var members: [User]
    
    @Environment(\.presentationMode) var presentationMode

    init(group: varGroup, task: Binding<varTask>) {    // Initialize state variables with existing task properties
        self.group = group
        self._task = task
        self._taskTitle = State(initialValue: task.wrappedValue.title)
        self._taskDuration = State(initialValue: task.wrappedValue.timeNeeded)
        self._taskDueDate = State(initialValue: task.wrappedValue.dueDate)
        self._taskDescription = State(initialValue: task.wrappedValue.taskDescription)
        self._members = State(initialValue: task.wrappedValue.members)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $taskTitle)
                    TextField("Duration in Min", value: $taskDuration, formatter: NumberFormatter())
                    DatePicker("Due Date", selection: $taskDueDate, displayedComponents: .date)
                    TextField("Description", text: $taskDescription, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section(header: Text("Assigned Users")) {
                    ForEach(members, id: \.id) { user in
                        Text(user.fname)
                    }
                }
                
                Button(action: {
                    // delete
                }) {
                    Text("Delete task")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            .navigationBarTitle("Edit Task", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Store locally
                        task.title = taskTitle
                        task.groupName = group.groupName
                        task.timeNeeded = taskDuration
                        task.dueDate = taskDueDate
                        task.taskDescription = taskDescription
                        task.members = members
                        
                        // send to database - specifically for the assigned group
                        // TODO
                        
                        // exit
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
            }
        }
    }
}

