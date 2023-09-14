//
//  DiaryQuoteMessageCell.swift
//  MessageKit
//
//  Created by Justin Lai on 2023/9/4.
//

import UIKit

open class DiaryQuoteMessageCell: MessageContentCell {
    /// The `MessageCellDelegate` for the cell.
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }
    
    open var containerViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    open var replyImageView: UIImageView = {
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
        label.textColor = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
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
    
    open var recordAtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    open var mealTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    open var diaryOneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open var diaryTwoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open var itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.365, green: 0.404, blue: 0.416, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    open var itemDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private var onlyHandleTextLink: Bool = false
    private var containerViewOneHeightLayout: NSLayoutConstraint?
    private var containerViewOneWidthLayout: NSLayoutConstraint?
    private var titleLabelWidthLayout: NSLayoutConstraint?
    private var recordAtLabelWidthLayout: NSLayoutConstraint?
    private var mealTypeLabelWidthLayout: NSLayoutConstraint?
    private var quoteLineViewHeightLayout: NSLayoutConstraint?
    private var itemLabelTopLayout: NSLayoutConstraint?
    private var itemLabelWidthLayout: NSLayoutConstraint?
    private var itemDescriptionLabelTopLayout: NSLayoutConstraint?
    private var itemDescriptionLabelWidthLayout: NSLayoutConstraint?
    private var containerViewTwoOriginY: CGFloat = 0

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
        setupContainerViewOneConstraints(frame: .zero)
        setupReplyImageViewConstraints(frame: CGRectMake(12, 12, 24, 24))
        setupTitleLabelConstraints(frame: CGRectMake(40, 12, 0, 24))
        setupRecordAtLabelConstraints(frame: CGRectMake(36, 48, 0, 17))
        setupMealTypeLabelConstraints(frame: CGRectMake(36, 65, 0, 22))
        setupQuoteLineViewConstraints(frame: CGRectMake(16, 48, 4, 0))
        setupDiaryOneImageViewConstraints(frame: CGRect(x: 36, y: 93, width: 88, height: 88))
        setupDiaryTwoImageViewConstraints(frame: CGRect(x: 127, y: 93, width: 88, height: 88))
        setupItemLabelConstraints(frame: CGRectMake(36, 0, 0, 20))
        setupItemDescriptionLabelConstraints(frame: CGRectMake(36, 0, 0, 24))
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
        diaryOneImageView.isHidden = true
        diaryTwoImageView.isHidden = true
        isHiddenItemAndItemDescriptionLabel(isHidden: true)
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
            containerViewOneWidthLayout?.constant = bubbleWidth
            containerViewOneHeightLayout?.constant = item.quoteHeight
            let titleLabelWidth = bubbleWidth - 40 - 12
            let labelWidth = bubbleWidth - 36 - 12
            titleLabelWidthLayout?.constant = titleLabelWidth
            recordAtLabelWidthLayout?.constant = labelWidth
            mealTypeLabelWidthLayout?.constant = labelWidth
            
            switch item.type {
            case .photoAndText:
                quoteLineViewHeightLayout?.constant = 183
                setupImageView(item: item)
                itemLabelTopLayout?.constant = 187
                itemLabelWidthLayout?.constant = labelWidth
                itemDescriptionLabelTopLayout?.constant = 207
                itemDescriptionLabelWidthLayout?.constant = labelWidth
                setupItemText(item: item)
                isHiddenItemAndItemDescriptionLabel(isHidden: false)
            case .photoOnly:
                quoteLineViewHeightLayout?.constant = 133
                setupImageView(item: item)
                isHiddenItemAndItemDescriptionLabel(isHidden: true)
            case .textOnly:
                quoteLineViewHeightLayout?.constant = 89
                itemLabelTopLayout?.constant = 93
                itemLabelWidthLayout?.constant = labelWidth
                itemDescriptionLabelTopLayout?.constant = 113
                itemDescriptionLabelWidthLayout?.constant = labelWidth
                setupItemText(item: item)
                isHiddenItemAndItemDescriptionLabel(isHidden: false)
            }
            lineView.frame = CGRectMake(0, 0, bubbleWidth, 0.5)
            lineView.backgroundColor = item.lineColor
            actionLabel.frame = CGRect(x: 0, y: item.quoteOriginY, width: bubbleWidth, height: item.bottomTextViewHeight)
            actionLabel.attributedText = item.actionString
            actionLabel.textContainerInset = item.bottomTextViewContentInset
            actionLabel.textAlignment = .center
            let quoteBottomPaddingViewOriginY = item.quoteOriginY + item.bottomTextViewHeight
            quoteBottomPaddingView.frame = CGRect(x:0, y:quoteBottomPaddingViewOriginY, width: bubbleWidth, height: item.quoteBottomPadding)
            containerViewTwoOriginY = quoteBottomPaddingViewOriginY + item.quoteBottomPadding
            containerViewTwo.frame = CGRect(x:0, y: containerViewTwoOriginY, width: bubbleWidth, height: item.messageHeight)
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
        let translateTouchLocation = CGPoint(x: touchPoint.x, y: touchPoint.y - containerViewTwoOriginY)
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
            imageView.isHidden = false
        }
    }
    
    private func setupContainerViewOneConstraints(frame: CGRect) {
        containerViewOne.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: frame.origin.y).isActive = true
        containerViewOne.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: frame.origin.x).isActive = true
        containerViewOneWidthLayout = containerViewOne.widthAnchor.constraint(equalToConstant: frame.size.width)
        containerViewOneWidthLayout?.isActive = true
        containerViewOneHeightLayout = containerViewOne.heightAnchor.constraint(equalToConstant: frame.size.height)
        containerViewOneHeightLayout?.isActive = true
    }
    
    private func setupReplyImageViewConstraints(frame: CGRect) {
        replyImageView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        replyImageView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        replyImageView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        replyImageView.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    private func setupTitleLabelConstraints(frame: CGRect) {
        titleLabel.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        titleLabelWidthLayout = titleLabel.widthAnchor.constraint(equalToConstant: frame.size.width)
        titleLabelWidthLayout?.isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    private func setupRecordAtLabelConstraints(frame: CGRect) {
        recordAtLabel.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        recordAtLabel.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        recordAtLabelWidthLayout = recordAtLabel.widthAnchor.constraint(equalToConstant: frame.size.width)
        recordAtLabelWidthLayout?.isActive = true
        recordAtLabel.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    private func setupMealTypeLabelConstraints(frame: CGRect) {
        mealTypeLabel.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        mealTypeLabel.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        mealTypeLabelWidthLayout = mealTypeLabel.widthAnchor.constraint(equalToConstant: frame.size.width)
        mealTypeLabelWidthLayout?.isActive = true
        mealTypeLabel.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    private func setupQuoteLineViewConstraints(frame: CGRect) {
        quoteLineView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        quoteLineView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        quoteLineView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        quoteLineViewHeightLayout = quoteLineView.heightAnchor.constraint(equalToConstant: frame.size.height)
        quoteLineViewHeightLayout?.isActive = true
    }
    
    private func setupDiaryOneImageViewConstraints(frame: CGRect) {
        diaryOneImageView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        diaryOneImageView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        diaryOneImageView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        diaryOneImageView.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    private func setupDiaryTwoImageViewConstraints(frame: CGRect) {
        diaryTwoImageView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y).isActive = true
        diaryTwoImageView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        diaryTwoImageView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
        diaryTwoImageView.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    private func setupItemLabelConstraints(frame: CGRect) {
        itemLabelTopLayout = itemLabel.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y)
        itemLabelTopLayout?.isActive = true
        itemLabel.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        itemLabelWidthLayout = itemLabel.widthAnchor.constraint(equalToConstant: frame.size.width)
        itemLabelWidthLayout?.isActive = true
        itemLabel.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    private func setupItemDescriptionLabelConstraints(frame: CGRect) {
        itemDescriptionLabelTopLayout = itemDescriptionLabel.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: frame.origin.y)
        itemDescriptionLabelTopLayout?.isActive = true
        itemDescriptionLabel.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: frame.origin.x).isActive = true
        itemDescriptionLabelWidthLayout = itemDescriptionLabel.widthAnchor.constraint(equalToConstant: frame.size.width)
        itemDescriptionLabelWidthLayout?.isActive = true
        itemDescriptionLabel.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
    }
    
    private func isHiddenItemAndItemDescriptionLabel(isHidden: Bool) {
        itemLabel.isHidden = isHidden
        itemDescriptionLabel.isHidden = isHidden
    }
    
}

