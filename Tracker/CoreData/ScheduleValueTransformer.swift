//
//  ScheduleValueTransformer.swift
//  Tracker
//
//  Created by Malik Timurkaev on 07.05.2024.
//

import UIKit
import CoreData

@objc
final class ScheduleValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        guard let value = value as? [String] else {
            return nil
        }
        
        return try? JSONEncoder().encode(value)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        
        guard let data = value as? NSData else {
            return nil
        }
        
        return try? JSONDecoder().decode([String].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            ScheduleValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: ScheduleValueTransformer.self)))
    }
}
