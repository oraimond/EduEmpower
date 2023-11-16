//
//  Group.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import Foundation

struct varGroup: Equatable {
    static func == (lhs: varGroup, rhs: varGroup) -> Bool {
        return lhs.groupName == rhs.groupName
    }
    
    let id = UUID()
    var groupName: String
    var members: [User]
}
