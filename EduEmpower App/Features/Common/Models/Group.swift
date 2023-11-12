//
//  Group.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import Foundation

struct UserGroup {
    let id = UUID()
    var title: String
    var users: [User]
}
