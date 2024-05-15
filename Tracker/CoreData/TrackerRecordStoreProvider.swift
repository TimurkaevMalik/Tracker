//
//  TrackerRecordProvider.swift
//  Tracker
//
//  Created by Malik Timurkaev on 14.05.2024.
//

import Foundation
import CoreData

protocol RecordStoreProviderDelegate: AnyObject {
    func didUpdate(record: TrackerRecord)
    func didDelete(record: TrackerRecord)
    func didAdd(record: TrackerRecord)
}

class TrackerRecordStoreProvider: NSObject {
    
    enum FetchTrackerControllerError: Error {
        case failedToInitializeContext
    }
    
    weak var delegate: RecordStoreProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let managedObject: RecordManagedObjectProtocol
    private var fetchedResultController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    private var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.calendar = .current
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        return formatter
    }
    
    
    init(delegate: RecordStoreProviderDelegate) {
        self.delegate = delegate
        self.managedObject = TrackerRecordStore()
        self.context = managedObject.context
        super.init()
        
        let sortDescription = NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: false)
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.sortDescriptors = [sortDescription]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultController = controller
        try? controller.performFetch()
    }
    
    func storeRecord(_ record: TrackerRecord) {
        managedObject.storeRecord(record)
    }
    
    func updateRecord(_ record: TrackerRecord) {
        managedObject.updateRecord(record)
    }
    
    func deleteRecord(of record: TrackerRecord) {
        managedObject.deleteRecord(record)
    }
    
    func fetchAllRecords() -> [TrackerRecord] {
        
        let records = managedObject.fetchAllRecords()
        
        var convertedRecords: [TrackerRecord] = []
        
        for record in records {
            
            if let id = record.id {
                
                let dates: [Date] = getDateArrayFromStrings(of: record)
                convertedRecords.append(TrackerRecord(id: id, date: dates))
            }
        }
        
        return convertedRecords
    }
    
    func fetchRecordWith(id: UUID) -> TrackerRecord? {
        
        guard
            let recordCoreData = managedObject.fetchRecordWith(id: id),
            let  datesStringArray = recordCoreData.datesString?.components(separatedBy: ",")
        else {
            return nil
        }
        
        let datesFormated = datesStringArray.map({ dateFormatter.date(from: $0) })
        
        var dates = [Date]()
        
        for date in datesFormated {
            if let date {
                dates.append(date)
            } else {
                return nil
            }
        }
        
        let record = TrackerRecord(id: id, date: dates)
        
        return record
    }
    
    func getDateArrayFromStrings(of record: TrackerRecordCoreData) -> [Date] {
        
        var dates: [Date] = []
        if  let datesString = record.datesString?.components(separatedBy: ",") {
            
            for dateString in datesString {
                
                if let date = dateFormatter.date(from: dateString) {
                    
                    dates.append(date)
                }
            }
            
        }
        return dates
    }
}


extension TrackerRecordStoreProvider: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard
            let recordCoreData = anObject as? TrackerRecordCoreData,
            let id = recordCoreData.id
        else {
            return
        }
        
        let dates = getDateArrayFromStrings(of: recordCoreData)
        let record = TrackerRecord(id: id, date: dates)
        
        switch type {
            
        case .insert:
            delegate?.didAdd(record: record)
        case .delete:
            delegate?.didDelete(record: record)
        case .update:
            delegate?.didUpdate(record: record)
        default:
            break
        }
    }
}
