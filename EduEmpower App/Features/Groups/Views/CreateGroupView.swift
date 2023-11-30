//
//  EditGroupView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct CreateGroupView: View {
    @Binding var group: varGroup // Pass in the selected group
    // TODO: Pass in logged-in user info to set as inviter
    @State var groupName: String
    @State var inviter: User
    @State var invitees: [User]
    @State var members: [User]
    @State var newMemberEmail: String
    
    @Environment(\.presentationMode) var presentationMode

    init(group: Binding<varGroup>) {    // Initialize state variables with existing group properties
        self._group = group
        self._groupName = State(initialValue: group.wrappedValue.groupName)
        //TODO: logged-in user is the inviter
        self._inviter = State(initialValue: group.wrappedValue.inviter)
        self._invitees = State(initialValue: group.wrappedValue.invitees)
        //TODO: members should include inviter as default
        self._members = State(initialValue: group.wrappedValue.members)
        self._newMemberEmail = State(initialValue: "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Name")) {
                    TextField("Group Name", text: $groupName)
                }
                
                Section(header: Text("Group Members Emails")) {
                    List {
                        ForEach(invitees, id: \.id) { invitee in
                            TextField("Email", text: $invitees[getIndex(for: invitee)].email)
                                .onChange(of: invitees[getIndex(for: invitee)].email) { newEmail in
                                    if let user = findUser(with: newEmail) {
                                        invitees[getIndex(for: invitee)] = user
                                    }
                                }
                        }
                        TextField("Add New Member", text: $newMemberEmail)
                            .onChange(of: newMemberEmail) { newEmail in
                                let newUser = User(fname: "", lname: "", email: newEmail)
                                invitees.append(newUser)
                            }
                    }
                }
            }
            .navigationBarTitle("Create group", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Store locally
                        group.groupName = groupName
                        group.inviter = inviter
                        group.invitees = invitees
                        group.members.append(inviter)
                        

                        let newGroup = varGroup(
                            id: group.id,
                            server_id: group.server_id,
                            groupName: groupName,
                            inviter: inviter,
                            invitees: invitees,
                            members: group.members
                        )
                        GroupStore.shared.save(newGroup)
                        
                        //TODO: for each invitees, update user's invitations (append this specific group)
                        
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
        if let index = invitees.firstIndex(where: { $0.id == user.id }) {
            return index
        }
        return 0
    }
    
    // TODO find a user based on email
    private func findUser(with email: String) -> User? {
        // Return the corresponding user or nil if not found
        return nil
    }

}
