//
//  ProfileAction.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/14/23.
//

import SwiftUI

struct ProfileAction {
    func call(token: String?, completion: @escaping (ProfileResponse) -> Void) {
        let path = "/user/profile"
        
        
        guard let url = URL(string: APIConstants.base_url + path) else {
            print("URL Error")
            return
        }
        
        guard let token else {
            print("No auth token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "get"
    
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                let response = try? JSONDecoder().decode(ProfileResponse.self, from: data)
                
                if let response = response {
                    completion(response)
                } else {
                    print("Failed to decode login")
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
