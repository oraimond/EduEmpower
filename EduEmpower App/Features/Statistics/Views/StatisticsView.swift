//
//  StatisticsView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI
import UIKit
import DeviceActivity
import Foundation

extension DeviceActivityReport.Context {
    static let pieChart = Self("pieChart")
}

struct StatisticsView: View {
    @State private var context: DeviceActivityReport.Context = .pieChart
    @State private var filter = DeviceActivityFilter(segment: .daily(during: DateInterval(start: Date(), end: Date())))
    
    @ObservedObject var viewModel: StatisticsViewModel = StatisticsViewModel()
    
    @State var newInsight: varInsight = varInsight(title: "", insightDescription: "")
    @State var newSuggestion: varSuggestion = varSuggestion(title: "", suggestionDescription: "")
    
    var body: some View {
        VStack {
            
            
            Text("Focus Statistics")
                .font(.largeTitle)
            
            
            // TODO: put graph diagram
            PieChartView(dataEntries: viewModel.dummyStats)
                .frame(width: 200, height: 200)
            
            
            VStack {
                // TODO if the ratio for social media greater than focus (show negatives) else (show positives)
                // Check if the "Focus" app value is less than 50
                if let focusApp = viewModel.dummyStats.first(where: { $0.app == "Focus" }), focusApp.value < 50 {
                    // Show negative insights
                    List(viewModel.negativeInsights, id: \.id) { insight in
                        InsightListRow(insight: insight)
                    }
                    List(viewModel.negativeSuggestions, id: \.id) { suggestion in
                        SuggestionListRow(suggestion: suggestion)
                    }
                } else {
                    // Show positive insights
                    List(viewModel.positiveInsights, id: \.id) { insight in
                        InsightListRow(insight: insight)
                    }
                    List(viewModel.positiveSuggestions, id: \.id) { suggestion in
                        SuggestionListRow(suggestion: suggestion)
                    }
                }
            }
           
        }
    }
}

#Preview {
    StatisticsView()
}

