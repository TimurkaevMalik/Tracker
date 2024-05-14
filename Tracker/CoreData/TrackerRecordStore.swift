//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Malik Timurkaev on 06.05.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    private let appDelegate: AppDelegate
    private let recordName = "TrackerRecordCoreData"
    private let dateName = "DateCoreData"
    
    private var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.calendar = .current
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        return formatter
    }
    
    
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
    
    
    func storeRecord(_ record: TrackerRecord){
        
        guard let recordEntityDescription = NSEntityDescription.entity(forEntityName: recordName, in: context)
//              let dateEntityDescription = NSEntityDescription.entity(forEntityName: dateName, in: context)
        else {
            return
        }
        
        let recordCoreData = TrackerRecordCoreData(entity: recordEntityDescription, insertInto: context)
//        let dateCoreData = DateCoreData(entity: dateEntityDescription, insertInto: context)
        
        recordCoreData.id = record.id
        
        let dates = record.date.map({ "\($0)"})
        recordCoreData.datesString = dates.joined(separator: ",")
        
//        for date in record.date {
//            
//            dateCoreData.date = date
//            dateCoreData.record = recordCoreData
//            
//            
//            print(dateCoreData)
//
//        }
        print(recordCoreData)
        print(recordCoreData.id)
        print(recordCoreData.datesString)

        appDelegate.saveContext()
    }
    
    func updateRecord(_ record: TrackerRecord) {
        
        guard let recordCoreData = fetchRecordWithCoreData(id: record.id) else { return }

        recordCoreData.id = record.id
        
        let dates = record.date.map({ "\($0)"})
        recordCoreData.datesString = dates.joined(separator: ",")
        
        print(recordCoreData)
        print(recordCoreData.id)
        print(recordCoreData.datesString)
        
        let allRecords = fetchAllRecords()
        
        print(allRecords)

        appDelegate.saveContext()
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        
        guard let recordCoreData = fetchRecordWithCoreData(id: record.id) else { return }
        
        let dates = getDateArrayFromStrings(of: recordCoreData)
        let datesString = record.date.map({ "\($0)"})
        
        if dates.count != 1 {
            recordCoreData.datesString = datesString.joined(separator: ",")
        } else {
            context.delete(recordCoreData)
        }
        
        appDelegate.saveContext()
    }
    
    func getDateArrayFromStrings(of record: TrackerRecordCoreData) -> [Date] {
        
        var dates: [Date] = []
        if  let datesString = record.datesString?.components(separatedBy: ",") {
            print(datesString)
            for dateString in datesString {
                
                if let date = dateFormatter.date(from: dateString) {
                    print(date)
                    dates.append(date)
                }
            }
            
        }
        return dates
    }
    func fetchAllRecords() -> [TrackerRecord] {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: recordName)
        
        do {
            
            let records = try context.fetch(fetchRequest)

            var convertedRecords: [TrackerRecord] = []
            
            for record in records {
            
                if let id = record.id {
                    
                    var dates: [Date] = getDateArrayFromStrings(of: record)
                    convertedRecords.append(TrackerRecord(id: id, date: dates))
                    }
                }
            
            
            print(convertedRecords)
            
            return convertedRecords
        } catch let error as NSError {
            
            print(error)
            return []
        }
    }
    
    func fetchRecordWith(id: UUID) -> TrackerRecord? {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: recordName)
        
        do {
            
            

            
            guard 
                let recordCoreData = try context.fetch(fetchRequest).first(where: { $0.id == id }),
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
            
            print(record)
            
            return record
        } catch let error as NSError {
            
            print(error)
            return nil
        }
    }
    
    func fetchRecordWithCoreData(id: UUID) -> TrackerRecordCoreData? {
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
