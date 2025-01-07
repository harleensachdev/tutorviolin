//
//  WorkspaceView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 06/01/2025.
//

import SwiftUI

struct WorkspaceView: View {
    @State private var showingScoreEditor = false
    
    var body: some View {
        VStack {
            Text("My Workspaces")
                .font(.title)
                .padding()
            
            Button(action: { showingScoreEditor = true }) {
                Label("New Score", systemImage: "plus.circle.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showingScoreEditor) {
                ScoreEditorView()
            }
            
            Spacer()
        }
    }
}
