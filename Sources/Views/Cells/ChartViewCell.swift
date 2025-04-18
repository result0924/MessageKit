//
//  ChartViewCell.swift
//  MessageKit
//
//  Created by Justin Lai on 2025/4/17.
//

import Foundation
import UIKit

open class ChartViewCell: MessageContentCell {
    // MARK: - Properties
    open var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
    
    private var metricsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var titleLabelWidthLayout: NSLayoutConstraint?
    private var titleLabelHeightLayout: NSLayoutConstraint?
    private var metricsStackViewHeightLayout: NSLayoutConstraint?
    
    // MARK: - Methods
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(titleLabel)
        messageContainerView.addSubview(arrowImageView)
        messageContainerView.addSubview(separatorView)
        messageContainerView.addSubview(metricsStackView)
        
        setupTitleLabelConstraints()
        setupArrowImageViewConstraints()
        setupSeparatorViewConstraints()
        setupMetricsStackViewConstraints()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        metricsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        switch message.kind {
        case .chartView(let item):
            titleLabel.attributedText = item.titleAttributedString
            titleLabelWidthLayout?.constant = item.titleViewSize.width
            titleLabelHeightLayout?.constant = item.titleViewSize.height
            
            // Clear existing metrics views
            metricsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            // Add metrics if they exist
            if !item.metrics.isEmpty {
                let metricsRowStackView = createMetricsRowStackView()
                metricsStackView.addArrangedSubview(metricsRowStackView)
                
                for (index, metric) in item.metrics.enumerated() {
                    if index > 0 && index % 2 == 0 {
                        let newRowStackView = createMetricsRowStackView()
                        metricsStackView.addArrangedSubview(newRowStackView)
                    }
                    
                    let metricView = createMetricView(for: metric)
                    if let lastRow = metricsStackView.arrangedSubviews.last as? UIStackView {
                        lastRow.addArrangedSubview(metricView)
                    }
                }
                
                metricsStackViewHeightLayout?.constant = item.metricsViewSize.height
                
            } else {
                metricsStackViewHeightLayout?.constant = 0
            }
            
        default:
            break
        }
    }
    
    // MARK: - Private Methods
    private func createMetricsRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    
    private func createMetricView(for metric: ChartViewMetric) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelLabel = UILabel()
        labelLabel.translatesAutoresizingMaskIntoConstraints = false
        labelLabel.attributedText = metric.labelAttributedString
        labelLabel.numberOfLines = 0
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.attributedText = metric.valueUnitAttributedString
        valueLabel.numberOfLines = 0
        
        containerView.addSubview(labelLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            labelLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            labelLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            labelLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: labelLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
        
        return containerView
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
    
    private func setupMetricsStackViewConstraints() {
        metricsStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8).isActive = true
        metricsStackView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: ChartViewConstants.metricsStackViewLeadingPadding).isActive = true
        metricsStackView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -ChartViewConstants.metricsStackViewTrailingPadding).isActive = true
        metricsStackViewHeightLayout = metricsStackView.heightAnchor.constraint(equalToConstant: 4)
        metricsStackViewHeightLayout?.isActive = true
    }
}
