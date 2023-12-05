//
//  Group.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import Foundation

struct varGroup: Equatable, Identifiable {
    static func == (lhs: varGroup, rhs: varGroup) -> Bool {
        return lhs.title == rhs.title
    }
    
    let id: UUID
    var server_id: Int?
    var title: String
    var inviter: User?
    var invitees: [User]
    var userids: [User] // inviter + invitees who accepted
    
    init(id: UUID? = nil, server_id: Int? = nil, title: String = "", inviter: User? = nil, invitees: [User] = [], userids: [User] = []) {
        self.id = id ?? UUID()
        self.server_id = server_id
        self.title = title
        self.inviter = inviter
        self.invitees = invitees
        self.userids = userids
    }
}
