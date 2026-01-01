//
//  QuickActionCard.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct QuickActionCard: View {
    let icon: String
    let title: String
    let description: String
    let iconColor: Color
    let backgroundColor: Color
    var isEmergency: Bool = false
    let action: () -> Void
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var adaptiveBackgroundColor: Color {
        if colorScheme == .dark {
            // Dark Mode: Dunklere Versionen der Hintergrundfarben
            return backgroundColor.opacity(0.3)
        } else {
            return backgroundColor
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                // Icon oben
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 26 : 19, weight: .semibold))
                    .foregroundColor(iconColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, isIPad ? Spacing.md : Spacing.sm)
                
                // Text unten, linksbündig
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: isIPad ? 17 : 13, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(description)
                        .font(.system(size: isIPad ? 13 : 10))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: isIPad ? 131 : 78)
            .padding(isIPad ? Spacing.lg : Spacing.md)
            .background(adaptiveBackgroundColor)
            .cornerRadius(CornerRadius.large)
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(isEmergency ? Color.accentRed.opacity(colorScheme == .dark ? 0.5 : 0.3) : Color.clear, lineWidth: isIPad ? 3 : 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
}
