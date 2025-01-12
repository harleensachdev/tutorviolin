//
//  MusicalNote.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import Foundation

struct MusicalNote: Identifiable, Codable { // Musical note represents a note with specific properties
    let id = UUID() // unique identifier to distinguish from other notes
    var pitch: String  // e.g., "C4", "D4", etc.
    var duration: NoteDuration
    var position: Double  // Position in measures
}

//let note = MusicalNote(pitch: "C4", duration: .quarter, position: 1.0)

