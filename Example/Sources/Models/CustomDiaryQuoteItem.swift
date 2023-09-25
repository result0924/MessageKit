//
//  CustomDiaryQuoteItem.swift
//  ChatExample
//
//  Created by Justin Lai on 2023/9/4.
//  Copyright © 2023 MessageKit. All rights reserved.
//

import Foundation
import MessageKit

struct CustomDiaryQuoteItem: DiaryQuoteMessageItem {
    
    struct DiaryQuoteItem {
        let type: DiaryQuoteItemType
        let title: String
        let recordAt: String
        let mealTypeAndPeriod: String
        let photoURLs: [URL]
        let recordType: String?
        let recordContent: NSAttributedString?
        let actionString: String
        let replyContent: String
    }
    
    let type: DiaryQuoteItemType
    let title: String
    let recordAt: String
    let mealTypeAndPeriod: String
    let photoURLs: [URL]
    let recordType: String?
    let recordContent: NSAttributedString?
    let lineColor: UIColor
    let actionString: NSAttributedString?
    let text: NSAttributedString
    let textViewContentInset: UIEdgeInsets
    let bottomTextViewContentInset: UIEdgeInsets
    let textViewHeight: CGFloat
    let bottomTextViewHeight: CGFloat
    let onlyHandleTextLink: Bool
    let quoteOriginY: CGFloat
    let quoteHeight: CGFloat
    let quoteBottomPadding: CGFloat
    let messageHeight: CGFloat
    let size: CGSize
    let containerViewBackgroundColor: UIColor

    init(diaryQuoteItem: CustomDiaryQuoteItem.DiaryQuoteItem) {
        self.type = diaryQuoteItem.type
        self.title = diaryQuoteItem.title
        self.recordAt = diaryQuoteItem.recordAt
        self.mealTypeAndPeriod = diaryQuoteItem.mealTypeAndPeriod
        self.photoURLs = diaryQuoteItem.photoURLs
        self.recordType = diaryQuoteItem.recordType
        self.recordContent = diaryQuoteItem.recordContent
        self.lineColor = UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1)
        self.onlyHandleTextLink = true
        self.textViewContentInset = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        self.bottomTextViewContentInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        self.containerViewBackgroundColor = UIColor(red: 244 / 255, green: 244 / 255, blue: 244 / 255, alpha: 1)
        let attributedTextString = NSAttributedString.init(string: diaryQuoteItem.replyContent, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)])
        self.text = attributedTextString
        
        let attributedActionString = NSAttributedString.init(string: diaryQuoteItem.actionString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        self.actionString = attributedActionString

        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let collectionViewLeftRightPadding: CGFloat = 95
        let maxBubbleWidth = screenWidth - collectionViewLeftRightPadding
        let maxTextWidth = maxBubbleWidth - textViewContentInset.left - textViewContentInset.right

        var replyHeight: CGFloat = 0
        let textSize = CGSize(width: maxTextWidth, height: CGFloat(Float.greatestFiniteMagnitude))

        let contentRect = attributedTextString.boundingRect(with: textSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
        replyHeight = contentRect.size.height + self.textViewContentInset.top + self.textViewContentInset.bottom

        var actionHeight: CGFloat = 0

        let bottomContentRect = attributedActionString.boundingRect(with: textSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
        actionHeight = bottomContentRect.size.height + self.bottomTextViewContentInset.top + self.bottomTextViewContentInset.bottom
        
        var diaryQuoteHeight: CGFloat
        
        switch type {
        case .photoAndText:
            diaryQuoteHeight = 233
        case .textOnly:
            diaryQuoteHeight = 139
        case .photoOnly:
            diaryQuoteHeight = 188
        case .unKnown:
            diaryQuoteHeight = 94
        }
        
        self.quoteOriginY = diaryQuoteHeight
        self.textViewHeight = replyHeight.rounded(.up)
        self.bottomTextViewHeight = actionHeight.rounded(.up)
        self.quoteBottomPadding = 8
        self.quoteHeight = diaryQuoteHeight + self.bottomTextViewHeight
        self.messageHeight = self.textViewHeight
        self.size = CGSize(width: maxBubbleWidth, height: self.quoteHeight + self.quoteBottomPadding + self.messageHeight)
    }
}

