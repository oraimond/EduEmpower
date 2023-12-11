//
//  SuggestionListRow.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct SuggestionListRow: View {
    let suggestion: String
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Suggestion")
                .font(.headline)
            Text(suggestion)
                .font(.footnote)
        }
    }
}
