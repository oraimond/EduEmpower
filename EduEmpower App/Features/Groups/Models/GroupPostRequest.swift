//
//  GroupPostRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupPostRequest {
    let groupName: String
    let inviter: User
    let invitees: [User]
    let members: [User]
}
