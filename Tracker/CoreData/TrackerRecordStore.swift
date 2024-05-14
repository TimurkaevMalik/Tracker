//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Malik Timurkaev on 06.05.2024.
//

import UIKit
import CoreData

protocol RecordManagedObjectProtocol {
    var context: NSManagedObjectContext { get }
    
    func storeRecord(_ record: TrackerRecord)
    func updateRecord(_ record: TrackerRecord)
    func deleteRecord(_ record: TrackerRecord)
    func fetchAllRecords() -> [TrackerRecordCoreData]
    func fetchRecordWith(id: UUID) -> TrackerRecordCoreData?
}
final class TrackerRecordStore {
    
    internal let context: NSManagedObjectContext
    private let appDelegate: AppDelegate
    private let recordName = "TrackerRecordCoreData"
    private let dateName = "DateCoreData"
    
    convenience init(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.init()
            return
        }
        
        self.init(appDelegate: appDelegate)
    }
    
    private init(appDelegate: AppDelegate){
        self.appDelegate = appDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
}

extension TrackerRecordStore: RecordManagedObjectProtocol {
    
    func storeRecord(_ record: TrackerRecord){
        
        guard let recordEntityDescription = NSEntityDescription.entity(forEntityName: recordName, in: context) else { return }
        
        let recordCoreData = TrackerRecordCoreData(entity: recordEntityDescription, insertInto: context)
        
        recordCoreData.id = record.id
        
        let dates = record.date.map({ "\($0)"})
        recordCoreData.datesString = dates.joined(separator: ",")
        
        appDelegate.saveContext()
    }
    
    func updateRecord(_ record: TrackerRecord) {
        
        guard let recordCoreData = fetchRecordWith(id: record.id) else { return }
        
        recordCoreData.id = record.id
        
        let dates = record.date.map({ "\($0)"})
        recordCoreData.datesString = dates.joined(separator: ",")
        
        let allRecords = fetchAllRecords()
        
        appDelegate.saveContext()
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        
        guard let recordCoreData = fetchRecordWith(id: record.id) else { return }
        
        let datesString = record.date.map({ "\($0)"})
        
        if record.date.count != 0 {
            recordCoreData.datesString = datesString.joined(separator: ",")
        } else {
            context.delete(recordCoreData)
        }
        
        appDelegate.saveContext()
    }
    
    
    func fetchAllRecords() -> [TrackerRecordCoreData] {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: recordName)
        
        do {
            
            let records = try context.fetch(fetchRequest)
            
            return records
        } catch let error as NSError {
            
            print(error)
            return []
        }
    }
    
    func fetchRecordWith(id: UUID) -> TrackerRecordCoreData? {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: recordName)
        
        do {
            
            let recordCoreData = try context.fetch(fetchRequest).first(where: { $0.id == id })
            
            return recordCoreData
        } catch let error as NSError {
            
            print(error)
            return nil
        }
    }
}
