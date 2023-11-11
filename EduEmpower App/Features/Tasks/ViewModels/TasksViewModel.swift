//
//  TasksViewModel.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import Foundation

class TasksViewModel: ObservableObject {

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    

    
    let dummyUsers: [User] = [
        User(fname: "John", lname: "Doe"),
        User(fname: "Jane", lname: "Smith"),
        User(fname: "Tom", lname: "Johnson"),
        User(fname: "Emily", lname: "Brown"),
        User(fname: "Michael", lname: "Williams")
    ]
    
    lazy var dummyTasks: [varTask] = [
        varTask(title: "Task 1", timeNeeded: 30, dueDate: Date().addingTimeInterval(60 * 60), taskDescription: "This is a description for task 1", members: [dummyUsers[0], dummyUsers[1]]),
        varTask(title: "Task 2", timeNeeded: 60, dueDate: Date().addingTimeInterval(60 * 60 * 2), taskDescription: "This is a description for task 2", members: [dummyUsers[2], dummyUsers[3]]),
        varTask(title: "Task 3", timeNeeded: 90, dueDate: Date().addingTimeInterval(60 * 60 * 3), taskDescription: "This is a description for task 3", members: [dummyUsers[1], dummyUsers[4]]),
        varTask(title: "Task 4", timeNeeded: 120, dueDate: Date().addingTimeInterval(60 * 60 * 4), taskDescription: "This is a description for task 4", members: [dummyUsers[0], dummyUsers[2], dummyUsers[4]]),
        varTask(title: "Task 5", timeNeeded: 150, dueDate: Date().addingTimeInterval(60 * 60 * 5), taskDescription: "This is a description for task 5", members: [dummyUsers[3], dummyUsers[4]]),
    ]
}
