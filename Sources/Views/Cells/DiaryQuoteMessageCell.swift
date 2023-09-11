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
        
        return label
    }()
    
    open var mealTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    open var diaryOneImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open var diaryTwoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open var itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.365, green: 0.404, blue: 0.416, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    open var itemDescriptionLabel: UILabel = {
        let label = UILabel()
    
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
    
    open var quoteBottomPaddingView: UIView = {
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
        containerViewOne.addSubview(diaryOneImageView)
        containerViewOne.addSubview(diaryTwoImageView)
        containerViewOne.addSubview(itemLabel)
        containerViewOne.addSubview(itemDescriptionLabel)
        actionLabel.addSubview(lineView)
        containerViewOne.addSubview(actionLabel)
        messageContainerView.addSubview(containerViewOne)
        messageContainerView.addSubview(quoteBottomPaddingView)
        containerViewTwo.addSubview(messageLabel)
        messageContainerView.addSubview(containerViewTwo)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        recordAtLabel.text = nil
        mealTypeLabel.text = nil
        
        messageLabel.attributedText = nil
        actionLabel.attributedText = nil
        itemLabel.text = nil
        itemDescriptionLabel.attributedText = nil
        diaryOneImageView.image = nil
        diaryTwoImageView.image = nil
        diaryOneImageView.frame = .zero
        diaryTwoImageView.frame = .zero
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
            setupText(item: item)
            let bubbleWidth = messageContainerView.frame.size.width
            containerViewOne.frame = CGRectMake(0, 0, bubbleWidth, item.quoteHeight)
            replyImageView.frame = CGRectMake(12, 12, 24, 24)
            titleLabel.frame = CGRectMake(40, 12, bubbleWidth - 40 - 12, 24)
            recordAtLabel.frame = CGRectMake(36, 48, bubbleWidth - 36 - 12, 17)
            mealTypeLabel.frame = CGRectMake(36, 65, bubbleWidth - 36 - 12, 22)
            
            switch item.type {
            case .photoAndText:
                quoteLineView.frame = CGRectMake(16, 48, 4, 183)
                setupImageView(item: item)
                itemLabel.frame = CGRectMake(36, 187, bubbleWidth - 36 - 12, 20)
                itemDescriptionLabel.frame = CGRectMake(36, 207, bubbleWidth - 36 - 12, 24)
                setupItemText(item: item)
            case .photoOnly:
                quoteLineView.frame = CGRectMake(16, 48, 4, 133)
                setupImageView(item: item)
            case .textOnly:
                quoteLineView.frame = CGRectMake(16, 48, 4, 89)
                itemLabel.frame = CGRectMake(36, 93, bubbleWidth - 36 - 12, 20)
                itemDescriptionLabel.frame = CGRectMake(36, 113, bubbleWidth - 36 - 12, 24)
                setupItemText(item: item)
            }
            lineView.frame = CGRectMake(0, 0, bubbleWidth, 0.5)
            lineView.backgroundColor = item.lineColor
            actionLabel.frame = CGRect(x: 0, y: item.quoteOriginY, width: bubbleWidth, height: item.bottomTextViewHeight)
            actionLabel.attributedText = item.actionString
            actionLabel.textContainerInset = item.bottomTextViewContentInset
            actionLabel.textAlignment = .center
            let quoteBottomPaddingViewOriginY = item.quoteOriginY + item.bottomTextViewHeight
            quoteBottomPaddingView.frame = CGRect(x:0, y:quoteBottomPaddingViewOriginY, width: bubbleWidth, height: item.quoteBottomPadding)
            containerViewTwo.frame = CGRect(x:0, y:quoteBottomPaddingViewOriginY + item.quoteBottomPadding, width: bubbleWidth, height: item.messageHeight)
            messageLabel.frame = CGRect(x: 0, y: 0, width: bubbleWidth, height: item.messageHeight)
            messageLabel.attributedText = item.text
            messageLabel.textInsets = item.bottomTextViewContentInset
        default:
            break
        }
        
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
    
    private func setupText(item: DiaryQuoteMessageItem) {
        titleLabel.text = item.title
        recordAtLabel.text = item.recordAt
        mealTypeLabel.text = item.mealTypeAndPeriod
    }
    
    private func setupItemText(item: DiaryQuoteMessageItem) {
        itemLabel.text = item.recordType
        itemDescriptionLabel.attributedText = item.recordContent
    }
    
    private func setupImageView(item: DiaryQuoteMessageItem) {
        guard !item.photoURLs.isEmpty else {
            return
        }
        
        for index in stride(from: 0, to: item.photoURLs.count, by: 1) {
            let imageView = (index == 0) ? diaryOneImageView : diaryTwoImageView
            imageView.frame = CGRect(x: 36 + CGFloat(index) * 91, y: 93, width: 88, height: 88)
        }
    }
}

