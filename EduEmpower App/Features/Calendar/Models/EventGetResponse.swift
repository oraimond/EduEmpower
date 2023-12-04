//
//  EventGetResponse.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/28/23.
//

import Foundation

struct EventGetResponse: Decodable {
    let eventid: Int
    let title: String
    let start: String
    let end: String
    let type: String
    let users: [String]
    let related_task: Int?
}
