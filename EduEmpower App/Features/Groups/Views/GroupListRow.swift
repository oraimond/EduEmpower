//
//  GroupListRow.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct GroupListRow: View {
    let group: varGroup
    @Binding var task: [varTask]
    @ObservedObject var viewModel: GroupViewModel = GroupViewModel()
    
    var body: some View {
        NavigationLink(destination: GroupTasksView (group: group, task: $task)) {
            VStack(alignment: .leading) {
                Text(group.title)
                    .font(.headline)
            }
        }
    }
}
