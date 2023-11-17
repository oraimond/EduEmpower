//
//  TaskAutoGenerateAction.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/16/23.
//

import Foundation

struct TaskAutoGenerateAction {
    let server_id: Int
    
    func call() {
        
        let initial_path = "/task/"
        let final_path = "/generate_events/"
        
        
        guard let url = URL(string: APIConstants.base_url + initial_path + String(server_id) + final_path) else {
            print("URL Error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthStore.shared.getToken())", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            // Error: API request failed
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
