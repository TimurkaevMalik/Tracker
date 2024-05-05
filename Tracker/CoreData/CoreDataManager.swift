//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Malik Timurkaev on 05.05.2024.
//

import UIKit
import CoreData

final class CoreDataManager: NSObject {
    
    public static let shared = CoreDataManager()
    
    private override init(){}
    
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
}
