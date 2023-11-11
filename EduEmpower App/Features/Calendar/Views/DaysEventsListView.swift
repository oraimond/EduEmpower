//
//  DaysEventsListView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import SwiftUI

struct DaysEventsListView: View {
    @EnvironmentObject var eventStore: EventStore
    @Binding var dateSelected: DateComponents?
//    @State private var formType: EventFormType?
    
    var body: some View {
        NavigationView {
            Group {
                if let dateSelected {
                    let foundEvents = eventStore.events
                        .filter { $0.start.startOfDay == dateSelected.date!.startOfDay }
                    List {
                        ForEach(foundEvents) { event in
                                EventListViewRow(event: event)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    DaysEventsListView()
//}
