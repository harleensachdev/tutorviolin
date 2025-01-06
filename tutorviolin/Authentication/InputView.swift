//
//  InputView.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 06/01/2025.
//
import SwiftUI
struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var systemImage: String? = nil
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(.gray)
                .fontWeight(.medium)
                .font(.footnote)
            
            HStack {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .foregroundColor(.gray)
                }
                
                if isSecureField {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .frame(height: 44)
            .padding(.horizontal)
            .cornerRadius(10)
        }
    }
}

#Preview {
    InputView(text:.constant(""), title: "Email address", placeholder: "name@example.com")}
