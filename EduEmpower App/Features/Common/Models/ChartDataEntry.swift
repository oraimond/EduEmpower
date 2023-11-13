//
//  ChartDataEntry.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import Foundation
import UIKit

struct varChartDataEntry {
    let id = UUID()
    let app: String
    var value: CGFloat
    let color: UIColor

    init(app: String, value: CGFloat, color: UIColor) {
        self.app = app
        self.value = value * 2 * .pi / 100  // convert the value into radians
        self.color = color
    }
}
