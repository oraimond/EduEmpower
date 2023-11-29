//
//  GroupPostRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupPostRequest: Encodable {
    let groupName: String
    let group_users: [String]
}
