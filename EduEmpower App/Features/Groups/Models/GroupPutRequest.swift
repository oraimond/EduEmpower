//
//  GroupPutRequest.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupPutRequest: Encodable {
    let groupid: Int
    let title: String
    let inviter: String
    let invitees: [String]
    let userids: [String]
}

//struct GroupUser: Decodable {
//    let user_id: String
//    let fname: String
//    let lname: String
//}
