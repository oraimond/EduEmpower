//
//  ProfileResponse.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/14/23.
//

import Foundation

struct ProfileResponse: Decodable {
    let userid: String
    let first_name: String
    let last_name: String
    let email: String
}
