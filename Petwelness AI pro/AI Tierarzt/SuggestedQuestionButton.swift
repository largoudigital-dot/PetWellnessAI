//
//  SuggestedQuestionButton.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct SuggestedQuestionButton: View {
    let question: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.brandPrimary)
                    .frame(width: 32, height: 32)
                    .background(Color.brandPrimary.opacity(0.1))
                    .cornerRadius(8)
                
                Text(question)
                    .font(.system(size: 16))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.md)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
















