//
//  ChartView.swift
//  Pods
//
//  Created by Justin Lai on 2025/4/21.
//


class ChartView: UIView {
    // MARK: - Properties
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
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
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
    
    private var titleLabelWidthLayout: NSLayoutConstraint?
    private var titleLabelHeightLayout: NSLayoutConstraint?
    private var metricsStackViewHeightLayout: NSLayoutConstraint?
    
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
            
            metricsStackViewHeightLayout?.constant = item.metricsViewSize.height
        } else {
            metricsStackViewHeightLayout?.constant = 0
        }
    }
    
    func resetAllSubviews() {
        titleLabel.text = nil
        metricsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(separatorView)
        addSubview(metricsStackView)
        
        setupConstraints()
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
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            metricsStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            metricsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            metricsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        metricsStackViewHeightLayout = metricsStackView.heightAnchor.constraint(equalToConstant: 4)
        metricsStackViewHeightLayout?.isActive = true
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
