//
//  TaskPutRequest.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/16/23.
//

import Foundation

import Foundation

struct TaskPutRequest: Encodable {
    let id: Int
    let title: String
    let duration: Int
    let due_date: String
    let description: String
    let assigned_users: [String]
    let scheduled: Bool
    let group_id: Int?
}
