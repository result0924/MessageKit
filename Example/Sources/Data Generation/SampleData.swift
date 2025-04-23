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

import UIKit
import MessageKit
import CoreLocation
import AVFoundation

final internal class SampleData {

    static let shared = SampleData()

    private init() {}

    enum MessageTypes: String, CaseIterable {
        case Text
        case AttributedText
        case Photo
        case PhotoFromURL = "Photo from URL"
        case Video
        case Audio
        case Emoji
        case Location
        case Url
        case Phone
        case Custom
        case ShareContact
        case Template
    }

    let system = MockUser(senderId: "000000", displayName: "System")
    let nathan = MockUser(senderId: "000001", displayName: "Nathan Tannar")
    let steven = MockUser(senderId: "000002", displayName: "Steven Deutsch")
    let wu = MockUser(senderId: "000003", displayName: "Wu Zhong")

    lazy var senders = [nathan, steven, wu]
    
    lazy var contactsToShare = [
        MockContactItem(name: "System", initials: "S"),
        MockContactItem(name: "Nathan Tannar", initials: "NT", emails: ["test@test.com"]),
        MockContactItem(name: "Steven Deutsch", initials: "SD", phoneNumbers: ["+1-202-555-0114", "+1-202-555-0145"]),
        MockContactItem(name: "Wu Zhong", initials: "WZ", phoneNumbers: ["202-555-0158"]),
        MockContactItem(name: "+40 123 123", initials: "#", phoneNumbers: ["+40 123 123"]),
        MockContactItem(name: "test@test.com", initials: "#", emails: ["test@test.com"])
    ]

    var currentSender: MockUser {
        return steven
    }

    var now = Date()
    
    let messageImages: [UIImage] = [#imageLiteral(resourceName: "img1"), #imageLiteral(resourceName: "img2")]
    let messageImageURLs: [URL] = [URL(string: "https://placekitten.com/g/200/300")!,
                                   URL(string: "https://placekitten.com/g/300/300")!,
                                   URL(string: "https://placekitten.com/g/300/400")!,
                                   URL(string: "https://placekitten.com/g/400/400")!]

    let emojis = [
        "👍",
        "😂😂😂",
        "👋👋👋",
        "😱😱😱",
        "😃😃😃",
        "❤️"
    ]
    
    let attributes = ["Font1", "Font2", "Font3", "Font4", "Color", "Combo"]
    
    let locations: [CLLocation] = [
        CLLocation(latitude: 37.3118, longitude: -122.0312),
        CLLocation(latitude: 33.6318, longitude: -100.0386),
        CLLocation(latitude: 29.3358, longitude: -108.8311),
        CLLocation(latitude: 39.3218, longitude: -127.4312),
        CLLocation(latitude: 35.3218, longitude: -127.4314),
        CLLocation(latitude: 39.3218, longitude: -113.3317)
    ]

    let sounds: [URL] = [Bundle.main.url(forResource: "sound1", withExtension: "m4a")!,
                         Bundle.main.url(forResource: "sound2", withExtension: "m4a")!
    ]

    let linkItem: (() -> MockLinkItem) = {
        MockLinkItem(
            text: "\(Lorem.sentence()) https://github.com/MessageKit",
            attributedText: nil,
            url: URL(string: "https://github.com/MessageKit")!,
            title: "MessageKit",
            teaser: "A community-driven replacement for JSQMessagesViewController - MessageKit",
            thumbnailImage: UIImage(named: "mkorglogo")!
        )
    }

    func attributedString(with text: String) -> NSAttributedString {
        let nsString = NSString(string: text)
        var mutableAttributedString = NSMutableAttributedString(string: text)
        let randomAttribute = Int(arc4random_uniform(UInt32(attributes.count)))
        let range = NSRange(location: 0, length: nsString.length)
        
        switch attributes[randomAttribute] {
        case "Font1":
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: range)
        case "Font2":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: range)
        case "Font3":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Font4":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Color":
            mutableAttributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: range)
        case "Combo":
            let msg9String = "Use .attributedText() to add bold, italic, colored text and more..."
            let msg9Text = NSString(string: msg9String)
            let msg9AttributedText = NSMutableAttributedString(string: String(msg9Text))
            
