//
//  GroupPostRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupPostRequest: Encodable {
    let groupName: String
    let inviter: String
    let invitees: [String]
    let members: [String]
}
