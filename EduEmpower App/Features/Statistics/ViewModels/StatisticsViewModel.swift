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
        varChartDataEntry(app: "Instagram", value: 55, color: UIColor.red),
        varChartDataEntry(app: "Focus", value: 10, color: UIColor.blue),
        varChartDataEntry(app: "Snapchat", value: 20, color: UIColor.yellow),
        varChartDataEntry(app: "YouTube", value: 15, color: UIColor.green),
    ]
    
    lazy var dummyInsights: [varInsight] = [
        varInsight(title: "Insight 1", insightDescription: "It seems you have been distracted over the past few weeks"),
        varInsight(title: "Insight 2", insightDescription: "More time spent on social media than in Focus time")
    ]
    
    lazy var dummySuggestions: [varSuggestion] = [
        varSuggestion(title: "Suggestion 1", suggestionDescription: "Set strict time limits: Allocate specific time blocks for social media and stick to them. Reserve the rest of your time for work."),
        varSuggestion(title: "Suggestion 2", suggestionDescription: "Prioritize tasks: Create a daily to-do list, focusing on important work tasks first, and reward yourself with social media breaks after completing them.")
    ]
}
