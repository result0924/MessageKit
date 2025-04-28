//
//  MessageChartAxisProperties.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import Foundation

struct MessageChartAxisProperties: Codable {
    enum AxisDataType: String, Codable {
        case unknown
        case integer
        case decimal
        case date
        case time

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = AxisDataType(rawValue: rawValue) ?? .unknown
        }
    }

    enum AxisNumberFormat: String, Codable {
        case unknown
        case whole
        case tenth
        case hundredth

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = AxisNumberFormat(rawValue: rawValue) ?? .unknown
        }
    }

    let label: String
    let unit: String
    let dataType: AxisDataType
    let axisNumberFormat: AxisNumberFormat?
    let min: Double?
    let max: Double?
    let tickInterval: Double?
    let showGridlines: Bool

    enum CodingKeys: String, CodingKey {
        case label, unit, min, max
        case dataType = "data_type"
        case axisNumberFormat = "axis_number_format"
        case tickInterval = "tick_interval"
        case showGridlines = "show_gridlines"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        label = try container.decode(String.self, forKey: .label)
        unit = try container.decode(String.self, forKey: .unit)
        dataType = try container.decode(AxisDataType.self, forKey: .dataType)
        axisNumberFormat = try container.decodeIfPresent(AxisNumberFormat.self, forKey: .axisNumberFormat)
        min = try container.decodeIfPresent(Double.self, forKey: .min)
        max = try container.decodeIfPresent(Double.self, forKey: .max)
        tickInterval = try container.decodeIfPresent(Double.self, forKey: .tickInterval)
        showGridlines = try container.decode(Bool.self, forKey: .showGridlines)
    }
}
