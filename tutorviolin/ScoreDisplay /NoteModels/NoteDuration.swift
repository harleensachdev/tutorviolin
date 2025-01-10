//
//  NoteDuration.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import Foundation

enum NoteDuration: String, CaseIterable {
    case whole = "o"
    case half = "o|"
    case quarter = "♩"
    case eighth = "♪"
    
    var durationValue: Double {
        switch self {
        case .whole: return 4.0
        case .half: return 2.0
        case .quarter: return 1.0
        case .eighth: return 0.5
        }
    }
}
