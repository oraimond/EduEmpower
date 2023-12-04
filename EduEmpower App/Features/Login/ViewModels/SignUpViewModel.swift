//
//  SignUpViewModel.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/9/23.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    
    @Published var fname: String = ""
    @Published var lname: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    var buttonColor: Color {
        return ready() ? Color.blue :  Color.gray
    }
    
    func ready() -> Bool {
        return !fname.isEmpty && !lname.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && passwordMatch()
    }
    
    func passwordMatch() -> Bool {
        return password == confirmPassword
    }

    func submit() {
        SignUpAction(
            parameters: SignUpRequest(
                fname: fname,
                lname: lname,
                userid: username,
                email: email,
                password: password)
        ).call()
    }
}
