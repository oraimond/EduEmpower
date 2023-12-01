//
//  InvitationPostRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/30/23.
//

import Foundation

struct InvitationPostRequest {
    let groupName: String
    let inviter: User
    let invitees: [User]
}
