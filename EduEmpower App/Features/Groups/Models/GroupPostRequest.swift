//
//  GroupPostRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupPostRequest: Encodable {
    let title: String
    let inviter: String
    let invitees: [String]
    let userids: [String]
}
