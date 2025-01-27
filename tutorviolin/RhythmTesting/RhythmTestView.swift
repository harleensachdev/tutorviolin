//
//  RhythmTestView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 19/01/2025.
//

import SwiftUI
import AVFoundation

// Array extension for windows functionality
extension Array {
    func windows(ofCount count: Int) -> [[Element]] {
        guard count > 0, self.count >= count else { return [] }
        return stride(from: 0, to: self.count - count + 1, by: 1).map {
            Array(self[$0..<$0+count])
        }
    }
}

// Accuracy enum
enum NoteAccuracy: Equatable {
    case none, perfect, good, poor
    
    var color: Color {
        switch self {
        case .none: return .clear
        case .perfect: return .green
        case .good: return .yellow
        case .poor: return .red
        }
    }
}

// Performance results struct
struct PerformanceResults {
    let noteAccuracy: [NoteAccuracy]
    let overallAccuracy: Double
    let tempoConsistency: Double
    let rhythmicPatterns: [String]
    let suggestions: [String]
    let difficultPassages: [Int] // Indices of challenging sections
    let strengthAreas: [String]
    let weaknessAreas: [String]
    let practiceExercises: [PracticeExercise]
}

struct PracticeExercise {
    let title: String
    let description: String
    let difficulty: String
    let estimatedTime: String
}
import SwiftUI
import AVFoundation

struct RhythmTestView: View {
    let score: Score
    @Environment(\.dismiss) var dismiss
    @StateObject private var metronome = MetronomeEngine()
    
    // Test state
    @State private var currentNoteIndex = 0
    @State private var tapTimings: [Double] = []
    @State private var startTime: Date?
    @State private var isPlaying = false
    @State private var isReady = false
    @State private var hasDemoPlayed = false
    @State private var isDemoPlaying = false
    @State private var showReport = false
    @State private var performanceResults: PerformanceResults?
    @State private var noteAccuracy: [NoteAccuracy] = []
    @State private var countdown: Int = 3
    @State private var showingCountdown = false
    @State private var isTestStarted = false
    @State private var playbackTask: Task<Void, Never>?
    
    // Tempo settings
    @State private var selectedTempo: TempoMarking = .moderato
    @State private var customBPM: Double = 112
    @State private var isCustomTempo: Bool = false
    @State private var showTempoSettings: Bool = false    // Computed properties
    private var currentBPM: Double {
        isCustomTempo ? customBPM : selectedTempo.bpm
    }
    @State private var scrollOffset: CGFloat = 0
    @State private var viewWidth: CGFloat = UIScreen.main.bounds.width
    
    private var beatDuration: Double {
        60.0 / currentBPM
    }
    
