//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Malik Timurkaev on 19.05.2024.
//

import Foundation
import UIKit

final class CategoryViewModel {
    
    let trackerCategoryStore: TrackerCategoryStore?
    
    private(set) var categories: [String] = []{
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    var categoriesBinding: Binding<[String]>?
    
    
    convenience init() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  {
            self.init()
            return
        }
        self.init(appDelegate: appDelegate)
    }
    
    private init(appDelegate: AppDelegate) {
        
        self.trackerCategoryStore = TrackerCategoryStore(appDelegate: appDelegate)
        trackerCategoryStore?.delegate = self
        self.categories = fetchCategories()
    }
    
    
    func storeNewCategory(_ category: TrackerCategory) {
        trackerCategoryStore?.storeCategory(category)
    }
    
    func fetchCategories() -> [String] {
        
        guard let categoryCoreData = trackerCategoryStore?.fetchAllCategories() else {
            return []
        }
        let convertedCategories = convertToCategotyArray(categoryCoreData)
        
        return convertedCategories.map({ $0.titleOfCategory })
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
    
}

extension CategoryViewModel: CategoryStoreDelegate {
    func storeDidUpdate(_ update: TrackerCategory) {
        categories = fetchCategories()
    }
}
