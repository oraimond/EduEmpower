//
//  GroupViewModel.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import Foundation

class GroupViewModel: ObservableObject {
    let dummyUsers: [User] = [
        User(fname: "John", lname: "Doe", email: "johndoe@umich.edu"),
        User(fname: "Jane", lname: "Smith", email: "janesmith@umich.edu"),
        User(fname: "Tom", lname: "Johnson", email: "tomjohnson@umich.edu"),
        User(fname: "Emily", lname: "Brown", email: "emilybrown@umich.edu"),
        User(fname: "Michael", lname: "Williams", email: "michaelwilliams@umich.edu")
    ]

    lazy var dummyGroups: [varGroup] = [
        varGroup(groupName: "Chemistry Group", userids: [dummyUsers[0], dummyUsers[1]]),
        varGroup(groupName: "Physics Group", userids: [dummyUsers[2], dummyUsers[3]]),
        varGroup(groupName: "History Group", userids: [dummyUsers[3], dummyUsers[4]])
    ]
    
    lazy var dummyTasks: [varTask] = [
        varTask(title: "Task 1", timeNeeded: 30, dueDate: Date().addingTimeInterval(60 * 60), taskDescription: "This is a description for task 1", members: [dummyUsers[0], dummyUsers[1]], group: dummyGroups[0]),
        varTask(title: "Task 2", timeNeeded: 60, dueDate: Date().addingTimeInterval(60 * 60 * 2), taskDescription: "This is a description for task 2", members: [dummyUsers[2], dummyUsers[3]], group: dummyGroups[1]),
        varTask(title: "Task 3", timeNeeded: 90, dueDate: Date().addingTimeInterval(60 * 60 * 3), taskDescription: "This is a description for task 3", members: [dummyUsers[1], dummyUsers[4]], group: dummyGroups[2]),
        varTask(title: "Task 4", timeNeeded: 120, dueDate: Date().addingTimeInterval(60 * 60 * 4), taskDescription: "This is a description for task 4", members: [dummyUsers[0], dummyUsers[2], dummyUsers[4]], group: dummyGroups[2]),
        varTask(server_id: 5, title: "Task 5", timeNeeded: 150, dueDate: Date().addingTimeInterval(60 * 60 * 5), taskDescription: "This is a description for task 5", members: [dummyUsers[1], dummyUsers[4]], group: dummyGroups[0]),
    ]
}
