//
//  TaskPutAction.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/15/23.
//

import Foundation

struct TaskPutAction {
    
    var parameters: TaskPutRequest
    
    func call(completion: @escaping (TaskResponse) -> Void) {
        
        let path = "/task/"
        
        guard let url = URL(string: APIConstants.base_url + path + String(parameters.id)) else {
            print("URL Error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "put"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthStore.shared.getToken())", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            print("Error: Unable to encode request parameters")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(TaskResponse.self, from: data)
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
