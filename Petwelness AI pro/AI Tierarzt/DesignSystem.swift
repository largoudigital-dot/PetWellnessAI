//
//  DesignSystem.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

// MARK: - Colors
extension Color {
    // Primary Brand Colors (Friendly Pet Theme: Emerald & Teal)
    static let brandPrimary = Color(red: 0.06, green: 0.63, blue: 0.51) // #10A381 (Emerald)
    static let brandPrimaryDark = Color(red: 0.04, green: 0.48, blue: 0.39)
    
    // Adaptive light background
    static var brandPrimaryLight: Color {
        Color(red: 0.06, green: 0.63, blue: 0.51).opacity(0.1)
    }
    
    // Gradient Colors (Emerald to Ocean)
    static let gradientStart = Color(red: 0.06, green: 0.63, blue: 0.51)
    static let gradientEnd = Color(red: 0.11, green: 0.55, blue: 0.72) // #1C8CB8
    
    // Accent Colors
    static let accentOrange = Color(red: 1.0, green: 0.65, blue: 0.0) // Medikamente
    static let accentBlue = Color(red: 0.0, green: 0.48, blue: 1.0) // Impfungen
    static let accentPurple = Color(red: 0.60, green: 0.40, blue: 0.90) // Konsultationen
    static let accentGreen = Color(red: 0.0, green: 0.78, blue: 0.33) // Ausgaben
    static let accentRed = Color(red: 1.0, green: 0.23, blue: 0.19) // Notfälle
    static let accentPink = Color(red: 1.0, green: 0.45, blue: 0.85) // Symptome
    static let accentYellow = Color(red: 1.0, green: 0.84, blue: 0.0) // Tipps/Hinweise
    
    // Background Colors
    static let backgroundPrimary = Color(.systemBackground)
    static let backgroundSecondary = Color(.secondarySystemBackground)
    static let backgroundTertiary = Color(.tertiarySystemBackground)
    
    // Text Colors - Automatically adapt to Dark Mode
    // These colors automatically change based on the system appearance
    // Light Mode: Black/Dark Gray
    // Dark Mode: White/Light Gray
    static let textPrimary = Color(.label)              // Main text color
    static let textSecondary = Color(.secondaryLabel)   // Secondary text color
    static let textTertiary = Color(.tertiaryLabel)     // Tertiary text color
    
    // White text that stays white (for colored backgrounds like gradients)
    // Use this for text on colored backgrounds that should always be white
    static let textOnColor = Color.white
    
    // Adaptive white text with opacity (for colored backgrounds)
    static func textOnColorOpacity(_ opacity: Double) -> Color {
        Color.white.opacity(opacity)
    }
    
    // Inverse text colors (for special cases)
    // These invert the normal text colors
    static var inverseTextPrimary: Color {
        Color(.systemBackground)
    }
    
    static var inverseTextSecondary: Color {
        Color(.secondarySystemBackground)
    }
}

// MARK: - Gradients
struct BrandGradient: View {
    var body: some View {
        LinearGradient(
            colors: [Color.gradientStart, Color.gradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// Helper for direct gradient usage as ShapeStyle
extension LinearGradient {
    static var brand: LinearGradient {
        LinearGradient(
            colors: [Color.gradientStart, Color.gradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// Extension to use BrandGradient as background
extension View {
    func brandGradientBackground() -> some View {
        self.background(LinearGradient.brand)
    }
}

// MARK: - Dark Mode Adaptive Text Modifiers
extension View {
    /// Automatically adapts text color to Dark Mode
    func adaptiveForegroundColor(_ color: Color) -> some View {
        self.foregroundColor(color)
    }
    
    /// Primary text color that adapts to Dark Mode
    func adaptiveTextPrimary() -> some View {
        self.foregroundColor(.textPrimary)
    }
    
    /// Secondary text color that adapts to Dark Mode
    func adaptiveTextSecondary() -> some View {
        self.foregroundColor(.textSecondary)
    }
    
    /// Tertiary text color that adapts to Dark Mode
    func adaptiveTextTertiary() -> some View {
        self.foregroundColor(.textTertiary)
    }
}

// MARK: - Typography
extension Font {
    static let appTitle = Font.system(size: 36, weight: .bold, design: .rounded)
    static let appSubtitle = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let sectionTitle = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let bodyText = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyTextBold = Font.system(size: 16, weight: .semibold, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let smallCaption = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Spacing
struct Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Corner Radius
struct CornerRadius {
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xlarge: CGFloat = 30
}

// MARK: - Shadow
struct AppShadow {
    static let small = Shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    static let medium = Shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    static let large = Shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Reusable Components

// Primary Button
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isDisabled: Bool
    
    init(_ title: String, icon: String? = nil, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background with Paw Pattern
                HStack {
                    Spacer()
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.15))
                        .offset(x: 20, y: 10)
                        .rotationEffect(.degrees(-15))
                }
                .clipped()
                
                HStack(spacing: Spacing.md) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .bold))
                    }
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                isDisabled 
                    ? LinearGradient(
                        colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    : LinearGradient(
                        colors: [
                            Color(red: 0.04, green: 0.48, blue: 0.39), // Dunkleres Emerald
                            Color(red: 0.08, green: 0.42, blue: 0.58)  // Dunkleres Ocean
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
            )
            .cornerRadius(CornerRadius.large)
            .shadow(color: isDisabled ? Color.clear : Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
        }
        .disabled(isDisabled)
        .buttonStyle(ScaleButtonStyle())
    }
}

// Secondary Button
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            .foregroundColor(.brandPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.brandPrimary.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .stroke(Color.brandPrimary.opacity(0.4), lineWidth: 2)
            )
            .cornerRadius(CornerRadius.large)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Card Component
struct AppCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(Spacing.xl)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.large)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

// Quick Action Button
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(CornerRadius.medium)
                    .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Pet Avatar
struct PetAvatar: View {
    let emoji: String
    let size: CGFloat
    
    init(emoji: String, size: CGFloat = 60) {
        self.emoji = emoji
        self.size = size
    }
    
    var body: some View {
        Text(emoji)
            .font(.system(size: size * 0.6))
            .frame(width: size, height: size)
            .background(
                LinearGradient(
                    colors: [Color.brandPrimaryLight, Color.brandPrimary.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(size / 2)
            .overlay(
                Circle()
                    .stroke(Color.brandPrimary.opacity(0.2), lineWidth: 2)
            )
    }
}

