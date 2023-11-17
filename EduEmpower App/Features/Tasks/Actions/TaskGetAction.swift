//
//  TaskGetAction.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/15/23.
//

import Foundation

struct TaskGetAction {
    func call(completion: @escaping ([TaskGetResponse]) -> Void) {
        let path = "/tasks"
        
        
        guard let url = URL(string: APIConstants.base_url + path) else {
            print("URL Error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "get"
    
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthStore.shared.getToken())", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([TaskGetResponse].self, from: data)
                    completion(response)
                } catch let jsonError {
                    print("Failed to decode tasks, error: \(jsonError)")
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
