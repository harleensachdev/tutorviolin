//
//  RestViewModel.swift
//  tutorviolin
//
//  Created by caramelloveschicken on 12/01/2025.
//

import SwiftUI

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

