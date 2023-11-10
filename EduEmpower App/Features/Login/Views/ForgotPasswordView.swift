//
//  ForgotPasswordView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: PasswordViewModel = PasswordViewModel()
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Please enter your email in the box below to recieve a new password")
                .font(.title2)
            
            Spacer()
            
            VStack {
                TextField(
                    "Email",
                    text: $viewModel.email
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
            }
            
            Spacer()
            
            Button(
                action: {
                    viewModel.submit()
                    isPresented = false
                },
                label: {
                    Text("Submit")
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
    ForgotPasswordView(isPresented: .constant(true))
//    ForgotPasswordView()
}
