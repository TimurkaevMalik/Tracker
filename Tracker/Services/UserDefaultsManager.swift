//
//  UserDefaultsManager.swift
//  Tracker
//
//  Created by Malik Timurkaev on 21.05.2024.
//

import Foundation
import UIKit

class UserDefaultsManager {
    
    
    private static let wasOnboardinShownKey = "wasOnboardinShown"
    
    static var wasOnboardinShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsManager.wasOnboardinShownKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsManager.wasOnboardinShownKey)
            
            if newValue == true {
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                let trackerCategoryStore = TrackerCategoryStore(appDelegate: appDelegate)
                
                trackerCategoryStore.storeCategory(TrackerCategory(titleOfCategory: "pined", trackersArray: []))
            }
        }
    }
}
