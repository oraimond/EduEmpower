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
        GroupGetAction(parameters: ProfileRequest(userid: AuthStore.shared.getUsername())).call() { response in
            for group in response {
                let inviter = (User(
                    fname: AuthStore.shared.fname ?? "",
                    lname: AuthStore.shared.lname ?? "",
                    email: AuthStore.shared.email ?? ""
                ))
                let invitees = group.invitees.map {
                    User(username: $0.userid, fname: $0.fname, lname: $0.lname, email: "email@example.com")
                }
                var userids = [User]()
                userids.append(User(fname: inviter.fname ,
                                    lname: inviter.lname ,
                                    email: inviter.email ))
                
                self.save(varGroup(
                    id: UUID(),
                    server_id: group.groupid,
                    groupName: group.title,
                    inviter: inviter,
                    invitees: invitees,
                    userids: userids
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
            print("Unable to delete group")
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
                        groupid: server_id,
                        title: group.groupName,
                        inviter: AuthStore.shared.getUsername(),
                        invitees: [],
                        userids: [AuthStore.shared.getUsername()]
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
                    title: group.groupName,
                    inviter: AuthStore.shared.getUsername(),
                    invitees: [],
                    userids: [AuthStore.shared.getUsername()]
                )).call() { response in
                    var groupCopy = group
                    groupCopy.server_id = response.id
                    self.groups.append(groupCopy)
                }
            }
        }
    }
    
}
