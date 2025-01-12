//
//  RefinedNoteView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 12/01/2025.
//

import SwiftUI
struct RefinedNoteView: View {
    let note: MusicalNote
    let headWidth: CGFloat
    let headHeight: CGFloat
    let stemWidth: CGFloat
    let stemHeight: CGFloat
    let shouldStemUp: Bool
    
    var body: some View {
        ZStack {
            if note.duration.isRest {
                RestView(duration: note.duration)
            } else {
                ZStack {
                    // Note head
                    Ellipse()
                        .fill(note.duration == .whole || note.duration == .half ||
                              note.duration == .wholeD || note.duration == .halfD ?
                              Color.white : Color.black)
                        .frame(width: headWidth, height: headHeight)
                        .rotationEffect(.degrees(-20))
                        .overlay(
                            Ellipse()
                                .stroke(Color.black, lineWidth: 0.5)
                        )
                    
                    // Stem and flags
                    if ![.whole, .wholeD].contains(note.duration) {
                        // Stem
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: stemWidth, height: stemHeight+5)
                            .offset(
                                x: shouldStemUp ? headWidth * 0.5 : -headWidth * 0.4,
                                y: shouldStemUp ? -stemHeight * 0.5 : stemHeight * 0.5
                            )
                        
                        // Eighth and Sixteenth note flags using images
                        if [.eighth, .eighthD, .sixteenth, .sixteenthD].contains(note.duration) {
                            NoteFlag(
                                duration: note.duration,
                                shouldStemUp: shouldStemUp,
                                stemWidth: stemWidth,
                                stemHeight: stemHeight
                            )
                            .frame(width: 10, height: shouldStemUp ? 8 : 12)
                            .offset(
                                x: shouldStemUp ? headWidth * 1 : -headWidth * 0.1,
                                y: shouldStemUp ? -stemHeight + 5 : stemHeight - 5
                            )
                        }
                        
                        // Dot for dotted notes
                        if note.duration.rawValue.hasSuffix(".") {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 3, height: 3)
                                .offset(x: headWidth * 1.2, y: 0)
                        }
                    }
                }
            }
        }
    }
}
