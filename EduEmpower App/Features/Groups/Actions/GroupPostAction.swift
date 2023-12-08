//
//  GroupPostAction.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupPostAction {
    var parameters: GroupPostRequest
    
    func call(completion: @escaping (GroupResponse) -> Void) {
        print("group post action running")
        let path = "/group/"
        
        guard let url = URL(string: APIConstants.base_url + path) else {
            print("URL Error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthStore.shared.getToken())", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            print("Error: Unable to encode request parameters")
        }
        
        let group = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(GroupResponse.self, from: data)
                    completion(response)
                } catch let jsonError {
                    print("Failed to decode groups, error: \(jsonError)")
                }
            } else {
                // Error: API request failed
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        group.resume()
    }
}
