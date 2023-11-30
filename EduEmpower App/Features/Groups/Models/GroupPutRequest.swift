//
//  GroupPutRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupPutRequest: Encodable {
    let id: Int
    let groupName: String
    let inviter: String
    let invitees: [String]
}
