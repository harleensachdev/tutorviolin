//
//  MetrenomeEngine.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 20/01/2025.
//

import SwiftUI

import SwiftUI
import AVFoundation

enum TempoMarking: String, CaseIterable {
    case largo = "Largo"
    case adagio = "Adagio"
    case andante = "Andante"
    case moderato = "Moderato"
    case allegro = "Allegro"
    case presto = "Presto"
    
    var bpm: Double {
        switch self {
        case .largo: return 50
        case .adagio: return 70
        case .andante: return 92
        case .moderato: return 112
        case .allegro: return 130
        case .presto: return 168
        }
    }
    
    var description: String {
        switch self {
        case .largo: return "Very slow and broad (50 BPM)"
        case .adagio: return "Slow and stately (70 BPM)"
        case .andante: return "Walking pace (92 BPM)"
        case .moderato: return "Moderate speed (112 BPM)"
        case .allegro: return "Fast and bright (130 BPM)"
        case .presto: return "Very fast (168 BPM)"
        }
    }
}

class MetronomeEngine: ObservableObject {
    private var audioEngine: AVAudioEngine
    private var player: AVAudioPlayerNode
    private var buffer: AVAudioPCMBuffer?
    private var timer: Timer?
    @Published private(set) var isPlaying: Bool = false
    private var bpm: Double = 100
    
    init() {
        audioEngine = AVAudioEngine()
        player = AVAudioPlayerNode()
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioEngine.attach(player)
        
        let sampleRate = 44100.0
        let duration = 0.05 // Shorter duration for crisper click
        let frameCount = UInt32(duration * sampleRate)
        
        guard let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCount) else {
            print("Failed to create audio format or buffer")
            return
        }
        
        buffer.frameLength = frameCount
        
        // Create a more percussive click sound
        if let data = buffer.floatChannelData?[0] {
            for frame in 0..<Int(frameCount) {
                let progress = Float(frame) / Float(frameCount)
                let amplitude = powf(1.0 - progress, 2.0) // Exponential decay
                let frequency: Float = 1000.0 + 500.0 * powf(1.0 - progress, 3.0) // Frequency sweep
                let sample = sinf(2.0 * .pi * frequency * Float(frame) / Float(sampleRate))
                data[frame] = sample * amplitude * 0.5
            }
        }
        
        self.buffer = buffer
        audioEngine.connect(player, to: audioEngine.mainMixerNode, format: audioFormat)
        
        do {
            try audioEngine.start()
        } catch {
            print("Could not start audio engine: \(error)")
        }
    }
    
    func start(bpm: Double) {
        guard let buffer = self.buffer else { return }
        self.bpm = bpm
        
        // Stop any existing playback
        stop()
        
        // Ensure audio engine is running
        if !audioEngine.isRunning {
            do {
                try audioEngine.start()
            } catch {
                print("Could not start audio engine: \(error)")
                return
            }
        }
        
        isPlaying = true
        player.scheduleBuffer(buffer, at: nil, options: [])
        player.play()
        
        // Schedule timer for repeated clicks
        timer = Timer.scheduledTimer(withTimeInterval: 60.0 / bpm, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.player.scheduleBuffer(buffer, at: nil, options: [])
            self.player.play()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        player.stop()
        isPlaying = false
    }
    
    func updateTempo(bpm: Double) {
        if isPlaying {
            stop()
            start(bpm: bpm)
        }
        self.bpm = bpm
    }
    
    deinit {
        stop()
        audioEngine.stop()
    }
}

struct TempoSettingsView: View {
    @Binding var selectedTempo: TempoMarking
    @Binding var customBPM: Double
    @Binding var isCustomTempo: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Preset Tempos")) {
                    ForEach(TempoMarking.allCases, id: \.self) { tempo in
                        Button(action: {
                            withAnimation {
                                selectedTempo = tempo
                                isCustomTempo = false
                            }
                            dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(tempo.rawValue)
                                        .font(.headline)
                                    Text(tempo.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if selectedTempo == tempo && !isCustomTempo {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .contentShape(Rectangle())
                    }
                }
                
                Section(header: Text("Custom Tempo")) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(Int(customBPM)) BPM")
                                .font(.headline)
                            Spacer()
                            if isCustomTempo {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        Slider(value: $customBPM,
                               in: 40...208,
                               step: 1) { editing in
                            if !editing {
                                isCustomTempo = true
                            }
                        }
                        Text(getBPMDescription(customBPM))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Tempo Settings")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
    
    private func getBPMDescription(_ bpm: Double) -> String {
        switch bpm {
        case 40...60: return "Very slow"
        case 61...80: return "Slow"
        case 81...100: return "Moderate slow"
        case 101...120: return "Moderate"
        case 121...140: return "Moderate fast"
        case 141...180: return "Fast"
        case 181...: return "Very fast"
        default: return ""
        }
    }
}
