//
//  Protocols.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.04.2024.
//

import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate(tracker: Tracker)
    func didDelete(tracker: Tracker)
    func didAdd(tracker: Tracker, with categoryTitle: String)
}

protocol RecordStoreDelegate: AnyObject {
    func didUpdate(record: TrackerRecord)
    func didDelete(record: TrackerRecord)
    func didAdd(record: TrackerRecord)
}

protocol TrackerViewControllerDelegate: AnyObject {
    func dismisTrackerTypeController()
    func addNewTracker(trackerCategory: TrackerCategory)
}

protocol ScheduleOfTrackerDelegate: AnyObject {
    func didRecieveDatesArray(dates: [String])
    func didDismissScreenWithChanges(dates: [String])
}

protocol CategoryModelDelegate: AnyObject {
    func didChooseCategory(_ category: String)
    func didDismissScreenWithChangesIn(_ category: String?)
}

protocol NewCategoryViewProtocol: AnyObject {
    func categoryAlreadyExists()
    func didStoreNewCategory()
}

protocol CollectionViewCellDelegate: AnyObject {
    func contextMenuForCell(_ cell: CollectionViewCell) -> UIContextMenuConfiguration?
    func attachMenuButtonTapped(_ cell: CollectionViewCell)
    func editMenuButtonTapped(_ cell: CollectionViewCell)
    func deleteMenuButtonTapped(_ cell: CollectionViewCell)
    func plusButtonTapped(_ cell: CollectionViewCell)
}
