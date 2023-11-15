//
//  Task.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import Foundation

struct varTask {
    let id = UUID()
    var groupName: String?
    var title: String
    var timeNeeded: Int
    var dueDate: Date
    var taskDescription: String
    var members: [User]
//    var group: UserGroup
}

