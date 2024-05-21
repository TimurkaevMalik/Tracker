//
//  UserDefaultsManager.swift
//  Tracker
//
//  Created by Malik Timurkaev on 21.05.2024.
//

import Foundation

class UserDefaultsManager {
    
    
    static var wasOnboardinShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: "wasOnboardinShown")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "wasOnboardinShown")
        }
    }
}
