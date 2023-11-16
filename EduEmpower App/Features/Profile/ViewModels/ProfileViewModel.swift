//
//  ProfileViewModel.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/13/23.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    
    var buttonColor: Color {
        return Color.blue
    }
    
    let dummyUser: User = User(fname: "John", lname: "Doe", email: "johndoe@umich.edu")
}
