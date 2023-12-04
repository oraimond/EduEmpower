//
//  EditGroupView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/15/23.
//

import SwiftUI

struct EditGroupView: View {
    @ObservedObject var authStore: AuthStore = AuthStore.shared
    @Binding var group: varGroup // Pass in the selected group

    @State var groupName: String
    @State var inviter: User
    @State var invitees: [User]
    @State var userids: [User]
    @State var newMemberEmail: String
    
    var loggedInUser: User {
        User(
            fname: authStore.fname ?? "",
            lname: authStore.lname ?? "",
            email: authStore.email ?? ""
        )
    }

    @Environment(\.presentationMode) var presentationMode

    init(group: Binding<varGroup>) {    // Initialize state variables with existing group properties
        self._group = group
        self._groupName = State(initialValue: group.wrappedValue.groupName)
        self._inviter = State(initialValue: group.wrappedValue.inviter ?? User(username: "", fname: "", lname: "", email: ""))
        self._invitees = State(initialValue: group.wrappedValue.invitees)
        self._userids = State(initialValue: group.wrappedValue.userids)
        self._newMemberEmail = State(initialValue: "")
    }

    var body: some View {
        NavigationView {
            Form {
                //only allow editing group name for simplification
                Section(header: Text("Group Name")) {
                    TextField("Group Name", text: $groupName)
                }
                
                Section(header: Text("Group Members Emails")) {
                    List {
                        ForEach(group.userids, id: \.id) { member in
                            TextField("Email", text: $userids[getIndex(for: member)].email)
                                .disabled(true)
                        }
                    }
                }
                Button(action: {
                    // delete
                    var mutableGroup = group
                    mutableGroup.userids = mutableGroup.userids.filter { userid in userid != loggedInUser }
                    GroupStore.shared.save(mutableGroup)
                }) {
                    Text("Delete Group")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                
            }
            .navigationBarTitle("Edit group", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Store locally
                        group.groupName = groupName
                        
                        // send to database
                        // TODO
                        let newGroup = varGroup(
                            id: group.id,
                            server_id: group.server_id,
                            groupName: groupName,
                            inviter: inviter,
                            invitees: invitees,
                            userids: group.userids
                        )
                        GroupStore.shared.save(newGroup)
                        
                        // exit
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
            }
        }
    }
    
    private func getIndex(for user: User) -> Int {
        if let index = userids.firstIndex(where: { $0.id == user.id }) {
            return index
        }
        return 0
    }

}
