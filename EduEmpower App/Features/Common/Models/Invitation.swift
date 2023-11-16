//
//  Invitation.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/15/23.
//

import Foundation

struct varInvitation {
    let id = UUID()
    var inviter: User
    var invitee: User
    var group: varGroup
}
