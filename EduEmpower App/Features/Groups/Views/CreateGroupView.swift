//
//  EditGroupView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct CreateGroupView: View {
    @Binding var group: varGroup // Pass in the selected group

    @State var groupName: String
    @State var groupMembers: [User]
    @State var newMemberEmail: String
    
    @Environment(\.presentationMode) var presentationMode

    init(group: Binding<varGroup>) {    // Initialize state variables with existing group properties
        self._group = group
        self._groupName = State(initialValue: group.wrappedValue.groupName)
        self._groupMembers = State(initialValue: group.wrappedValue.members)
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
                        ForEach(groupMembers, id: \.id) { member in
                            TextField("Email", text: $groupMembers[getIndex(for: member)].email)
                                .onChange(of: groupMembers[getIndex(for: member)].email) { newEmail in
                                    if let user = findUser(with: newEmail) {
                                        groupMembers[getIndex(for: member)] = user
                                    }
                                }
                        }
                        TextField("Add New Member", text: $newMemberEmail)
                            .onChange(of: newMemberEmail) { newEmail in
                                let newUser = User(fname: "", lname: "", email: newEmail)
                                groupMembers.append(newUser)
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
                        group.members = groupMembers
                        
                        // send to database
                        // TODO
                        
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
        if let index = groupMembers.firstIndex(where: { $0.id == user.id }) {
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
