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
            
            Spacer()
            
            Text("Focus Statistics")
                .font(.largeTitle)
            
            DeviceActivityReport(context, filter: filter)
            
            // TODO: put graph diagram
            PieChartView(dataEntries: viewModel.dummyStats)
                .frame(width: 150, height: 150)
            
            
            VStack {
                // TODO if the ratio for social media greater than focus (show negatives) else (show positives)
                List(viewModel.insightsList, id: \.id) {
                    insight in InsightListRow(insight: insight)
                }
                
                List(viewModel.suggestionsList, id: \.id) {
                    suggestion in SuggestionListRow(suggestion: suggestion)
                }
            }
           
        }
    }
}

#Preview {
    StatisticsView()
}

