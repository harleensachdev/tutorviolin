//
//  TimeSignatureView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 10/01/2025.
//

import SwiftUI

struct TimeSignatureView: View {
    let timeSignature: TimeSignature
    
    var body: some View {
        VStack(spacing: 2) {
            // Upper number
            Text("\(timeSignature.beats)")
                .font(.system(size: 16, weight: .bold))
            
            // Lower number
            Text("\(timeSignature.beatValue)")
                .font(.system(size: 16, weight: .bold))
        }
    }
}
