//
//  EditGroupView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct EditGroupView: View {
    @Binding var group: varGroup // Pass in the selected group

    @State var groupId: Int
    @State var groupName: String
    @State var groupMembers: [User]
    
    @Environment(\.presentationMode) var presentationMode

    init(group: Binding<varGroup>) {    // Initialize state variables with existing group properties
        self._group = group
        self._groupId = State(initialValue: group.wrappedValue.groupId)
        self._groupName = State(initialValue: group.wrappedValue.groupName)
        self._groupMembers = State(initialValue: group.wrappedValue.members)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Identification Number")) {
                    TextField("Group ID", value: $groupId, formatter: NumberFormatter())
                }
                Section(header: Text("Group Details")) {
                    TextField("Group Name", text: $groupName)
                }
                
                Section(header: Text("Group Members")) {
                    ForEach(groupMembers, id: \.id) { user in
                        Text(user.fname)
                    }
                }
            }
            .navigationBarTitle("Edit group", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Store locally
                        group.groupId = groupId
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
}
