//
//  GroupPutRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupPutRequest {
    let id: Int
    let groupName: String
    let inviter: User
    let invitees: [User]
    let members: [User]
}

//struct GroupUser: Decodable {
//    let user_id: String
//    let fname: String
//    let lname: String
//}
