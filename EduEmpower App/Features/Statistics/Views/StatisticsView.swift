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

    
    @State var insight: StatGetResponse
    
    var body: some View {
        VStack {
            
            
            Text("Focus Statistics")
                .font(.largeTitle)
            
            
            // TODO: put graph diagram
            PieChartView(dataEntries: viewModel.dummyStats)
                .frame(width: 200, height: 200)
            
            
            VStack {
                InsightListRow(insight: insight.insight)
                SuggestionListRow(suggestion: insight.suggestion)
             }
        }
        .onAppear {
            generateAndDisplayInsights()
        }
    }
    func generateAndDisplayInsights() {
        let path = "/generate_insights/"
        guard let url = URL(string: APIConstants.base_url + path) else {
            print("URL Error")
            return
        }
        var request = URLRequest(url: url)
        // not sure
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthStore.shared.getToken())", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(StatGetResponse.self, from: data)
                    DispatchQueue.main.async {
                        insight = response
                    }
                } catch let error {
                    print("Failed to decode insights, error: \(error)")
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}



