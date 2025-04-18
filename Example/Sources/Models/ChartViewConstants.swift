//
//  ChartViewConstants.swift
//  MessageKit
//
//  Created by Justin Lai on 2025/4/17.
//

import UIKit

enum ChartViewConstants {
    // Font Sizes
    static let titleFontSize: CGFloat = 16
    static let labelFontSize: CGFloat = 14
    static let valueFontSize: CGFloat = 18
    static let unitFontSize: CGFloat = 14
    
    // Font Weights
    static let titleFontWeight: UIFont.Weight = .medium
    static let regularFontWeight: UIFont.Weight = .regular
    
    // Fonts
    static var titleFont: UIFont {
        UIFont.systemFont(ofSize: titleFontSize, weight: titleFontWeight)
    }
    static var labelFont: UIFont {
        UIFont.systemFont(ofSize: labelFontSize, weight: regularFontWeight)
    }
    static var valueFont: UIFont {
        UIFont.systemFont(ofSize: valueFontSize, weight: regularFontWeight)
    }
    static var unitFont: UIFont {
        UIFont.systemFont(ofSize: unitFontSize, weight: regularFontWeight)
    }
    
    // Colors
    static let normalColor = UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 1)
    static let unitColor = UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
    
    // Layout
    static let metricsStackViewLeadingPadding: CGFloat = 12
    static let metricsStackViewTrailingPadding: CGFloat = 12
    static let metricsStackViewSpacing: CGFloat = 8
    static let metricsLabelSpacing: CGFloat = 4
    
    // Other
    static let lineHeight: CGFloat = 0.5
    static let collectionViewLeftRightPadding: CGFloat = 95
    static let textViewContentInset = UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 36)
} 