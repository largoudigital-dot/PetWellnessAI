//
//  TypingIndicator.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct TypingIndicator: View {
    @State private var animationPhase = 0
    @State private var timer: Timer?
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.textSecondary)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animationPhase == index ? 1.3 : 0.8)
                    .opacity(animationPhase == index ? 1.0 : 0.4)
                    .animation(.easeInOut(duration: 0.4), value: animationPhase)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary)
        .cornerRadius(24)
        .frame(maxWidth: 80, alignment: .leading)
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.4)) {
                    animationPhase = (animationPhase + 1) % 3
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

