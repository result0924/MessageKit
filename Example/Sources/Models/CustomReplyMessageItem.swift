//
//  CustomReplyMessageItem.swift
//  ChatExample
//
//  Created by Edward Chang on 2024/12/25.
//  Copyright © 2024 MessageKit. All rights reserved.
//

import UIKit
import MessageKit

struct CustomReplyMessageItem: ReplyMessageItem {

    static let grayBackgroundColor = UIColor(red: 244 / 255, green: 244 / 255, blue: 244 / 255, alpha: 1)

    struct ReplyItem {
        let isFromOtherSenders: Bool
        let quoteType: ReplyQuoteItemType
        let title: String
        let quoteImage: UIImage?
        let quoteContent: String?
        let quotePhotoURL: URL?
        let replyMessageType: ReplyMessageType
        let replyContent: String
        let quoteViewBackgroundColor: UIColor = grayBackgroundColor
        let replyViewBackgroundColor: UIColor
    }

    let isFromOtherSenders: Bool

    // quote message content
    var quoteType: MessageKit.ReplyQuoteItemType
    let title: String
    let quoteImage: UIImage?
    let quoteContent: String?
    let quotePhotoURL: URL?

    // message content
    let messageType: ReplyMessageType
    let text: NSAttributedString
    var mediaURL: URL?
    let textViewContentInset: UIEdgeInsets
    let replyTextContentInset: UIEdgeInsets
    let textViewHeight: CGFloat

    var quoteOriginY: CGFloat
    var quoteHeight: CGFloat
    var quoteBottomPadding: CGFloat
    let messageHeight: CGFloat
    let size: CGSize
    let replyTextWidth: CGFloat
    let quoteViewBackgroundColor: UIColor
    var replyViewBackgroundColor: UIColor

    init(replyItem: Self.ReplyItem) {
        self.isFromOtherSenders = replyItem.isFromOtherSenders
        self.quoteType = replyItem.quoteType
        self.title = replyItem.title
        self.quoteImage = replyItem.quoteImage
        self.quoteContent = replyItem.quoteContent
        self.quotePhotoURL = replyItem.quotePhotoURL
        self.messageType = replyItem.replyMessageType
        self.textViewContentInset = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        self.replyTextContentInset = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        self.quoteViewBackgroundColor = replyItem.quoteViewBackgroundColor
        self.replyViewBackgroundColor = replyItem.replyViewBackgroundColor

        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let collectionViewLeftRightPadding: CGFloat = 95
        let maxBubbleWidth = screenWidth - collectionViewLeftRightPadding
        let maxTextWidth = maxBubbleWidth - textViewContentInset.left - textViewContentInset.right
        let textSize = CGSize(width: maxTextWidth, height: CGFloat(Float.greatestFiniteMagnitude))

        let contentRect: CGRect
        let boundingRect: CGRect

        let defaultText = NSAttributedString(string: "")

        switch replyItem.replyMessageType {
        case .text:
            let attributedTextString = NSAttributedString(string: replyItem.replyContent, attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 16, weight: .regular)])
            self.text = attributedTextString
            contentRect = attributedTextString.boundingRect(with: textSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            boundingRect = attributedTextString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.zero), options: [.usesLineFragmentOrigin], context: nil)
        case .sticker:
            self.text = defaultText
            self.mediaURL = URL(string: replyItem.replyContent)
            contentRect = CGRect(x: 0, y: 0, width: 96, height: 96)
            boundingRect = CGRect(x: 0, y: 0, width: 96, height: 96)
        }

        var replyHeight: CGFloat = 0
        replyHeight = contentRect.size.height + self.textViewContentInset.top + self.textViewContentInset.bottom

        var quoteContentHeight: CGFloat

        switch quoteType {
        case .smallIcon:
            quoteContentHeight = 84
        case .text:
            let attributedMessageTypeContent = NSAttributedString.init(string: replyItem.quoteContent ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
            let messageTypeContentRect = attributedMessageTypeContent.boundingRect(with: textSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
            quoteContentHeight = min(60 + messageTypeContentRect.size.height, 106)
        case .photo:
            quoteContentHeight = 112
        case .unknown:
            quoteContentHeight = 102
        }

        self.quoteOriginY = quoteContentHeight
        self.textViewHeight = replyHeight.rounded(.up)
        self.quoteBottomPadding = 8
        self.quoteHeight = quoteContentHeight
        self.messageHeight = self.textViewHeight
        self.replyTextWidth = ceil(boundingRect.width) + self.textViewContentInset.left + self.textViewContentInset.right
        self.size = CGSize(width: maxBubbleWidth, height: self.quoteHeight + self.quoteBottomPadding + self.messageHeight)
    }
}
