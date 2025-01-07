//
//  Clef.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI
enum Clef: String, CaseIterable {
    case treble = "𝄞"    // G clef
    case alto = "𝄡"      // C clef
    case bass = "𝄢"      // F clef
    
    var staffOffset: Int {
        switch self {
        case .treble: return 0
        case .alto: return 6   // Middle C is on the middle line
        case .bass: return 12  // Middle C is on the third space up
        }
    }
}
