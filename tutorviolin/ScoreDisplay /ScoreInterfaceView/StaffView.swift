//
//  StaffView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//
import SwiftUI
struct StaffView: View {
    @Binding var keySignature: KeySignature
    @Binding var clef: Clef
    @Binding var timeSignature: TimeSignature
    
    let notes: [MusicalNote]
    @State private var currentPage: Int = 0
    @State private var scrollPosition: CGFloat = 0
    
    // Refined measurements
    private let staffLineSpacing: CGFloat = 6.5
    private let noteHeadWidth: CGFloat = 7.5
    private let noteHeadHeight: CGFloat = 6
    private let stemWidth: CGFloat = 0.8
    private let stemHeight: CGFloat = 28
    private let horizontalSpacing: CGFloat = 50
    private let staffTopPosition: CGFloat = 20
    private let leftMargin: CGFloat = 100
    private let clefWidth: CGFloat = 40
    private let timeSignatureStartX: CGFloat = 20
    private let ledgerLineWidth: CGFloat = 12
    private let ledgerLineThickness: CGFloat = 0.5
    private let barLineWidth: CGFloat = 1
    private let notesPerPage: Int = 8
    private let pageWidth: CGFloat = UIScreen.main.bounds.width
    private let accidentalOffset: CGFloat = 12 // Offset for accidentals
    private func getAccidental(for pitch: String) -> String? {
        let noteName = String(pitch.prefix(1))
        let octave = String(pitch.suffix(1))
        
        // Handle key signature accidentals
        if keySignature.accidentalCount > 0 { // Sharps
            let affectedNotes = Set(KeySignature.sharpOrder.prefix(keySignature.accidentalCount))
            if affectedNotes.contains(noteName) {
                return "♯"
            }
        } else if keySignature.accidentalCount < 0 { // Flats
            let affectedNotes = Set(KeySignature.flatOrder.prefix(abs(keySignature.accidentalCount)))
            if affectedNotes.contains(noteName) {
                return "♭"
            }
        }
        
        // Handle natural signs if needed (when a note would normally be sharp/flat in the key)
        // This would require tracking previous accidentals in the same measure
        return nil
    }
    private func isNewMeasure(at index: Int) -> Bool {
        var currentBeatCount: Double = 0
        for i in 0...index {
            currentBeatCount += notes[i].duration.durationValue
            if currentBeatCount >= timeSignature.beatsPerMeasure {
                currentBeatCount = 0
                if i == index {
                    return true
                }
            }
        }
        return false
    }
    
    // Calculate visible width (width available for notes)
     private var visibleWidth: CGFloat {
         pageWidth - leftMargin
     }
     
     // Calculate total content width
     private var totalContentWidth: CGFloat {
         let notesWidth = CGFloat(notes.count) * horizontalSpacing
         return max(pageWidth, leftMargin + notesWidth + 100)
     }
     
     // Calculate number of pages
     private var totalPages: Int {
         let notesPerPageWidth = (visibleWidth / horizontalSpacing).rounded(.down)
         return max(1, Int(ceil(Double(notes.count) / Double(notesPerPageWidth))))
     }
     
     // Calculate the start and end indices for the current page
     private var currentPageIndices: (start: Int, end: Int) {
         let notesPerPageWidth = Int((visibleWidth / horizontalSpacing).rounded(.down))
         let start = currentPage * notesPerPageWidth
         let end = min(start + notesPerPageWidth, notes.count)
         return (start, end)
     }
     
     // Calculate scroll offset for current page
     private var pageScrollOffset: CGFloat {
         let notesPerPageWidth = (visibleWidth / horizontalSpacing).rounded(.down)
         return CGFloat(currentPage) * (notesPerPageWidth * horizontalSpacing)
     }

    
    // Calculate bar line positions
    private func getBarLinePositions() -> [CGFloat] {
        var positions: [CGFloat] = []
        var currentBeatCount: Double = 0
        var currentX = leftMargin
        
        for note in notes {
            currentBeatCount += note.duration.durationValue
            currentX += horizontalSpacing
            
            if currentBeatCount >= timeSignature.beatsPerMeasure {
                positions.append(currentX - horizontalSpacing/2)
                currentBeatCount = currentBeatCount.truncatingRemainder(dividingBy: timeSignature.beatsPerMeasure)
            }
        }
        
        return positions
    }
    
