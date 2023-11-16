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
        User(fname: "John", lname: "Doe", email: "johndoe@umich.edu"),
        User(fname: "Jane", lname: "Smith", email: "janesmith@umich.edu"),
        User(fname: "Tom", lname: "Johnson", email: "tomjohnson@umich.edu"),
        User(fname: "Emily", lname: "Brown", email: "emilybrown@umich.edu"),
        User(fname: "Michael", lname: "Williams", email: "michaelwilliams@umich.edu")
    ]
    
    lazy var dummyGroups: [varGroup] = [
        varGroup(groupName: "Chemistry Group", members: [dummyUsers[0], dummyUsers[1]]),
        varGroup(groupName: "Physics Group", members: [dummyUsers[2], dummyUsers[3]]),
        varGroup(groupName: "History Group", members: [dummyUsers[3], dummyUsers[4]])
    ]
    
    lazy var dummyTasks: [varTask] = [
        varTask(group: dummyGroups[0], title: "Task 1", timeNeeded: 30, dueDate: Date().addingTimeInterval(60 * 60), taskDescription: "This is a description for task 1", members: [dummyUsers[0], dummyUsers[1]]),
        varTask(group: dummyGroups[1], title: "Task 2", timeNeeded: 60, dueDate: Date().addingTimeInterval(60 * 60 * 2), taskDescription: "This is a description for task 2", members: [dummyUsers[2], dummyUsers[3]]),
        varTask(group: dummyGroups[2], title: "Task 3", timeNeeded: 90, dueDate: Date().addingTimeInterval(60 * 60 * 3), taskDescription: "This is a description for task 3", members: [dummyUsers[1], dummyUsers[4]]),
        varTask(group: dummyGroups[2], title: "Task 4", timeNeeded: 120, dueDate: Date().addingTimeInterval(60 * 60 * 4), taskDescription: "This is a description for task 4", members: [dummyUsers[0], dummyUsers[2], dummyUsers[4]]),
        varTask(group: dummyGroups[0], title: "Task 5", timeNeeded: 150, dueDate: Date().addingTimeInterval(60 * 60 * 5), taskDescription: "This is a description for task 5", members: [dummyUsers[1], dummyUsers[4]]),    ]
}
