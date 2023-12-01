//
//  InvitationGetResponse.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/30/23.
//

import Foundation

struct InvitationGetResponse: Decodable {
    let id: Int
    let groupName: String
    let inviter: InviteUser
    let invitees: [InviteUser]
}

struct InviteUser: Decodable {
    let user_id: String
    let fname: String
    let lname: String
}
