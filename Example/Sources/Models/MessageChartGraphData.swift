//
//  MessageChartGraphData.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import Foundation

struct MessageChartGraphData: Codable {
    enum GraphType: String, Codable {
        case unknown
        case straightLine = "straight_line"
        case smoothedLine = "smoothed_line"

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = GraphType(rawValue: rawValue) ?? .unknown
        }
    }

    let graphType: GraphType
    let yAxisProperties: MessageChartAxisProperties
    let xAxisProperties: MessageChartAxisProperties
    let series: [MessageChartGraphSeries]

    enum CodingKeys: String, CodingKey {
        case graphType = "graph_type"
        case yAxisProperties = "y-axis_properties"
        case xAxisProperties = "x-axis_properties"
        case series
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        graphType = try container.decode(GraphType.self, forKey: .graphType)
        yAxisProperties = try container.decode(MessageChartAxisProperties.self, forKey: .yAxisProperties)
        xAxisProperties = try container.decode(MessageChartAxisProperties.self, forKey: .xAxisProperties)
        series = try container.decode([MessageChartGraphSeries].self, forKey: .series)
    }
}
