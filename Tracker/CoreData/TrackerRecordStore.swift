//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Malik Timurkaev on 06.05.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
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
    
    func stroreTracerRecord(_ record: TrackerRecord){
        
    }
    
    
}
