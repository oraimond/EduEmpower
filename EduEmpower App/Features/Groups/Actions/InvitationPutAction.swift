//
//  InvitationPutAction.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/30/23.
//

import Foundation

struct InvitationPutAction {
    var parameters: InvitationPutRequest
    
    func call(completion: @escaping (InvitationResponse) -> Void) {
        let path = "/invitation/"
        
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
        
        let invitation = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(InvitationResponse.self, from: data)
                    completion(response)
                } catch let jsonError {
                    print("Failed to decode invitations, error: \(jsonError)")
                }
            } else {
                // Error: API request failed
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        invitation.resume()
        
    }
}
