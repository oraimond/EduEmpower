//
//  ContentView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    @ObservedObject var authStore: AuthStore = AuthStore.shared
    
    var body: some View {
        
        if authStore.loggedIn {
            TabView(selection: $selectedTab) {
                HomeView()
                    .environmentObject(EventStore(preview: true))
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Home")
                    }.tag(0)
                
                GroupsView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Groups")
                    }.tag(1)
                
                TasksView()
                    .tabItem {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Tasks")
                    }.tag(2)
                
                StatisticsView()
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Statistics")
                    }.tag(3)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }.tag(4)
            }
        } else {
            LoginView()
        }
    }
}
