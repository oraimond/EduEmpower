import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInView: View {
    @Binding var isPresented: Bool
    private let signinClient = GIDSignIn.sharedInstance
    
    var body: some View {
        if let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController {
            GoogleSignInButton {
                signinClient.signIn(withPresenting: rootVC){ result, error in
                    if error != nil {
                        print("signIn: \(error!.localizedDescription)")
                    } else {
                        backendSignin(result?.user.idToken?.tokenString)
                    }
                }
            }
            .frame(width:100, height:50, alignment: Alignment.center)
            .onAppear {
                if let user = signinClient.currentUser {
                    backendSignin(user.idToken?.tokenString)
                } else {
                    signinClient.restorePreviousSignIn { user, error in
                        if error != nil {
                            print("restorePreviousSignIn: \(error!.localizedDescription)")
                        } else {
                            backendSignin(user?.idToken?.tokenString)
                        }
                    }
                }
            }
        }
    }
    
    func backendSignin(_ token: String?) {
        Task {
            if let validToken = token {
                // send token to backend
            }
//            if let _ = await ChattStore.shared.addUser(token) {
//                await ChatterID.shared.save()
//            }
            isPresented.toggle()
        }
    }
}
