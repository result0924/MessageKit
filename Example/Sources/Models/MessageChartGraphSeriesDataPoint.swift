//
//  MessageChartGraphSeriesDataPoint.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import Foundation

struct MessageChartGraphSeriesDataPoint: Codable {
    let xAxis: String
    let yAxis: String
    let showLabel: Bool

    enum CodingKeys: String, CodingKey {
        case xAxis = "x"
        case yAxis = "y"
        case showLabel = "show_label"
    }
}
