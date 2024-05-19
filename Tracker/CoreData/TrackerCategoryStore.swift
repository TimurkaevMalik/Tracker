//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Malik Timurkaev on 06.05.2024.
//

import UIKit
import CoreData

protocol CategoryStoreDelegate: AnyObject {
    func storeDidUpdate(_ update: TrackerCategory)
}

final class TrackerCategoryStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var fectchedResultController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private let appDelegate: AppDelegate
    weak var delegate: CategoryStoreDelegate?
    private let categoryName = "TrackerCategoryCoreData"
    
    init(/*_ delegate: CategoryStoreDelegate?*/appDelegate: AppDelegate){
        self.appDelegate = appDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
//        if let delegate {
//            self.delegate = delegate
//        }
        super.init()
        
        let sortDescriptions = NSSortDescriptor(keyPath: \TrackerCategoryCoreData.titleOfCategory, ascending: false)
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: categoryName)
        fetchRequest.sortDescriptors = [sortDescriptions]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        fectchedResultController = controller
        try? fectchedResultController?.performFetch()
    }
    
    
    func storeCategory(_ category: TrackerCategory) {
        
//        guard fetchCategory(with: category.titleOfCategory) == nil else {
//            return
//        }
        
        guard let categoryEntityDescription = NSEntityDescription.entity(forEntityName: categoryName, in: context ) else {
            return
        }
        
        let trackerCategoryCoreData = TrackerCategoryCoreData(entity: categoryEntityDescription, insertInto: context)
        
        trackerCategoryCoreData.titleOfCategory = category.titleOfCategory
        
        appDelegate.saveContext()
    }
    
    
    func fetchAllCategories() -> [TrackerCategoryCoreData]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: categoryName)
        
        do {
            let response = try context.fetch(fetchRequest) as? [TrackerCategoryCoreData]
            return response
            
        } catch let error as NSError {
            assertionFailure("\(error)")
            return nil
        }
    }
    
    func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: categoryName)
        
        do {
            let categories = try context.fetch(fetchRequest)
            
            return categories.first(where: { category in
                category.titleOfCategory == title })
            
        } catch let error as NSError {
            assertionFailure("\(error)")
            return nil
        }
    }
    
    func convertToCategotyArray( _ response: [TrackerCategoryCoreData]) -> [TrackerCategory] {
        
        var categoryArray: [TrackerCategory] = []
        for categoryCoreData in response {
            
            if let title = categoryCoreData.titleOfCategory {
                let category = TrackerCategory(titleOfCategory: title, trackersArray: [])
                categoryArray.append(category)
            }
        }
        
        return categoryArray
    }
    
    private func convertCoreDataToCategory( _ categoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        
        var category: TrackerCategory
        
        if let title = categoryCoreData.titleOfCategory {
            
            category = TrackerCategory(titleOfCategory: title, trackersArray: [])
            
            return category
        }
        
        return nil
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard
            let categoryCoreData = anObject as? TrackerCategoryCoreData,
            let category = convertCoreDataToCategory(categoryCoreData)
        else { return }
        
        switch type {
            
        case .insert:
            delegate?.storeDidUpdate(category)
            break
        case .delete:
            break
        case .update:
            delegate?.storeDidUpdate(category)
            break
        default:
            break
        }
    }
}
