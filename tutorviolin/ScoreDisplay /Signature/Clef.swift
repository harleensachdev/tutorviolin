//
//  Clef.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI
enum Clef: String, CaseIterable, Codable {
    case treble = "𝄞"    // G clef
    
    var staffOffset: Int {
        switch self {
        case .treble: return 0
        }
    }
}
