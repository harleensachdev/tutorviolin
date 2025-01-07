//
//  TimeSignature.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import Foundation

struct TimeSignature {
    var beats: Int
    var beatValue: Int
    
    static let common = TimeSignature(beats: 4, beatValue: 4)
}
