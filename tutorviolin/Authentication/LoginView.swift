//
//  LoginView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 06/01/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showWorkspace = false
    
    var body: some View {
        NavigationStack {
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
                    InputView(text: $password,
                            title: "Password",
                            placeholder: "Enter your password",
                            systemImage: "lock",
                            isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
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
                
                NavigationLink {
                    RegistrationView()
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
                WorkspaceView()
            }
        }
    }
}
