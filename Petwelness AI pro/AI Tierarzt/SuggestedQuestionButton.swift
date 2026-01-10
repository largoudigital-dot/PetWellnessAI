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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: isIPad ? Spacing.lg : Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 20 : 18, weight: .semibold))
                    .foregroundColor(.brandPrimary)
                    .frame(width: isIPad ? 40 : 32, height: isIPad ? 40 : 32)
                    .background(
                        LinearGradient(
                            colors: [Color.brandPrimary.opacity(0.15), Color.brandPrimary.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(isIPad ? 10 : 8)
                
                Text(question)
                    .font(.system(size: isIPad ? 17 : 15, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: isIPad ? 22 : 20))
                    .foregroundColor(.brandPrimary.opacity(0.6))
            }
            .padding(isIPad ? Spacing.lg : Spacing.md)
            .background(Color.backgroundSecondary)
            .cornerRadius(isIPad ? CornerRadius.large : CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? CornerRadius.large : CornerRadius.medium)
                    .stroke(Color.brandPrimary.opacity(0.2), lineWidth: isIPad ? 1.5 : 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: isIPad ? 6 : 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
















