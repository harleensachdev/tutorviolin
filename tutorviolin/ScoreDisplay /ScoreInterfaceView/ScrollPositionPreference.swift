//
//  ScrollPositionPreference.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 12/01/2025.
//

import SwiftUI

struct ScrollPositionPreference: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { // reduce is a required function in preference key
        value = nextValue() // replacing value with latest value
        // inout CGFloat ensures value is copied and passed into function, not passed by reference
    }
}
