//
//  DateFormatManager.swift
//  Tracker
//
//  Created by Malik Timurkaev on 24.04.2024.
//

import Foundation

class DateFormatManager {
    
    static let shared = DateFormatManager()
    
    private var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }
    
    func formatateToStringFrom(date: Date) -> String {
        
        return dateFormatter.string(from: date)
    }
}
