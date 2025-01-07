//
//  TimeSignatureSelector.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//
import SwiftUI

struct TimeSignatureSelector: View {
    @Binding var timeSignature: TimeSignature
    
    var body: some View {
        Button("\(timeSignature.beats)/\(timeSignature.beatValue)") {
            // Toggle between 4/4 and 3/4
            if timeSignature.beats == 4 {
                timeSignature = TimeSignature(beats: 3, beatValue: 4)
            } else {
                timeSignature = TimeSignature(beats: 4, beatValue: 4)
            }
        }
    }
}
