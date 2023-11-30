//
//  GroupStore.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/16/23.
//

import Foundation

class GroupStore: ObservableObject {
    static let shared = GroupStore()
    
    @Published var groups = [varGroup]()
    
    private init() {}
    
    func fetchGroups() {
        GroupGetAction().call() { response in
            for group in response {
                let invitees = group.group_users.map {
                    User(username: $0.user_id, fname: $0.fname, lname: $0.lname, email: "TODO")
                }
                
                self.save(varGroup(
                    id: UUID(),
                    server_id: group.id,
                    groupName: group.groupName,
                    invitees: group.invitees
                ), fetching: true)
                
            }
        }
    }
    
    func delete(group_id: UUID, server_id: Int?) {
        if let index = groups.firstIndex(where: { $0.id == group_id}) {
            groups.remove(at: index)
            if let server_id {
                GroupDeleteAction(server_id: server_id).call()
            }
        } else {
            print("Unable to delete task")
        }
    }
    
    func save(_ group: varGroup, fetching: Bool = false) {
        if fetching {
            if let index = groups.firstIndex(where: { $0.server_id == group.server_id}) {
                groups[index] = group
            } else {
                groups.append(group)
            }
        } else {
            if let index = groups.firstIndex(where: { $0.id == group.id}) {
                if let server_id = group.server_id {
                    GroupPutAction(parameters: GroupPutRequest(
                        id: server_id,
                        groupName: group.groupName,
                        group_users: [] //TODO
                    )).call() { response in
                        if response.id == server_id {
                            self.groups[index] = group
                        }
                    }
                } else {
                    print("Error updating group")
                }
            } else {
                GroupPostAction(parameters: GroupPostRequest(
                    groupName: group.groupName,
                    group_users: [] //TODO
                )).call() { response in
                    var groupCopy = group
                    groupCopy.server_id = response.id
                    self.groups.append(groupCopy)
                }
            }
        }
    }
    
}
