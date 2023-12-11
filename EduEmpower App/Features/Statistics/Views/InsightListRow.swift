//
//  InsightListRow.swift
//  EduEmpower App
//
//  Created by Sori Kang on 11/12/23.
//

import SwiftUI

struct InsightListRow: View {
    let insight: String
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Insight")
                .font(.headline)
            Text(insight)
                .font(.footnote)
        }
    }
}
