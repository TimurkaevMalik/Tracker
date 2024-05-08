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
        
        guard let categoryEntityDescription = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context ) else {
            return
        }
        
        let TrackerCategoryCoreData = TrackerCategoryCoreData(entity: categoryEntityDescription, insertInto: context)
        
        TrackerCategoryCoreData.titleOfCategory = category.titleOfCategory
        
        print(TrackerCategoryCoreData)
        appDelegate.saveContext()
    }
    
    func updateStoredCategory(_ category: TrackerCategory){
        
    }
    
    
    func fetchCategories() -> [TrackerCategory]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCoreData")
        
        do {
            let response = try context.fetch(fetchRequest) as? [TrackerCategory]
            print(response)
            
            return response
        } catch {
            print(error.localizedDescription)
            print(error)
            return nil
        }
    }
}
