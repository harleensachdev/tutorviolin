//
//  NoteDurationButton.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI

struct NoteDurationButton: View { // view protocol renders ui interface
    let duration: NoteDuration
    let isSelected: Bool
    let action: () -> Void // code that runs when button is tapped
    
    var body: some View {
        Button(action: action) {
            Text(duration.rawValue)
                .font(.system(size: 24))
                .padding(8)
                .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
        }
    }
}
// displays duration for now, i want it to play note later 
