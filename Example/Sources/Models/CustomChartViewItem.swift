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
        enum Font {
            static let title = UIFont.systemFont(ofSize: 16, weight: .medium)
            static let label = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let chartInfo = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let unit = label
            static let dietTitle = UIFont.boldSystemFont(ofSize: 14)
            static let dietText = UIFont.systemFont(ofSize: 16, weight: .regular)
            static let message = UIFont.systemFont(ofSize: 16, weight: .regular)
        }

        enum Color {
            static let normal = UIColor(white: 0.267, alpha: 1)
            static let unit = UIColor(white: 0.533, alpha: 1)
            static let dietText = UIColor(white: 0.376, alpha: 1)
        }

        enum Layout {
            static let metricsLeading: CGFloat = 12
            static let metricsTrailing: CGFloat = 12
            static let metricsSpacing: CGFloat = 8
            static let labelSpacing: CGFloat = 4

            static let lineHeight: CGFloat = 1
            static let collectionPadding: CGFloat = 95
            static let contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 36)
            static let chartViewHeight: CGFloat = 216
            static let chartInfoHeight: CGFloat = 52
            static let dietImageHeight: CGFloat = 48

            static let actionContentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            static let actionButtonContentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }
    }

    // MARK: - Properties
    var title: String
    var titleViewSize: CGSize
    var metricsViewSize: CGSize
    var metrics: [ChartViewMetric]
    var dietInfoTitle: String?
    var dietInfoText: String?
    var dietInfoImages: [URL]
    var chartInfos: [NSAttributedString]
    var chartInfoViewSize: CGSize = .zero
    var dietInfoTitleLabelSize: CGSize
    var dietInfoTextLabelSize: CGSize
    var dietInfoImagesViewSize: CGSize
    var messageAttributedString: NSAttributedString?
    var messageLabelSize: CGSize
    var actionAttributedString: NSAttributedString?
    var actionButtonSize: CGSize
    var size: CGSize

    // MARK: - Attributed Strings
    var titleAttributedString: NSAttributedString {
        NSAttributedString(string: title, attributes: [
            .font: Constants.Font.title,
            .foregroundColor: Constants.Color.normal
        ])
    }

    var dietInfoTitleAttributedString: NSAttributedString? {
        guard let title = dietInfoTitle else { return nil }
        return NSAttributedString(string: title, attributes: [
            .font: Constants.Font.dietTitle,
            .foregroundColor: Constants.Color.dietText
        ])
    }

    var dietInfoTextAttributedString: NSAttributedString? {
        guard let text = dietInfoText else { return nil }
        return NSAttributedString(string: text, attributes: [
            .font: Constants.Font.dietText,
            .foregroundColor: Constants.Color.dietText
        ])
    }

    var metricsStackViewLeadingPadding: CGFloat { Constants.Layout.metricsLeading }
    var metricsStackViewTrailingPadding: CGFloat { Constants.Layout.metricsTrailing }

    // MARK: - Init
    init(title: String, metrics: [ChartViewMetric], chartInfos: [NSAttributedString], dietInfoTitle: String?, dietInfoText: String?, dietInfoImages: [URL], messageContent: NSAttributedString?, actionAttributedString: NSAttributedString?) {
        self.title = title
        self.metrics = metrics
        self.chartInfos = chartInfos
        self.dietInfoTitle = dietInfoTitle
        self.dietInfoText = dietInfoText
        self.dietInfoImages = dietInfoImages
        self.messageAttributedString = messageContent
        self.actionAttributedString = actionAttributedString

        let screenWidth = UIScreen.main.bounds.width
        let maxBubbleWidth = screenWidth - Constants.Layout.collectionPadding
        let maxTextWidth = maxBubbleWidth - Constants.Layout.contentInset.left - Constants.Layout.contentInset.right
        let dietInfoWidth = maxBubbleWidth - 24
        let messageWidth = maxBubbleWidth - 24

        titleViewSize = Self.sizeForText(title, font: Constants.Font.title, maxWidth: maxTextWidth)
        metricsViewSize = Self.metricsSize(for: metrics, maxWidth: maxBubbleWidth)
        chartInfoViewSize = Self.chartInfoSize(chartInfos: chartInfos, maxWidth: maxBubbleWidth)

        dietInfoTitleLabelSize = Self.sizeForText(dietInfoTitle, font: Constants.Font.dietTitle, maxWidth: dietInfoWidth, lines: 1)
        dietInfoTextLabelSize = Self.sizeForText(dietInfoText, font: Constants.Font.dietText, maxWidth: dietInfoWidth)
        dietInfoImagesViewSize = dietInfoImages.isEmpty ? .zero : CGSize(width: dietInfoWidth, height: Constants.Layout.dietImageHeight)
        messageLabelSize = Self.sizeForAttributedText(messageContent, maxWidth: messageWidth)

        let actionTextHeight = Self.actionTextHeight(for: actionAttributedString, maxWidth: maxBubbleWidth)
        actionButtonSize = actionTextHeight > 0 ? CGSize(width: maxBubbleWidth - Constants.Layout.actionContentInset.left - Constants.Layout.actionContentInset.right, height: actionTextHeight) : .zero

        size = Self.totalBubbleSize(
            titleHeight: titleViewSize.height,
            metricsHeight: metricsViewSize.height,
            dietTitleHeight: dietInfoTitleLabelSize.height,
            dietTextHeight: dietInfoTextLabelSize.height,
            dietImagesHeight: dietInfoImagesViewSize.height,
            messageContentHeight: messageLabelSize.height,
            actionHeight: actionTextHeight,
            maxWidth: maxBubbleWidth,
            chartInfoSize: chartInfoViewSize
        )
    }

    // MARK: - Size Calculations
    private static func sizeForText(_ text: String?, font: UIFont, maxWidth: CGFloat, lines: Int = 0) -> CGSize {
        guard let text = text, !text.isEmpty else { return .zero }
        let attrString = NSAttributedString(string: text, attributes: [.font: font])
        return sizeForAttributedText(attrString, maxWidth: maxWidth, lines: lines)
    }

    private static func sizeForAttributedText(_ text: NSAttributedString?, maxWidth: CGFloat, lines: Int = 0) -> CGSize {
        guard let text = text, !text.string.isEmpty else { return .zero }
        let maxSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        var bounding = text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        bounding.size.width = ceil(bounding.width)
        bounding.size.height = ceil(bounding.height)
        if lines > 0 {
            let font = (text.attribute(.font, at: 0, effectiveRange: nil) as? UIFont) ?? .systemFont(ofSize: 14)
            bounding.size.height = min(bounding.height, font.lineHeight * CGFloat(lines))
        }
        return bounding.size
    }

    private static func metricsSize(for metrics: [ChartViewMetric], maxWidth: CGFloat) -> CGSize {
        guard !metrics.isEmpty else { return .zero }
        let padding = Constants.Layout.metricsLeading + Constants.Layout.metricsTrailing
        var heights: [CGFloat] = []

        for (index, metric) in metrics.enumerated() {
            let isOddLast = index == metrics.count - 1 && metrics.count % 2 == 1
            let width = isOddLast ? (maxWidth - padding) : (maxWidth - padding - Constants.Layout.metricsSpacing) / 2
            let labelHeight = metric.labelAttributedString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
            let valueHeight = metric.valueUnitAttributedString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
            heights.append(labelHeight + Constants.Layout.labelSpacing + valueHeight)
        }

        var totalHeight: CGFloat = 0
        for i in stride(from: 0, to: heights.count, by: 2) {
            let rowHeight = max(heights[i], i + 1 < heights.count ? heights[i + 1] : 0)
            totalHeight += rowHeight + Constants.Layout.metricsSpacing
        }

        return CGSize(width: maxWidth, height: totalHeight)
    }

    private static func chartInfoSize(chartInfos: [NSAttributedString], maxWidth: CGFloat) -> CGSize {
        guard !chartInfos.isEmpty else { return .zero }
        let availableWidth = maxWidth - 16
        var currentLineWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        let lineHeight: CGFloat = 24

        for info in chartInfos {
            let font = info.attribute(.font, at: 0, effectiveRange: nil) as? UIFont ?? Constants.Font.chartInfo
            let width = (info.string as NSString).size(withAttributes: [.font: font]).width + 16

            if currentLineWidth + width + (currentLineWidth > 0 ? 8 : 0) > availableWidth {
                totalHeight += lineHeight + 8
                currentLineWidth = width
            } else {
                currentLineWidth += (currentLineWidth > 0 ? 8 : 0) + width
            }
        }

        totalHeight += lineHeight + 16
        return CGSize(width: maxWidth, height: totalHeight)
    }

    private static func actionTextHeight(for attr: NSAttributedString?, maxWidth: CGFloat) -> CGFloat {
        guard let attr = attr, !attr.string.isEmpty else { return 0 }
        let contentWidth = maxWidth - Constants.Layout.actionContentInset.left - Constants.Layout.actionContentInset.right - Constants.Layout.actionButtonContentInset.left - Constants.Layout.actionButtonContentInset.right
        let contentSize = sizeForAttributedText(attr, maxWidth: contentWidth)
        return contentSize.height + Constants.Layout.actionButtonContentInset.top + Constants.Layout.actionButtonContentInset.bottom
    }

    private static func totalBubbleSize(
        titleHeight: CGFloat,
        metricsHeight: CGFloat,
        dietTitleHeight: CGFloat,
        dietTextHeight: CGFloat,
        dietImagesHeight: CGFloat,
        messageContentHeight: CGFloat,
        actionHeight: CGFloat,
        maxWidth: CGFloat,
        chartInfoSize: CGSize
    ) -> CGSize {
        let spacing4: CGFloat = 4
        let spacing12: CGFloat = 12
        let lineHeight = Constants.Layout.lineHeight
        let contentInset = Constants.Layout.contentInset
        let actionInset = Constants.Layout.actionContentInset

        var height = contentInset.top + titleHeight + lineHeight + contentInset.bottom

        if metricsHeight > 0 {
            height += metricsHeight + spacing4
        }

        height += Constants.Layout.chartViewHeight + chartInfoSize.height

        let hasDietTitle = dietTitleHeight > 0
        let hasDietText = dietTextHeight > 0
        let hasDietImages = dietImagesHeight > 0
        let hasDietContent = hasDietTitle || hasDietText || hasDietImages

        if hasDietContent {
            height += spacing4
            if hasDietTitle { height += dietTitleHeight + spacing4 }
            if hasDietText { height += dietTextHeight + spacing4 }
            if hasDietImages { height += dietImagesHeight + spacing4 }
        }

        if messageContentHeight > 0 {
            height += (hasDietContent ? spacing12 : spacing4) + lineHeight + spacing12 + messageContentHeight + spacing12
        }

        if actionHeight > 0 {
            if hasDietContent && messageContentHeight == 0 { height += spacing12 }
            else if !hasDietContent && messageContentHeight == 0 { height += spacing4 }
            height += lineHeight + actionInset.top + actionHeight + actionInset.bottom
        }

        return CGSize(width: maxWidth, height: height)
    }
}
