//
//  StatisticsViewModel.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import Foundation
import UIKit

class StatisticsViewModel: ObservableObject {
    
    var dummyStats: [varChartDataEntry] = [
        varChartDataEntry(app: "Instagram", value: 25, color: UIColor.red),
        varChartDataEntry(app: "Focus", value: 25, color: UIColor.blue),
        varChartDataEntry(app: "Snapchat", value: 25, color: UIColor.yellow),
        varChartDataEntry(app: "YouTube", value: 25, color: UIColor.green),
    ]
    
    lazy var dummyInsights: [varInsight] = [
        varInsight(title: "Insight 1", insightDescription: "This is dummy insight 1"),
        varInsight(title: "Insight 2", insightDescription: "This is dummy insight 2")
    ]
    
    lazy var dummySuggestions: [varSuggestion] = [
        varSuggestion(title: "Suggestion 1", suggestionDescription: "This is a dummy suggestion 1"),
        varSuggestion(title: "Suggestion 2", suggestionDescription: "This is a dummy suggestion 2")
    ]
}
