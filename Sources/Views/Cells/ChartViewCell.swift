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
    private let chartView = ChartView()
    
    // MARK: - Methods
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(chartView)
        setupChartViewConstraints()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        chartView.resetAllSubviews()
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        switch message.kind {
        case .chartView(let item):
            chartView.configure(item: item)
        default:
            break
        }
    }
    
    // MARK: - Private Methods
    private func setupChartViewConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: messageContainerView.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor)
        ])
    }
}
