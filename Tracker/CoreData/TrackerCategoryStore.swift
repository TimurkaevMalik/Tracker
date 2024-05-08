//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Malik Timurkaev on 06.05.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    
    private let context: NSManagedObjectContext
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
    
    
    func storeCategory(_ category: TrackerCategory) {
        
        let TrackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        
        TrackerCategoryCoreData.titleOfCategory = category.titleOfCategory
        
        print(TrackerCategoryCoreData)
        appDelegate.saveContext()
    }
    
    func updateStoredCategory(_ category: TrackerCategory){
        
    }
    
    
    func fetchCategories() -> [TrackerCategory] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCoreData")
        
        do {
            let resopnse = (try? context.fetch(fetchRequest) as? [TrackerCategory]) ?? []
            print(resopnse)
            return resopnse
        }
    }
}
