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
    @ObservedObject var authStore: AuthStore = AuthStore.shared
    
    @State var newGroup: varGroup?
    
    @State var showingEditGroupView = false
    @State var showingInvitationView = false
    
    var loggedInUser: User {
            User(
                fname: authStore.fname ?? "",
                lname: authStore.lname ?? "",
                email: authStore.email ?? "",
                invitations: authStore.group_invitations
            )
        }
    
    var body: some View {
        NavigationStack{
            // TODO: filter groups and only show if the authStore user is in group's inviter or userids of groupStore.groups
            List(groupsStore.groups.filter { group in
                group.inviter == loggedInUser ||
                group.members.contains(loggedInUser) },
                 id: \.id) { group in
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

