//
//  NoteDuration.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import Foundation


enum NoteDuration: String, CaseIterable, Codable {
    case whole = "𝅝"             // U+1D15D
    case wholeD = "𝅝."           // Whole note with dot
    case half = "𝅗𝅥"             // U+1D157 U+1D165
    case halfD = "𝅗𝅥."           // Half note with dot
    case quarter = "♩"           // U+2669
    case quarterD = "♩."         // Quarter note with dot
    case eighth = "♪"            // U+266A
    case eighthD = "♪."          // Eighth note with dot
    case sixteenth = "♬"         // U+266C
    case sixteenthD = "♬."       // Sixteenth note with dot
    // Rests
    case wholeRest = "𝄻"         // U+1D13B
    case halfRest = "𝄼"          // U+1D13C
    case quarterRest = "𝄽"       // U+1D13D
    case eighthRest = "𝄾"        // U+1D13E    

    var durationValue: Double {
        switch self {
        case .whole, .wholeRest: return 4.0
        case .wholeD: return 6.0
        case .half, .halfRest: return 2.0
        case .halfD: return 3.0
        case .quarter, .quarterRest: return 1.0
        case .quarterD: return 1.5
        case .eighth, .eighthRest: return 0.5
        case .eighthD: return 0.75
        case .sixteenth: return 0.25
        case .sixteenthD: return 0.375
        }
    }
    
    var isRest: Bool {
        switch self {
        case .wholeRest, .halfRest, .quarterRest, .eighthRest:
            return true
        default:
            return false
        }
    }
    
    // Helper to get a nice display size for each symbol
    var displaySize: CGFloat {
        switch self {
        case .whole, .wholeD:
            return 28
        case .half, .halfD:
            return 26
        case .quarter, .quarterD:
            return 24
        case .eighth, .eighthD:
            return 24
        case .sixteenth, .sixteenthD:
            return 24
        case .wholeRest, .halfRest, .quarterRest, .eighthRest:
            return 22
        }
    }
}
