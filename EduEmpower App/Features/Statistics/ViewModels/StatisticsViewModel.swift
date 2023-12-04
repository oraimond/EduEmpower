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
    
    lazy var insightsList: [varInsight] = [
        //negative
        varInsight(title: "Insight 1", insightDescription: "It appears you've faced challenges maintaining focus recently. "),
        varInsight(title: "Insight 2", insightDescription: "Social media usage seems to be exceeding your intended focus time. Evaluate and set stricter limits to maintain a balance."),
        //positive
        varInsight(title: "Insight 3", insightDescription: "Efficiently managing your time and maintaining focus has led to productive outcomes. Keep up the good work!"),
        varInsight(title: "Insight 4", insightDescription: "Consistently prioritizing important tasks and minimizing unnecessary app usage demonstrates your commitment to productivity.")
    ]
    
    lazy var suggestionsList: [varSuggestion] = [
        varSuggestion(title: "Suggestion 1", suggestionDescription: "Set strict time limits: Allocate specific time blocks for social media and stick to them. Reserve the rest of your time for work."),
        varSuggestion(title: "Suggestion 2", suggestionDescription: "Prioritize tasks: Create a daily to-do list, focusing on important work tasks first, and reward yourself with social media breaks after completing them."),
        varSuggestion(title: "Suggestion 3", suggestionDescription: "Mindful Distractions:Designate specific times for distractions to ensure you stay productive. Allow yourself short breaks for activities like checking social media or browsing the web, but set a timer to avoid spending too much time on them."),
        varSuggestion(title: "Suggestion 4", suggestionDescription: "Task-break Intervals: Break down your work into intervals, and schedule short breaks between tasks. Use these breaks to engage in quick, enjoyable activities, such as a brief walk or a fun online quiz. This helps refresh your mind without losing focus."),
    ]
}
