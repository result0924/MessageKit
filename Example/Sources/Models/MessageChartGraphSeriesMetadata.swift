//
//  MessageChartGraphSeriesMetadata.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import Foundation

struct MessageChartGraphSeriesMetadata: Codable {
    enum LineType: String, Codable {
        case unknown
        case solid
        case solidWithDataPoints = "solid_with_data_points"
        case dash

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = LineType(rawValue: rawValue) ?? .unknown
        }
    }

    let name: String
    let lineType: LineType
    let lineColor: String
    let showXValueLabel: Bool
    let showYValueLabel: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case lineType = "line_type"
        case lineColor = "line_color"
        case showXValueLabel = "show_x_value_label"
        case showYValueLabel = "show_y_value_label"
    }
}
