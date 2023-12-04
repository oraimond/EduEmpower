//
//  HomeCalendarView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var eventStore: EventStore
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    @State private var dateSelected: DateComponents?
    @State private var displayEvents: Bool = false
    @State private var displaySignIn: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), 
                             eventStore: eventStore,
                             dateSelected: $dateSelected,
                             displayEvents: $displayEvents)
                Button(action: {
                    displaySignIn = true
                }) {
                    Text("Import Google Calendar")
                        .font(.headline)
                        .padding()
                        .frame(alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .sheet(isPresented: $displayEvents) {
                DaysEventsListView(dateSelected: $dateSelected)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $displaySignIn) {
                GoogleSignInView(isPresented: $displaySignIn, eventStore: eventStore)
            }
            .navigationTitle("Calendar")
        }
        .refreshable {
            eventStore.fetchEvents()
        }
        .task {
            eventStore.fetchEvents()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(EventStore(preview: true))
}
