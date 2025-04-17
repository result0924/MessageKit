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
    var title: String
    var titleViewSize: CGSize
    var size: CGSize
    
    init(title: String) {
        self.title = title
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let collectionViewLeftRightPadding: CGFloat = 95
        let maxBubbleWidth = screenWidth - collectionViewLeftRightPadding
        let textViewContentInset = UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 36)
        let maxTextWidth = maxBubbleWidth - textViewContentInset.left - textViewContentInset.right
        let textSize = CGSize(width: maxTextWidth, height: CGFloat(Float.greatestFiniteMagnitude))
        let attributedTextString = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        let contentRect = attributedTextString.boundingRect(with: textSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
        let titleHeight = contentRect.size.height + textViewContentInset.top + textViewContentInset.bottom
        let lineHeight: CGFloat = 0.5
        self.titleViewSize = CGSize(width: maxTextWidth, height: contentRect.size.height)
        self.size = CGSize(width: maxBubbleWidth, height:titleHeight + lineHeight + 200)
    }
}
