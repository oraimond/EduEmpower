//
//  TaskPutRequest.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/16/23.
//

import Foundation

struct TaskPutRequest: Encodable {
    let taskid: Int
    let title: String
    let duration: Int
    let due_date: String
    let description: String
    let userids: [String]
    let scheduled: Bool
    let group_id: Int?
}
