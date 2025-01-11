//
//  PianoKeyboardView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI

struct NoteSelectorView: View {
    let action: (String) -> Void
    @State private var selectedOctave: Int = 4
    
    private let notes = ["C", "D", "E", "F", "G", "A", "B"]
    private let octaveRange = 3...7
    
    var body: some View {
        VStack(spacing: 8) {
            // Octave selector
            HStack {
                Text("Octave:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ForEach(octaveRange, id: \.self) { octave in
                    Button(action: { selectedOctave = octave }) {
                        Text("\(octave)")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedOctave == octave ? Color.blue : Color.clear)
                            )
                            .foregroundColor(selectedOctave == octave ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal)
            
            // Note buttons in a grid
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 50, maximum: 60), spacing: 8)
            ], spacing: 8) {
                ForEach(notes, id: \.self) { note in
                    let isPlayable = isNoteInRange("\(note)\(selectedOctave)")
                    
                    Button(action: {
                        if isPlayable {
                            action("\(note)\(selectedOctave)")
                        }
                    }) {
                        Text(note)
                            .font(.title3)
                            .frame(width: 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isPlayable ? Color.white : Color.gray.opacity(0.3))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(isPlayable ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 1)
                            )
                    }
                    .disabled(!isPlayable)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Check if note is within violin range (G3-E7)
    private func isNoteInRange(_ note: String) -> Bool {
        let noteValue = note.dropLast() // Get note without octave
        let octave = Int(note.last?.description ?? "0") ?? 0
        
        if octave == 3 {
            return ["G", "A", "B"].contains(String(noteValue))
        } else if octave == 7 {
            return ["C", "D", "E"].contains(String(noteValue))
        }
        return octave >= 4 && octave <= 6
    }
}
