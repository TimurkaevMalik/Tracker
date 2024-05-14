//
//  FecthTrackerController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.05.2024.
//

import Foundation
import CoreData

protocol TrackerStoreProviderDelegate: AnyObject {
    func didUpdate(tracker: Tracker)
    func didDelete(tracker: Tracker)
    func didAdd(tracker: Tracker, with categoryTitle: String)
}

final class TrackerStoreProvider: NSObject {
    
    enum FetchTrackerControllerError: Error {
        case failedToInitializeContext
    }
    
    weak var delegate: TrackerStoreProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let managedObject: TrackerMangedObjectProtocol
    
    private var fectchedResultController: NSFetchedResultsController<TrackerCoreData>?
    
    init(delegate: TrackerStoreProviderDelegate) {
        
        self.delegate = delegate
        self.managedObject = TrackerStore()
        self.context = managedObject.context
        super.init()
        
        let sortDescription = NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [sortDescription]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        self.fectchedResultController = controller
        try? controller.performFetch()
        
    }
    
    func updateCategoriesArray() -> [TrackerCategory]? {
        
        guard let trackersCoreData = managedObject.fetchAllTrackers() else {
            return nil
        }
        
        var categories: [TrackerCategory] = []
        
        for tracker in trackersCoreData {
            
            if let convertedTracker = convertCoreDataToTracker(tracker) {
                
                if !categories.isEmpty, categories.contains(where: { element in
                    element.titleOfCategory == tracker.trackerCategory?.titleOfCategory
                }) {
                    
                    for index in 0..<categories.count {
                        
                        if categories[index].titleOfCategory == tracker.trackerCategory?.titleOfCategory {
                            
                            var trackers: [Tracker] = categories[index].trackersArray
                            trackers.append(convertedTracker)
                            
                            categories[index] = TrackerCategory(titleOfCategory: categories[index].titleOfCategory, trackersArray: trackers)
                        }
                    }
                } else {
                    
                    categories.append(TrackerCategory(titleOfCategory: tracker.trackerCategory?.titleOfCategory ?? "", trackersArray: [convertedTracker]))
                }
            }
        }
        
        return categories
    }
    
    func deleteTrackerWithId(id: UUID){
        managedObject.deleteTrackerWith(id: id)
    }
    
    func convertCoreDataToTracker(_ trackerCoreData: TrackerCoreData) -> Tracker? {
        
        var tracker: Tracker
        let schedule = trackerCoreData.schedule != nil ? trackerCoreData.schedule : nil
        
        if
            let id = trackerCoreData.id,
            let name = trackerCoreData.name,
            let colorHexString = trackerCoreData.color,
            let emoji = trackerCoreData.emoji
        {
            tracker = Tracker(
                id: id,
                name: name,
                color: managedObject.uiColorMarshalling.color(from: colorHexString),
                emoji: emoji,
                schedule: schedule?.components(separatedBy: " ") ?? [])
            
            return tracker
        }
        
        return nil
    }
    
    func convertCoreDataToCategory( _ categoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        
        var category: TrackerCategory
        
        if let title = categoryCoreData.titleOfCategory {
            
            category = TrackerCategory(titleOfCategory: title, trackersArray: [])
            
            return category
        }
        
        return nil
    }
}

extension TrackerStoreProvider: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard
            let trackerCoreData = anObject as? TrackerCoreData,
            let tracker = convertCoreDataToTracker(trackerCoreData) else {
            return
        }
        
        switch type {
            
        case .insert:
            if let title = trackerCoreData.trackerCategory?.titleOfCategory {
                delegate?.didAdd(tracker: tracker, with: title)
            }
            
        case .delete:
            delegate?.didDelete(tracker: tracker)
            
        case .update:
            break
        default:
            break
        }
    }
}
