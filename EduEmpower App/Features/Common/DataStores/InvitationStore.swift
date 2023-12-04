//
//  InvitationStore.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

class InvitationStore: ObservableObject {
    static let shared = InvitationStore()
    
    @Published var invitations = [varInvitation]()
    
    private init() {}
    
    func fetchInvitations() {
        
    }
}
