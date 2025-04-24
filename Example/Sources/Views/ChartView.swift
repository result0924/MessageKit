//
//  ChartView.swift
//  Pods
//
//  Created by Justin Lai on 2025/4/21.
//

import Kingfisher
import MessageKit
import UIKit

protocol ChartViewDelegate: AnyObject {
    func didTapActionButton(in chartView: ChartView)
}

class ChartView: UIView {
    // MARK: - Properties
    weak var delegate: ChartViewDelegate?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic_arrowRight")
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.914, green: 0.914, blue: 0.914, alpha: 1)
        return view
    }()
    
    private let metricsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chartInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple
        return view
    }()
    
    private let dietInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    private let dietInfoTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let dietInfoImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let messageSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.914, green: 0.914, blue: 0.914, alpha: 1)
        return view
    }()
    
    let messageLabel: MessageLabel = {
        let label = MessageLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let actionSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.914, green: 0.914, blue: 0.914, alpha: 1)
        return view
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.borderColor = UIColor(red: 45 / 255, green: 181 / 255, blue: 155 / 255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()
    
    private var titleLabelWidthLayout: NSLayoutConstraint?
    private var titleLabelHeightLayout: NSLayoutConstraint?
    private var metricsStackViewHeightLayout: NSLayoutConstraint?
    private var chartInfoViewHeightLayout: NSLayoutConstraint?
    private var chartViewTopAnchorConstraint: NSLayoutConstraint?
    private var metricsStackViewTopAnchorConstraint: NSLayoutConstraint?
    private var dietInfoTitleLabelTopAnchorConstraint: NSLayoutConstraint?
    private var dietInfoTitleLabelHeightLayout: NSLayoutConstraint?
    private var dietInfoTextLabelTopAnchorConstraint: NSLayoutConstraint?
    private var dietInfoTextLabelHeightLayout: NSLayoutConstraint?
    private var dietInfoImageStackViewTopAnchorConstraint: NSLayoutConstraint?
    private var dietInfoImageStackViewHeightLayout: NSLayoutConstraint?
    private var messageSeparatorViewTopAnchorConstraint: NSLayoutConstraint?
    private var messageSeparatorViewHeightLayout: NSLayoutConstraint?
    private var messageLabelTopAnchorConstraint: NSLayoutConstraint?
    private var messageLabelHeightLayout: NSLayoutConstraint?
    private var actionSeparatorViewTopAnchorConstraint: NSLayoutConstraint?
    private var actionSeparatorViewHeightLayout: NSLayoutConstraint?
    private var actionButtonTopAnchorConstraint: NSLayoutConstraint?
    private var actionButtonHeightLayout: NSLayoutConstraint?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Public Methods
    func configure(item: ChartViewItem) {
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
            
            metricsStackViewTopAnchorConstraint?.constant = 8
            metricsStackViewHeightLayout?.constant = item.metricsViewSize.height
            chartViewTopAnchorConstraint?.constant = -4
        } else {
            metricsStackViewTopAnchorConstraint?.constant = 0
            metricsStackViewHeightLayout?.constant = 0
            chartViewTopAnchorConstraint?.constant = 0
        }
        
        // Configure chart info view
        if !item.chartInfoString.isEmpty {
            chartInfoViewHeightLayout?.constant = 52
        } else {
            chartInfoViewHeightLayout?.constant = 0
        }
        
        var hasDiet = !item.dietInfoImages.isEmpty
        
        if let dietTitle = item.dietInfoTitleAttributedString, !dietTitle.string.isEmpty {
            hasDiet = true
            dietInfoTitleLabel.attributedText = dietTitle
            dietInfoTitleLabelTopAnchorConstraint?.constant = 4
            dietInfoTitleLabelHeightLayout?.constant = item.dietInfoTitleLabelSize.height
        } else {
            dietInfoTitleLabelTopAnchorConstraint?.constant = 0
            dietInfoTitleLabelHeightLayout?.constant = 0
        }
        
        if let dietText = item.dietInfoTextAttributedString, !dietText.string.isEmpty {
            hasDiet = true
            dietInfoTextLabel.attributedText = dietText
            dietInfoTextLabelTopAnchorConstraint?.constant = 4
            dietInfoTextLabelHeightLayout?.constant = item.dietInfoTextLabelSize.height
        } else {
            dietInfoTextLabelTopAnchorConstraint?.constant = 0
            dietInfoTextLabelHeightLayout?.constant = 0
        }
        
        configureDietImageStackView(images: item.dietInfoImages, height: item.dietInfoImagesViewSize.height)
        
        if let messageAttributedString = item.messageAttributedString, !messageAttributedString.string.isEmpty {
            let topConstraint: CGFloat = hasDiet ? 12 : 4
            messageSeparatorViewTopAnchorConstraint?.constant = topConstraint
            messageSeparatorViewHeightLayout?.constant = 1
            messageLabelTopAnchorConstraint?.constant = 12
            messageLabel.attributedText = item.messageAttributedString
            messageLabelHeightLayout?.constant = item.messageLabelSize.height
        } else {
            messageSeparatorViewTopAnchorConstraint?.constant = 0
            messageSeparatorViewHeightLayout?.constant = 0
            messageLabelTopAnchorConstraint?.constant = 0
            messageLabelHeightLayout?.constant = 0
        }
        
        if let actionAttributedString = item.actionAttributedString, !actionAttributedString.string.isEmpty {
            actionButton.setAttributedTitle(actionAttributedString, for: .normal)
            
            actionSeparatorViewTopAnchorConstraint?.constant = 12
            actionSeparatorViewHeightLayout?.constant = 1
            
            actionButtonTopAnchorConstraint?.constant = 12
            actionButtonHeightLayout?.constant = item.actionButtonSize.height
        } else {
            actionButton.setAttributedTitle(nil, for: .normal)
            
            actionSeparatorViewTopAnchorConstraint?.constant = 0
            actionSeparatorViewHeightLayout?.constant = 0
            
            actionButtonTopAnchorConstraint?.constant = 0
            actionButtonHeightLayout?.constant = 0
        }
    }
    
    func configureDietImageStackView(images: [URL], height: CGFloat) {
        // 先清空 stackView 內容
        dietInfoImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard !images.isEmpty else {
            dietInfoImageStackViewTopAnchorConstraint?.constant = 0
            dietInfoImageStackViewHeightLayout?.constant = 0
            return
        }
        
        dietInfoImageStackViewTopAnchorConstraint?.constant = 4
        dietInfoImageStackViewHeightLayout?.constant = height

        // 最多只取前 4 張
        let maxDisplayCount = 4
        let totalCount = images.count
        let displayImages = Array(images.prefix(maxDisplayCount))

        for (index, imageURL) in displayImages.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 4
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
            // 使用 Kingfisher 載入圖片
            imageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "image_message_placeholder"),
                options: [
                    .transition(.fade(0.2)),
                    .processor(DownsamplingImageProcessor(size: CGSize(width: 48, height: 48))),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ]
            )

            // 最後一張而且有超出時顯示 "+N"
            if index == maxDisplayCount - 1 && totalCount > maxDisplayCount {
                let overlayView = UIView()
                overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                overlayView.translatesAutoresizingMaskIntoConstraints = false

                let label = UILabel()
                label.text = "+\(totalCount - maxDisplayCount)"
                label.textColor = .white
                label.font = .systemFont(ofSize: 14, weight: .medium)
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false

                imageView.addSubview(overlayView)
                overlayView.addSubview(label)

                NSLayoutConstraint.activate([
                    overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
                    overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                    overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                    overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

                    label.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
                ])
            }

            dietInfoImageStackView.addArrangedSubview(imageView)
        }
    }
    
    func resetAllSubviews() {
        titleLabel.attributedText = nil
        metricsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dietInfoTitleLabel.attributedText = nil
        dietInfoTextLabel.attributedText = nil
        dietInfoImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        messageLabel.attributedText = nil
        actionButton.setAttributedTitle(nil, for: .normal)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(separatorView)
        addSubview(metricsStackView)
        addSubview(chartView)
        addSubview(chartInfoView)
        addSubview(dietInfoTitleLabel)
        addSubview(dietInfoTextLabel)
        addSubview(dietInfoImageStackView)
        addSubview(messageSeparatorView)
        addSubview(messageLabel)
        addSubview(actionSeparatorView)
        addSubview(actionButton)
        setupConstraints()
        
        actionButton.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
    }
    
    @objc private func handleActionButtonTap() {
        delegate?.didTapActionButton(in: self)
    }
    
    private func setupConstraints() {
        titleLabelWidthLayout = titleLabel.widthAnchor.constraint(equalToConstant: 0)
        titleLabelWidthLayout?.isActive = true
        titleLabelHeightLayout = titleLabel.heightAnchor.constraint(equalToConstant: 0)
        titleLabelHeightLayout?.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            metricsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            metricsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 216),
            
            chartInfoView.topAnchor.constraint(equalTo: chartView.bottomAnchor),
            chartInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dietInfoTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dietInfoTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            dietInfoTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dietInfoTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            dietInfoImageStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),

            messageSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            messageSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            actionSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        metricsStackViewTopAnchorConstraint = metricsStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0)
        metricsStackViewTopAnchorConstraint?.isActive = true
        metricsStackViewHeightLayout = metricsStackView.heightAnchor.constraint(equalToConstant: 0)
        metricsStackViewHeightLayout?.isActive = true
        
        chartViewTopAnchorConstraint = chartView.topAnchor.constraint(equalTo: metricsStackView.bottomAnchor, constant: 0)
        chartViewTopAnchorConstraint?.isActive = true
        
        chartInfoViewHeightLayout = chartInfoView.heightAnchor.constraint(equalToConstant: 0)
        chartInfoViewHeightLayout?.isActive = true
        
        dietInfoTitleLabelTopAnchorConstraint = dietInfoTitleLabel.topAnchor.constraint(equalTo: chartInfoView.bottomAnchor, constant: 0)
        dietInfoTitleLabelTopAnchorConstraint?.isActive = true

        dietInfoTitleLabelHeightLayout = dietInfoTitleLabel.heightAnchor.constraint(equalToConstant: 0)
        dietInfoTitleLabelHeightLayout?.isActive = true
        
        dietInfoTextLabelTopAnchorConstraint = dietInfoTextLabel.topAnchor.constraint(equalTo: dietInfoTitleLabel.bottomAnchor, constant: 0)
        dietInfoTextLabelTopAnchorConstraint?.isActive = true

        dietInfoTextLabelHeightLayout = dietInfoTextLabel.heightAnchor.constraint(equalToConstant: 0)
        dietInfoTextLabelHeightLayout?.isActive = true
        
        dietInfoImageStackViewTopAnchorConstraint = dietInfoImageStackView.topAnchor.constraint(equalTo: dietInfoTextLabel.bottomAnchor, constant: 0)
        dietInfoImageStackViewTopAnchorConstraint?.isActive = true

        dietInfoImageStackViewHeightLayout = dietInfoImageStackView.heightAnchor.constraint(equalToConstant: 0)
        dietInfoImageStackViewHeightLayout?.isActive = true
        
        messageSeparatorViewTopAnchorConstraint = messageSeparatorView.topAnchor.constraint(equalTo: dietInfoImageStackView.bottomAnchor, constant: 0)
        messageSeparatorViewTopAnchorConstraint?.isActive = true

        messageSeparatorViewHeightLayout = messageSeparatorView.heightAnchor.constraint(equalToConstant: 0)
        messageSeparatorViewHeightLayout?.isActive = true
        
        messageLabelTopAnchorConstraint = messageLabel.topAnchor.constraint(equalTo: messageSeparatorView.bottomAnchor, constant: 0)
        messageLabelTopAnchorConstraint?.isActive = true

        messageLabelHeightLayout = messageLabel.heightAnchor.constraint(equalToConstant: 0)
        messageLabelHeightLayout?.isActive = true
        
        actionSeparatorViewTopAnchorConstraint = actionSeparatorView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 0)
        actionSeparatorViewTopAnchorConstraint?.isActive = true
        
        actionSeparatorViewHeightLayout = actionSeparatorView.heightAnchor.constraint(equalToConstant: 0)
        actionSeparatorViewHeightLayout?.isActive = true
        
        actionButtonTopAnchorConstraint = actionButton.topAnchor.constraint(equalTo: actionSeparatorView.bottomAnchor, constant: 0)
        actionButtonTopAnchorConstraint?.isActive = true
        
        actionButtonHeightLayout = actionButton.heightAnchor.constraint(equalToConstant: 0)
        actionButtonHeightLayout?.isActive = true
    }
    
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
}
