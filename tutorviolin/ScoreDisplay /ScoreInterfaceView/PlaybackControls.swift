//
//  PlaybackControls.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//
import SwiftUI

struct PlaybackControls: View {
    @Binding var isPlaying: Bool
    let playScore: () -> Void
    
    var body: some View {
        Button(action: playScore) {
            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 30))
        }
        .disabled(isPlaying)
    }
}
