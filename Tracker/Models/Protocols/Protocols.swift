//
//  Protocols.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.04.2024.
//

import Foundation

protocol CreatingTrackerDelegate {
    
    func CreatingTrackerViewDidDismiss()
}

protocol HabbitTrackerControllerDelegate {
    
    func dismisTrackerTypeController()
    
    func addNewTracker(trackerCategory: TrackerCategory)
}

protocol ScheduleOfTrackerDelegate {
    
    func didRecieveDatesArray(dates: [String])
}

protocol CategoryOfTrackerDelegate {
    
    func didChooseCategory(_ category: String)
}
