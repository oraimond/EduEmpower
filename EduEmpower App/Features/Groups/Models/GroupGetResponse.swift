//
//  GroupGetResponse.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupGetResponse: Decodable {
    let groupid: Int
    let title: String
    let inviter: GroupUser
    let invitees: [GroupUser]
    let userids: [GroupUser]
}

struct GroupUser: Decodable {
    let userid: String
    let fname: String
    let lname: String
}
