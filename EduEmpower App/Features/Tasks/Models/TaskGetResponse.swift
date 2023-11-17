//
//  TaskGetResponse.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/15/23.
//

import Foundation

struct TaskGetResponse: Decodable {
    let id: Int
    let title: String
    let duration: Int
    let due_date: String
    let description: String
    let assigned_users: [AssignedUser]
    let scheduled: Bool
    let group_id: Int?
}

struct AssignedUser: Decodable {
    let user_id: String
    let fname: String
    let lname: String
}
