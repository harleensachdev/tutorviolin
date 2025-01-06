//
//  Item.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 06/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
