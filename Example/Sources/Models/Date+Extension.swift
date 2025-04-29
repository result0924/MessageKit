//
//  Date+Extension.swift
//  ChatExample
//
//  Created by Justin Lai on 2025/4/29.
//  Copyright © 2025 MessageKit. All rights reserved.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    // MARK: - Add Methods

    func add(_ unit: Calendar.Component, value: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: unit, value: value, to: self) ?? self
    }

    func add(year: Int) -> Date {
        add(.year, value: year)
    }

    func add(month: Int) -> Date {
        add(.month, value: month)
    }

    func add(week: Int) -> Date {
        add(.weekOfYear, value: week)
    }

    func add(day: Int) -> Date {
        add(.day, value: day)
    }

    func add(hour: Int) -> Date {
        add(.hour, value: hour)
    }

    func add(minute: Int) -> Date {
        add(.minute, value: minute)
    }

    func add(seconds: Int) -> Date {
        add(.second, value: seconds)
    }
}
