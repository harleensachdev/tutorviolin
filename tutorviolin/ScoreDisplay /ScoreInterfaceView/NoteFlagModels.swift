//
//  NoteFlagModels.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 11/01/2025.
//

import SwiftUI

struct NoteFlag: View {
    let duration: NoteDuration
    let shouldStemUp: Bool
    let stemWidth: CGFloat
    let stemHeight: CGFloat
    
    var body: some View {
        if duration.isSixteenth {
            SixteenthFlag(stemUp: shouldStemUp)
        } else {
            EighthFlag(stemUp: shouldStemUp)
        }
    }
}

struct EighthFlag: Shape {
    let stemUp: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if stemUp {
            // Starting point at stem
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            // First curve creating the hook
            path.addCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control1: CGPoint(x: rect.minX + rect.width * 0.7, y: rect.minY + rect.height * 0.2),
                control2: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.midY - rect.height * 0.2)
            )
            
            // Return curve
            path.addCurve(
                to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.4),
                control1: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.midY + rect.height * 0.2),
                control2: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.minY + rect.height * 0.3)
            )
        } else {
            // Starting point at stem for downward flag
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            // First curve creating the hook
            path.addCurve(
                to: CGPoint(x: rect.minX, y: rect.midY),
                control1: CGPoint(x: rect.maxX - rect.width * 0.7, y: rect.minY + rect.height * 0.2),
                control2: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.midY - rect.height * 0.2)
            )
            
            // Return curve
            path.addCurve(
                to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.4),
                control1: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.midY + rect.height * 0.2),
                control2: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY + rect.height * 0.3)
            )
        }
        
        return path
    }
}

struct SixteenthFlag: View {
    let stemUp: Bool
    
    var body: some View {
        VStack(spacing: stemUp ? 0 : 2) {
            EighthFlag(stemUp: stemUp)
                .frame(width: 10, height: 12)
            EighthFlag(stemUp: stemUp)
                .frame(width: 10, height: 12)
        }
    }
}
