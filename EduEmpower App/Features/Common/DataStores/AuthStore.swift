//
//  AuthStore.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/14/23.
//

import Foundation

class AuthStore: ObservableObject {
    static let shared = AuthStore()
    
    @Published var loggedIn: Bool = false
    var token: String?
    var user_id: String?
    var expires_at: Double?
    
    @Published var fname: String?
    @Published var lname: String?
    @Published var email: String?
    
    private init() {} // ensure that only one instance of AuthStore can be created
    

    
    func getProfile() {
        ProfileAction(parameters: ProfileRequest(userid: getUsername())).call() { response in
            self.fname = response.first_name
            self.lname = response.last_name
            self.email = response.email
        }
    }
    
    func getToken() -> String {
        if let token {
            return token
        }
        print("No Auth Token")
        return "NoToken"
    }
    
    func getUsername() -> String {
        if let user_id {
            return user_id
        }
        print("No Auth Token")
        return "NoToken"
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
    
    func logout() {
        // TODO clear all data stores
    }

}
