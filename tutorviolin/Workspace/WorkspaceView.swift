//
//  WorkspaceView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 06/01/2025.
//

import SwiftUI

struct WorkspaceView: View {
    @StateObject private var workspaceVM = WorkspaceViewModel()
    @State private var showingScoreEditor = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(workspaceVM.workspaces) { workspace in
                    Section(header: Text(workspace.name)) {
                        ForEach(workspace.scores) { score in
                            NavigationLink(score.name) {
                                StaffView(
                                    keySignature: .constant(score.keySignature),
                                    clef: .constant(score.clef),
                                    timeSignature: .constant(score.timeSignature),
                                    notes: score.notes
                                )
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
        }
        .sheet(isPresented: $showingScoreEditor) {
            ScoreEditorView()
                .environmentObject(workspaceVM)
        }
    }
}
