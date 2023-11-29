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
    static let pieChart = Self("Pie Chart")
}

struct StatisticsView: View {
    private var currentDate: Date { Date() }
    
    private var startOfWeek: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
    }
    
    private var endOfWeek: Date {
        Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
    }
    
    private var thisWeek: DateInterval {
        DateInterval(start: startOfWeek, end: endOfWeek)
    }
    
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

