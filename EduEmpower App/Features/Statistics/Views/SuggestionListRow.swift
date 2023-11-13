//
//  SuggestionListRow.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct SuggestionListRow: View {
    let suggestion: varSuggestion
    
//    @ObservableObject var viewModel: StatisticsViewModel = StatisticsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(suggestion.title)
                .font(.headline)
            Text(suggestion.suggestionDescription)
                .font(.footnote)
        }
    }
}
