//
//  Extensious.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.04.2024.
//

import UIKit
import Foundation

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        
        for subview in subviews {
            addSubview(subview)
        }
    }
}

extension Date {
    func startOfWeek(using calendar: Calendar) -> Date {
        
        guard let sunday = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date else {
            return Date()
        }
        
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        guard let monday = calendar.date(byAdding: dateComponents, to: sunday) else {
            return Date()
        }
        
        return monday
    }
}
