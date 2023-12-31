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
            
            drawText(entry.app, at: center, angle: startAngle + entry.value/2, radius: radius)


            startAngle = endAngle
        }
    }
    
    private func drawText(_ text: String, at center: CGPoint, angle: CGFloat, radius: CGFloat) {
        let labelRadius = radius * 0.75 // Adjust this multiplier to control the position of labels
        let x = center.x + labelRadius * cos(angle)
        let y = center.y + labelRadius * sin(angle)

        let labelRect = CGRect(x: x - 50, y: y - 10, width: 100, height: 20) // Adjust the label size and position
        let label = UILabel(frame: labelRect)
        label.text = text
        label.textAlignment = .center
        self.addSubview(label)
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
