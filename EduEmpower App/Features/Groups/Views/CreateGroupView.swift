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
    @State var newMemberEmail: String
    @State var newMemberEmail1: String
    @State var newMemberEmail2: String
    @State var newMemberEmail3: String
    
    @Environment(\.presentationMode) var presentationMode

    init(group: Binding<varGroup>) {    // Initialize state variables with existing group properties
        self._group = group
        self._title = State(initialValue: group.wrappedValue.title)
        self._inviter = State(initialValue: group.wrappedValue.inviter ?? User(fname: "", lname: "", email: ""))
        self._invitees = State(initialValue: group.wrappedValue.invitees)
        self._userids = State(initialValue: group.wrappedValue.userids)
        self._newMemberEmail = State(initialValue: "")
        self._newMemberEmail1 = State(initialValue: "")
        self._newMemberEmail2 = State(initialValue: "")
        self._newMemberEmail3 = State(initialValue: "")

    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Name")) {
                    TextField("Group Name", text: $title)
                }
                Section(header: Text("Group Members Emails")) {
                        List {
                            TextField("Add New Member", text: $newMemberEmail, onCommit: {
                                if !newMemberEmail.isEmpty {
                                    invitees.append(User(fname: "", lname: "", email: newMemberEmail))
                                }
                            })
                            TextField("Add New Member", text: $newMemberEmail1, onCommit: {
                                if !newMemberEmail1.isEmpty {
                                    invitees.append(User(fname: "", lname: "", email: newMemberEmail1))
                                }
                            })
                            TextField("Add New Member", text: $newMemberEmail2, onCommit: {
                                if !newMemberEmail2.isEmpty {
                                    invitees.append(User(fname: "", lname: "", email: newMemberEmail2))
                                }
                            })
                            TextField("Add New Member", text: $newMemberEmail3, onCommit: {
                                if !newMemberEmail3.isEmpty {
                                    invitees.append(User(fname: "", lname: "", email: newMemberEmail3))
                                }
                            })
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
                            
                            print("group inviter:", group.inviter?.email)
                            
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


//                    List {
//                        TextField("Add New Email", text: $newMemberEmail, onCommit: {
//                            if !newMemberEmail.isEmpty {
//                                // Add the new email to the array
//                                invitees.append(User(fname: "", lname: "", email: newMemberEmail))
//                                // Clear the newEmail field for the next input
//                                newMemberEmail = ""
//                            }
//
//                        })
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                    }
//                    
//
//                }
//            }
//        }
//        .navigationBarTitle("Create group", displayMode: .inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    // Store locally
//                    group.title = title
//                    group.inviter = (User(
//                        fname: authStore.fname ?? "",
//                        lname: authStore.lname ?? "",
//                        email: authStore.email ?? ""
//                    ))
//                    group.invitees = invitees
//                    group.userids.append(User(
//                        fname: inviter.fname,
//                        lname: inviter.lname,
//                        email: inviter.email
//                    ))
//                    
//
//                    let newGroup = varGroup(
//                        id: group.id,
//                        server_id: group.server_id,
//                        title: title,
//                        inviter: inviter,
//                        invitees: invitees,
//                        userids: group.userids
//                    )
//                    GroupStore.shared.save(newGroup)
//
//                    
//                    // exit
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Image(systemName: "checkmark.circle.fill")
//                }
//            }
//        }
//    }
//}
//    
//
//    
//
//
