//
//  LetterCollectionViewCell.swift
//  Tracker
//
//  Created by Malik Timurkaev on 14.04.2024.
//

import Foundation
import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Date
    
    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Date) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}
