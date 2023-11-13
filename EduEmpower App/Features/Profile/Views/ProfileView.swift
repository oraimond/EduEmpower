//
//  ProfileView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel = ProfileViewModel()
    
    @State private var logOutActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .foregroundColor(.blue)
                Text(viewModel.dummyUser.fname).font(.largeTitle)
                Text(viewModel.dummyUser.lname).font(.largeTitle)
                Spacer()
                Button(
                    action: {logOutActive = true},
                    label: {
                        Text("Logout")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(Color.white)
                            .background(viewModel.buttonColor)
                            .cornerRadius(10)
                    }
                )
                .navigationDestination(isPresented: $logOutActive) {
                    LoginView()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView()
}
