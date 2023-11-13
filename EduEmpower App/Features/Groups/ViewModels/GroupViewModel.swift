//
//  GroupViewModel.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import Foundation

class GroupViewModel: ObservableObject {
    let dummyUsers: [User] = [
        User(fname: "John", lname: "Doe"),
        User(fname: "Jane", lname: "Smith"),
        User(fname: "Tom", lname: "Johnson"),
        User(fname: "Emily", lname: "Brown"),
        User(fname: "Michael", lname: "Williams")
    ]

    lazy var dummyGroups: [varGroup] = [
        varGroup(groupId: 1, groupName: "Chemistry Group", members: [dummyUsers[0], dummyUsers[1]]),
        varGroup(groupId: 2, groupName: "Physics Group", members: [dummyUsers[2], dummyUsers[3]]),
        varGroup(groupId: 3, groupName: "History Group", members: [dummyUsers[3], dummyUsers[4]])
    ]
    
    lazy var dummyTasks: [varTask] = [
        varTask(groupId: 1, title: "Task 1", timeNeeded: 30, dueDate: Date().addingTimeInterval(60 * 60), taskDescription: "This is a description for task 1", members: [dummyUsers[0], dummyUsers[1]]),
        varTask(groupId: 2, title: "Task 2", timeNeeded: 60, dueDate: Date().addingTimeInterval(60 * 60 * 2), taskDescription: "This is a description for task 2", members: [dummyUsers[2], dummyUsers[3]]),
        varTask(groupId: 3, title: "Task 3", timeNeeded: 90, dueDate: Date().addingTimeInterval(60 * 60 * 3), taskDescription: "This is a description for task 3", members: [dummyUsers[1], dummyUsers[4]]),
        varTask(groupId: 4, title: "Task 4", timeNeeded: 120, dueDate: Date().addingTimeInterval(60 * 60 * 4), taskDescription: "This is a description for task 4", members: [dummyUsers[0], dummyUsers[2], dummyUsers[4]]),
        varTask(groupId: 3, title: "Task 5", timeNeeded: 150, dueDate: Date().addingTimeInterval(60 * 60 * 5), taskDescription: "This is a description for task 5", members: [dummyUsers[1], dummyUsers[4]]),
    ]
}
