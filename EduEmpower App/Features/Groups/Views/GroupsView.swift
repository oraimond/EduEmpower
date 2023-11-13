//
//  GroupsView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI

struct GroupsView: View {
    @ObservedObject var viewModel: GroupViewModel = GroupViewModel()
    
    @State var newGroup: varGroup = varGroup(groupId: -1, groupName: "", members: [])
    
    @State var showingEditGroupView = false
    
    var body: some View {
        NavigationStack{
            List(viewModel.dummyGroups, id: \.id) { group in
                GroupListRow(group: group, task: $viewModel.dummyTasks)
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing) {
                    Button {
                        showingEditGroupView = true
                    } label: {
                        Image(systemName: "plus.square")
                    }
                }
            }
            .sheet(isPresented: $showingEditGroupView) {
                EditGroupView(group: $newGroup)
            }
        }
    }
}

#Preview {
    GroupsView()
}

