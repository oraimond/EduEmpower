//
//  GroupInvitationView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/15/23.
//

import SwiftUI

struct GroupInvitationView: View {
    @ObservedObject var viewModel: GroupViewModel = GroupViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            List(viewModel.dummyInvitations, id: \.id) { invitation in
                VStack(alignment: .leading) {
                    Text(invitation.inviter.fname + " invites you to join " + invitation.group.groupName)
                        .font(.subheadline)
                    HStack {
                        Button(action: {
                            // TODO add to groups
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
                            // Delete from Invitations
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
