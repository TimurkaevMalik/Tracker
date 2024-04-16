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

protocol HabbitTrackerControllerProtocol {
    
    func dismisTrackerTypeController()
    
    func addNewTracker(trackerCategory: TrackerCategory)
}
