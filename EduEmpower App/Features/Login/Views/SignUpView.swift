//
//  SignUpView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/9/23.
//

import SwiftUI

struct SignUpView: View {
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: SignUpViewModel = SignUpViewModel()
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Enter your details below to sign up")
                .font(.title2)
            
            Spacer()
            
            VStack {
                TextField(
                    "First Name",
                    text: $viewModel.fname
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                
                TextField(
                    "Last Name",
                    text: $viewModel.lname
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                
                TextField(
                    "Email",
                    text: $viewModel.email
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                
                SecureField(
                    "Password",
                    text: $viewModel.password
                )
                .padding(.top, 20)
                
                Divider()
                
                SecureField(
                    "Re-enter Password",
                    text: $viewModel.confirmPassword
                )
                .padding(.top, 20)
                
                Divider()
                
                if !viewModel.passwordMatch() && !viewModel.confirmPassword.isEmpty {
                    Text("Passwords do not match")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            
            Spacer()
            
            Button(
                action: {
                    viewModel.submit()
                    isPresented = false
                },
                label: {
                    Text("Sign Up")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(viewModel.buttonColor)
                        .cornerRadius(10)
                }
            )
            .disabled(!viewModel.ready())
        }
        .padding(30)
    }
}

#Preview {
    SignUpView(isPresented: .constant(true))
}
