//
//  GroupGetAction.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupGetAction {
    
    var parameters: ProfileRequest
    
    func call(completion: @escaping ([GroupGetResponse]) -> Void) {
        let path = "/groups/"
        
        guard let url = URL(string: APIConstants.base_url + path) else {
            print ("URL Error")
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
                    let response = try JSONDecoder().decode([GroupGetResponse].self, from: data)
                    completion(response)
                } catch let jsonError {
                    print("Failed to decode group, error: \(jsonError)")
                }
            } else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        group.resume()
    }
}