            msg9AttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSRange(location: 0, length: msg9Text.length))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: msg9Text.range(of: ".attributedText()"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "bold"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "italic"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: msg9Text.range(of: "colored"))
            mutableAttributedString = msg9AttributedText
        default:
            fatalError("Unrecognized attribute for mock message")
        }
        
        return NSAttributedString(attributedString: mutableAttributedString)
    }

    func dateAddingRandomTime() -> Date {
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .hour, value: randomNumber, to: now)!
            now = date
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: randomMinute, to: now)!
            now = date
            return date
        }
    }
    
    func randomMessageType() -> MessageTypes {
        return MessageTypes.allCases.compactMap {
            guard UserDefaults.standard.bool(forKey: "\($0.rawValue)" + " Messages") else { return nil }
            return $0
        }.random()!
    }

    // swiftlint:disable cyclomatic_complexity
    func randomMessage(allowedSenders: [MockUser]) -> MockMessage {
        let uniqueID = UUID().uuidString
        let user = allowedSenders.random()!
        let date = dateAddingRandomTime()

        switch randomMessageType() {
        case .Text:
            let randomSentence = Lorem.sentence()
            return MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
        case .AttributedText:
            let randomSentence = Lorem.sentence()
            let attributedText = attributedString(with: randomSentence)
            return MockMessage(attributedText: attributedText, user: user, messageId: uniqueID, date: date)
        case .Photo:
            let image = messageImages.random()!
            return MockMessage(image: image, user: user, messageId: uniqueID, date: date)
        case .PhotoFromURL:
            let imageURL: URL = messageImageURLs.random()!
            return MockMessage(imageURL: imageURL, user: user, messageId: uniqueID, date: date)
        case .Video:
            let image = messageImages.random()!
            return MockMessage(thumbnail: image, user: user, messageId: uniqueID, date: date)
        case .Audio:
            let randomNumberSound = Int(arc4random_uniform(UInt32(sounds.count)))
            let soundURL = sounds[randomNumberSound]
            return MockMessage(audioItem: MockAudioItem(image: nil, text: "", audioURL: soundURL), user: user, messageId: uniqueID, date: date)
        case .Emoji:
            return MockMessage(emoji: emojis.random()!, user: user, messageId: uniqueID, date: date)
        case .Location:
            return MockMessage(location: locations.random()!, user: user, messageId: uniqueID, date: date)
        case .Url:
            return MockMessage(linkItem: linkItem(), user: user, messageId: uniqueID, date: date)
        case .Phone:
            return MockMessage(text: "123-456-7890", user: user, messageId: uniqueID, date: date)
        case .Custom:
            return MockMessage(custom: "Someone left the conversation", user: system, messageId: uniqueID, date: date)
        case .ShareContact:
            return MockMessage(contact: contactsToShare.random()!, user: user, messageId: uniqueID, date: date)
        case .Template:
            let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
            let image = messageImages[randomNumberImage]
            let randomSentence = Lorem.sentence()
            return MockMessage(template: CustomTemplateItem(image: image, text: randomSentence, actionString: "send"), user: user, messageId: uniqueID, date: date)
        }
    }
    // swiftlint:enable cyclomatic_complexity

    func getMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = senders.random()!
            let date = dateAddingRandomTime()
            let randomSentence = Lorem.sentence()
            let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getMessages(count: Int) -> [MockMessage] {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = senders.random()!
            let date = dateAddingRandomTime()
            let randomSentence = Lorem.sentence()
            let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        return messages
    }
    
    func getAdvancedMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Enable Custom Messages
        UserDefaults.standard.set(true, forKey: "Custom Messages")
        for _ in 0..<count {
            let message = randomMessage(allowedSenders: senders)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getTemplateMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Enable Template Messages
        UserDefaults.standard.set(true, forKey: "Template Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let date = dateAddingRandomTime()
            let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
            let image = messageImages[randomNumberImage]
            let randomSentence = Lorem.sentence()
            let message = MockMessage(template: CustomTemplateItem(image: image, text: randomSentence, actionString: "send"), user: system, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getDiaryQuoteMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Enable Template Messages
        UserDefaults.standard.set(true, forKey: "Diary Quote Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let date = dateAddingRandomTime()
            let inputString = "256 mg/dL"
            let attributedString = NSMutableAttributedString(string: inputString)

            if let range256 = inputString.range(of: "256") {
                let largeFont = UIFont.systemFont(ofSize: 20)
                let largeTextColor = UIColor(red: 0.365, green: 0.404, blue: 0.416, alpha: 1)
                let nsRange256 = NSRange(range256, in: inputString)
                
                attributedString.addAttribute(.font, value: largeFont, range: nsRange256)
                attributedString.addAttribute(.foregroundColor, value: largeTextColor, range: nsRange256)
            }

            if let rangemgDL = inputString.range(of: "mg/dL") {
                let smallFont = UIFont.systemFont(ofSize: 14)
                let smallTextColor = UIColor(red: 0.365, green: 0.404, blue: 0.416, alpha: 1)
                let nsRangemgDL = NSRange(rangemgDL, in: inputString)
                
                attributedString.addAttribute(.font, value: smallFont, range: nsRangemgDL)
                attributedString.addAttribute(.foregroundColor, value: smallTextColor, range: nsRangemgDL)
            }
            let randomSentence = "建議減少正餐醣類的份量，肉類和蔬菜幾乎不會影響血糖，可以多點一份肉類、沙拉，幫助穩定飯後血糖！http://google.com"
            let type = DiaryQuoteItemType.allCases.randomElement() ?? .photoAndText
            var diaryQuoteItem: CustomDiaryQuoteItem.DiaryQuoteItem
            let fakeURL = URL(string: "url")!
            let fakeRecordAtText = "2023年06月13日 上午11:38"
            switch type {
            case .photoAndText:
                diaryQuoteItem = CustomDiaryQuoteItem.DiaryQuoteItem(type: type, title: "回覆了你的日記", recordAt: fakeRecordAtText, mealTypeAndPeriod: "午餐前", photoURLs: [fakeURL, fakeURL], recordType: "血糖", recordContent: attributedString, actionString: "查看日記", replyContent: randomSentence)
            case .photoOnly:
                diaryQuoteItem = CustomDiaryQuoteItem.DiaryQuoteItem(type: type, title: "回覆了你的日記", recordAt: fakeRecordAtText, mealTypeAndPeriod: "午餐前", photoURLs: [fakeURL], recordType: nil, recordContent: nil, actionString: "查看日記", replyContent: randomSentence)
            case .textOnly:
                diaryQuoteItem = CustomDiaryQuoteItem.DiaryQuoteItem(type: type, title: "回覆了你的日記", recordAt: fakeRecordAtText, mealTypeAndPeriod: "午餐前", photoURLs: [], recordType: "體重", recordContent: attributedString, actionString: "查看日記", replyContent: randomSentence)
            case .unknown:
                diaryQuoteItem = CustomDiaryQuoteItem.DiaryQuoteItem(type: type, title: "回覆了你的日記", recordAt: fakeRecordAtText, mealTypeAndPeriod: "午餐前", photoURLs: [], recordType: "", recordContent: attributedString, actionString: "查看日記", replyContent: randomSentence)
            }
            let message = MockMessage(diaryQuote: CustomDiaryQuoteItem(diaryQuoteItem: diaryQuoteItem), user: system, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getReplyMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let date = dateAddingRandomTime()

            let type = ReplyQuoteItemType.allCases.dropLast().randomElement() ?? .text
            var replyItem: CustomReplyMessageItem.ReplyItem

            let sender = senders.random() ?? currentSender
            let isFromOtherSenders = sender != currentSender
            let replyViewBackgroundColor = isFromOtherSenders ? CustomReplyMessageItem.grayBackgroundColor : .systemGreen
            switch type {
            case .smallIcon:
                replyItem = CustomReplyMessageItem.ReplyItem(isFromOtherSenders: isFromOtherSenders, quoteType: .smallIcon, title: "回覆", quoteImage: UIImage(imageLiteralResourceName: "image_message_placeholder"), quoteContent: "Title.pdf", quotePhotoURL: nil, replyMessageType: .text, replyContent: "回覆訊息photoAndText", replyViewBackgroundColor: replyViewBackgroundColor)
            case .photo:
                replyItem = CustomReplyMessageItem.ReplyItem(isFromOtherSenders: isFromOtherSenders, quoteType: .photo, title: "回覆", quoteImage: nil, quoteContent: "回覆訊息photoOnly", quotePhotoURL: nil, replyMessageType: .text, replyContent: "回覆訊息photoOnly", replyViewBackgroundColor: replyViewBackgroundColor)
            case .text:
                replyItem = CustomReplyMessageItem.ReplyItem(isFromOtherSenders: isFromOtherSenders, quoteType: .text, title: "回覆", quoteImage: nil, quoteContent: "textOnly", quotePhotoURL: nil, replyMessageType: .sticker, replyContent: "https://dev.health2sync.com/images/stickers/1/s_014.png", replyViewBackgroundColor: .clear)
            case .unknown:
                replyItem = CustomReplyMessageItem.ReplyItem(isFromOtherSenders: isFromOtherSenders, quoteType: .unknown, title: "回覆", quoteImage: nil, quoteContent: "textOnly", quotePhotoURL: nil, replyMessageType: .text, replyContent: "回覆訊息unknown", replyViewBackgroundColor: replyViewBackgroundColor)
            }
            let message = MockMessage(reply: CustomReplyMessageItem(replyItem: replyItem), user: sender, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }

    func getChartMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        let titles = ["1/13 午餐 血糖波動", "1/14 晚餐 血糖波動", "1/15 早餐 血糖波動早餐 血糖波動"]
        let metricsLabels = ["Total Weight Change Total Weight Change", "Last Weight", "BMI", "Body Fat"]
        let units = ["kg", "kg", "", "%"]
        let possibleDietTitles = ["營養建議", "飲食重點飲食重點飲食重點飲食重點飲食重點飲食重點飲食重點飲食重點", ""]
        let possibleDietTexts = [
            "建議多攝取高纖蔬菜、減少糖分攝取，有助穩定血糖波動。建議多攝取高纖蔬菜、減少糖分攝取，有助穩定血糖波動。建議多攝取高纖蔬菜、減少糖分攝取，有助穩定血糖波動。",
            "早餐請選擇低GI值食物，例如全穀類或豆製品。",
            ""
        ]
        let messageContents = ["📓 筆記本：對糖尿病前期或糖尿病高風險族群來說，維持血糖穩定及控制體重是預防糖尿病的關鍵", "對糖尿病前期或糖尿病高風險族群來說，維持血糖穩定及控制體重是預防糖尿病的關鍵；其中，飲食習慣更是影響血糖、體重的重要因素，建議養成定時進食的習慣，以少糖、少油、少鹽為原則。", ""]
        
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let date = dateAddingRandomTime()
            let sender = senders.random() ?? currentSender
            let title = titles.randomElement() ?? titles[0]
            
            // 隨機生成 0-4 個 metrics
            let metricsCount = Int.random(in: 0...4)
            var metrics: [ChartViewMetric] = []
            
            for i in 0..<metricsCount {
                let label = metricsLabels[i]
                let unit = units[i]
                let value = String(format: "%.1f", Double.random(in: 50...100))
                let colors: [UIColor] = [
                    UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 1),  // normal
                    UIColor(red: 150.0/255.0, green: 118.0/255.0, blue: 214.0/255.0, alpha: 1),  // low
                    UIColor(red: 252.0/255.0, green: 180.0/255.0, blue: 93.0/255.0, alpha: 1)  // high
                ]
                let valueColor = colors.randomElement() ?? colors[0]
                
                let metric = ChartViewMetric(
                    label: label,
                    value: value,
                    unit: unit,
                    valueColor: valueColor
                )
                metrics.append(metric)
            }
            
            let dietInfoTitle = possibleDietTitles.randomElement()
            let dietInfoText = possibleDietTexts.randomElement()
            
            let dietInfoImages: [URL]
            if Bool.random() {
                let count = Int.random(in: 0...10)
                dietInfoImages = Array(repeating: URL(string: "https://dev.health2sync.com/images/stickers/1/s_014.png")!, count: count)
            } else {
                dietInfoImages = []
            }
            let font = UIFont.systemFont(ofSize: 16, weight: .regular)
            let textColor = UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 1)

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor
            ]
            let messageElement = NSMutableAttributedString(string: messageContents.randomElement() ?? titles[0], attributes: attributes)
            let actionStrings = ["血糖波動", "1/14 晚餐 血糖波動 action string yoyoyo", ""]
            
            
            let font2 = UIFont.systemFont(ofSize: 18, weight: .semibold)
            let textColor2 = UIColor(red: 0.169, green: 0.71, blue: 0.608, alpha: 1)

            let attributes2: [NSAttributedString.Key: Any] = [
                .font: font2,
                .foregroundColor: textColor2
            ]
            let actionAttributedString = NSMutableAttributedString(string: actionStrings.randomElement() ?? actionStrings[0], attributes: attributes2)
            
            let chartViewItem = CustomChartViewItem(
                title: title,
                metrics: metrics,
                shouldShowChartInfo: false,
                dietInfoTitle: dietInfoTitle,
                dietInfoText: dietInfoText,
                dietInfoImages: dietInfoImages,
                messageContent: messageElement,
                actionAttributedString: actionAttributedString,
            )
            let message = MockMessage(chartView: chartViewItem, user: sender, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }

    func getTemplateAudioMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Enable Template Messages
        UserDefaults.standard.set(true, forKey: "Template Messages")
        for i in 0..<count {
            let uniqueID = UUID().uuidString
            let date = dateAddingRandomTime()
            let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
            let image = i % 2 == 0 ? nil : messageImages[randomNumberImage]
            let randomSentence = i % 3 == 0 ? "https://tw.yahoo.com" : Lorem.sentence()
            let randomNumberSound = Int(arc4random_uniform(UInt32(sounds.count)))
            let soundURL = sounds[randomNumberSound]
            let message = MockMessage(audioItem: MockAudioItem(image: image, text: randomSentence, audioURL: soundURL), user: system, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }

    func getMessages(count: Int, allowedSenders: [MockUser], completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = senders.random()!
            let date = dateAddingRandomTime()
            let randomSentence = Lorem.sentence()
            let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }

    func getAvatarFor(sender: SenderType) -> Avatar {
        let firstName = sender.displayName.components(separatedBy: " ").first
        let lastName = sender.displayName.components(separatedBy: " ").first
        let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
        switch sender.senderId {
        case "000001":
            return Avatar(image: #imageLiteral(resourceName: "Nathan-Tannar"), initials: initials)
        case "000002":
            return Avatar(image: #imageLiteral(resourceName: "Steven-Deutsch"), initials: initials)
        case "000003":
            return Avatar(image: #imageLiteral(resourceName: "Wu-Zhong"), initials: initials)
        case "000000":
            return Avatar(image: nil, initials: "SS")
        default:
            return Avatar(image: nil, initials: initials)
        }
    }

}
