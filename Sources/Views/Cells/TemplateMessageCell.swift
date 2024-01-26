//
//  TemplateMessageCell.swift
//  MessageKit
//
//  Created by justin on 2020/04/22.
//  Copyright © 2020 MessageKit. All rights reserved.
//
// Note: iOS version need more than iOS 11

import UIKit

open class TemplateMessageCell: MessageContentCell {
    private var onlyHandleTextLink: Bool = false
    
    /// The `MessageCellDelegate` for the cell.
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }
    
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    open var messageLabel = MessageLabel()

    open var actionButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.borderColor = UIColor(red: 45 / 255, green: 181 / 255, blue: 155 / 255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()

    open var actionBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        return backgroundView
    }()

    // MARK: - Methods

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(imageView)
        messageContainerView.addSubview(messageLabel)
        messageContainerView.addSubview(actionBackgroundView)
        messageContainerView.addSubview(actionButton)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        imageView.image = nil
        actionButton.setAttributedTitle(nil, for: .normal)
    }

    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        if onlyHandleTextLink {
            super.handleTapGesture(gesture)
            return
        }
        
        let touchLocation = gesture.location(in: self)
        let actionView = actionBackgroundView.frame.size.height > 0 ? actionBackgroundView : messageLabel
        let actionViewTouchArea = CGRect(actionView.frame.origin.x, actionView.frame.origin.y, actionView.frame.size.width, actionView.frame.size.height)
        let translateTouchLocation = convert(touchLocation, to: messageContainerView)
        if actionViewTouchArea.contains(translateTouchLocation) {
            delegate?.didTapActionView(in: self)
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
        case .template(let item), .media(let item as TemplateItem):
            let bubbleWidth = messageContainerView.frame.size.width
            imageView.image = item.image ?? item.placeholderImage
            let imageHeight = item.imageHeight
            let textViewHeight = item.textViewHeight
            let bottomTextViewHeight = item.bottomTextViewHeight
            imageView.frame = CGRect(x: 0, y: 0, width: bubbleWidth, height: imageHeight)
            messageLabel.frame = CGRect(x: 0, y: imageHeight, width: bubbleWidth, height: textViewHeight)
            actionBackgroundView.frame = CGRect(x: 0, y: imageHeight + textViewHeight, width: bubbleWidth, height: bottomTextViewHeight)
            actionButton.frame = CGRect(x: 12, y: imageHeight + textViewHeight, width: bubbleWidth - 24, height: bottomTextViewHeight - 14)
            actionButton.isHidden = item.actionString == nil
            messageLabel.attributedText = item.text
            messageLabel.textInsets = item.textViewContentInset
            actionButton.setAttributedTitle(item.actionString, for: .normal)
            actionButton.contentEdgeInsets = item.bottomTextViewContentInset
            onlyHandleTextLink = item.onlyHandleTextLink
        default:
            break
        }

            displayDelegate.configurePhotoMessageImageView(imageView, for: message, at: indexPath, in: messagesCollectionView)
        
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
        let translateTouchLocation = CGPoint(x: touchPoint.x, y: touchPoint.y - imageView.frame.size.height)
        return messageLabel.handleGesture(translateTouchLocation)
    }
}
