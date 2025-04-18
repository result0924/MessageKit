//
//  CustomViewItem.swift
//  MessageKit
//
//  Created by Justin Lai on 2025/4/17.
//

import Foundation
import UIKit

public protocol ChartViewItem {
    /// The attributed string for the title
    var titleAttributedString: NSAttributedString { get }
    
    /// The size of the title view
    var titleViewSize: CGSize { get }
    
    /// The metrics to display in the chart view
    var metrics: [ChartViewMetric] { get }
    
    /// The size of the metrics view
    var metricsViewSize: CGSize { get }
    
    /// The size of the chart view
    var size: CGSize { get }
}

public struct ChartViewMetric {
    // MARK: - Properties
    /// The label of the metric
    public let label: String
    
    /// The value of the metric
    public let value: String
    
    /// The unit of the metric
    public let unit: String
    
    /// The color of the value
    public let valueColor: UIColor
    
    public var labelAttributedString: NSAttributedString {
        NSAttributedString(
            string: label,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 1)
            ]
        )
    }
    
    public var valueUnitAttributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .regular),
            .foregroundColor: valueColor
        ]
        attributedString.append(NSAttributedString(string: value, attributes: valueAttributes))
        
        if !unit.isEmpty {
            let spaceAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .regular),
                .foregroundColor: valueColor
            ]
            attributedString.append(NSAttributedString(string: " ", attributes: spaceAttributes))
            
            let unitAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
            ]
            attributedString.append(NSAttributedString(string: unit, attributes: unitAttributes))
        }
        
        return attributedString
    }
    
    public init(label: String, value: String, unit: String, valueColor: UIColor) {
        self.label = label
        self.value = value
        self.unit = unit
        self.valueColor = valueColor
    }
}
