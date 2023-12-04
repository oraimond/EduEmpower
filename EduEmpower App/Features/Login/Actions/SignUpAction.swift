//
//  SignUpAction.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/5/23.
//

import Foundation

struct SignUpAction {
    
    var parameters: SignUpRequest
    
    func call() {
        
        let path = "//signup"
        
        
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
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            // Error: API request failed
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

