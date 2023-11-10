//
//  PasswordViewModel.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import SwiftUI

class PasswordViewModel: ObservableObject {

    @Published var email: String = ""
    
    var buttonColor: Color {
        return ready() ? Color.blue :  Color.gray
    }
    
    func ready() -> Bool {
        return !email.isEmpty
    }

    func submit() {
        PasswordAction(
            parameters: PasswordRequest(
                email: email
            )
        ).call { _ in
            // Login successful, navigate to the Home screen
        }
    }
}

