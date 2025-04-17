//
//  ChartViewCell.swift
//  MessageKit
//
//  Created by Justin Lai on 2025/4/17.
//

import Foundation

open class ChartViewCell: MessageContentCell {
    open var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    open var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic_arrowRight")
        return imageView
    }()
    
    open var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        return view
    }()
    
    private var titleLabelWidthLayout: NSLayoutConstraint?
    private var titleLabelHeightLayout: NSLayoutConstraint?
    
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(titleLabel)
        messageContainerView.addSubviews(arrowImageView)
        messageContainerView.addSubviews(separatorView)
        setupTitleLabelConstraints()
        setupArrowImageViewConstraints()
        setupSeparatorViewConstraints()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        switch message.kind {
        case .chartView(let item):
            titleLabel.text = item.title
            titleLabelWidthLayout?.constant = item.titleViewSize.width
            titleLabelHeightLayout?.constant = item.titleViewSize.height
            
        default:
            break
        }

    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 12).isActive = true
        titleLabelWidthLayout = titleLabel.widthAnchor.constraint(equalToConstant: 0)
        titleLabelWidthLayout?.isActive = true
        titleLabelHeightLayout = titleLabel.heightAnchor.constraint(equalToConstant: 0)
        titleLabelHeightLayout?.isActive = true
    }

    private func setupArrowImageViewConstraints() {
        arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        arrowImageView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -12).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupSeparatorViewConstraints() {
        separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: 0).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
