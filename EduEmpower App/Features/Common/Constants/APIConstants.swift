//
//  APIConstants.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/14/23.
//

import Foundation

struct APIConstants {
//    static let base_url: String = "http://localhost:3001"
    static let base_url: String = "https://34.16.135.240"
    
    static func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: dateString)
    }
    
    static func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
