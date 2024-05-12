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
        
        guard fetchCategory(with: category.titleOfCategory) == nil else {
            return
        }
        
        guard let categoryEntityDescription = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context ) else {
            return
        }
        
        let trackerCategoryCoreData = TrackerCategoryCoreData(entity: categoryEntityDescription, insertInto: context)
        
        trackerCategoryCoreData.titleOfCategory = category.titleOfCategory
        
        print(trackerCategoryCoreData)
        appDelegate.saveContext()
    }
    
    
    func fetchAllCategories() -> [TrackerCategoryCoreData]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCoreData")
        
        do {
            
            let response = try context.fetch(fetchRequest) as? [TrackerCategoryCoreData]

            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        do {
            let categories = try context.fetch(fetchRequest)
            
            print(categories.count)
            
            return categories.first(where: { category in
                category.titleOfCategory == title
            })
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func convertResponseToType( _ response: [TrackerCategoryCoreData]) -> [TrackerCategory] {
        
        var categoryArray: [TrackerCategory] = []
        for categoryCoreData in response {
            
            if 
               let title = categoryCoreData.titleOfCategory {
                let category = TrackerCategory(titleOfCategory: title, trackersArray: [])
                categoryArray.append(category)
            }
        }
        
        return categoryArray
    }
}
