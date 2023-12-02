//
//  Invitation.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/15/23.
//

import Foundation

struct varInvitation: Identifiable {
    let id: UUID
    var server_id: Int? // id for group?
    var inviter: User
    var invitee: User
    var groupName: String
    
    init(id: UUID? = nil, server_id: Int? = nil, inviter: User? = nil, invitee: User? = nil, groupName: String? = "") {
        self.id = id ?? UUID()
        self.server_id = server_id
        self.inviter = inviter!
        self.invitee = invitee!
        self.groupName = groupName ?? ""
    }
}
