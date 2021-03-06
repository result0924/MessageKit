/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import CoreLocation
import MessageKit
import AVFoundation

private struct CoordinateItem: LocationItem {

    var location: CLLocation
    var size: CGSize

    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }

}

private struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }

}

struct MockAudiotem: AudioItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    var text: NSAttributedString
    var textViewContentInset: UIEdgeInsets
    var lineColor: UIColor
    var imageHeight: CGFloat
    var textViewHeight: CGFloat
    var audioURL: URL
    var audioDuration: Float
    var audioSize: CGSize

    init(image: UIImage?, text: String, audioURL: URL) {

        // if change must change SDK's template cell
        self.textViewContentInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self.lineColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)

        self.placeholderImage = UIImage(named: "Wu-Zhong") ?? UIImage()
        let attributedTextString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)])
        self.text = attributedTextString
        self.image = image

        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let collectionViewLeftRightPadding: CGFloat = 95
        let onlyAudio = image == nil && text.isEmpty
        let maxBubbleWidth = onlyAudio ? 160 : screenWidth - collectionViewLeftRightPadding
        let maxTextWidth = maxBubbleWidth - textViewContentInset.left - textViewContentInset.right

        // image ratio should be 4:3 (width:height)
        let imageHeight: CGFloat = (image != nil) ? maxBubbleWidth * 3 / 4 : 0

        var height: CGFloat = 0
        let textSize = CGSize(width: maxTextWidth, height: CGFloat(Float.greatestFiniteMagnitude))

        if text.isEmpty == false {
            let contentRect = attributedTextString.boundingRect(with: textSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
            height = contentRect.size.height + self.textViewContentInset.top + self.textViewContentInset.bottom
        }

        self.imageHeight = imageHeight
        self.textViewHeight = height.rounded(.up)
        self.audioURL = audioURL
        // compute duration
        let audioAsset = AVURLAsset(url: audioURL)
        self.audioDuration = Float(CMTimeGetSeconds(audioAsset.duration))
        self.audioSize = CGSize(width: maxBubbleWidth, height: 40)

        self.size = CGSize(width: maxBubbleWidth, height: imageHeight + height.rounded(.up) + audioSize.height)
    }

}

struct MockContactItem: ContactItem {
    
    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]
    
    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
        self.displayName = name
        self.initials = initials
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }
    
}

internal struct MockMessage: MessageType {

    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind

    var user: MockUser

    private init(kind: MessageKind, user: MockUser, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(custom: Any?, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date)
    }

    init(text: String, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }

    init(attributedText: NSAttributedString, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date)
    }

    init(image: UIImage, user: MockUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(thumbnail: UIImage, user: MockUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date)
    }

    init(location: CLLocation, user: MockUser, messageId: String, date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date)
    }

    init(emoji: String, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date)
    }

    init(audioItem: MockAudiotem, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date)
    }

    init(contact: MockContactItem, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date)
    }

    init(template: CustomTemplateItem, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .template(template), user: user, messageId: messageId, date: date)
    }
}

struct CustomTemplateItem: TemplateItem {
    var actionString: NSAttributedString?
    var url: URL?
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

    init(image: UIImage?, text: String, actionString: String?) {

        // if change must change SDK's template cell
        self.textViewContentInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        self.bottomTextViewContentInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        self.lineColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)

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
        let imageHeight: CGFloat = (image != nil) ? maxBubbleWidth * 3 / 4 : 0

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
    }
}
