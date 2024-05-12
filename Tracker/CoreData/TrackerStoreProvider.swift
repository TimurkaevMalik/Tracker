//
//  FecthTrackerController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.05.2024.
//

import Foundation
import CoreData

protocol TrackerStoreProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackerCoreData)
    func didAddTracker(_ tracker: TrackerCoreData)
}

final class TrackerStoreProvider: NSObject {
    
    enum FetchTrackerControllerError: Error {
        case failedToInitializeContext
    }
    
    weak var delegate: TrackerStoreProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore
    
    private var fectchedResultController: NSFetchedResultsController<TrackerCoreData>?
    
    init(delegate: TrackerStoreProviderDelegate, trackerStore: TrackerStore) {
        
        self.delegate = delegate
        self.context = trackerStore.context
        self.trackerStore = trackerStore
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
}

extension TrackerStoreProvider: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let tracker = anObject as? TrackerCoreData else {
            return
        }
        
        switch type {
            
        case .insert:
            delegate?.didAddTracker(tracker)
        case .delete:
            break
        case .update:
            break
        default:
            break
        }
    }
}
