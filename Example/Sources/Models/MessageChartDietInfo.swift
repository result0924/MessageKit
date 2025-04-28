//
//  MessageChartDietInfo.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import Foundation

struct MessageChartDietInfo: Codable {
    struct DietImage: Codable {
        let thumb: String
        let full: String
    }

    let title: String?
    let text: String?
    let images: [DietImage]
    let relevantDietDiaries: [Int]

    enum CodingKeys: String, CodingKey {
        case title, text, images
        case relevantDietDiaries = "relevant_diet_diaries"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        images = try container.decodeIfPresent([DietImage].self, forKey: .images) ?? []
        relevantDietDiaries = try container.decodeIfPresent([Int].self, forKey: .relevantDietDiaries) ?? []
    }
}
