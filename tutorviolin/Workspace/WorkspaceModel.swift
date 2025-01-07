//
//  WorkspaceModel.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI
import Foundation

struct Workspace: Identifiable {
    let id = UUID()
    var name: String
    var notes: [MusicalNote]
    var timeSignature: TimeSignature
    var keySignature: KeySignature
}
