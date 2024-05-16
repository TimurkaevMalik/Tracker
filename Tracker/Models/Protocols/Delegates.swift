//
//  Protocols.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.04.2024.
//

import Foundation

protocol TrackerStoreProviderDelegate: AnyObject {
    func didUpdate(tracker: Tracker)
    func didDelete(tracker: Tracker)
    func didAdd(tracker: Tracker, with categoryTitle: String)
}

protocol TrackerViewControllerDelegate: AnyObject {
    
    func dismisTrackerTypeController()
    
    func addNewTracker(trackerCategory: TrackerCategory)
}

protocol ScheduleOfTrackerDelegate: AnyObject {
    
    func didRecieveDatesArray(dates: [String])
    
    func didDismissScreenWithChanges(dates: [String])
}

protocol CategoryOfTrackerDelegate: AnyObject {
    
    func didChooseCategory(_ category: String)
    
    func didDismissScreenWithChangesIn(_ category: String?)
}

protocol CollectionViewCellDelegate: AnyObject {
    
    func didTapCollectionCellButton(_ cell: CollectionViewCell)
}

protocol CreatingTrackerDelegate {
    
    func CreatingTrackerViewDidDismiss()
}
