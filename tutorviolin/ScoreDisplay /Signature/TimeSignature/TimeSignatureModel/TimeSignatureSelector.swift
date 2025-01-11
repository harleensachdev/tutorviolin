//
//  TimeSignatureSelector.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//
import SwiftUI

struct TimeSignatureSelector: View {
    @Binding var timeSignature: TimeSignature
    @State private var showingPicker = false
    
    var body: some View {
        Button(action: { showingPicker = true }) {
            HStack {
                Text("Time:")
                    .foregroundColor(.secondary)
                TimeSignatureView(timeSignature: timeSignature)
            }
        }
        .sheet(isPresented: $showingPicker) {
            NavigationView {
                List(TimeSignature.commonTimeSignatures, id: \.beats) { sig in
                    Button(action: {
                        timeSignature = sig
                        showingPicker = false
                    }) {
                        HStack {
                            Text("\(sig.beats)/\(sig.beatValue)")
                            Spacer()
                            if timeSignature == sig {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .navigationTitle("Select Time Signature")
                .navigationBarItems(trailing: Button("Done") {
                    showingPicker = false
                })
            }
        }
    }
}
