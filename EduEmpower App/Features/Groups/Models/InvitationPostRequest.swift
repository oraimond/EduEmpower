//
//  InvitationPostRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/30/23.
//

import Foundation

struct InvitationPostRequest: Encodable {
    let groupName: String
    let inviter: String
    let invitees: [String]
}
