//
//  CustomChartViewItem.swift
//  ChatExample
//
//  Created by Justin Lai on 2025/4/17.
//  Copyright © 2025 MessageKit. All rights reserved.
//

import UIKit
import MessageKit

struct CustomChartViewItem: ChartViewItem {
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

    // MARK: - Properties
    var title: String
    var titleViewSize: CGSize
    var metricsViewSize: CGSize
    var metrics: [ChartViewMetric]
    var shouldShowChartInfo: Bool
    var size: CGSize
    
    // MARK: - Initialization
    init(title: String, metrics: [ChartViewMetric], shouldShowChartInfo: Bool) {
        self.title = title
        self.metrics = metrics
        let (titleSize, metricsSize, bubbleSize) = Self.calculateSizes(for: title, metrics: metrics, shouldShowChartInfo: shouldShowChartInfo)
        self.titleViewSize = titleSize
        self.metricsViewSize = metricsSize
        self.shouldShowChartInfo = shouldShowChartInfo
        self.size = bubbleSize
    }
    
    // MARK: - ChartViewItem
    var titleAttributedString: NSAttributedString {
        NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: ChartViewConstants.titleFont,
                NSAttributedString.Key.foregroundColor: ChartViewConstants.normalColor
            ]
        )
    }
    
    var metricsStackViewLeadingPadding: CGFloat {
        ChartViewConstants.metricsStackViewLeadingPadding
    }
    
    var metricsStackViewTrailingPadding: CGFloat {
        ChartViewConstants.metricsStackViewTrailingPadding
    }
    
    // MARK: - Private Methods
    private static func calculateSizes(for title: String, metrics: [ChartViewMetric], shouldShowChartInfo: Bool) -> (titleSize: CGSize, metricsSize: CGSize, bubbleSize: CGSize) {
        let screenWidth = UIScreen.main.bounds.width
        let maxBubbleWidth = screenWidth - ChartViewConstants.collectionViewLeftRightPadding
        let maxTextWidth = maxBubbleWidth - ChartViewConstants.textViewContentInset.left - ChartViewConstants.textViewContentInset.right
        
        let titleAttributedString = NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: ChartViewConstants.titleFont,
                NSAttributedString.Key.foregroundColor: ChartViewConstants.normalColor
            ]
        )
        let titleSize = calculateAttributedStringSize(for: titleAttributedString, maxWidth: maxTextWidth)
        
        let metricsSize = calculateMetricsSize(for: metrics, maxWidth: maxBubbleWidth)
        let bubbleSize = calculateBubbleSize(titleHeight: titleSize.height, metricsHeight: metricsSize.height, shouldShowChartInfo: shouldShowChartInfo)
        
        return (titleSize, metricsSize, bubbleSize)
    }
    
    private static func calculateMetricsSize(for metrics: [ChartViewMetric], maxWidth: CGFloat) -> CGSize {
        guard !metrics.isEmpty else { return .zero }
        let metricsStackViewPadding = ChartViewConstants.metricsStackViewLeadingPadding + ChartViewConstants.metricsStackViewTrailingPadding
        
        // 計算每個 metric 的高度
        var metricHeights: [CGFloat] = []
        for (index, metric) in metrics.enumerated() {
            // 如果是奇數個 metrics 且是最後一個，使用整行寬度
            let isLastOddMetric = index == metrics.count - 1 && metrics.count % 2 == 1
            let metricWidth = isLastOddMetric ? 
                (maxWidth - metricsStackViewPadding) : 
                (maxWidth - metricsStackViewPadding - ChartViewConstants.metricsStackViewSpacing) / 2
            
            let labelSize = calculateAttributedStringSize(for: metric.labelAttributedString, maxWidth: metricWidth)
            let valueUnitSize = calculateAttributedStringSize(for: metric.valueUnitAttributedString, maxWidth: metricWidth)
            let totalHeight = labelSize.height + ChartViewConstants.metricsLabelSpacing + valueUnitSize.height
            metricHeights.append(totalHeight)
        }
        
        // 計算每一行的高度
        var totalMetricsHeight: CGFloat = 0
        for i in stride(from: 0, to: metricHeights.count, by: 2) {
            let leftHeight = metricHeights[i]
            let rightHeight = i + 1 < metricHeights.count ? metricHeights[i + 1] : 0
            let rowHeight = max(leftHeight, rightHeight)
            totalMetricsHeight += rowHeight
            
            totalMetricsHeight += ChartViewConstants.metricsStackViewSpacing
        }
        
        return CGSize(width: maxWidth, height: totalMetricsHeight)
    }
    
    private static func calculateAttributedStringSize(for attributedString: NSAttributedString, maxWidth: CGFloat) -> CGSize {
        let textSize = CGSize(width: maxWidth, height: CGFloat(Float.greatestFiniteMagnitude))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: mutableAttributedString.length)
        )
        
        let contentRect = mutableAttributedString.boundingRect(
            with: textSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        return contentRect.size
    }
    
    private static func calculateBubbleSize(titleHeight: CGFloat, metricsHeight: CGFloat, shouldShowChartInfo: Bool) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let maxBubbleWidth = screenWidth - ChartViewConstants.collectionViewLeftRightPadding
        let chartViewHeightLayout: CGFloat = 216
        let chartInfoHeight: CGFloat = shouldShowChartInfo ? 52 : 0
        
        let totalHeight = titleHeight + 
            ChartViewConstants.textViewContentInset.top + 
            ChartViewConstants.textViewContentInset.bottom + 
            ChartViewConstants.lineHeight + 
            (metricsHeight > 0 ? metricsHeight + 4 : 0) +
            chartViewHeightLayout +
            chartInfoHeight
        
        return CGSize(width: maxBubbleWidth, height: totalHeight)
    }
}
