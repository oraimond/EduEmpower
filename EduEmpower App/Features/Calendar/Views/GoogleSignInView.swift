import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInView: View {
    @Binding var isPresented: Bool
    private let signinClient = GIDSignIn.sharedInstance
    private let additionalScopes = ["https://www.googleapis.com/auth/calendar", "https://www.googleapis.com/auth/calendar.events"]
    @ObservedObject var eventStore: EventStore
    
    var body: some View {
        if let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController {
            GoogleSignInButton {
                signinClient.signIn(withPresenting: rootVC, hint: "test hint", additionalScopes: additionalScopes) { result, error in
                    if error != nil {
                        print("signIn: \(error!.localizedDescription)")
                    } else {
                        getEvents(result?.user.accessToken.tokenString)
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
                            getEvents(user?.accessToken.tokenString)
                            backendSignin(user?.idToken?.tokenString)
                        }
                    }
                }
            }
        }
    }
    
    func getEvents(_ token: String?) {
        Task {
            if let accessToken = token {
                
                let timeMin = ISO8601DateFormatter().string(from: Date())
                let timeMax = ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .day, value: 30, to: Date())!)
                
                let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/primary/events?timeMin=\(timeMin)&timeMax=\(timeMax)&singleEvents=true&orderBy=startTime")!
                var request = URLRequest(url: url)
                request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "GET"
                
                do {
                    let (data, response) = try await URLSession.shared.data(for: request)
                        
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("getEvents: HTTP STATUS: \(httpStatus.statusCode)")
                        return
                    }
                        
                    guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                        print("getEvents: failed JSON deserialization")
                        return
                    }
                    
                    struct myEvent: Decodable {
                        let created: String
                        let end: DateTimeZone
                        let start: DateTimeZone
                        let summary: String

                        struct DateTimeZone: Decodable {
                            let dateTime: String
                            let timeZone: String
                        }
                    }

                    struct Response: Decodable {
                        let items: [myEvent]
                    }

                    let dictionary = jsonObj// this is your dictionary from your question
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(Response.self, from: jsonData)
                        for event in response.items {
                            
                            let dateFormatter = ISO8601DateFormatter()
                            let start = dateFormatter.date(from: event.start.dateTime) ?? Date()
                            let end = dateFormatter.date(from: event.end.dateTime) ?? nil
                            
                            eventStore.add(Event(start: start, end: end, note: event.summary))
                            
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                    
                } catch {
                    print("getEvents: ERROR")
                }
            }
        }
    }
    
    func checkScopes(_ currentUser: GIDGoogleUser?) {
        guard let currentUser = signinClient.currentUser else {
            return ; /* Not signed in. */
        }
        
        let grantedScopes = currentUser.grantedScopes
        if grantedScopes == nil || !grantedScopes!.contains(additionalScopes) {
            if let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController {
                currentUser.addScopes(additionalScopes, presenting: rootVC) { signInResult, error in
                    guard error == nil else {
                        return
                    }
                    guard let signInResult = signInResult else {
                        return
                    }
                    currentUser.refreshTokensIfNeeded { user, error in
                        guard error == nil else { return }
                        guard let user = user else { return }
                        
                        // Get the access token to attach it to a REST or gRPC request.
                        let accessToken = user.accessToken.tokenString
                        
                        print(user.grantedScopes!)
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
