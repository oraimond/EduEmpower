//
//  AuthStore.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/14/23.
//

import Foundation

class AuthStore: ObservableObject {
    @Published var loggedIn: Bool = false
    var token: String?
    var user_id: String?
    var expires_at: String?
    
    @Published var fname: String?
    @Published var lname: String?
    @Published var email: String?

    
    func getProfile() {
        ProfileAction().call(token: token) { response in
            self.fname = response.first_name
            self.lname = response.last_name
            self.email = response.email
        }
    }
    
    func getFname() -> String {
        if let fname {
            return fname
        }
        return "Unknown"
    }
    
    func getLname() -> String {
        if let lname {
            return lname
        }
        return "Unknown"
    }
}
