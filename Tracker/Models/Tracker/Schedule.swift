//
//  Schedule.swift
//  Tracker
//
//  Created by Malik Timurkaev on 24.04.2024.
//

import Foundation

class Schedule {
    
    let unregularEvent: String?
    let monday: String?
    let tuesday: String?
    let wednesday: String?
    let thursday: String?
    let friday: String?
    let saturday: String?
    let sunday: String?
    
    init( monday: String?, tuesday: String?, wednesday: String?, thursday: String?, friday: String?, saturday: String?, sunday: String?) {
        
        self.unregularEvent = nil
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
    }
    
    init( unregularEvent: String = "unregularEvent"){
        self.unregularEvent = unregularEvent
        
        self.monday = nil
        self.tuesday = nil
        self.wednesday = nil
        self.thursday = nil
        self.friday = nil
        self.saturday = nil
        self.sunday = nil
    }
    
}
