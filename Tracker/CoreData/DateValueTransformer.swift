//
//  ScheduleValueTransformer.swift
//  Tracker
//
//  Created by Malik Timurkaev on 07.05.2024.
//

import UIKit
import CoreData

@objc
final class DateValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        guard let value = value as? [Date] else { return nil }
        
        return try? JSONEncoder().encode(value)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        
        guard let data = value as? NSData else { return nil }
        
        return try? JSONDecoder().decode([Date].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            DateValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DateValueTransformer.self)))
    }
}
