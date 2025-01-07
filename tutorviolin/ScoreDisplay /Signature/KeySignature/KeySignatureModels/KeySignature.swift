//
//  KeySignature.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI

struct KeySignature: Equatable, Identifiable {
    let id = UUID()
    var tonic: String      // The root note (e.g., "C", "G", etc.)
    var mode: Mode
    var accidentalCount: Int  // Number of sharps (positive) or flats (negative)
    
    enum Mode: String, CaseIterable {
        case major = "Major"
        case minor = "Minor"
        
        var symbol: String {
            switch self {
            case .major: return ""
            case .minor: return "m"
            }
        }
    }
    
    // The order of sharps: F C G D A E B
    static let sharpOrder = ["F", "C", "G", "D", "A", "E", "B"]
    
    // The order of flats: B E A D G C F
    static let flatOrder = ["B", "E", "A", "D", "G", "C", "F"]
    
    // Common key signatures
    static let commonKeys: [KeySignature] = [
        // Major keys with sharps
        KeySignature(tonic: "C", mode: .major, accidentalCount: 0),
        KeySignature(tonic: "G", mode: .major, accidentalCount: 1),
        KeySignature(tonic: "D", mode: .major, accidentalCount: 2),
        KeySignature(tonic: "A", mode: .major, accidentalCount: 3),
        KeySignature(tonic: "E", mode: .major, accidentalCount: 4),
        KeySignature(tonic: "B", mode: .major, accidentalCount: 5),
        KeySignature(tonic: "F♯", mode: .major, accidentalCount: 6),
        KeySignature(tonic: "C♯", mode: .major, accidentalCount: 7),
        
        // Major keys with flats
        KeySignature(tonic: "F", mode: .major, accidentalCount: -1),
        KeySignature(tonic: "B♭", mode: .major, accidentalCount: -2),
        KeySignature(tonic: "E♭", mode: .major, accidentalCount: -3),
        KeySignature(tonic: "A♭", mode: .major, accidentalCount: -4),
        KeySignature(tonic: "D♭", mode: .major, accidentalCount: -5),
        KeySignature(tonic: "G♭", mode: .major, accidentalCount: -6),
        KeySignature(tonic: "C♭", mode: .major, accidentalCount: -7),
        
        // Natural minor keys
        KeySignature(tonic: "A", mode: .minor, accidentalCount: 0),
        KeySignature(tonic: "E", mode: .minor, accidentalCount: 1),
        KeySignature(tonic: "B", mode: .minor, accidentalCount: 2),
        KeySignature(tonic: "F♯", mode: .minor, accidentalCount: 3),
        KeySignature(tonic: "C♯", mode: .minor, accidentalCount: 4),
        // Add more minor keys as needed
    ]
    
    var displayName: String {
        "\(tonic)\(mode.symbol)"
    }
}
