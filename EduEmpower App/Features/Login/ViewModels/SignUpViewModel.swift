//
//  SignUpViewModel.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/9/23.
//

import Foundation

class SignUpViewModel: ObservableObject {
    
    @Published var fname: String = ""
    @Published var lname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    func submit() {
        print("Submitted")
//        PasswordAction(
//            parameters: PasswordRequest(
//                email: email
//            )
//        ).call { _ in
//            // Login successful, navigate to the Home screen
//        }
    }
}
