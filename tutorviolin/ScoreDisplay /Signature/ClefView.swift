//
//  ClefView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 10/01/2025.
//

import SwiftUI

// New view for drawing the treble clef
struct ClefView: View {
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                // Simplified G-clef drawing path
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Start from top of G curl
                path.move(to: CGPoint(x: width * 0.7, y: height * 0.2))
                
                // Upper curl
                path.addCurve(
                    to: CGPoint(x: width * 0.3, y: height * 0.4),
                    control1: CGPoint(x: width * 0.8, y: height * 0.25),
                    control2: CGPoint(x: width * 0.6, y: height * 0.35)
                )
                
                // Main stem
                path.addCurve(
                    to: CGPoint(x: width * 0.4, y: height * 0.8),
                    control1: CGPoint(x: width * 0.2, y: height * 0.5),
                    control2: CGPoint(x: width * 0.3, y: height * 0.7)
                )
                
                // Lower curl
                path.addCurve(
                    to: CGPoint(x: width * 0.7, y: height * 0.6),
                    control1: CGPoint(x: width * 0.5, y: height * 0.9),
                    control2: CGPoint(x: width * 0.7, y: height * 0.8)
                )
            }
            .stroke(Color.black, lineWidth: 1.2)
        }
    }
}
