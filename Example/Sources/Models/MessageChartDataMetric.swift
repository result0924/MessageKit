//
//  MessageChartDataMetric.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import UIKit

struct MessageChartDataMetric: Codable {
    enum ValueLevel: String, Codable {
        case unknown
        case normal
        case low
        case high

        var color: UIColor {
            switch self {
            case .unknown, .normal:
                return UIColor.lightText
            case .low:
                return UIColor.purple
            case .high:
                return UIColor.orange
            }
        }
    }

    let label: String
    let value: String
    let unit: String?
    let valueLevel: ValueLevel

    enum CodingKeys: String, CodingKey {
        case label, value, unit
        case valueLevel = "value_level"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        label = try container.decode(String.self, forKey: .label)
        value = try container.decode(String.self, forKey: .value)
        unit = try container.decodeIfPresent(String.self, forKey: .unit)

        do {
            let rawValue = try container.decode(String.self, forKey: .valueLevel)
            valueLevel = ValueLevel(rawValue: rawValue) ?? .unknown
        } catch {
            valueLevel = .unknown
        }
    }
}
