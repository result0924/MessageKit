//
//  MessageChartData.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import Foundation

struct MessageChartData: Codable {
    let title: String
    let metrics: [MessageChartDataMetric]
    let graphData: MessageChartGraphData?
    let dietInfo: MessageChartDietInfo?

    enum CodingKeys: String, CodingKey {
        case title
        case metrics
        case graphData = "graph_data"
        case dietInfo = "diet_info"
    }
}
