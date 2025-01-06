//
//  WorkspaceView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 06/01/2025.
//

import SwiftUI

struct WorkspaceView: View {
    var body: some View {
        VStack {
            Text("My Workspaces")
                .font(.title)
                .padding()
            
            Spacer()
            
            Text("Add your first workspace")
                .foregroundColor(.gray)
            
            Button(action: {}) {
                Label("New Workspace", systemImage: "plus.circle.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
    }
}
