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

    // MARK: - Constants
    private enum Constants {
        // Font Sizes
        static let titleFontSize: CGFloat = 16
        static let labelFontSize: CGFloat = 14

        // Fonts
        static var titleFont: UIFont { .systemFont(ofSize: titleFontSize, weight: .medium) }
        static var labelFont: UIFont { .systemFont(ofSize: labelFontSize, weight: .regular) }
        static var unitFont: UIFont { labelFont }
        static var dietTitleFont: UIFont { .boldSystemFont(ofSize: labelFontSize) }
        static var dietTextFont: UIFont { .systemFont(ofSize: titleFontSize, weight: .regular) }

        // Colors
        static let normalColor = UIColor(white: 0.267, alpha: 1)
        static let unitColor = UIColor(white: 0.533, alpha: 1)
        static let dietTextColor = UIColor(white: 0.376, alpha: 1)

        // Layout
        static let metricsLeading: CGFloat = 12
        static let metricsTrailing: CGFloat = 12
        static let metricsSpacing: CGFloat = 8
        static let labelSpacing: CGFloat = 4

        // Misc
        static let lineHeight: CGFloat = 1
        static let collectionPadding: CGFloat = 95
        static let contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 36)
        static let chartViewHeight: CGFloat = 216
        static let chartInfoHeight: CGFloat = 52
        static let dietImageHeight: CGFloat = 48
    }

    // MARK: - Properties
    var title: String
    var titleViewSize: CGSize
    var metricsViewSize: CGSize
    var metrics: [ChartViewMetric]
    var shouldShowChartInfo: Bool
    var dietInfoTitle: String?
    var dietInfoText: String?
    var dietInfoImages: [URL]
    var chartInfoViewSize: CGSize = .zero
    var dietInfoTitleLabelSize: CGSize
    var dietInfoTextLabelSize: CGSize
    var dietInfoImagesViewSize: CGSize
    var size: CGSize
    var chartInfoString: [NSAttributedString] = []

    // MARK: - Computed
    var titleAttributedString: NSAttributedString {
        NSAttributedString(string: title, attributes: [
            .font: Constants.titleFont,
            .foregroundColor: Constants.normalColor
        ])
    }

    var dietInfoTitleAttributedString: NSAttributedString? {
        guard let title = dietInfoTitle else { return nil }
        return NSAttributedString(string: title, attributes: [
            .font: Constants.dietTitleFont,
            .foregroundColor: Constants.dietTextColor
        ])
    }

    var dietInfoTextAttributedString: NSAttributedString? {
        guard let text = dietInfoText else { return nil }
        return NSAttributedString(string: text, attributes: [
            .font: Constants.dietTextFont,
            .foregroundColor: Constants.dietTextColor
        ])
    }

    var metricsStackViewLeadingPadding: CGFloat { Constants.metricsLeading }
    var metricsStackViewTrailingPadding: CGFloat { Constants.metricsTrailing }

    // MARK: - Init
    init(title: String, metrics: [ChartViewMetric], shouldShowChartInfo: Bool, dietInfoTitle: String?, dietInfoText: String?, dietInfoImages: [URL]) {
        self.title = title
        self.metrics = metrics
        self.shouldShowChartInfo = shouldShowChartInfo
        self.dietInfoTitle = dietInfoTitle
        self.dietInfoText = dietInfoText
        self.dietInfoImages = dietInfoImages

        let screenWidth = UIScreen.main.bounds.width
        let maxBubbleWidth = screenWidth - Constants.collectionPadding
        let maxTextWidth = maxBubbleWidth - Constants.contentInset.left - Constants.contentInset.right
        let dietInfoWidth = maxBubbleWidth - 24

        // Title size
        titleViewSize = Self.sizeForText(title, font: Constants.titleFont, maxWidth: maxTextWidth)

        // Metrics size
        metricsViewSize = Self.metricsSize(for: metrics, maxWidth: maxBubbleWidth)

        // Diet Info sizes
        dietInfoTitleLabelSize = Self.sizeForText(dietInfoTitle, font: Constants.dietTitleFont, maxWidth: dietInfoWidth, lines: 1)
        dietInfoTextLabelSize = Self.sizeForText(dietInfoText, font: Constants.dietTextFont, maxWidth: dietInfoWidth)
        dietInfoImagesViewSize = dietInfoImages.isEmpty ? .zero : CGSize(width: dietInfoWidth, height: Constants.dietImageHeight)

        size = Self.totalBubbleSize(
            titleHeight: titleViewSize.height,
            metricsHeight: metricsViewSize.height,
            shouldShowChartInfo: shouldShowChartInfo,
            dietTitleHeight: dietInfoTitleLabelSize.height,
            dietTextHeight: dietInfoTextLabelSize.height,
            dietImagesHeight: dietInfoImagesViewSize.height,
            maxWidth: maxBubbleWidth
        )
    }

    // MARK: - Size Helpers
    private static func sizeForText(_ text: String?, font: UIFont, maxWidth: CGFloat, lines: Int = 0) -> CGSize {
        guard let text = text, !text.isEmpty else { return .zero }
        let attrString = NSAttributedString(string: text, attributes: [.font: font])
        let maxSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        var bounding = attrString.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        bounding.size.width = ceil(bounding.width)
        bounding.size.height = ceil(bounding.height)
        if lines > 0 {
            bounding.size.height = min(bounding.height, font.lineHeight * CGFloat(lines))
        }
        return bounding.size
    }

    private static func metricsSize(for metrics: [ChartViewMetric], maxWidth: CGFloat) -> CGSize {
        guard !metrics.isEmpty else { return .zero }
        let padding = Constants.metricsLeading + Constants.metricsTrailing
        var heights: [CGFloat] = []

        for (index, metric) in metrics.enumerated() {
            let isOddLast = index == metrics.count - 1 && metrics.count % 2 == 1
            let width = isOddLast ? (maxWidth - padding) : (maxWidth - padding - Constants.metricsSpacing) / 2
            let labelHeight = metric.labelAttributedString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
            let valueHeight = metric.valueUnitAttributedString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
            heights.append(labelHeight + Constants.labelSpacing + valueHeight)
        }

        var totalHeight: CGFloat = 0
        for i in stride(from: 0, to: heights.count, by: 2) {
            let rowHeight = max(heights[i], i + 1 < heights.count ? heights[i + 1] : 0)
            totalHeight += rowHeight + Constants.metricsSpacing
        }

        return CGSize(width: maxWidth, height: totalHeight)
    }

    private static func totalBubbleSize(titleHeight: CGFloat, metricsHeight: CGFloat, shouldShowChartInfo: Bool, dietTitleHeight: CGFloat, dietTextHeight: CGFloat, dietImagesHeight: CGFloat, maxWidth: CGFloat) -> CGSize {
        var height = titleHeight + Constants.contentInset.top + Constants.contentInset.bottom + Constants.lineHeight
        if metricsHeight > 0 { height += metricsHeight + 4 }
        height += Constants.chartViewHeight
        if shouldShowChartInfo { height += Constants.chartInfoHeight }

        let dietHasContent = dietTitleHeight > 0 || dietTextHeight > 0 || dietImagesHeight > 0
        if dietHasContent { height += 4 }
        if dietTitleHeight > 0 { height += dietTitleHeight + 4 }
        if dietTextHeight > 0 { height += dietTextHeight + 4 }
        if dietImagesHeight > 0 { height += dietImagesHeight + 4 }

        return CGSize(width: maxWidth, height: height)
    }
}
