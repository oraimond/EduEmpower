//
//  LoginViewModel.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {

    @Published var username: String = ""
    @Published var password: String = ""
    
    var authStore: AuthStore
    
    init(authStore: AuthStore) {
        self.authStore = authStore
    }
    
    var buttonColor: Color {
        return ready() ? Color.blue :  Color.gray
    }
    
    func ready() -> Bool {
        return !username.isEmpty && !password.isEmpty
    }

    func login() {
        LoginAction(
            parameters: LoginRequest(
                username: username,
                password: password
            )
        ).call { response in
            print("Login successful, navigate to the Home screen")
            self.authStore.loggedIn.toggle()
            self.authStore.token = response.token
            self.authStore.user_id = response.user_id
            self.authStore.expires_at = response.expires_at
            
            self.authStore.getProfile()
        }
    }
}
