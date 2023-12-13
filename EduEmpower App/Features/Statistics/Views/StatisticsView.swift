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

struct StatEntry: Encodable {
    let app: String
    let value: CGFloat
}

struct StatisticsView: View {
    @State private var context: DeviceActivityReport.Context = .pieChart
    @State private var filter = DeviceActivityFilter(segment: .daily(during: DateInterval(start: Date(), end: Date())))
    
    @ObservedObject var viewModel: StatisticsViewModel = StatisticsViewModel()

    
    @State private var insight: StatGetResponse?
    
    var body: some View {
        VStack {
            
            
            Text("Focus Statistics")
                .font(.largeTitle)
            
            
            // TODO: put graph diagram
            PieChartView(dataEntries: viewModel.dummyStats)
                .frame(width: 200, height: 200)
            
            
            VStack {
                if let insight = insight {
                    InsightListRow(insight: insight.insight)
                    SuggestionListRow(suggestion: insight.suggestion)
                } else {
                    Text("Loading insights...")
                        .padding()
                }
             }
        }
        .onAppear {
            DispatchQueue.main.async {
                generateAndDisplayInsights()
            }        }
    }
    func generateAndDisplayInsights() {
        let path = "/generate-insights/"
        guard let url = URL(string: APIConstants.base_url + path) else {
            print("URL Error")
            return
        }
        let dummyStats = viewModel.dummyStats
        
        let mappedStats = dummyStats.reduce(into: [String: Int]()) { (result, entry) in
            result[entry.app] = entry.val_int
        }

        let statsForBackend = ["user_statistics": mappedStats]
        
        var request = URLRequest(url: url)
        // not sure
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthStore.shared.getToken())", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        do {
            // Check if viewModel.dummyStats is Encodable
            let jsonData = try JSONEncoder().encode(statsForBackend)
            request.httpBody = jsonData
        } catch {
            print("Failed to serialize dummy stats: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8) ?? "Empty Data")
                    let response = try JSONDecoder().decode(StatGetResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.insight = response
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



