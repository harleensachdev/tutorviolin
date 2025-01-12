//
//  WorkspaceModel.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI
import Foundation

// WorkspaceModel.swift
struct Score: Identifiable, Codable {
    let id = UUID()
    var name: String
    var notes: [MusicalNote]
    var timeSignature: TimeSignature
    var keySignature: KeySignature
    var clef: Clef
}

struct Workspace: Identifiable, Codable {
    let id = UUID()
    var name: String
    var scores: [Score]  // Changed from notes to scores
}
