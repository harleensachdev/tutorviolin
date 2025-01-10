//
//  StaffView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//
import SwiftUI
struct StaffView: View {
    @Binding var keySignature: KeySignature
    @Binding var clef: Clef
    let notes: [MusicalNote]
    
    // Refined measurements based on traditional music notation
    private let staffLineSpacing: CGFloat = 6.5  // Reduced spacing between staff lines
    private let noteHeadWidth: CGFloat = 7.5     // Standard note head width
    private let noteHeadHeight: CGFloat = 6      // Slightly shorter than width for oval shape
    private let stemWidth: CGFloat = 0.8         // Very thin stem
    private let stemHeight: CGFloat = 28         // Longer stem length
    private let horizontalSpacing: CGFloat = 50  // More space between notes
    // Add new constants for better positioning
    private let staffTopPosition: CGFloat = 20    // Lower starting position for staff
    private let leftMargin: CGFloat = 100        // More space for clef and key signature
    private let clefWidth: CGFloat = 40          // Space for clef
    private func getYPosition(for pitch: String) -> CGFloat {
        // More precise positioning using the refined staff line spacing
        let basePosition: CGFloat = 53 // Starting position of the bottom staff line
        
        let pitchMap: [String: CGFloat] = [
            // Middle C is one ledger line below staff
            "C4": basePosition + (staffLineSpacing * 3),
            // D is in space below staff
            "D4": basePosition + (staffLineSpacing * 2.5),
            // E is on bottom line
            "E4": basePosition + (staffLineSpacing * 2),
            // F is in first space
            "F4": basePosition + (staffLineSpacing * 1.5),
            // G is on second line
            "G4": basePosition + staffLineSpacing,
            // A is in second space
            "A4": basePosition + (staffLineSpacing * 0.5),
            // B is on third line
            "B4": basePosition
        ]
        
        return pitchMap[pitch] ?? basePosition
    }
    
    var body: some View {

            
            GeometryReader { geometry in
                ZStack {
                    // Thinner staff lines
                    ForEach(0..<5) { line in
                        Path { path in
                            let y = CGFloat(line) * staffLineSpacing + 40
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        .stroke(Color.black, lineWidth: 0.5) // Much thinner lines
                    } 
                    
                    HStack(spacing: 0) {
                        KeySignatureView(keySignature: keySignature, clef: clef)
                            .frame(width: leftMargin - clefWidth) // Use remaining space
                            .offset(y: staffTopPosition - staffLineSpacing * 0.5) // Align with staff
                        
                        Spacer()
                    }
        
                        
                    // Draw notes with refined measurements
                    ForEach(Array(notes.enumerated()), id: \.element.id) { index, note in
                        RefinedNoteView(
                            note: note,
                            headWidth: noteHeadWidth,
                            headHeight: noteHeadHeight,
                            stemWidth: stemWidth,
                            stemHeight: stemHeight,
                            shouldStemUp: getYPosition(for: note.pitch) > 40 // Stem direction based on position
                        )
                        .position(
                            x: leftMargin + CGFloat(index) * horizontalSpacing,
                            y: getYPosition(for: note.pitch)
                        )
                    }
                }
            
        }
        .frame(height: 80) // Smaller overall height
    }
}

struct RefinedNoteView: View {
    let note: MusicalNote
    let headWidth: CGFloat
    let headHeight: CGFloat
    let stemWidth: CGFloat
    let stemHeight: CGFloat
    let shouldStemUp: Bool
    
    var body: some View {
        ZStack {
            // Note head with more precise oval shape
            Ellipse()
                .fill(note.duration == .whole || note.duration == .half ? Color.white : Color.black)
                .frame(width: headWidth, height: headHeight)
                .rotationEffect(.degrees(-20))
                .overlay(
                    Ellipse()
                        .stroke(Color.black, lineWidth: 0.5)
                )
            
            // Stem with proper positioning
            if note.duration != .whole {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: stemWidth, height: stemHeight)
                    .offset(
                        x: shouldStemUp ? headWidth * 0.3 : -headWidth * 0.3,
                        y: shouldStemUp ? -stemHeight * 0.5 : stemHeight * 0.5
                    )
            }
        }
    }
}
