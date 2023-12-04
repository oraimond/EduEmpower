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
    
    var buttonColor: Color {
        return ready() ? Color.blue :  Color.gray
    }
    
    func ready() -> Bool {
        return !username.isEmpty && !password.isEmpty
    }

    func login() {
        LoginAction(
            parameters: LoginRequest(
                userid: username,
                password: password
            )
        ).call { response in
            print("Login successful, navigate to the Home screen")
            AuthStore.shared.loggedIn.toggle()
            AuthStore.shared.token = response.Token
            AuthStore.shared.user_id = response.userid
            AuthStore.shared.expires_at = response.expiresat
            
            // Get info from database
            AuthStore.shared.getProfile()
            TaskStore.shared.fetchTasks()
        }
    }
    
    func login_demo() {
        LoginAction(
            parameters: LoginRequest(
                userid: "jsmith",
                password: "password"
            )
        ).call { response in
            print("Login successful, navigate to the Home screen")
            AuthStore.shared.loggedIn.toggle()
            AuthStore.shared.token = response.Token
            AuthStore.shared.user_id = response.userid
            AuthStore.shared.expires_at = response.expiresat
            
            // Get info from database
            AuthStore.shared.getProfile()
            TaskStore.shared.fetchTasks()
        }
    }
}
