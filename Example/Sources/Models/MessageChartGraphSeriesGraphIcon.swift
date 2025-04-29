//
//  MessageChartGraphSeriesGraphIcon.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import Foundation

struct MessageChartGraphSeriesGraphIcon: Codable {
    enum IconType: String, Codable {
        case unknown
        case food
        case exercise
        case medication

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = IconType(rawValue: rawValue) ?? .unknown
        }
    }

    enum Action: String, Codable {
        case unknown
        case openDiary = "open_diary"

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = Action(rawValue: rawValue) ?? .unknown
        }
    }

    let xAxis: String
    let iconType: IconType
    let action: Action
    let resourceId: String

    enum CodingKeys: String, CodingKey {
        case xAxis = "x"
        case iconType = "icon_type"
        case action
        case resourceId = "resource_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        xAxis = try container.decode(String.self, forKey: .xAxis)
        iconType = try container.decode(IconType.self, forKey: .iconType)
        action = try container.decode(Action.self, forKey: .action)
        resourceId = try container.decode(String.self, forKey: .resourceId)
    }
    
    init(
        xAxis: String,
        iconType: IconType,
        action: Action,
        resourceId: String
    ) {
        self.xAxis = xAxis
        self.iconType = iconType
        self.action = action
        self.resourceId = resourceId
    }
}
