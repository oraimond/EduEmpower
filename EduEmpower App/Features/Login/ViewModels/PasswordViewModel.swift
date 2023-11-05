//
//  PasswordViewModel.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import Foundation

class PasswordViewModel: ObservableObject {

    @Published var email: String = ""

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

