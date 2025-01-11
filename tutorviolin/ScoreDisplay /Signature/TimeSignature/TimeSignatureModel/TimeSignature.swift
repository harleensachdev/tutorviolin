//
//  TimeSignature.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import Foundation

struct TimeSignature: Equatable {
    var beats: Int
    var beatValue: Int
    
    static let common = TimeSignature(beats: 4, beatValue: 4)
    static let cut = TimeSignature(beats: 2, beatValue: 2)
    
    // Common time signatures used in violin repertoire
    static let commonTimeSignatures: [TimeSignature] = [
        TimeSignature(beats: 4, beatValue: 4),  // Common time
        TimeSignature(beats: 2, beatValue: 2),  // Cut time
        TimeSignature(beats: 3, beatValue: 4),  // Waltz time
        TimeSignature(beats: 6, beatValue: 8),  // Compound duple
        TimeSignature(beats: 9, beatValue: 8),  // Compound triple
        TimeSignature(beats: 12, beatValue: 8), // Compound quadruple
        TimeSignature(beats: 5, beatValue: 4),  // Quintuple
        TimeSignature(beats: 7, beatValue: 8),  // Septuple
        TimeSignature(beats: 2, beatValue: 4),  // Simple duple
        TimeSignature(beats: 3, beatValue: 8),  // Simple triple
        TimeSignature(beats: 6, beatValue: 4)   // Compound duple
    ]
    
    // Calculate beats per measure
    var beatsPerMeasure: Double {
        Double(beats) * (4.0 / Double(beatValue))
    }
}
