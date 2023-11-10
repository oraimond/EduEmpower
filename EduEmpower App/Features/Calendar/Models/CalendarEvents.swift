//
//  Events.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import Foundation

struct EventData: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

struct DailyEvents {
    let date: Date
    let events: [EventData]
}
