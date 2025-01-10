//
//  ScoreEditorView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//
import SwiftUI
struct ScoreEditorView: View {
    // Your existing state variables remain the same
    @State private var notes: [MusicalNote] = []
    @State private var selectedDuration: NoteDuration = .quarter
    @State private var timeSignature = TimeSignature.common
    @State private var keySignature = KeySignature(tonic: "C", mode: .major, accidentalCount: 0)
    @State private var clef: Clef = .treble
    @State private var isPlaying = false
    
    // Simplified layout constants - we'll use these to ensure proper spacing
    private let staffHeight: CGFloat = 160
    private let contentPadding: CGFloat = 16
    
    var body: some View {
        VStack(spacing: contentPadding) {
            // Top controls section
            HStack {
                KeySignatureSelector(keySignature: $keySignature, clef: $clef)
                TimeSignatureSelector(timeSignature: $timeSignature)
                Spacer()
                PlaybackControls(isPlaying: $isPlaying, playScore: playScore)
            }
            .padding(.horizontal)
            
            // Note duration selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(NoteDuration.allCases, id: \.self) { duration in
                        NoteDurationButton(
                            duration: duration,
                            isSelected: duration == selectedDuration,
                            action: { selectedDuration = duration }
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            // Single staff view - this uses your existing StaffView
            StaffView(keySignature: $keySignature, clef: $clef, notes: notes)
                .frame(height: staffHeight)
            
            // Piano keyboard
            PianoKeyboardView { pitch in
                addNote(pitch: pitch)
            }
        }
    }
    
    // Update playback to use modern async/await instead of Thread.sleep
    private func playScore() {
        Task {
            guard !isPlaying else { return }
            isPlaying = true
            
            for note in notes {
                ScoreAudioEngine.shared.playNote(pitch: note.pitch)
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            }
            
            isPlaying = false
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
}
