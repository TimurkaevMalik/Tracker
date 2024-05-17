//
//  DateFormatManager.swift
//  Tracker
//
//  Created by Malik Timurkaev on 24.04.2024.
//

import Foundation

final class DateFormatManager {
    
    static let shared = DateFormatManager()
    
//    private var dateFormatter: DateFormatter {
//        
//        let formatter = DateFormatter()
//        
//        formatter.dateStyle = .short
//        formatter.timeStyle = .none
//        
//        return formatter
//    }
    private var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.calendar = .current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        return formatter
    }
    
    func getStringFrom(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func getDateFrom(string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}
