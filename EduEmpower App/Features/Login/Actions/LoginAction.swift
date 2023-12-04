//
//  LoginAction.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import Foundation

struct LoginAction {
    
    var parameters: LoginRequest
    
    func call(completion: @escaping (LoginResponse) -> Void) {
        
        let path = "//login"
        
        
        guard let url = URL(string: APIConstants.base_url + path) else {
            print("URL Error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            print("Error: Unable to encode request parameters")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                let response = try? JSONDecoder().decode(LoginResponse.self, from: data)
                
                if let response = response {
                    completion(response)
                } else {
                    // TODO failed login
                    print("Incorrect details")
                }
            } else {
                // Error: API request failed
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
