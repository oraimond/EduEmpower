//
//  UsageGraphView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/11/23.


import UIKit
import SwiftUI

struct PieChartView: View {
    
    @ObservedObject var viewModel: StatisticsViewModel = StatisticsViewModel()
    
    @State var dataEntries: [varChartDataEntry] =
    [
        varChartDataEntry(app: "Instagram", value: 25, color: UIColor.red),
        varChartDataEntry(app: "Focus", value: 25, color: UIColor.blue),
        varChartDataEntry(app: "Snapchat", value: 25, color: UIColor.yellow),
        varChartDataEntry(app: "YouTube", value: 25, color: UIColor.green),
    ]
    // You can customize this data structure based on your data model
    func drawPieChart(in rect: CGRect) {
        guard UIGraphicsGetCurrentContext() != nil else { return }

        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        var startAngle: CGFloat = 0

        for entry in dataEntries {
            let endAngle = startAngle + entry.value

            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()

            entry.color.setFill()
            path.fill()

            startAngle = endAngle
        }
    }
}

extension PieChartView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        drawPieChart(in: uiView.bounds)
    }
}
