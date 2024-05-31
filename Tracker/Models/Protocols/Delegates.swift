//
//  Protocols.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.04.2024.
//

import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate(tracker: Tracker, categoryTitle: String)
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
    func didEditTracker(tracker: TrackerToEdit)
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
    func pinMenuButtonTappedOn(_ indexPath: IndexPath)
    func unpinMenuButtonTappedOn(_ indexPath: IndexPath)
    func editMenuButtonTappedOn(_ indexPath: IndexPath)
    func deleteMenuButtonTappedOn(_ indexPath: IndexPath)
    func plusButtonTapped(_ cell: CollectionViewCell)
}
