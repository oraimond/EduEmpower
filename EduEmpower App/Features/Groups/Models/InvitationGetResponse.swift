//
//  InvitationGetResponse.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct InvitationGetResponse: Decodable {
    let id: Int
    let groupName: String
    let inviter: InvitationUser
    let invitee: InvitationUser
}

struct InvitationUser: Decodable {
    let user_id: String
    let fname: String
    let lname: String
}