    var body: some View {
        VStack {
                    // Navigation bar stays the same
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        Spacer()
                        Text("Rhythm Test")
                            .font(.headline)
                        Spacer()
                    }
                    
                    // Wrap StaffView in a GeometryReader and ScrollView
                    GeometryReader { geometry in
                        ScrollViewReader { scrollProxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                StaffView(
                                    keySignature: .constant(score.keySignature),
                                    clef: .constant(score.clef),
                                    timeSignature: .constant(score.timeSignature),
                                    notes: score.notes
                                )
                                .frame(width: max(geometry.size.width, CGFloat(score.notes.count) * 50 + 200))
                                .overlay(
                                    ForEach(Array(zip(score.notes.indices, noteAccuracy)), id: \.0) { index, accuracy in
                                        Circle()
                                            .fill(accuracy.color.opacity(0.3))
                                            .frame(width: 20, height: 20)
                                            .position(notePosition(for: index))
                                    }
                                )
                                .overlay(
                                    Group {
                                        if currentNoteIndex < score.notes.count {
                                            Rectangle()
                                                .fill(Color.blue.opacity(0.2))
                                                .frame(width: 2, height: 100)
                                                .position(notePosition(for: currentNoteIndex))
                                                .id("currentNote")
                                        }
                                    }
                                )
                            }
                            .onChange(of: currentNoteIndex) { newIndex in
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    scrollProxy.scrollTo("currentNote", anchor: .center)
                                }
                            }
                        }
                    }
                    .frame(height: 200)
            Spacer()
            
            // Tempo and metronome controls
            HStack(spacing: 16) {
                Button(action: { showTempoSettings.toggle() }) {
                    Label(
                        isCustomTempo ? "\(Int(customBPM)) BPM" : selectedTempo.rawValue,
                        systemImage: "metronome"
                    )
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                
                if isPlaying {
                    Button(action: toggleMetronome) {
                        Image(systemName: metronome.isPlaying ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
            }
            
            // Main test interface
            VStack {
                if showingCountdown {
                    Text("\(countdown)")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.blue)
                } else if isPlaying {
                    Text("Tap to the rhythm!")
                        .font(.title2)
                    
                    Button(action: handleTap) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 200, height: 200)
                            .overlay(
                                VStack {
                                    Text("TAP")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                    Text("\(score.notes.count - currentNoteIndex) notes remaining")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                } else if !isReady {
                    VStack(spacing: 20) {
                        Text("Listen to the piece first")
                            .font(.title2)
                        Button(action: playDemo) {
                            Label("Play Demo", systemImage: "play.circle.fill")
                                .font(.title2)
                                .padding()
                                .background(hasDemoPlayed || isDemoPlaying ? Color.gray : Color.blue)  // Changed condition
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(hasDemoPlayed || isDemoPlaying)  // Changed condition
                    }
                } else {
                    Button(action: startCountdown) {
                        Text("Start Test")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            noteAccuracy = Array(repeating: .none, count: score.notes.count)
        }
        .sheet(isPresented: $showReport) {
            if let results = performanceResults {
                PerformanceReportView(results: results)
            }
        }
        .sheet(isPresented: $showTempoSettings) {
            TempoSettingsView(
                selectedTempo: $selectedTempo,
                customBPM: $customBPM,
                isCustomTempo: $isCustomTempo
            )
        }
    }
    
    // MARK: - Private Methods
    
    private func toggleMetronome() {
        if metronome.isPlaying {
            metronome.stop()
        } else {
            metronome.start(bpm: currentBPM)
        }
    }
    
    private func notePosition(for index: Int) -> CGPoint {
        CGPoint(x: 100 + Double(index) * 50, y: 40)
    }
    
    private func playDemo() {
        isDemoPlaying = true
        let baseDuration = beatDuration
        
        Task {
            for note in score.notes {
                if !note.duration.isRest {
                    ScoreAudioEngine.shared.playNote(pitch: note.pitch)
                }
                try? await Task.sleep(nanoseconds: UInt64(note.duration.durationValue * baseDuration * 1_000_000_000))
            }
            await MainActor.run {
                isDemoPlaying = false
                hasDemoPlayed = true  // Set this to true after demo completes
                isReady = true
            }
        }
    }
    private func startCountdown() {
        showingCountdown = true
        countdown = 3
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                showingCountdown = false
                startTest()
            }
        }
    }
    
    private func startTest() {
        currentNoteIndex = 0
        tapTimings = []
        noteAccuracy = Array(repeating: .none, count: score.notes.count)
        startTime = Date()
        isPlaying = true
        
        // Start metronome if not already playing
        if !metronome.isPlaying {
            metronome.start(bpm: currentBPM)
        }
        
        // Play notes with timing based on current tempo
        let baseDuration = beatDuration  // Whole note duration
        
        Task {
            for note in score.notes {
                if !note.duration.isRest {
                    ScoreAudioEngine.shared.playNote(pitch: note.pitch)
                }
                try? await Task.sleep(nanoseconds: UInt64(note.duration.durationValue * baseDuration * 1_000_000_000))
            }
            
            await MainActor.run {
                finishTest()
            }
        }
    }
    
    private func handleTap() {
        guard let start = startTime, currentNoteIndex < score.notes.count else { return }
        
        let tapTime = Date().timeIntervalSince(start)
        tapTimings.append(tapTime)
        
        let expectedTime = calculateExpectedTime(for: currentNoteIndex)
        let accuracy = calculateAccuracy(tapTime: tapTime, expectedTime: expectedTime)
        noteAccuracy[currentNoteIndex] = accuracy
        
        currentNoteIndex += 1
        
        if currentNoteIndex >= score.notes.count {
            finishTest()
        }
    }
    private func calculateAccuracy(tapTime: Double, expectedTime: Double) -> NoteAccuracy {
        // Give extra buffer for the first note
        let toleranceWindow = beatDuration * (currentNoteIndex == 0 ? 0.8 : 0.4) // 80% buffer for first note, 40% for others
        let difference = abs(tapTime - expectedTime)
        
        switch difference {
        case 0..<(toleranceWindow * 0.5): return .perfect
        case (toleranceWindow * 0.5)..<toleranceWindow: return .good
        default: return .poor
        }
    }

    private func calculateExpectedTime(for noteIndex: Int) -> Double {
        var totalTime: Double = 0
        let baseDuration = beatDuration * 1
        
        // For first note, allow the user to be a bit late
        if noteIndex == 0 {
            return 0.0  // Any time within the buffer window is acceptable
        }
        
        // For subsequent notes, calculate normally
        for i in 0..<noteIndex {
            totalTime += score.notes[i].duration.durationValue * baseDuration
        }
        return totalTime
    }
    
    private func finishTest() {
        isPlaying = false
        metronome.stop()
        
        // Calculate difficult passages (sequences of poor accuracy)
        let difficultPassages = noteAccuracy.windows(ofCount: 3).enumerated()
            .compactMap { index, window in
                window.allSatisfy { $0 == .poor } ? index : nil
            }
        
        // Analyze strengths and weaknesses
        let strengthAreas = analyzeStrengths()
        let weaknessAreas = analyzeWeaknesses()
        
        // Generate practice exercises
        let practiceExercises = generatePracticeExercises()
        
        let results = PerformanceResults(
            noteAccuracy: noteAccuracy,
            overallAccuracy: calculateOverallAccuracy(),
            tempoConsistency: calculateTempoConsistency(),
            rhythmicPatterns: analyzeRhythmicPatterns(),
            suggestions: generateSuggestions(),
            difficultPassages: difficultPassages,
            strengthAreas: strengthAreas,
            weaknessAreas: weaknessAreas,
            practiceExercises: practiceExercises
        )
        
        performanceResults = results
        showReport = true
    }
    
    private func calculateOverallAccuracy() -> Double {
        let accuracyScores = noteAccuracy.map { accuracy -> Double in
            switch accuracy {
            case .perfect: return 1.0
            case .good: return 0.7
            case .poor: return 0.3
            case .none: return 0.0
            }
        }
        return accuracyScores.reduce(0.0, +) / Double(accuracyScores.count)
    }
    
    private func calculateTempoConsistency() -> Double {
        guard tapTimings.count >= 2 else { return 1.0 }
        
        let intervals = zip(tapTimings, tapTimings.dropFirst()).map { $1 - $0 }
        let expectedInterval = beatDuration
        let variations = intervals.map { abs($0 - expectedInterval) }
        let averageVariation = variations.reduce(0.0, +) / Double(variations.count)
        
        return max(0, 1 - (averageVariation / expectedInterval))
    }
    
    private func analyzeRhythmicPatterns() -> [String] {
        var patterns: [String] = []
        
        // Analyze timing variations
        if let maxDeviation = tapTimings.map({ abs($0 - calculateExpectedTime(for: tapTimings.firstIndex(of: $0) ?? 0)) }).max(),
           maxDeviation > (beatDuration * 0.3) {
            patterns.append("Tendency to deviate from the beat")
        }
        
        // Analyze consecutive accuracy
        let accuracyWindows = noteAccuracy.windows(ofCount: 3)
        let consecutivePoor = accuracyWindows.filter { window in
            window.allSatisfy { $0 == .poor }
        }.count
        
        if consecutivePoor > 0 {
            patterns.append("Difficulty maintaining rhythm in sequences")
        }
        
        return patterns
    }
    
    private func analyzeStrengths() -> [String] {
        var strengths: [String] = []
        
        // Analyze overall accuracy
        let overallAccuracy = calculateOverallAccuracy()
        if overallAccuracy > 0.8 {
            strengths.append("Strong overall rhythm accuracy")
        }
        
        // Analyze tempo consistency
        let tempoConsistency = calculateTempoConsistency()
        if tempoConsistency > 0.85 {
            strengths.append("Excellent tempo maintenance")
        }
        
        // Analyze perfect note sequences
        let perfectSequences = noteAccuracy.windows(ofCount: 3)
            .filter { window in window.allSatisfy { $0 == .perfect } }
            .count
        
        if perfectSequences > 0 {
            strengths.append("Strong consecutive note accuracy")
        }
        
        return strengths
    }
    
    private func analyzeWeaknesses() -> [String] {
        var weaknesses: [String] = []
        
        // Analyze overall accuracy
        let overallAccuracy = calculateOverallAccuracy()
        if overallAccuracy < 0.6 {
            weaknesses.append("Overall rhythm accuracy needs improvement")
        }
        
        // Analyze tempo consistency
        let tempoConsistency = calculateTempoConsistency()
        if tempoConsistency < 0.7 {
            weaknesses.append("Tempo maintenance needs work")
        }
        
        // Analyze poor note sequences
        let poorSequences = noteAccuracy.windows(ofCount: 3)
            .filter { window in window.allSatisfy { $0 == .poor } }
            .count
        
        if poorSequences > 0 {
            weaknesses.append("Difficulty with consecutive notes")
        }
        
        return weaknesses
    }
    
    private func generatePracticeExercises() -> [PracticeExercise] {
        var exercises: [PracticeExercise] = []
        
        // Base exercises on performance analysis
        if calculateTempoConsistency() < 0.8 {
            exercises.append(PracticeExercise(
                title: "Metronome Basics",
                description: "Practice with metronome at slower tempo",
                difficulty: "Beginner",
                estimatedTime: "15 mins"
            ))
        }
        
        if analyzeRhythmicPatterns().contains("Difficulty maintaining rhythm in sequences") {
            exercises.append(PracticeExercise(
                title: "Rhythm Sequences",
                description: "Practice difficult passages with subdivision",
                difficulty: "Intermediate",
                estimatedTime: "20 mins"
            ))
                    }
                    
                    if calculateOverallAccuracy() < 0.7 {
                        exercises.append(PracticeExercise(
                            title: "Pattern Recognition",
                            description: "Break down complex rhythms into smaller units",
                            difficulty: "Advanced",
                            estimatedTime: "30 mins"
                        ))
                    }
                    
                    return exercises
                }
                
                private func generateSuggestions() -> [String] {
                    var suggestions: [String] = []
                    
                    let overallAccuracy = calculateOverallAccuracy()
                    let tempoConsistency = calculateTempoConsistency()
                    
                    // Basic suggestions based on performance metrics
                    if overallAccuracy < 0.7 {
                        suggestions.append("Start practicing at a slower tempo (\(Int(currentBPM * 0.75)) BPM)")
                        suggestions.append("Use subdivision exercises to improve accuracy")
                    }
                    
                    if tempoConsistency < 0.8 {
                        suggestions.append("Practice with metronome at current tempo (\(Int(currentBPM)) BPM)")
                        suggestions.append("Focus on maintaining steady tempo throughout")
                    }
                    
                    // Add suggestions based on rhythmic patterns
                    let patterns = analyzeRhythmicPatterns()
                    if patterns.contains("Tendency to deviate from the beat") {
                        suggestions.append("Practice with metronome accent on downbeats")
                        suggestions.append("Record yourself and compare with reference tempo")
                    }
                    
                    if patterns.contains("Difficulty maintaining rhythm in sequences") {
                        suggestions.append("Break down complex passages into smaller segments")
                        suggestions.append("Practice difficult sections at 50% tempo first")
                    }
                    
                    // Add tempo-specific suggestions
                    if isCustomTempo {
                        if customBPM > 120 {
                            suggestions.append("Consider practicing at a moderate tempo first")
                        }
                    } else {
                        switch selectedTempo {
                        case .presto, .allegro:
                            suggestions.append("Master the rhythm at a slower tempo before increasing speed")
                        case .largo, .adagio:
                            suggestions.append("Focus on subdividing beats for better accuracy")
                        default:
                            break
                        }
                    }
                    
                    return suggestions
                }
            }

