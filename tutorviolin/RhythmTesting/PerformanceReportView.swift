//
//  PerformanceReportView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 19/01/2025.
//

import SwiftUI


// Enhanced PerformanceReportView.swift
struct PerformanceReportView: View {
    let results: PerformanceResults
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Performance Overview
                Section(header: Text("Performance Overview").font(.title)) {
                    HStack {
                        PerformanceMetricView(
                            title: "Accuracy",
                            value: results.overallAccuracy,
                            icon: "target"
                        )
                        Spacer()
                        PerformanceMetricView(
                            title: "Tempo",
                            value: results.tempoConsistency,
                            icon: "metronome"
                        )
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Strengths and Weaknesses
                Section(header: Text("Analysis").font(.title2)) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Strengths").font(.headline)
                        ForEach(results.strengthAreas, id: \.self) { strength in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(strength)
                            }
                        }
                        
                        Text("Areas for Improvement").font(.headline)
                            .padding(.top)
                        ForEach(results.weaknessAreas, id: \.self) { weakness in
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.orange)
                                Text(weakness)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Practice Exercises
                Section(header: Text("Recommended Practice").font(.title2)) {
                    ForEach(results.practiceExercises, id: \.title) { exercise in
                        PracticeExerciseCard(exercise: exercise)
                    }
                }
                
                // Additional Resources
                Section(header: Text("Additional Resources").font(.title2)) {
                    VStack(alignment: .leading, spacing: 10) {
                        ResourceLink(
                            title: "Rhythm Training Videos",
                            description: "Watch video tutorials for rhythm training",
                            icon: "video.fill"
                        )
                        ResourceLink(
                            title: "Metronome Practice Guide",
                            description: "Learn effective metronome practice techniques",
                            icon: "metronome.fill"
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Performance Report")
        .navigationBarItems(trailing: Button("Done") { dismiss() })
    }
}

struct PerformanceMetricView: View {
    let title: String
    let value: Double
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.subheadline)
            Text("\(Int(value * 100))%")
                .font(.title)
                .foregroundColor(metricColor)
        }
    }
    
    private var metricColor: Color {
        switch value {
        case 0.8...1.0: return .green
        case 0.6..<0.8: return .yellow
        default: return .red
        }
    }
}

struct PracticeExerciseCard: View {
    let exercise: PracticeExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.title)
                .font(.headline)
            Text(exercise.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                Label(exercise.difficulty, systemImage: "star.fill")
                Spacer()
                Label(exercise.estimatedTime, systemImage: "clock.fill")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ResourceLink: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
