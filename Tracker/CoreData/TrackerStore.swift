//
//  TrackerStore.swift
//  Tracker
//
//  Created by Malik Timurkaev on 06.05.2024.
//

import UIKit
import CoreData

protocol TrackerMangedObjectProtocol {
    var context: NSManagedObjectContext { get }
    var uiColorMarshalling: UIColorMarshalling { get }
    
    func storeNewTracker(_ tracker: Tracker, for categoryTitle: String)
    func fetchAllTrackers() -> [TrackerCoreData]?
    func deleteAllTrackers()
    func deleteTrackerWith(id: UUID)

}

final class TrackerStore {
    
    internal let context: NSManagedObjectContext
    internal let uiColorMarshalling = UIColorMarshalling()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let appDelegate: AppDelegate
    
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
    
extension TrackerStore: TrackerMangedObjectProtocol {
    
    func storeNewTracker(_ tracker: Tracker, for categoryTitle: String) {
        
        guard let trackerEntityDescription = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: context ) else {
            return
        }
        
        let trackerCoreData = TrackerCoreData(entity: trackerEntityDescription, insertInto: context)
        
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.emoji = tracker.emoji
        
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        
        if !tracker.schedule.isEmpty {
            let schedule: [String] = tracker.schedule.map { element in
                
                return element ?? ""
            }
            let weekdays: String = schedule.joined(separator: " ")
            
            trackerCoreData.schedule = weekdays
            
        } else {
            trackerCoreData.schedule = nil
        }
        
        let categoryCoreData = trackerCategoryStore.fetchCategory(with: categoryTitle)
        
        categoryCoreData?.titleOfCategory = categoryTitle
        categoryCoreData?.addToTrackersArray(trackerCoreData)
        
        print(trackerCoreData)
        appDelegate.saveContext()
    }
    
    func fetchAllTrackers() -> [TrackerCoreData]? {
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        do {
            
            let response = try context.fetch(fetchRequest)
            
            print(response.count)
            print(response.first?.trackerCategory?.titleOfCategory as Any)
            
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteAllTrackers() {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        do {
            
            let trackers = try context.fetch(fetchRequest)
            trackers.forEach({ context.delete($0) })
            
            appDelegate.saveContext()
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteTrackerWith(id: UUID){
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")

        do {
            
            let trackers = try context.fetch(fetchRequest)
            
            guard let tracker = trackers.first(where: { $0.id == id }) else { return }
            
            context.delete(tracker)
            appDelegate.saveContext()
            
        } catch let error as NSError {
            
        }
    }
    
    private func convertResponseToType(_ response: [TrackerCoreData]) -> [Tracker] {
        
        var trackerArray: [Tracker] = []
        
        for trackerCoreData in response {
            
            let schedule = trackerCoreData.schedule != nil ? trackerCoreData.schedule : nil
            
            if
                let id = trackerCoreData.id,
                let name = trackerCoreData.name,
                let colorHexString = trackerCoreData.color,
                let emoji = trackerCoreData.emoji
            {
                let tracker = Tracker(
                    id: id,
                    name: name,
                    color: uiColorMarshalling.color(from: colorHexString),
                    emoji: emoji,
                    schedule: schedule?.components(separatedBy: " ") ?? [])
                
                trackerArray.append(tracker)
            }
        }
        
        return trackerArray
    }
}

