//
//  SignUpRequest.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 12/3/23.
//

import Foundation

struct SignUpRequest: Encodable {
    let fname: String
    let lname: String
    let userid: String
    let email: String
    let password: String
}
