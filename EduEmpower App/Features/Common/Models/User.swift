//
//  User.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import Foundation

struct User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
    let id = UUID()
    var username: String
    var fname: String
    var lname: String
    var email: String
}
