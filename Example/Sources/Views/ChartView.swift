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
    
    private var item: ChartViewItem?
    private var hasDiet = false

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
    
    private let chartView: LineChartView = {
        let view = LineChartView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chartInfoView: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.horizontalAlignment = .left
        layout.verticalAlignment = .center
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
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

    func configure(item: ChartViewItem) {
        self.item = item
        configureTitle(item)
        configureMetrics(item)
        configureChartInfo(item)
        configureDietInfo(item)
        configureMessage(item)
        configureAction(item)
    }

    // MARK: - Configure Sections

    private func configureTitle(_ item: ChartViewItem) {
        titleLabel.attributedText = item.titleAttributedString
        titleLabelWidthLayout?.constant = item.titleViewSize.width
        titleLabelHeightLayout?.constant = item.titleViewSize.height
    }

    private func configureMetrics(_ item: ChartViewItem) {
        metricsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !item.metrics.isEmpty else {
            metricsStackViewTopAnchorConstraint?.constant = 0
            metricsStackViewHeightLayout?.constant = 0
            chartViewTopAnchorConstraint?.constant = 0
            return
        }

        let metricsRowStackView = createMetricsRowStackView()
        metricsStackView.addArrangedSubview(metricsRowStackView)

        for (index, metric) in item.metrics.enumerated() {
            if index > 0 && index % 2 == 0 {
                let newRow = createMetricsRowStackView()
                metricsStackView.addArrangedSubview(newRow)
            }
            let metricView = createMetricView(for: metric)
            (metricsStackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(metricView)
        }

        metricsStackViewTopAnchorConstraint?.constant = 8
        metricsStackViewHeightLayout?.constant = item.metricsViewSize.height
        chartViewTopAnchorConstraint?.constant = -4
    }

    private func configureChartInfo(_ item: ChartViewItem) {
        chartInfoView.reloadData()
        chartInfoViewHeightLayout?.constant = item.chartInfoViewSize.height
    }

    private func configureDietInfo(_ item: ChartViewItem) {
        hasDiet = false

        if let title = item.dietInfoTitleAttributedString, !title.string.isEmpty {
            dietInfoTitleLabel.attributedText = title
            dietInfoTitleLabelTopAnchorConstraint?.constant = 4
            dietInfoTitleLabelHeightLayout?.constant = item.dietInfoTitleLabelSize.height
            hasDiet = true
        } else {
            dietInfoTitleLabelTopAnchorConstraint?.constant = 0
            dietInfoTitleLabelHeightLayout?.constant = 0
        }

        if let text = item.dietInfoTextAttributedString, !text.string.isEmpty {
            dietInfoTextLabel.attributedText = text
            dietInfoTextLabelTopAnchorConstraint?.constant = 4
            dietInfoTextLabelHeightLayout?.constant = item.dietInfoTextLabelSize.height
            hasDiet = true
        } else {
            dietInfoTextLabelTopAnchorConstraint?.constant = 0
            dietInfoTextLabelHeightLayout?.constant = 0
        }

        configureDietImageStackView(images: item.dietInfoImages, height: item.dietInfoImagesViewSize.height)
        if !item.dietInfoImages.isEmpty {
            hasDiet = true
        }
    }

    private func configureMessage(_ item: ChartViewItem) {
        guard let message = item.messageAttributedString, !message.string.isEmpty else {
            messageSeparatorViewTopAnchorConstraint?.constant = 0
            messageSeparatorViewHeightLayout?.constant = 0
            messageLabelTopAnchorConstraint?.constant = 0
            messageLabelHeightLayout?.constant = 0
            return
        }

        let top: CGFloat = hasDiet ? 12 : 4
        messageSeparatorViewTopAnchorConstraint?.constant = top
        messageSeparatorViewHeightLayout?.constant = 1
        messageLabelTopAnchorConstraint?.constant = 12
        messageLabel.attributedText = message
        messageLabelHeightLayout?.constant = item.messageLabelSize.height
    }

    private func configureAction(_ item: ChartViewItem) {
        guard let action = item.actionAttributedString, !action.string.isEmpty else {
            actionButton.setAttributedTitle(nil, for: .normal)
            actionSeparatorViewTopAnchorConstraint?.constant = 0
            actionSeparatorViewHeightLayout?.constant = 0
            actionButtonTopAnchorConstraint?.constant = 0
            actionButtonHeightLayout?.constant = 0
            return
        }

        actionButton.setAttributedTitle(action, for: .normal)
        actionSeparatorViewTopAnchorConstraint?.constant = 12
        actionSeparatorViewHeightLayout?.constant = 1
        actionButtonTopAnchorConstraint?.constant = 12
        actionButtonHeightLayout?.constant = item.actionButtonSize.height
    }

    func configureDietImageStackView(images: [URL], height: CGFloat) {
        dietInfoImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !images.isEmpty else {
            dietInfoImageStackViewTopAnchorConstraint?.constant = 0
            dietInfoImageStackViewHeightLayout?.constant = 0
            return
        }

        dietInfoImageStackViewTopAnchorConstraint?.constant = 4
        dietInfoImageStackViewHeightLayout?.constant = height

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
        
        // Setup collection view
        chartInfoView.register(ChartInfoCell.self, forCellWithReuseIdentifier: "ChartInfoCell")
        chartInfoView.delegate = self
        chartInfoView.dataSource = self
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

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension ChartView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item?.chartInfos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartInfoCell", for: indexPath) as! ChartInfoCell
        if let attributedString = item?.chartInfos[indexPath.item] {
            cell.configure(with: attributedString)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let attributedString = item?.chartInfos[indexPath.item] else { return .zero }
        
        // 使用 attributed string 的 font 來計算
        if let font = attributedString.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            let width = (attributedString.string as NSString).size(withAttributes: [.font: font]).width + 16 // 加上左右 padding
            
            // 如果寬度超過 collection view 的寬度，則使用 collection view 的寬度
            let maxWidth = collectionView.bounds.width - 16 // 減去左右 padding
            if width > maxWidth {
                return CGSize(width: maxWidth, height: 24)
            } else {
                return CGSize(width: width, height: 24)
            }
        }
        
        // 如果沒有 font 屬性，使用預設的系統字型
        let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        let width = (attributedString.string as NSString).size(withAttributes: [.font: font]).width + 16
        let maxWidth = collectionView.bounds.width - 16
        if width > maxWidth {
            return CGSize(width: maxWidth, height: 24)
        }
        return CGSize(width: width, height: 24)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - ChartInfoCell
class ChartInfoCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        label.numberOfLines = 1
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with attributedString: NSAttributedString) {
        label.attributedText = attributedString
    }
}

// Add AlignedCollectionViewFlowLayout class at the end of the file
class AlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    enum HorizontalAlignment {
        case left
        case center
        case right
    }
    
    enum VerticalAlignment {
        case top
        case center
        case bottom
    }
    
    var horizontalAlignment: HorizontalAlignment = .left
    var verticalAlignment: VerticalAlignment = .center
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        guard let collectionView = collectionView else {
            return originalAttributes
        }

        let attributesCopy = originalAttributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        var rowCollections: [[UICollectionViewLayoutAttributes]] = []
        var currentRow: [UICollectionViewLayoutAttributes] = []
        var currentY: CGFloat = -1
        
        for attribute in attributesCopy {
            let frameY = round(attribute.frame.origin.y * 1000) / 1000
            if abs(frameY - currentY) > 1.0 {
                if !currentRow.isEmpty {
                    rowCollections.append(currentRow)
                }
                currentRow = [attribute]
                currentY = frameY
            } else {
                currentRow.append(attribute)
            }
        }
        if !currentRow.isEmpty {
            rowCollections.append(currentRow)
        }
        
        for rowAttributes in rowCollections {
            let totalWidth = rowAttributes.reduce(0) { $0 + $1.frame.width } +
                CGFloat(rowAttributes.count - 1) * minimumInteritemSpacing
            let contentWidth = collectionView.bounds.width
            var xOffset: CGFloat = 0
            
            switch horizontalAlignment {
            case .left:
                xOffset = sectionInset.left
            case .center:
                xOffset = (contentWidth - totalWidth) / 2
            case .right:
                xOffset = contentWidth - totalWidth - sectionInset.right
            }
            
            for attribute in rowAttributes {
                attribute.frame.origin.x = xOffset
                xOffset += attribute.frame.width + minimumInteritemSpacing
            }
        }
        
        return attributesCopy
    }
}

