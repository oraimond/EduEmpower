//
//  HomeCalendarView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var eventStore: EventStore
    @State private var dateSelected: DateComponents?
    @State private var displayEvents: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), 
                             eventStore: eventStore,
                             dateSelected: $dateSelected,
                             displayEvents: $displayEvents)
            }
            .sheet(isPresented: $displayEvents) {
                DaysEventsListView(dateSelected: $dateSelected)
                    .presentationDetents([.medium, .large])
            }
            .navigationTitle("Calendar")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(EventStore(preview: true))
}
