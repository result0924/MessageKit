//
//  MessageChartGraphSeries.swift
//  h2syncapp
//
//  Created by jlai on 2025/4/11.
//  Copyright © 2025 H2 Inc. All rights reserved.
//

import Foundation

struct MessageChartGraphSeries: Codable {
    let metadata: MessageChartGraphSeriesMetadata
    let data: [MessageChartGraphSeriesDataPoint]
    let icons: [MessageChartGraphSeriesGraphIcon]
    
    init(
        metadata: MessageChartGraphSeriesMetadata,
        data: [MessageChartGraphSeriesDataPoint],
        icons: [MessageChartGraphSeriesGraphIcon]
    ) {
        self.metadata = metadata
        self.data = data
        self.icons = icons
    }
}
