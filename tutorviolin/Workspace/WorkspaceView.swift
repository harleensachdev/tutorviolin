//
//  WorkspaceView.swift
//  tutorviolin
//

import SwiftUI

struct WorkspaceView: View {
    @ObservedObject var workspaceVM: WorkspaceViewModel
    @State private var showingScoreEditor = false
    @State private var isPlaying = false
    @Binding var showingRhythmTest: Bool
    @Binding var selectedScore: Score?
    @Binding var path: NavigationPath
    
    var body: some View {
        List {
            ForEach(workspaceVM.workspaces) { workspace in
                Section(header: Text(workspace.name)) {
                    ForEach(workspace.scores) { score in
                        VStack(alignment: .leading) {
                            NavigationLink {
                                ScoreDetailView(
                                    score: score,
                                    isPlaying: $isPlaying,
                                    showingRhythmTest: $showingRhythmTest,
                                    selectedScore: $selectedScore
                                )
                            } label: {
                                Text(score.name)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("My Workspaces")
        .toolbar {
            Button(action: { showingScoreEditor = true }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingScoreEditor) {
            NavigationStack {
                ScoreEditorView()
                    .environmentObject(workspaceVM)
            }
        }
    }
}

struct ScoreDetailView: View {
    let score: Score
    @Binding var isPlaying: Bool
    @Binding var showingRhythmTest: Bool
    @Binding var selectedScore: Score?
    
    var body: some View {
        VStack {
            StaffView(
                keySignature: .constant(score.keySignature),
                clef: .constant(score.clef),
                timeSignature: .constant(score.timeSignature),
                notes: score.notes
            )
            
            HStack {
                Button(action: {
                    playScore(score.notes)
                }) {
                    Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                
                Button(action: {
                    withAnimation {
                        selectedScore = score  // Set the score first
                        DispatchQueue.main.async {
                            showingRhythmTest = true  // Then show the view
                        }
                    }
                }) {
                    Text("Take Rhythm Test")
                        .foregroundColor(.purple)
                        .font(.headline)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func playScore(_ notes: [MusicalNote]) {
        Task {
            guard !isPlaying else { return }
            isPlaying = true
            
            for note in notes {
                if !note.duration.isRest {
                    ScoreAudioEngine.shared.playNote(pitch: note.pitch)
                }
                try? await Task.sleep(nanoseconds: UInt64(note.duration.durationValue * 500_000_000))
            }
            
            isPlaying = false
        }
    }
}
