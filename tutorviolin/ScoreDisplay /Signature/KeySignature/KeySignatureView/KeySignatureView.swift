//
//  KeySignatureView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI

struct KeySignatureView: View {
    let keySignature: KeySignature
    let clef: Clef
    
    private let staffLineSpacing: CGFloat = 8
    private let accidentalWidth: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw clef
                Text(clef.rawValue)
                    .font(.system(size: staffLineSpacing * 8))
                    .position(x: staffLineSpacing * 3,
                             y: geometry.size.height / 3)
                
                // Draw accidentals
                HStack(spacing: accidentalWidth) {
                    ForEach(0..<abs(keySignature.accidentalCount), id: \.self) { index in
                        let accidental = keySignature.accidentalCount > 0 ? "♯" : "♭"
                        let positions = calculateAccidentalPositions()
                        
                        Text(accidental)
                            .font(.system(size: staffLineSpacing * 2))
                            .offset(y: positions[index] * staffLineSpacing / 2)
                    }
                }
                .position(x: staffLineSpacing * 8,
                         y: geometry.size.height / 3)
            }
        }
    }
    
    // Calculate vertical positions for accidentals based on key signature
    private func calculateAccidentalPositions() -> [CGFloat] {
        let order = keySignature.accidentalCount > 0 ?
            KeySignature.sharpOrder : KeySignature.flatOrder
        
        // These positions are relative to the middle line of the staff
        let sharpPositions: [String: CGFloat] = [
            "F": 1, "C": -3, "G": 1, "D": -2, "A": -5, "E": 0, "B": -3
        ]
        
        let flatPositions: [String: CGFloat] = [
            "B": -3, "E": 0, "A": -4, "D": -1, "G": -5, "C": -2, "F": -6
        ]
        
        let positions = keySignature.accidentalCount > 0 ? sharpPositions : flatPositions
        return order.prefix(abs(keySignature.accidentalCount)).compactMap { positions[$0] }
    }
}
