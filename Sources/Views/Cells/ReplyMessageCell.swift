//
//  ReplyMessageCell.swift
//  MessageKit
//
//  Created by Edward Chang on 2024/12/25.
//

import UIKit

open class ReplyMessageCell: MessageContentCell {
    /// The `MessageCellDelegate` for the cell.
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }

    open var containerViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    open var replyIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    open var quoteLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()

    // photo
    open var quoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()

    // file icon
    open var quoteIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // replied message
    open var quoteContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    open var quoteBottomPaddingView: UIView = {
        let emptyView = UIView()
        return emptyView
    }()

    open var containerViewTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    open var messageLabel = MessageLabel()

    open var mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private var containerViewOneHeightLayout: NSLayoutConstraint?
    private var containerViewWidthLayout: NSLayoutConstraint?
    private var titleLabelWidthLayout: NSLayoutConstraint?
    private var quoteLineViewHeightLayout: NSLayoutConstraint?
    private var quoteLabelTopLayout: NSLayoutConstraint?
    private var quoteLabelOriginXLayout: NSLayoutConstraint?
    private var quoteLabelWidthLayout: NSLayoutConstraint?
    private var containerViewTwoOriginY: CGFloat = 0

    // MARK: - Methods

    open override func setupSubviews() {
        super.setupSubviews()
        containerViewOne.addSubview(replyIconView)
        containerViewOne.addSubview(titleLabel)
        containerViewOne.addSubview(quoteLineView)
        containerViewOne.addSubview(quoteIconView)
        containerViewOne.addSubview(quoteImageView)
        containerViewOne.addSubview(quoteContentLabel)
        messageContainerView.addSubview(containerViewOne)
        messageContainerView.addSubview(quoteBottomPaddingView)
        containerViewTwo.addSubview(messageLabel)
        containerViewTwo.addSubview(mediaImageView)
        messageContainerView.addSubviews(containerViewTwo)

        setupContainerViewOneConstraints(frame: .zero)
        let itemOriginX: CGFloat = 36
        let photoOriginY: CGFloat = 48
        setupReplyIconViewConstraints(frame: CGRectMake(12, 12, 24, 24))
        setupTitleLabelConstraints(frame: CGRectMake(40, 12, 0, 24))
        setupQuoteLineViewConstraints(frame: CGRectMake(16, 48, 4, 0))
        setupQuoteIconViewConstrains(frame: CGRectMake(itemOriginX, photoOriginY + 1, 24, 24))
        setupQuoteImageViewConstrains(frame: CGRectMake(itemOriginX, photoOriginY, 48, 48))
        setupQuoteContentLabelConstraints(frame: CGRectMake(itemOriginX + 36, photoOriginY, 0, 16))
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        quoteIconView.image = nil
        quoteImageView.image = nil
        quoteContentLabel.text = nil
        quoteIconView.isHidden = true
        quoteImageView.isHidden = true
        messageLabel.attributedText = nil
        mediaImageView.image = nil
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        messageContainerView.backgroundColor = .clear

        switch message.kind {
        case .reply(let item):
            setupText(item: item)
            let bubbleWidth = messageContainerView.frame.size.width
            containerViewWidthLayout?.constant = bubbleWidth
            containerViewOneHeightLayout?.constant = item.quoteHeight
            let titleLabelWidth = bubbleWidth - 24 - 4 - 12 * 2 // -replyImageWidth - spacing - edgeInset
            let labelWidth = bubbleWidth - 32 - 4 - 16 // -imageWidth - spacing - edgeInset
            titleLabelWidthLayout?.constant = titleLabelWidth
            quoteLabelWidthLayout?.constant = labelWidth

            containerViewOne.backgroundColor = item.quoteViewBackgroundColor
            containerViewTwo.backgroundColor = item.replyViewBackgroundColor

            switch item.quoteType {
            case .smallIcon:
                quoteIconView.isHidden = false
                quoteImageView.isHidden = true
                quoteContentLabel.numberOfLines = 1
                setupQuoteIconView(item: item)
                quoteLineViewHeightLayout?.constant = item.quoteHeight - 56
                quoteLabelTopLayout?.constant = 52
                quoteLabelOriginXLayout?.constant = 72
                quoteLabelWidthLayout?.constant = labelWidth - 24 - 4 * 2 // -imageWidth - spacing
            case .photo:
                quoteIconView.isHidden = true
                quoteImageView.isHidden = false
                quoteContentLabel.numberOfLines = 3
                setupQuoteImageView(item: item)
                quoteLabelTopLayout?.constant = 50
                quoteLabelOriginXLayout?.constant = 96
                quoteLineViewHeightLayout?.constant =  48
                quoteLabelWidthLayout?.constant = labelWidth - 48 - 8 * 2 // -imageWidth - spacing
            case .text:
                quoteIconView.isHidden = true
                quoteImageView.isHidden = true
                quoteContentLabel.numberOfLines = 3
                quoteLineViewHeightLayout?.constant = item.quoteHeight - 58
                quoteLabelTopLayout?.constant = 46
                quoteLabelOriginXLayout?.constant = 36
                quoteLabelWidthLayout?.constant = labelWidth
            case .unknown:
                break
            }

            let quoteBottomPaddingViewOriginY = item.quoteOriginY
            quoteBottomPaddingView.frame = CGRect(x: 0, y: quoteBottomPaddingViewOriginY, width: bubbleWidth, height: item.quoteBottomPadding)

            containerViewTwoOriginY = quoteBottomPaddingViewOriginY + item.quoteBottomPadding
            let messageLabelWidth = item.replyTextWidth < bubbleWidth ? item.replyTextWidth : bubbleWidth
            let containerViewTwoOriginX = item.isFromOtherSenders ? 0 : messageContainerView.bounds.width - messageLabelWidth
            containerViewTwo.frame = CGRect(x: containerViewTwoOriginX, y: containerViewTwoOriginY, width: messageLabelWidth, height: item.messageHeight)

            messageLabel.frame = CGRect(x: 0, y: 0, width: messageLabelWidth, height: item.messageHeight)
            mediaImageView.frame = CGRect(x: 0, y: 0, width: messageLabelWidth, height: item.messageHeight)

            switch item.messageType {
            case .text:
                messageLabel.attributedText = item.text
            case .sticker:
//                mediaImageView.image = UIImage(imageLiteralResourceName: "ic_sticker")
                break
            }
            messageLabel.textInsets = item.replyTextContentInset
        default:
            break
        }
    }

    private func setupText(item: ReplyMessageItem) {
        titleLabel.text = item.title
        quoteContentLabel.text = item.quoteContent
    }

    private func setupQuoteIconView(item: ReplyMessageItem) {
        quoteIconView.image = item.quoteImage
    }

    private func setupQuoteImageView(item: ReplyMessageItem) {
//        quoteImageView.image = UIImage(imageLiteralResourceName: "image_message_placeholder")
    }

    private func setupContainerViewOneConstraints(frame: CGRect) {
        containerViewOne.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: frame.origin.y).isActive = true
        containerViewOne.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: frame.origin.x).isActive = true
        containerViewWidthLayout = containerViewOne.widthAnchor.constraint(equalToConstant: frame.size.width)
        containerViewWidthLayout?.isActive = true
        containerViewOneHeightLayout = containerViewOne.heightAnchor.constraint(equalToConstant: frame.size.height)
        containerViewOneHeightLayout?.isActive = true
    }

    private func setupReplyIconViewConstraints(frame: CGRect) {
        replyIconView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        replyIconView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        replyIconView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        replyIconView.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }

    private func setupQuoteLineViewConstraints(frame: CGRect) {
        quoteLineView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        quoteLineView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        quoteLineView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        quoteLineViewHeightLayout = quoteLineView.heightAnchor.constraint(equalToConstant: frame.size.height)
        quoteLineViewHeightLayout?.isActive = true
    }

    private func setupTitleLabelConstraints(frame: CGRect) {
        titleLabel.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        titleLabelWidthLayout = titleLabel.widthAnchor.constraint(equalToConstant: frame.size.width)
        titleLabelWidthLayout?.isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }

    private func setupQuoteImageViewConstrains(frame: CGRect) {
        quoteImageView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        quoteImageView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        quoteImageView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        quoteImageView.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }

    private func setupQuoteIconViewConstrains(frame: CGRect) {
        quoteIconView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        quoteIconView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        quoteIconView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        quoteIconView.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }

    private func setupQuoteContentLabelConstraints(frame: CGRect) {
        quoteLabelTopLayout = quoteContentLabel.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y)
        quoteLabelTopLayout?.isActive = true

        quoteLabelOriginXLayout = quoteContentLabel.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x + 36)
        quoteLabelOriginXLayout?.isActive = true

        quoteLabelWidthLayout = quoteContentLabel.widthAnchor.constraint(equalToConstant: frame.size.width)
        quoteLabelWidthLayout?.isActive = true
    }
}

