//
//  ContentView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 06/01/2025.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    @StateObject private var workspaceVM = WorkspaceViewModel()
    @State private var showingARBowTracker = false
    @State private var showingRhythmTest = false
    @State private var selectedScore: Score?
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            LoginView(path: $path)
                .navigationDestination(for: String.self) { viewId in
                    switch viewId {
                    case "workspace":
                        WorkspaceView(
                            workspaceVM: workspaceVM,
                            showingRhythmTest: $showingRhythmTest,
                            selectedScore: $selectedScore,
                            path: $path
                        )
                    default:
                        EmptyView()
                    }
                }
        }
        .sheet(isPresented: $showingRhythmTest) {
            NavigationStack {
                if let score = selectedScore {
                    RhythmTestView(score: score)
                } else {
                    Text("No score selected. Please try again.")
                        .foregroundColor(.red)
                }
            }
        }
       
        .onChange(of: showingRhythmTest) { newValue in
            if !newValue {
                // Clear selection when sheet is dismissed
                selectedScore = nil
            }
        }
        .onChange(of: showingARBowTracker) { newValue in
            if !newValue {
                // Clear selection when fullScreenCover is dismissed
                selectedScore = nil
            }
        }
    }
}

