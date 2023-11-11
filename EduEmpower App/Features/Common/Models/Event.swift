//
//  Event.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import Foundation

struct Event: Identifiable {
    enum EventType: String, Identifiable, CaseIterable {
        case gcal, automatedTask, unspecified
        var id: String {
            self.rawValue
        }

        var icon: String {
            switch self {
            case .gcal:
                return "📆"
            case .automatedTask:
                return "🤖"
            case .unspecified:
                return "🗓️"
            }
        }
    }

    var eventType: EventType
    var start: Date
    var end: Date
    var note: String
    var id: String
    
    var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents(
            [.month,
             .day,
             .year,
             .hour,
             .minute],
            from: start)
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }

    init(id: String = UUID().uuidString, eventType: EventType = .unspecified, start: Date, end: Date? = nil, note: String) {
        self.eventType = eventType
        self.start = start
        self.end = end ?? start.addingTimeInterval(3600)
        self.note = note
        self.id = id
    }

    // Data to be used in the preview
    static var sampleEvents: [Event] {
        return [
            Event(eventType: .gcal, start: Date().diff(numDays: 0), note: "Take dog to groomers"),
            Event(start: Date().diff(numDays: -1), note: "Get gift for Emily"),
            Event(eventType: .gcal, start: Date().diff(numDays: 6), note: "File tax returns."),
            Event(eventType: .automatedTask, start: Date().diff(numDays: 2), note: "Dinner party at Dave and Janet's"),
            Event(eventType: .gcal, start: Date().diff(numDays: -1), note: "Complete Audit."),
            Event(eventType: .automatedTask, start: Date().diff(numDays: -3), note: "Football Game"),
            Event(start: Date().diff(numDays: -4), note: "Plan for winter vacation.")
        ]
    }
}

extension Date {
    func diff(numDays: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: numDays, to: self)!
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
