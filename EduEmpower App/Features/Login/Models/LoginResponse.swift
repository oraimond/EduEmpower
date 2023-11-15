//
//  LoginResponse.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import Foundation

struct LoginResponse: Decodable {
    let token: String
    let user_id: String
    let expires_at: String
}
