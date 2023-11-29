//
//  GroupsView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI

struct GroupsView: View {
    @ObservedObject var viewModel: GroupViewModel = GroupViewModel()
    @ObservedObject var groupsStore: GroupStore = GroupStore.shared
    @ObservedObject var tasksStore: TaskStore = TaskStore.shared
    
    @State var newGroup: varGroup?
    
    @State var showingEditGroupView = false
    @State var showingInvitationView = false
    
    var body: some View {
        NavigationStack{
            List(groupsStore.groups, id: \.id) { group in
                GroupListRow(group: group, task: $tasksStore.tasks)
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing) {
                    Button {
                        newGroup = varGroup()
                        showingEditGroupView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $newGroup, onDismiss: { newGroup = nil }) {
                group in
                CreateGroupView(group: Binding.constant(group))
            }
            
            Spacer()
            
            Button(action: {
                showingInvitationView = true
            }) {
                Text("Invitation")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showingInvitationView) {
                GroupInvitationView()
            }
        }
    }
}

#Preview {
    GroupsView()
}

