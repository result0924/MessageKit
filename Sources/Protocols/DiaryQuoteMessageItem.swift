//
//  DiaryQuoteItem.swift
//  MessageKit
//
//  Created by Justin Lai on 2023/9/4.
//

import Foundation

public protocol PhotoItems {
    /// An array of photos.
    var photos: [PhotoItem] { get }
}

/// Different types of diary quote items.
public enum DiaryQuoteItemType: CaseIterable {
    /// An item that includes both a photo and text.
    case photoAndText

    /// An item that includes text only.
    case textOnly

    /// An item that includes a photo only.
    case photoOnly
    
    /// A situation that should not occur.
    case unknown
}

public protocol DiaryQuoteMessageItem: MessageItem, ActionItem {
    var type: DiaryQuoteItemType { get }
    var title: String { get }
    var recordAt: String { get }
    var mealTypeAndPeriod: String { get }
    var photoURLs: [URL] { get }
    var recordType: String? { get }
    var recordContent: NSAttributedString? { get }
    var quoteOriginY: CGFloat { get }
    var quoteHeight: CGFloat { get }
    var quoteBottomPadding: CGFloat { get }
    var messageHeight: CGFloat { get }
    var size: CGSize { get }
    var replyTextWidth: CGFloat { get }
    var replyTextContentInset: UIEdgeInsets { get }
    var containerViewBackgroundColor: UIColor { get }
}
