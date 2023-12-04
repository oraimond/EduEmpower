//
//  LoginResponse.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import Foundation

struct LoginResponse: Decodable {
    let Token: String
    let userid: String
    let expiresat: Double
}
