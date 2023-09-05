//
//  CustomTemplateItem.swift
//  ChatExample
//
//  Created by Justin Lai on 2023/9/4.
//  Copyright © 2023 MessageKit. All rights reserved.
//

import Foundation
import MessageKit

struct CustomTemplateItem: TemplateItem {

    var actionString: NSAttributedString?
    var photoURL: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    var text: NSAttributedString
    var textViewContentInset: UIEdgeInsets
    var bottomTextViewContentInset: UIEdgeInsets
    var lineColor: UIColor
    var imageHeight: CGFloat
    var textViewHeight: CGFloat
    var bottomTextViewHeight: CGFloat
    var onlyHandleTextLink: Bool

    init(image: UIImage?, text: String, actionString: String?) {

        // if change must change SDK's template cell
        self.textViewContentInset = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        self.bottomTextViewContentInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        self.lineColor = UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1)

        self.placeholderImage = UIImage(named: "Wu-Zhong") ?? UIImage()
        let attributedTextString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)])
        self.text = attributedTextString
        self.image = image
        
        let attributedActionString = NSAttributedString.init(string: actionString ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)])

        if actionString != nil {
            self.actionString = attributedActionString
        }

        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let collectionViewLeftRightPadding: CGFloat = 95
        let maxBubbleWidth = screenWidth - collectionViewLeftRightPadding
        let maxTextWidth = maxBubbleWidth - textViewContentInset.left - textViewContentInset.right

        // image ratio should be 4:3 (width:height)
        let imageHeight: CGFloat = (image != nil) ? maxBubbleWidth * 9 / 14 : 0

        var height: CGFloat = 0
        let textSize = CGSize(width: maxTextWidth, height: CGFloat(Float.greatestFiniteMagnitude))

        if text.isEmpty == false {
            let contentRect = attributedTextString.boundingRect(with: textSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
            height = contentRect.size.height + self.textViewContentInset.top + self.textViewContentInset.bottom
        }

        var bottomHeight: CGFloat = 0

        if let actionString = actionString, actionString.isEmpty == false {
            let bottomContentRect = attributedActionString.boundingRect(with: textSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
            bottomHeight = bottomContentRect.size.height + self.bottomTextViewContentInset.top + self.bottomTextViewContentInset.bottom
        }
        
        self.imageHeight = imageHeight
        self.textViewHeight = height.rounded(.up)
        self.bottomTextViewHeight = bottomHeight.rounded(.up)

        self.size = CGSize(width: maxBubbleWidth, height: imageHeight + height.rounded(.up) + bottomHeight.rounded(.up))
        self.onlyHandleTextLink = true
    }
}
