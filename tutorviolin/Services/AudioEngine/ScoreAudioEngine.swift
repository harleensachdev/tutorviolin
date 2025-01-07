//
//  ScoreAudioEngine.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import AVFoundation

class ScoreAudioEngine {
    static let shared = ScoreAudioEngine()
    private let audioPlayer = AVAudioEngine()
    private let synth = AVAudioUnitSampler()
    
    private init() {
        setupAudio()
    }
    
    private func setupAudio() {
        audioPlayer.attach(synth)
        audioPlayer.connect(synth, to: audioPlayer.mainMixerNode, format: nil)
        
        do {
            try audioPlayer.start()
        } catch {
            print("Audio engine error: \(error)")
        }
    }
    
    func playNote(pitch: String) {
        if let midiNote = getMIDINote(for: pitch) {
            synth.startNote(midiNote, withVelocity: 64, onChannel: 0)
            
            // Stop note after 0.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.synth.stopNote(midiNote, onChannel: 0)
            }
        }
    }
    
    private func getMIDINote(for pitch: String) -> UInt8? {
        let noteMap = ["C": 60, "D": 62, "E": 64, "F": 65, "G": 67, "A": 69, "B": 71]
        let note = String(pitch.prefix(1))
        return UInt8(noteMap[note] ?? 60)
    }
}
