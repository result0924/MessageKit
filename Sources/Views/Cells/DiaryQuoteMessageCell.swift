//
//  DiaryQuoteMessageCell.swift
//  MessageKit
//
//  Created by Justin Lai on 2023/9/4.
//

import UIKit

open class DiaryQuoteMessageCell: MessageContentCell {
    private var onlyHandleTextLink: Bool = false
    
    /// The `MessageCellDelegate` for the cell.
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }
    
    open var containerViewOne: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    open var replyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let assetBundle = Bundle.messageKitAssetBundle()
        let imagePath = assetBundle.path(forResource: "reply", ofType: "png", inDirectory: "Images")
        let image = UIImage(contentsOfFile: imagePath ?? "")
        imageView.image = image
        return imageView
    }()
    
    open var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "回覆了你的日記"
        
        return label
    }()
    
    open var quoteLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        
        return view
    }()
    
    open var recordAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "2023年06月13日 上午11:38"
        
        return label
    }()
    
    open var mealTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "午餐前"
        
        return label
    }()
    
    open var imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    open var diaryOneImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(imageLiteralResourceName: "img1")
        return imageView
    }()
    
    open var diaryTwoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(imageLiteralResourceName: "img2")
        return imageView
    }()
    
    open var itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.365, green: 0.404, blue: 0.416, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "血糖"
        
        return label
    }()
    
    open var itemDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        let inputString = "256 mg/dL"
        let attributedString = NSMutableAttributedString(string: inputString)
        let largeFont = UIFont.systemFont(ofSize: 20, weight: .medium)
        let largeTextColor = UIColor(red: 0.365, green: 0.404, blue: 0.416, alpha: 1)

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
        
        label.attributedText = attributedString
        
        return label
    }()
    
    open var containerViewTwo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()

    open var messageLabel = MessageLabel()

    open var lineView: UIView = {
        let lineView = UIView()
        return lineView
    }()

    open var actionLabel: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.contentInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        if #available(iOS 11.0, *) {
            textView.adjustsFontForContentSizeCategory = true
        }
        return textView
    }()
    
    open var emptyView: UIView = {
        let emptyView = UIView()
        return emptyView
    }()

    // MARK: - Methods

    open override func setupSubviews() {
        super.setupSubviews()
        containerViewOne.addSubview(replyImageView)
        containerViewOne.addSubview(titleLabel)
        containerViewOne.addSubview(quoteLineView)
        containerViewOne.addSubview(recordAtLabel)
        containerViewOne.addSubview(mealTypeLabel)
        imageStackView.addArrangedSubview(diaryOneImageView)
        imageStackView.addArrangedSubview(diaryTwoImageView)
        containerViewOne.addSubview(imageStackView)
        containerViewOne.addSubview(itemLabel)
        containerViewOne.addSubview(itemDescriptionLabel)
        containerViewOne.addSubview(lineView)
        containerViewOne.addSubview(actionLabel)
        messageContainerView.addSubview(containerViewOne)
        messageContainerView.addSubview(emptyView)
        containerViewTwo.addSubview(messageLabel)
        messageContainerView.addSubview(containerViewTwo)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        actionLabel.attributedText = nil
    }

    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        if onlyHandleTextLink {
            super.handleTapGesture(gesture)
            return
        }
        
        let touchLocation = gesture.location(in: self)
        // compute action label touch area, currently action label which is hardly touchable
        let actionView = actionLabel.frame.size.height > 0 ? actionLabel : messageLabel
        let actionViewTouchArea = CGRect(actionView.frame.origin.x, actionView.frame.origin.y, actionView.frame.size.width, actionView.frame.size.height)
        let translateTouchLocation = convert(touchLocation, to: messageContainerView)
        if actionViewTouchArea.contains(translateTouchLocation) {
            delegate?.didTapDiaryQuoteActionView(in: self)
        } else {
            super.handleTapGesture(gesture)
        }
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        switch message.kind {
        case .diaryQuote(let item):
            let bubbleWidth = messageContainerView.frame.size.width
            containerViewOne.frame = CGRectMake(0, 0, bubbleWidth, 288)
            replyImageView.frame = CGRectMake(12, 12, 24, 24)
            titleLabel.frame = CGRectMake(40, 12, bubbleWidth - 40 - 12, 24)
            quoteLineView.frame = CGRectMake(16, 48, 4, 183)
            recordAtLabel.frame = CGRectMake(36, 48, bubbleWidth - 36 - 12, 17)
            mealTypeLabel.frame = CGRectMake(36, 65, bubbleWidth - 36 - 12, 22)
            imageStackView.frame = CGRectMake(36, 93, 179, 88)
            imageStackView.addArrangedSubview(diaryOneImageView)
            imageStackView.addArrangedSubview(diaryTwoImageView)
            itemLabel.frame = CGRectMake(36, 187, bubbleWidth - 36 - 12, 20)
            itemDescriptionLabel.frame = CGRectMake(36, 207, bubbleWidth - 36 - 12, 24)
            lineView.frame = CGRectMake(0, 243, bubbleWidth, 0.5)
            lineView.backgroundColor = UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1)
            actionLabel.frame = CGRect(x: 0, y: 243.5, width: bubbleWidth, height: 45)
            actionLabel.attributedText = NSAttributedString(string: "查看日記", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.169, green: 0.71, blue: 0.608, alpha: 1) as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            actionLabel.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            actionLabel.textAlignment = .center
            emptyView.frame = CGRect(x:0, y:288, width: bubbleWidth, height: 8)
            containerViewTwo.frame = CGRect(x:0, y:296, width: bubbleWidth, height: 132)
            messageLabel.frame = CGRect(x: 0, y: 0, width: bubbleWidth, height: 132)
            let message = "建議減少正餐醣類的份量，肉類和蔬菜幾乎不會影響血糖，可以多點一份肉類、沙拉，幫助穩定飯後血糖！"
            let messageAttributedString = NSMutableAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 1) as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = 24
            paragraphStyle.maximumLineHeight = 24
            messageAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: message.count))
            messageLabel.attributedText = messageAttributedString
            messageLabel.textInsets = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        default:
            break
        }

        displayDelegate.configurePhotoMessageImageView(replyImageView, for: message, at: indexPath, in: messagesCollectionView)
        
        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)

        messageLabel.configure {
            messageLabel.enabledDetectors = enabledDetectors
            for detector in enabledDetectors {
                let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                messageLabel.setAttributes(attributes, detector: detector)
            }
        }
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        let translateTouchLocation = CGPoint(x: touchPoint.x, y: touchPoint.y - replyImageView.frame.size.height)
        return messageLabel.handleGesture(translateTouchLocation)
    }
}

