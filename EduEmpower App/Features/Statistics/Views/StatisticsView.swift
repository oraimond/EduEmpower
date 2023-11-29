//
//  StatisticsView.swift
//  EduEmpower App
//
//  Created by Oli Raimond on 11/10/23.
//

import SwiftUI
import UIKit
import DeviceActivity

extension DeviceActivityReport.Context {
    static let pieChart = Self("Pie Chart")
}

struct StatisticsView: View {
    @ObservedObject var viewModel: StatisticsViewModel = StatisticsViewModel()
    
    @State var newInsight: varInsight = varInsight(title: "", insightDescription: "")
    @State var newSuggestion: varSuggestion = varSuggestion(title: "", suggestionDescription: "")
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Focus Statistics")
                .font(.largeTitle)
            
            // TODO: put graph diagram
            PieChartView(dataEntries: viewModel.dummyStats)
                .frame(width: 150, height: 150)
            
            VStack {
                List(viewModel.dummyInsights, id: \.id) {
                    insight in InsightListRow(insight: insight)
                }
                
                List(viewModel.dummySuggestions, id: \.id) {
                    suggestion in SuggestionListRow(suggestion: suggestion)
                }
            }
           
        }
    }
}

#Preview {
    StatisticsView()
}

