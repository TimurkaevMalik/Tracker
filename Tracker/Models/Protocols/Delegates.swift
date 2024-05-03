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

protocol ChosenTrackerControllerDelegate {
    
    func dismisTrackerTypeController()
    
    func addNewTracker(trackerCategory: TrackerCategory)
}

protocol ScheduleOfTrackerDelegate {
    
    func didRecieveDatesArray(dates: [String])
    
    func didDismissScreenWithChanges(dates: [String])
}

protocol CategoryOfTrackerDelegate {
    
    func didChooseCategory(_ category: String)
    
    func didDismissScreenWithChangesIn(_ category: String?)
}

protocol CollectionViewCellDelegate {
    
    func didTapCollectionCellButton(_ cell: CollectionViewCell)
}
