//
//  GroupGetResponse.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupGetResponse: Decodable {
    let id: Int
    let groupName: String
    let inviter: GroupUser
    let invitees: [GroupUser]
    let members: [GroupUser]
}

struct GroupUser: Decodable {
    let user_id: String
    let fname: String
    let lname: String
}
