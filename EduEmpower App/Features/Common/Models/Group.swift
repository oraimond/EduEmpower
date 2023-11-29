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
    var members: [User]
    
    init(id: UUID? = nil, server_id: Int? = nil, groupName: String = "", members: [User] = []) {
        self.id = id ?? UUID()
        self.server_id = server_id
        self.groupName = groupName
        self.members = members
    }
}
