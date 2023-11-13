//
//  InsightListRow.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct InsightListRow: View {
    let insight: varInsight
    
//    @ObservableObject var viewModel: StatisticsViewModel = StatisticsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(insight.title)
                .font(.headline)
            Text(insight.insightDescription)
                .font(.footnote)
        }
    }
}
