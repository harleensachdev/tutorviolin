//
//  RegisterView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 06/01/2025.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var workspaceVM = WorkspaceViewModel()
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @State private var showWorkspace = false
    @State private var showingARBowTracker = false
    @State private var showingRhythmTest = false
    @State private var selectedScore: Score?
    @State private var path = NavigationPath()
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text("Welcome to ViolinTutor")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Perfect your practice with AI-powered feedback")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 60)
            
            VStack(spacing: 16) {
                InputView(text: $email,
                        title: "Email",
                        placeholder: "name@example.com",
                        systemImage: "envelope")
                
                InputView(text: $username,
                        title: "Username",
                        placeholder: "Enter username",
                        systemImage: "person")
                
                InputView(text: $password,
                        title: "Password",
                        placeholder: "Enter your password",
                        systemImage: "lock",
                        isSecureField: true)
                
                InputView(text: $confirmPassword,
                        title: "Confirm Password",
                        placeholder: "Confirm your password",
                        systemImage: "lock",
                        isSecureField: true)
            }
            .padding(.horizontal)
            
            Button(action: { showWorkspace = true }) {
                HStack {
                    Text("Get Started")
                    Image(systemName: "chevron.right")
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 300, height: 48)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.top, 24)
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .font(.system(size: 14))
            }
            .padding(.top, 6)
            
            Spacer()
        }
        .navigationDestination(isPresented: $showWorkspace) {
            WorkspaceView(
                workspaceVM: workspaceVM,
                showingRhythmTest: $showingRhythmTest,
                selectedScore: $selectedScore,
                path: $path
            )            }
    }
        }
    

#Preview {
    RegistrationView()
}
