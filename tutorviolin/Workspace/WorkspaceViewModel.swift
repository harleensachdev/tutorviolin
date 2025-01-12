//
//  WorkspaceViewModel.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 12/01/2025.
//

import SwiftUI

// WorkspaceViewModel.swift
class WorkspaceViewModel: ObservableObject {
    @Published var workspaces: [Workspace] = []
    
    func saveScore(name: String, notes: [MusicalNote], timeSignature: TimeSignature,
                  keySignature: KeySignature, clef: Clef, workspaceName: String) {
        let score = Score(name: name, notes: notes, timeSignature: timeSignature,
                         keySignature: keySignature, clef: clef)
        
        if let workspaceIndex = workspaces.firstIndex(where: { $0.name == workspaceName }) {
            workspaces[workspaceIndex].scores.append(score)
        } else {
            let newWorkspace = Workspace(name: workspaceName, scores: [score])
            workspaces.append(newWorkspace)
        }
    }
}
