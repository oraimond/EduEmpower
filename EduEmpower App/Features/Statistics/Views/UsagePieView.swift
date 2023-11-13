//
//  UsageGraphView.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/11/23.


import UIKit
import SwiftUI

class PieChartUIView: UIView {
    var dataEntries: [varChartDataEntry] =
    [
        varChartDataEntry(app: "Instagram", value: 25, color: UIColor.red),
        varChartDataEntry(app: "Focus", value: 25, color: UIColor.blue),
        varChartDataEntry(app: "Snapchat", value: 25, color: UIColor.yellow),
        varChartDataEntry(app: "YouTube", value: 25, color: UIColor.green),
    ]

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        var startAngle: CGFloat = -.pi / 2 // starts at top of circle

        for entry in dataEntries {
            let endAngle = startAngle + entry.value
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            
            context.setFillColor(entry.color.cgColor)
            path.fill()

            startAngle = endAngle
        }
    }
}



struct PieChartView: View {
    
    @ObservedObject var viewModel: StatisticsViewModel = StatisticsViewModel()

    @State var dataEntries: [varChartDataEntry]
 
}

extension PieChartView: UIViewRepresentable {
    func makeUIView(context: Context) -> PieChartUIView {
        let view = PieChartUIView()
        view.dataEntries = dataEntries
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: PieChartUIView, context: Context) {
        uiView.dataEntries = dataEntries
        uiView.setNeedsDisplay()
    }
}


//struct PieChartView: View {
//    
//    @ObservedObject var viewModel: StatisticsViewModel = StatisticsViewModel()
//    
//    
//    // You can customize this data structure based on your data model
//    func drawPieChart(in rect: CGRect) {
//        guard UIGraphicsGetCurrentContext() != nil else { return }
//
//        let radius = min(rect.width, rect.height) / 2
//        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
//
//        var startAngle: CGFloat = 0
//
//        for entry in dataEntries {
//            let endAngle = startAngle + entry.value
//
//            let path = UIBezierPath()
//            path.move(to: center)
//            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//            path.close()
//
//            entry.color.setFill()
//            path.fill()
//
//            startAngle = endAngle
//        }
//    }
//}
//
//extension PieChartView: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        view.backgroundColor = .clear
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        drawPieChart(in: uiView.bounds)
//    }
//}