    private func getYPosition(for pitch: String) -> CGFloat {
        
        // More precise positioning using the refined staff line spacing
        let basePosition: CGFloat = 53 // Starting position of the bottom staff line
        
        let pitchMap: [String: CGFloat] = [
            // Below staff (G3 to B3)
            "G3": basePosition + (staffLineSpacing * 5),  // 2 ledger lines below
            "A3": basePosition + (staffLineSpacing * 4.5),    // Space between 2nd & 1st ledger line below
            "B3": basePosition + (staffLineSpacing * 4),  // First ledger line below
            
            // First octave (C4 to B4)
            "C4": basePosition + (staffLineSpacing * 3.5),    // Space below bottom line
            "D4": basePosition + (staffLineSpacing * 2.5),  // Bottom line
            "E4": basePosition + (staffLineSpacing * 2),    // First space
            "F4": basePosition + (staffLineSpacing * 1.5),  // Second line
            "G4": basePosition + staffLineSpacing,          // Second space
            "A4": basePosition + (staffLineSpacing * 0.5),  // Third line
            "B4": basePosition,                             // Third space
            
            // Second octave (C5 to B5)
            "C5": basePosition - (staffLineSpacing * 0.5),  // Fourth line
            "D5": basePosition - staffLineSpacing,          // Fourth space
            "E5": basePosition - (staffLineSpacing * 1.5),  // Fifth line
            "F5": basePosition - (staffLineSpacing * 2),    // Space above staff
            "G5": basePosition - (staffLineSpacing * 2.5),  // First ledger line above
            "A5": basePosition - (staffLineSpacing * 2.5),    // Space above first ledger line
            "B5": basePosition - (staffLineSpacing * 3),  // Second ledger line above
            
            // Third octave (C6 to B6)
            "C6": basePosition - (staffLineSpacing * 3.5),    // Space above second ledger line
            "D6": basePosition - (staffLineSpacing * 4),  // Third ledger line above
            "E6": basePosition - (staffLineSpacing * 4.5),    // Space above third ledger line
            "F6": basePosition - (staffLineSpacing * 5),  // Fourth ledger line above
            "G6": basePosition - (staffLineSpacing * 5.5),    // Space above fourth ledger line
            "A6": basePosition - (staffLineSpacing * 6),  // Fifth ledger line above
            "B6": basePosition - (staffLineSpacing * 6.5),    // Space above fifth ledger line
            
            // Highest notes (C7 to E7)
            "C7": basePosition - (staffLineSpacing * 7),  // Sixth ledger line above
            "D7": basePosition - (staffLineSpacing * 7.5),    // Space above sixth ledger line
            "E7": basePosition - (staffLineSpacing * 8)   // Seventh ledger line above
        ]
        
        return pitchMap[pitch] ?? basePosition
    }
    private func getLedgerLines(for pitch: String) -> [CGFloat] {
        let notePosition = getYPosition(for: pitch)
        var ledgerLines: [CGFloat] = []
        
        // For notes below the staff (G3, A3, B3)
        if notePosition > 53 + (staffLineSpacing * 2.5) {
            let lowestStaffLine = 53 + (staffLineSpacing * 2.5)
            var currentLine = lowestStaffLine + staffLineSpacing
            while currentLine <= notePosition + (staffLineSpacing * 0.5) {
                ledgerLines.append(currentLine)
                currentLine += staffLineSpacing
            }
        }
        
        // For notes above the staff (F5 and higher)
        if notePosition < 53 - (staffLineSpacing * 1.5) {
            let highestStaffLine = 53 - (staffLineSpacing * 1.5)
            var currentLine = highestStaffLine - staffLineSpacing
            while currentLine >= notePosition - (staffLineSpacing * 0.5) {
                ledgerLines.append(currentLine)
                currentLine -= staffLineSpacing
            }
        }
        
        return ledgerLines
    }
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: true) {
                    GeometryReader { geometry in
                        ZStack {
                            // Staff lines (keep existing code)
                            ForEach(0..<5) { line in
                                Path { path in
                                    let y = CGFloat(line) * staffLineSpacing + 40
                                    path.move(to: CGPoint(x: 0, y: y))
                                    path.addLine(to: CGPoint(x: totalContentWidth, y: y))
                                }
                                .stroke(Color.black, lineWidth: ledgerLineThickness)
                            }
                            
                            // Key signature and time signature (keep existing code)
                            HStack(spacing: 0) {
                                KeySignatureView(keySignature: keySignature, clef: clef)
                                    .frame(width: 50)
                                    .offset(y: staffTopPosition - staffLineSpacing * 0.5)
                                TimeSignatureView(timeSignature: timeSignature)
                                    .offset(x: 25, y: staffTopPosition - staffLineSpacing * 0.5)
                                Spacer()
                            }
                            
                            // Bar lines (keep existing code)
                            ForEach(getBarLinePositions(), id: \.self) { x in
                                Path { path in
                                    path.move(to: CGPoint(x: x, y: 40))
                                    path.addLine(to: CGPoint(x: x, y: 40 + staffLineSpacing * 4))
                                }
                                .stroke(Color.black, lineWidth: barLineWidth)
                            }
                            
                            // Notes with ledger lines
                            ForEach(Array(notes.enumerated()), id: \.element.id) { index, note in
                                                            let noteX = leftMargin + CGFloat(index) * horizontalSpacing
                                                            let noteY = getYPosition(for: note.pitch)
                                                            
                                                            Group {
                                                                // Draw accidental if needed
                                                                if let accidental = getAccidental(for: note.pitch) {
                                                                    Text(accidental)
                                                                        .font(.system(size: staffLineSpacing * 3))
                                                                        .position(x: noteX - accidentalOffset, y: noteY)
                                                                }
                                                                
                                                                // Ledger lines
                                                                if !note.duration.isRest {
                                                                    ForEach(getLedgerLines(for: note.pitch), id: \.self) { lineY in
                                                                        Path { path in
                                                                            path.move(to: CGPoint(x: noteX - ledgerLineWidth/2, y: lineY))
                                                                            path.addLine(to: CGPoint(x: noteX + ledgerLineWidth/2, y: lineY))
                                                                        }
                                                                        .stroke(Color.black, lineWidth: 0.5)
                                                                    }
                                                                }
                                                                
                                                                // Note view
                                                                RefinedNoteView(
                                                                    note: note,
                                                                    headWidth: noteHeadWidth,
                                                                    headHeight: noteHeadHeight,
                                                                    stemWidth: stemWidth,
                                                                    stemHeight: stemHeight,
                                                                    shouldStemUp: noteY > 40
                                                                )
                                                                .position(x: noteX, y: noteY)
                                                                .id("note\(index)")
                                                            }
                                                        }
                                                    }
                                                }
                                                .frame(height: 80)
                                                .frame(width: max(UIScreen.main.bounds.width, CGFloat(notes.count) * horizontalSpacing + leftMargin + 100))
                                            }
                                            .onChange(of: notes.count) { state, newCount in
                                                if newCount > 0 {
                                                    withAnimation {
                                                        proxy.scrollTo("note\(newCount - 1)", anchor: .trailing)
                                                    }
                                                }
                                            }
                                            .onChange(of: currentPage) { state, newPage in
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    let noteIndex = min(newPage * Int(visibleWidth / horizontalSpacing), notes.count - 1)
                                                    if noteIndex >= 0 {
                                                        proxy.scrollTo("note\(noteIndex)", anchor: .leading)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        // Navigation controls (keep existing navigation controls code)
                                        HStack {
                                            Button(action: {
                                                withAnimation {
                                                    currentPage = max(0, currentPage - 1)
                                                }
                                            }) {
                                                Image(systemName: "arrow.left.circle.fill")
                                                    .font(.title)
                                                    .foregroundColor(currentPage > 0 ? .blue : .gray)
                                            }
                                            .disabled(currentPage == 0)
                                            
                                            Spacer()
                                            
                                            Text("\(currentPage + 1) / \(totalPages)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                withAnimation {
                                                    currentPage = min(totalPages - 1, currentPage + 1)
                                                }
                                            }) {
                                                Image(systemName: "arrow.right.circle.fill")
                                                    .font(.title)
                                                    .foregroundColor(currentPage < totalPages - 1 ? .blue : .gray)
                                            }
                                            .disabled(currentPage >= totalPages - 1)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
    struct RefinedNoteView: View {
        let note: MusicalNote
        let headWidth: CGFloat
        let headHeight: CGFloat
        let stemWidth: CGFloat
        let stemHeight: CGFloat
        let shouldStemUp: Bool
        
        var body: some View {
            ZStack {
                if note.duration.isRest {
                    RestView(duration: note.duration)
                } else {
                    ZStack {
                        // Note head
                        Ellipse()
                            .fill(note.duration == .whole || note.duration == .half ||
                                  note.duration == .wholeD || note.duration == .halfD ?
                                  Color.white : Color.black)
                            .frame(width: headWidth, height: headHeight)
                            .rotationEffect(.degrees(-20))
                            .overlay(
                                Ellipse()
                                    .stroke(Color.black, lineWidth: 0.5)
                            )
                        
                        // Stem and flags
                        if ![.whole, .wholeD].contains(note.duration) {
                            // Stem
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: stemWidth, height: stemHeight+5)
                                .offset(
                                    x: shouldStemUp ? headWidth * 0.5 : -headWidth * 0.4,
                                    y: shouldStemUp ? -stemHeight * 0.5 : stemHeight * 0.5
                                )
                            
                            // Eighth and Sixteenth note flags using images
                            if [.eighth, .eighthD, .sixteenth, .sixteenthD].contains(note.duration) {
                                NoteFlag(
                                    duration: note.duration,
                                    shouldStemUp: shouldStemUp,
                                    stemWidth: stemWidth,
                                    stemHeight: stemHeight
                                )
                                .frame(width: 10, height: shouldStemUp ? 8 : 12)
                                .offset(
                                    x: shouldStemUp ? headWidth * 1 : -headWidth * 0.1,
                                    y: shouldStemUp ? -stemHeight + 5 : stemHeight - 5
                                )
                            }
                            
                            // Dot for dotted notes
                            if note.duration.rawValue.hasSuffix(".") {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 3, height: 3)
                                    .offset(x: headWidth * 1.2, y: 0)
                            }
                        }
                    }
                }
            }
        }
    }


