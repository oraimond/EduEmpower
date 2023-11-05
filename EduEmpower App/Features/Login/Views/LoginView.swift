//
//  ContentView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
//    @State private var presentingPasswordView = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Text("Welcome to EduEmpower")
                    .font(.largeTitle)
                
                Spacer()
                
                VStack {
                    TextField(
                        "Username",
                        text: $viewModel.username
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
                }
                
                Spacer()
                
                Button(
                    action: viewModel.login,
                    label: {
                        Text("Sign in")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                )
                HStack {
                    NavigationLink(destination: ForgotPasswordView()) {
                        Button(
                            action: {
                                print("Button tapped")
        //                        presentingPasswordView.toggle()
                            },
                            label: {
                                Text("Forgot password")
                            }
                        )
                    }
                    
                    Spacer()
                    Button(
                        action: {
                            // sign up action
                        },
                        label: {
                            Text("Sign up")
                        }
                    )
                }
            }
            .padding(30)
        }
        
//        .navigationDestination(isPresented: $presentingPasswordView) {
//            ForgotPasswordView(isPresented: $presentingPasswordView)
//        }
    }
}

#Preview {
    LoginView()
}
