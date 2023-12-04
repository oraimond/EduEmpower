//
//  EventStore.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import Foundation

@MainActor
class EventStore: ObservableObject {
    @Published var events = [Event]()
    @Published var preview: Bool
    @Published var changedEvent: Event?
    @Published var movedEvent: Event?

    init(preview: Bool = false) {
        self.preview = preview
        fetchEvents()
    }

    func fetchEvents() {
        if preview {
            events = Event.sampleEvents
        } else {
            EventGetAction().call() { response in
                for event in response {
                    var type = Event.EventType.unspecified
                    if event.type == "gcal" {
                        type = .gcal
                    } else if event.type == "automatedTask" {
                        type = .automatedTask
                    }
                    
                    let event = Event(
                        id: String(event.eventid),
                        eventType: type,
                        start: ISO8601DateFormatter().date(from: event.start) ?? Date(),
                        end: ISO8601DateFormatter().date(from: event.end),
                        note: event.title
                    )
                    
                    if let index = self.events.firstIndex(where: { $0.id == event.id }) {
                        self.events[index] = event
                    } else {
                        self.events.append(event)
                    }
                }
            }
        }
    }

    func delete(_ event: Event) {
        if let index = events.firstIndex(where: {$0.id == event.id}) {
            changedEvent = events.remove(at: index)
        }
    }

    func add(_ event: Event) {
        events.append(event)
        changedEvent = event
    }

    func update(_ event: Event) {
        if let index = events.firstIndex(where: {$0.id == event.id}) {
            movedEvent = events[index]
            events[index].start = event.start
            events[index].end = event.end
            events[index].note = event.note
            events[index].eventType = event.eventType
            changedEvent = event
        }
    }

}
