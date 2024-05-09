//
//  TrackerStore.swift
//  Tracker
//
//  Created by Malik Timurkaev on 06.05.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private let context: NSManagedObjectContext
    private let appDelegate: AppDelegate
    private let uiColorMarshalling = UIColorMarshalling()
    
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
            var weekdays: String = schedule.joined(separator: " ")
            
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        
        do {
            
            guard let response = try context.fetch(fetchRequest) as? [TrackerCoreData] else {
                return nil
            }
            
            print(response.count)
            print(response.first?.name)
            print(response.first?.trackerCategory)
            print(response.first?.trackerCategory?.titleOfCategory)
            
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func convertResponseToType(_ response: [TrackerCoreData]) -> [Tracker] {
        
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

