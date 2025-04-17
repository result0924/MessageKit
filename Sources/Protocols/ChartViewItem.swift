//
//  CustomViewItem.swift
//  MessageKit
//
//  Created by Justin Lai on 2025/4/17.
//

import Foundation

public protocol ChartViewItem {
    var title: String { get }
    var titleViewSize: CGSize { get }
    var size: CGSize { get }
}
