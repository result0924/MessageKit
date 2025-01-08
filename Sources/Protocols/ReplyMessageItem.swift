//
//  ReplyMessageItem.swift
//  MessageKit
//
//  Created by Edward Chang on 2024/12/25.
//

import Foundation

/// Different types of rely item
public enum ReplyQuoteItemType: CaseIterable {
    /// An item that includes both a photo and text.
    case photoAndText

    /// An item that includes text only.
    case textOnly

    /// An item that includes a photo only.
    case photoOnly

    /// A situation that should not occur.
    case unknown
}

public enum ReplyMessageType {
    case text
    case sticker
}

public protocol ReplyMessageItem: MessageItem {
    var quoteType: ReplyQuoteItemType { get }
    var title: String { get }
    var quoteImage: UIImage? { get }
    var quoteContent: String? { get }
    var quotePhotoURL: URL? { get }
    var quoteOriginY: CGFloat { get }
    var quoteHeight: CGFloat { get }
    var quoteBottomPadding: CGFloat { get }
    var messageHeight: CGFloat { get }
    var size: CGSize { get }
    var messageType: ReplyMessageType { get }
    var mediaURL: URL? { get }
    var replyTextWidth: CGFloat { get }
    var replyTextContentInset: UIEdgeInsets { get }
    var quoteViewBackgroundColor: UIColor { get }
    var replyViewBackgroundColor: UIColor { get }
}
