//
//  FecthTrackerController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.05.2024.
//

import Foundation
import CoreData

protocol DataProviderdelegate: AnyObject {
    func didUpdate(_ update: TrackerCoreData)
}

final class FetchTrackerController: NSObject {
    
    enum FetchTrackerControllerError: Error {
        case failedToInitializeContext
    }
    
    weak var delegate: DataProviderdelegate?
    
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore
    
    private lazy var fectchedResultController: NSFetchedResultsController<TrackerCoreData> = {
        
        let sortDescription = NSSortDescriptor(key: "name", ascending: false)
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [sortDescription]
        
        let fetchResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
        
        return fetchResultsController
    }()
    
    init(delegate: DataProviderdelegate, trackerStore: TrackerStore) {
        
        self.delegate = delegate
        self.context = trackerStore.context
        self.trackerStore = trackerStore
    }
}

extension FetchTrackerController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            <#code#>
        case .delete:
            <#code#>
        case .update:
            <#code#>
        default:
            break
        }
    }
}
