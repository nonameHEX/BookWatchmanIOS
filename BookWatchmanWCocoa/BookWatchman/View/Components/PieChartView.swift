//
//  PieChartView.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 04.01.2025.
//

import SwiftUI
import Charts

struct PieChartView: View {
    let data: [(label: String, value: Int, color: Color)]

    var body: some View {
        Chart(data, id: \.label) { item in
            SectorMark(
                angle: .value("Knihy", item.value),
                innerRadius: .ratio(0.5),
                angularInset: 2
            )
            .foregroundStyle(item.color)
        }
    }
}
