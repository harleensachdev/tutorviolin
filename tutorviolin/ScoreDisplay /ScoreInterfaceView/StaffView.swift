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
    
    var body: some View {
        HStack(spacing: 0) {
            KeySignatureView(keySignature: keySignature, clef: clef)
                .frame(width: 60)
            
            
            GeometryReader { geometry in
                ZStack {
                    // Draw staff lines
                    ForEach(0..<5) { line in
                        Path { path in
                            let y = CGFloat(line) * 10 + 50
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        .stroke(Color.black, lineWidth: 1)
                    }
                    
                    // Draw notes
                    HStack(spacing: 30) {
                        ForEach(notes) { note in
                            Text(note.duration.rawValue)
                                .font(.system(size: 24))
                        }
                    }
                    
                }
            }
        }
        
    }
    
}
