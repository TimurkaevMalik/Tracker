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
        
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.emoji = tracker.emoji
        
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        
        if !tracker.schedule.isEmpty {
            
            var weekdays: String = ""
            
            for weekday in tracker.schedule {
                weekdays += " " + (weekday ?? " ")
                
            }
            
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
}
