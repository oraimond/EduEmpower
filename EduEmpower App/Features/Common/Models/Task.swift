//
//  Task.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import Foundation

struct varTask: Identifiable {
    let id: UUID
    var server_id: Int?
    var title: String
    var timeNeeded: Int
    var dueDate: Date
    var taskDescription: String
    var members: [User]
    var scheduled: Bool
    var group: varGroup?
    
    init(id: UUID? = nil, server_id: Int? = nil, title: String = "", timeNeeded: Int = 60, dueDate: Date = Date(), taskDescription: String = "", members: [User] = [], scheduled: Bool = false, group: varGroup? = nil) {
        self.id = id ?? UUID()
        self.server_id = server_id
        self.title = title
        self.timeNeeded = timeNeeded
        self.dueDate = dueDate
        self.taskDescription = taskDescription
        self.members = members
        self.scheduled = scheduled
        self.group = group
    }
}

