//
//  InvitationGetAction.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/30/23.
//

import Foundation

struct InvitationGetAction {
    func call(completion: @escaping ([InvitationGetResponse]) -> Void) {
        let path = "/invitations/"
        
        guard let url = URL(string: APIConstants.base_url + path) else {
            print ("URL Error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthStore.shared.getToken())", forHTTPHeaderField: "Authorization")
        
        let invitation = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([InvitationGetResponse].self, from: data)
                    completion(response)
                } catch let jsonError {
                    print("Failed to decode invitation, error: \(jsonError)")
                }
            } else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        invitation.resume()
    }
}
