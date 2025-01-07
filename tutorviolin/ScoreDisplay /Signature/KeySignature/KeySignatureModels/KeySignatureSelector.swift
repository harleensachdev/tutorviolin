//
//  KeySignatureSelector.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI
struct KeySignatureSelector: View {
    @Binding var keySignature: KeySignature
    @Binding var clef: Clef
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Clef selector
            Picker("Clef", selection: $clef) {
                ForEach(Clef.allCases, id: \.self) { clef in
                    Text(clef.rawValue)
                        .font(.system(size: 24))
                        .tag(clef)
                }
            }
            .pickerStyle(.segmented)
            
            // Key signature selector
            Menu {
                ForEach(KeySignature.commonKeys) { key in
                    Button(action: { keySignature = key }) {
                        HStack {
                            Text(key.displayName)
                            if keySignature == key {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(keySignature.displayName)
                    Image(systemName: "chevron.down")
                }
                .padding(8)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
            }
        }
    }
}