// Extension to help with note type checking
extension NoteDuration {
    var isSixteenth: Bool {
        self == .sixteenth || self == .sixteenthD
    }
}

struct RestView: View {
    let duration: NoteDuration
    
    var body: some View {
        GeometryReader { geometry in
            switch duration {
            case .wholeRest:
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 10, height: 3)
                    .offset(y: 8)
            case .halfRest:
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 10, height: 3)
                    .offset(y: 12)
            case .quarterRest:
                Image("quarter_rest")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .offset(y: 9)
            case .eighthRest:
                Image("eighth_rest")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .offset(y: 9)

            default:
                EmptyView()
            }
        }
        .frame(width: 15, height: 30)  // Smaller frame for rests
    }
}

#Preview {
    // Create sample data
    let sampleNotes: [MusicalNote] = [
        MusicalNote(pitch: "E7", duration: .quarter, position: 0),
        MusicalNote(pitch: "B4", duration: .quarter, position: 1),
        MusicalNote(pitch: "B5", duration: .eighth, position: 2)
    ]
    
    return VStack(spacing: 20) {
        // Preview with C Major (no accidentals)
        StaffView(
            keySignature: .constant(KeySignature(tonic: "C", mode: .major, accidentalCount: 7)),
            clef: .constant(.treble),
            timeSignature: .constant(.common),
            notes: sampleNotes
        )
        
        // Preview with G Major (1 sharp)
        StaffView(
            keySignature: .constant(KeySignature(tonic: "G", mode: .major, accidentalCount: 1)),
            clef: .constant(.treble),
            timeSignature: .constant(.common),
            notes: sampleNotes
        )
        
        // Preview with D Major (2 sharps)
        StaffView(
            keySignature: .constant(KeySignature(tonic: "D", mode: .major, accidentalCount: 2)),
            clef: .constant(.treble),
            timeSignature: .constant(.common),
            notes: sampleNotes
        )
        
        // Preview with F Major (1 flat)
        StaffView(
            keySignature: .constant(KeySignature(tonic: "D", mode: .major, accidentalCount: -5)),
            clef: .constant(.treble),
            timeSignature: .constant(.common),
            notes: sampleNotes
        )
        
        // Preview with B♭ Major (2 flats)
        StaffView(
            keySignature: .constant(KeySignature(tonic: "B♭", mode: .major, accidentalCount: -7)),
            clef: .constant(.treble),
            timeSignature: .constant(.common),
            notes: sampleNotes
        )
    }
    .padding()
    .frame(height: 500)  // Adjust this to see more or fewer staves
}
