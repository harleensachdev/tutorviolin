//
//  PianoKeyboardView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI

struct PianoKeyboardView: View {
    let notes = ["C", "D", "E", "F", "G", "A", "B"]
    let action: (String) -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(notes, id: \.self) { note in
                Button(action: { action("\(note)4") }) {
                    Text(note)
                        .frame(width: 40, height: 120)
                        .background(Color.white)
                        .border(Color.black)
                }
            }
        }
    }
}
