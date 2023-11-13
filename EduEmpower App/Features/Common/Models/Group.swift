//
//  Group.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import Foundation

struct varGroup {
    let id = UUID()
    var groupId: Int
    var groupName: String
    var members: [User]
}
