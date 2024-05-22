//
//  UserDefaultsManager.swift
//  Tracker
//
//  Created by Malik Timurkaev on 21.05.2024.
//

import Foundation

class UserDefaultsManager {
    
    private static let wasOnboardinShownKey = "wasOnboardinShown"
    
    static var wasOnboardinShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsManager.wasOnboardinShownKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsManager.wasOnboardinShownKey)
        }
    }
}
