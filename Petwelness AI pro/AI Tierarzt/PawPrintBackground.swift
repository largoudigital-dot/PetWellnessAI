//
//  PawPrintBackground.swift
//  AI Tierarzt
//
//  Created for Professional Background Design
//

import SwiftUI

// MARK: - Paw Print Background View
struct PawPrintBackground: View {
    @Environment(\.colorScheme) var colorScheme
    
    var opacity: Double = 0.048
    var size: CGFloat = 50
    var spacing: CGFloat = 80
    
    var body: some View {
        ZStack {
            // Base background color (adapts to color scheme)
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            // Paw print pattern
            GeometryReader { geometry in
                let rows = Int(geometry.size.height / spacing) + 2
                let cols = Int(geometry.size.width / spacing) + 2
                
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<cols, id: \.self) { col in
                        let x = CGFloat(col) * spacing - spacing / 2
                        let y = CGFloat(row) * spacing - spacing / 2
                        
                        // Offset every other row for better pattern
                        let offsetX = row % 2 == 0 ? 0 : spacing / 2
                        
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: size))
                            .foregroundColor(
                                colorScheme == .dark
                                    ? Color.white.opacity(opacity)
                                    : Color.black.opacity(opacity)
                            )
                            .position(
                                x: x + offsetX,
                                y: y
                            )
                            .rotationEffect(.degrees(Double.random(in: -15...15)))
                    }
                }
            }
        }
    }
}

// MARK: - Subtle Paw Print Overlay
struct SubtlePawPrintOverlay: View {
    @Environment(\.colorScheme) var colorScheme
    
    var opacity: Double = 0.03
    var size: CGFloat = 40
    
    var body: some View {
        ZStack {
            // Large paw prints in corners
            VStack {
                HStack {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: size * 2))
                        .foregroundColor(
                            colorScheme == .dark
                                ? Color.white.opacity(opacity)
                                : Color.black.opacity(opacity)
                        )
                        .offset(x: -20, y: -20)
                        .rotationEffect(.degrees(-25))
                    
                    Spacer()
                    
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: size * 1.5))
                        .foregroundColor(
                            colorScheme == .dark
                                ? Color.white.opacity(opacity)
                                : Color.black.opacity(opacity)
                        )
                        .offset(x: 20, y: -20)
                        .rotationEffect(.degrees(25))
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: size * 1.5))
                        .foregroundColor(
                            colorScheme == .dark
                                ? Color.white.opacity(opacity)
                                : Color.black.opacity(opacity)
                        )
                        .offset(x: -20, y: 20)
                        .rotationEffect(.degrees(25))
                    
                    Spacer()
                    
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: size * 2))
                        .foregroundColor(
                            colorScheme == .dark
                                ? Color.white.opacity(opacity)
                                : Color.black.opacity(opacity)
                        )
                        .offset(x: 20, y: 20)
                        .rotationEffect(.degrees(-25))
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Card Background with Paw Prints
struct PawPrintCardBackground: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Card background
            Color.backgroundSecondary
            
            // Subtle paw prints
            GeometryReader { geometry in
                let spacing: CGFloat = 120
                let rows = Int(geometry.size.height / spacing) + 1
                let cols = Int(geometry.size.width / spacing) + 1
                
                ForEach(0..<min(rows * cols, 6), id: \.self) { index in
                    let row = index / cols
                    let col = index % cols
                    let x = CGFloat(col) * spacing
                    let y = CGFloat(row) * spacing
                    
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 30))
                        .foregroundColor(
                            colorScheme == .dark
                                ? Color.white.opacity(0.024)
                                : Color.black.opacity(0.024)
                        )
                        .position(x: x, y: y)
                        .rotationEffect(.degrees(Double.random(in: -20...20)))
                }
            }
        }
    }
}

// MARK: - View Extension for Easy Use
extension View {
    /// Adds a professional paw print background
    func pawPrintBackground(opacity: Double = 0.048, size: CGFloat = 50, spacing: CGFloat = 80) -> some View {
        ZStack {
            PawPrintBackground(opacity: opacity, size: size, spacing: spacing)
            self
        }
    }
    
    /// Adds subtle paw print overlay in corners
    func subtlePawPrintOverlay(opacity: Double = 0.03, size: CGFloat = 40) -> some View {
        ZStack {
            self
            SubtlePawPrintOverlay(opacity: opacity, size: size)
        }
    }
    
    /// Adds paw print background to cards
    func pawPrintCardBackground() -> some View {
        ZStack {
            PawPrintCardBackground()
            self
        }
    }
}

