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
    
    
    convenience init(){
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            self.init()
            return
        }
        
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    
}
