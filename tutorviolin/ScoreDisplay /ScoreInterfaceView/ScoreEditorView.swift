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
    @State private var currentPage: Int = 0
    @State private var showingSaveDialog = false
    @State private var scoreName = ""
    @State private var workspaceName = ""
    @EnvironmentObject var workspaceVM: WorkspaceViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Top controls section
            HStack {
                KeySignatureSelector(keySignature: $keySignature, clef: $clef)
                TimeSignatureSelector(timeSignature: $timeSignature)
                Spacer()
                PlaybackControls(isPlaying: $isPlaying, playScore: playScore)
            }
            .padding(.horizontal)
            
            // Staff view with scroll functionality
            StaffView(
                keySignature: $keySignature,
                clef: $clef,
                timeSignature: $timeSignature,
                notes: notes
            )
            .frame(height: 160)
            .padding(.horizontal)
            
            // Note duration selector
            NoteDurationSelector(
                selectedDuration: $selectedDuration,
                onSelect: { duration in
                    selectedDuration = duration
                    if duration.isRest {
                        addRest()
                    }
                }
            )
            .frame(height: 240)
            
            // Note selector (only visible when non-rest duration is selected)
            if !selectedDuration.isRest {
                NoteSelectorView { pitch in
                    addNote(pitch: pitch)
                }
                .frame(height: 160)
                .transition(.opacity)
            }
            
            HStack {
                // Clear button
                Button(action: { notes.removeAll() }) {
                    Label("Clear Score", systemImage: "trash")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                // Undo button
                Button(action: { if !notes.isEmpty { notes.removeLast() }}) {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                        .foregroundColor(.blue)
                }
                Button(action: {
                    showingSaveDialog = true
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title)
                        .foregroundColor(.blue)
                }.sheet(isPresented: $showingSaveDialog) {
                    NavigationView {
                        Form {
                            Section(header: Text("Score Details")) {
                                TextField("Score Name", text: $scoreName)
                                    .textContentType(.name)
                                
                                TextField("Workspace Name", text: $workspaceName)
                                    .textContentType(.name)
                            }
                            
                            Section {
                                Button(action: {
                                    workspaceVM.saveScore(
                                        name: scoreName,
                                        notes: notes,
                                        timeSignature: timeSignature,
                                        keySignature: keySignature,
                                        clef: clef,
                                        workspaceName: workspaceName
                                    )
                                    showingSaveDialog = false
                                    scoreName = ""
                                    workspaceName = ""
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Save Score")
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                }
                                .disabled(scoreName.isEmpty || workspaceName.isEmpty)
                                .listRowBackground(
                                    (scoreName.isEmpty || workspaceName.isEmpty) ?
                                    Color.gray : Color.blue
                                )
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .navigationTitle("Save Score")
                        .navigationBarItems(
                            trailing: Button("Cancel") {
                                showingSaveDialog = false
                                scoreName = ""
                                workspaceName = ""
                            }
                        )
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .padding(.vertical)
                    .animation(.easeInOut, value: selectedDuration.isRest)
                }
            }
        }
    }
    
    private func playScore() {
        Task {
            guard !isPlaying else { return }
            isPlaying = true
            
            for note in notes {
                if !note.duration.isRest {
                    ScoreAudioEngine.shared.playNote(pitch: note.pitch)
                }
                // Use the durationValue from NoteDuration for timing
                try? await Task.sleep(nanoseconds: UInt64(note.duration.durationValue * 500_000_000))
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
    
    private func addRest() {
        let newRest = MusicalNote(
            pitch: "R",
            duration: selectedDuration,
            position: Double(notes.count)
        )
        notes.append(newRest)
    }
}
