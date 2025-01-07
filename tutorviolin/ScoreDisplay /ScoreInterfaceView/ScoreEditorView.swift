//
//  ScoreEditorView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI

struct ScoreEditorView: View {
    @State private var notes: [MusicalNote] = []
    @State private var selectedDuration: NoteDuration = .quarter
    @State private var timeSignature = TimeSignature.common
    @State private var keySignature = KeySignature(tonic: "C", mode: .major, accidentalCount: 0)
    @State private var clef: Clef = .treble
    @State private var isPlaying = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                KeySignatureSelector(keySignature: $keySignature, clef: $clef)
                TimeSignatureSelector(timeSignature: $timeSignature)
                Spacer()
                PlaybackControls(isPlaying: $isPlaying, playScore: playScore)
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(NoteDuration.allCases, id: \.self) { duration in
                        NoteDurationButton(
                            duration: duration,
                            isSelected: duration == selectedDuration,
                            action: { selectedDuration = duration }
                        )
                    }
                }
                .padding()
            }
            
            StaffView(keySignature: $keySignature, clef: $clef, notes: notes)
                .frame(height: 200)
            
            PianoKeyboardView { pitch in
                addNote(pitch: pitch)
            }
        }
    }
    
    private func addNote(pitch: String) {
        let newNote = MusicalNote(
            pitch: pitch,
            duration: selectedDuration,
            position: Double(notes.count)
        )
        notes.append(newNote)
        ScoreAudioEngine.shared.playNote(pitch: pitch)
    }
    
    private func playScore() {
        guard !isPlaying else { return }
        isPlaying = true
        
        for note in notes {
            ScoreAudioEngine.shared.playNote(pitch: note.pitch)
            Thread.sleep(forTimeInterval: 0.5)
        }
        
        isPlaying = false
    }
}
