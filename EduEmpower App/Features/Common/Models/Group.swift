//
//  Group.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import Foundation

struct varGroup: Equatable, Identifiable {
    static func == (lhs: varGroup, rhs: varGroup) -> Bool {
        return lhs.groupName == rhs.groupName
    }
    
    let id: UUID
    var server_id: Int?
    var groupName: String
    var inviter: User
    var invitees: [User]
    
    init(id: UUID? = nil, server_id: Int? = nil, groupName: String = "", inviter: User? = nil, invitees: [User] = []) {
        self.id = id ?? UUID()
        self.server_id = server_id
        self.groupName = groupName
        self.inviter = inviter!
        self.invitees = invitees
    }
}
