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
        VStack(spacing: 1) {
            Text("\(timeSignature.beats)")
                .font(.system(size: 14, weight: .bold))
            Text("\(timeSignature.beatValue)")
                .font(.system(size: 14, weight: .bold))
        }
        .frame(width: 20)
    }
}
