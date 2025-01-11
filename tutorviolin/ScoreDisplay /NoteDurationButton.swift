//
//  NoteDurationButton.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 07/01/2025.
//

import SwiftUI

struct NoteDurationSelector: View {
    @Binding var selectedDuration: NoteDuration
    let onSelect: (NoteDuration) -> Void
    
    private let columns = [
        GridItem(.adaptive(minimum: 50, maximum: 60), spacing: 6)  // Slightly smaller buttons
    ]
    
    private var groupedDurations: [(String, [NoteDuration])] {
        [
            ("Notes", [.whole, .half, .quarter, .eighth, .sixteenth]),
            ("Dotted Notes", [.wholeD, .halfD, .quarterD, .eighthD, .sixteenthD]),
            ("Rests", [.wholeRest, .halfRest, .quarterRest, .eighthRest])
        ]
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {  // Reduced spacing
                ForEach(groupedDurations, id: \.0) { group in
                    VStack(alignment: .leading, spacing: 6) {  // Reduced spacing
                        Text(group.0)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, spacing: 6) {  // Reduced spacing
                            ForEach(group.1, id: \.rawValue) { duration in
                                NoteDurationButton(
                                    duration: duration,
                                    isSelected: selectedDuration == duration,
                                    action: { onSelect(duration) }
                                )
                            }
                        }
                        .padding(.horizontal, 6)
                    }
                }
            }
            .padding(.vertical, 8)  // Reduced padding
        }
        .frame(height: 280)  // Fixed height to show all items
    }
}

struct NoteDurationButton: View {
    let duration: NoteDuration
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(buttonBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(buttonBorderColor, lineWidth: 1)
                    )
                
                ZStack {
                    Image.noteImage(for: duration)
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                    
                    // Add manual dot for dotted notes that don't have dotted images
                    if duration.rawValue.hasSuffix("D") &&
                        ([.eighthD, .sixteenthD].contains(duration)) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 3, height: 3)
                            .offset(x: 8, y: 0)
                    }
                }
            }
            .frame(width: 50, height: 50)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var buttonBackgroundColor: Color {
        isSelected ? Color.blue.opacity(0.15) : Color(.systemBackground)
    }
    
    private var buttonBorderColor: Color {
        isSelected ? Color.blue : Color.gray.opacity(0.3)
    }
}

extension Image {
    static func noteImage(for duration: NoteDuration) -> Image {
        switch duration {
        case .whole: return Image("whole_note")
        case .wholeD: return Image("whole_note_dotted")
        case .half: return Image("half_note")
        case .halfD: return Image("half_note_dotted")
        case .quarter: return Image("quarter_note")
        case .quarterD: return Image("quarter_note_dotted")
        case .eighth: return Image("flagup_eighth_note")
        case .eighthD: return Image("flagup_eighth_note_dotted") // Add dot in UI
        case .sixteenth: return Image("flagup_sixteenth_note")
        case .sixteenthD: return Image("flagup_sixteenth_note_dotted") // Add dot in UI
        case .wholeRest: return Image("whole_rest")
        case .halfRest: return Image("half_rest")
        case .quarterRest: return Image("quarter_rest")
        case .eighthRest: return Image("eighth_rest")
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Preview provider
struct NoteDurationSelector_Previews: PreviewProvider {
    static var previews: some View {
        NoteDurationSelector(
            selectedDuration: .constant(.quarter),
            onSelect: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
