//
//  EventListViewRow.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/11/23.
//

import SwiftUI

struct EventListViewRow: View {
    let event: Event
//    @Binding var formType: EventFormType?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(event.eventType.icon)
                        .font(.system(size: 40))
                    Text(event.note)
                }
                HStack {
                    Text("Start:")
                    Text(
                        event.start.formatted(date: .abbreviated,
                                             time: .shortened)
                    )
                }
                HStack {
                    Text("End:")
                    Text(
                        event.end.formatted(date: .abbreviated,
                                             time: .shortened)
                    )
                }

            }
            Spacer()
            Button {
//                formType = .update(event)
            } label: {
                Text("Edit")
            }
            .buttonStyle(.bordered)
        }
    }
}
