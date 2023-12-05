//
//  EditGroupView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct CreateGroupView: View {
    @ObservedObject var authStore: AuthStore = AuthStore.shared
    @Binding var group: varGroup // Pass in the selected group
    
    @State var title: String
    @State var inviter: User
    @State var invitees: [User]
    @State var userids: [User]
    @State var newMemberEmails: [String]
    @State var newMemberEmail: String
    
    @Environment(\.presentationMode) var presentationMode

    init(group: Binding<varGroup>) {    // Initialize state variables with existing group properties
        self._group = group
        self._title = State(initialValue: group.wrappedValue.title)
        self._inviter = State(initialValue: group.wrappedValue.inviter ?? User(fname: "", lname: "", email: ""))
        self._invitees = State(initialValue: group.wrappedValue.invitees)
        self._userids = State(initialValue: group.wrappedValue.userids)
        self._newMemberEmail = State(initialValue: "")
        self._newMemberEmails = State(initialValue: [])
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Name")) {
                    TextField("Group Name", text: $title)
                }
                Section(header: Text("Group Members Emails")) {
//                    List {
//       }
                    TextField("Add New Email", text: $newMemberEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        if !newMemberEmail.isEmpty {
                            // Add the new email to the array
                            invitees.append(User(fname: "", lname: "", email: newMemberEmail))
                            // Clear the newEmail field for the next input
                            newMemberEmail = ""
                        }
                    }) {
                        Text("Add Email")
                    }

                }
                }
            }
            .navigationBarTitle("Create group", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Store locally
                        group.title = title
                        group.inviter = (User(
                            fname: authStore.fname ?? "",
                            lname: authStore.lname ?? "",
                            email: authStore.email ?? ""
                        ))
                        group.invitees = invitees
                        group.userids.append(User(
                            fname: inviter.fname,
                            lname: inviter.lname,
                            email: inviter.email
                        ))
                        

                        let newGroup = varGroup(
                            id: group.id,
                            server_id: group.server_id,
                            title: title,
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
    

    


