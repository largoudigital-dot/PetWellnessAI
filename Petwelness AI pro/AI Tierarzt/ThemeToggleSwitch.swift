//
//  ThemeToggleSwitch.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

// MARK: - Theme Toggle Switch
struct ThemeToggleSwitch: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let knobSize = height - 6
            let knobOffset = isDarkMode ? width - knobSize - 3 : 3
            
            ZStack(alignment: .leading) {
                // Background - ändert Farbe je nach Modus
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(isDarkMode ? Color(white: 0.25) : Color.white)
                    .frame(width: width, height: height)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                // Icons im Hintergrund (dezent, wenn nicht aktiv)
                HStack(spacing: 0) {
                    // Sun Icon (links)
                    Image(systemName: "sun.max")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(isDarkMode ? Color(white: 0.4) : Color.clear)
                        .frame(width: (width - knobSize) / 2)
                    
                    Spacer()
                        .frame(width: knobSize)
                    
                    // Moon Icon (rechts)
                    Image(systemName: "moon")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(isDarkMode ? Color.clear : Color(white: 0.4))
                        .frame(width: (width - knobSize) / 2)
                }
                
                // Knob mit aktivem Icon
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: knobSize, height: knobSize)
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                    
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                .offset(x: knobOffset)
            }
        }
        .frame(width: 64, height: 34)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isDarkMode.toggle()
            }
        }
    }
}
















