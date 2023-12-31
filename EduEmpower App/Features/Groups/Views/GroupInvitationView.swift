//
//  GroupInvitationView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/15/23.
//

import SwiftUI

struct GroupInvitationView: View {
    @ObservedObject var viewModel: GroupViewModel = GroupViewModel()
    @ObservedObject var groupsStore: GroupStore = GroupStore.shared
    @ObservedObject var authStore: AuthStore = AuthStore.shared

    var loggedInUser: User {
        User(
            fname: authStore.fname ?? "",
            lname: authStore.lname ?? "",
            email: authStore.email ?? ""
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Invitations")) {
                    ForEach(groupsStore.groups.filter { group in
                        group.invitees.contains{ invitee in
                            invitee.email == loggedInUser.email
                        }
                    }, id: \.id) { group in
                        VStack(alignment: .leading) {
                            Text(group.inviter.fname + " invites you to join " + group.title)
                                .font(.subheadline)
                            HStack {
                                Button(action: {
                                    // TODO add to groups
                                    var mutableGroup = group
                                    mutableGroup.userids.append(loggedInUser)
                                    mutableGroup.invitees = mutableGroup.invitees.filter { invitee in
                                        invitee != loggedInUser
                                    }
                                    GroupStore.shared.save(mutableGroup)
                                }) {
                                    Text("Accept")
                                        .font(.caption)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.top, 10)
                                Button(action: {
                                    // Delete from Invitees
                                    var mutableGroup = group
                                    mutableGroup.invitees = mutableGroup.invitees.filter { invitee in
                                        invitee != loggedInUser
                                    }
                                    GroupStore.shared.save(mutableGroup, fetching: true)
                                }) {
                                    Text("Decline")
                                        .font(.caption)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.top, 10)

                            }
                        }
                    }
                }
            }
        }
    }
}
