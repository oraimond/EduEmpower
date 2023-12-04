//
//  GroupDeleteAction.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/29/23.
//

import Foundation

struct GroupDeleteAction {
    let server_id: Int
    
    func call() {
        let path = "/group/"
        
        guard let url = URL(string: APIConstants.base_url + path + String(server_id)) else {
            print("URL Error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "delete"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthStore.shared.getToken())", forHTTPHeaderField: "Authorization")
        
        let group = URLSession.shared.dataTask(with: request) {
            _, _, error in
            // Error: API request failed
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        group.resume()
        
    }
}
