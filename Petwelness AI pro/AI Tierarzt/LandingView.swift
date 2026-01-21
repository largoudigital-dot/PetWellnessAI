//
//  LandingView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct LandingView: View {
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var acceptedTerms = false
    @State private var acceptedPrivacy = false
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var animateLogo = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    // Screen height detection for responsive layout
    private var availableHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    private var isSmallScreen: Bool { availableHeight < 700 }
    private var isMediumScreen: Bool { availableHeight >= 700 && availableHeight < 900 }
    private var isLargeScreen: Bool { availableHeight >= 900 && availableHeight < 1200 }
    
    // Dynamic spacing based on screen height
    private var dynamicSpacing: CGFloat {
        if isIPad { return 32 }
        switch availableHeight {
        case ..<700: return 8  // iPhone SE
        case 700..<900: return 12  // iPhone 14/15
        case 900..<1200: return 16  // iPhone Pro Max
        default: return 24
        }
    }
    
    // Responsive sizes using screen height percentages
    private var logoSize: CGFloat {
        if isIPad { return availableHeight * 0.20 }
        return availableHeight * 0.15
    }
    
    private var logoCircleSize: CGFloat {
        logoSize * 1.25
    }
    
    private var welcomeTitleSize: CGFloat {
        if isIPad { return availableHeight * 0.047 }
        return min(36, max(24, availableHeight * 0.036))
    }
    
    private var welcomeDescSize: CGFloat {
        if isIPad { return availableHeight * 0.022 }
        return min(18, max(14, availableHeight * 0.020))
    }
    
    // Compact warning box sizing (0.7-0.85rem equivalent)
    private var disclaimerIconSize: CGFloat {
        if isIPad { return 28 }
        return min(18, max(14, availableHeight * 0.020))
    }
    
    private var disclaimerTextSize: CGFloat {
        if isIPad { return 18 }
        return min(13.6, max(11, availableHeight * 0.016))
    }
    
    private var disclaimerPadding: CGFloat {
        if isIPad { return 20 }
        return min(16, max(8, availableHeight * 0.018))
    }
    
    private var checkboxSize: CGFloat {
        if isIPad { return 36 }
        return min(24, max(20, availableHeight * 0.028))
    }
    
    private var checkboxTextSize: CGFloat {
        if isIPad { return 22 }
        return min(15, max(13, availableHeight * 0.018))
    }
    
    private var buttonHeight: CGFloat {
        if isIPad { return 90 }
        return min(60, max(50, availableHeight * 0.070))
    }
    
    private var buttonTextSize: CGFloat {
        if isIPad { return 28 }
        return min(18, max(16, availableHeight * 0.021))
    }
    
    private var buttonIconSize: CGFloat {
        if isIPad { return 30 }
        return min(18, max(16, availableHeight * 0.021))
    }
    
    private var pawPrintSize: CGFloat {
        if isIPad { return 60 }
        return 40
    }
    
    private var maxContentWidth: CGFloat { isIPad ? 800 : .infinity }
    
    var body: some View {
        ZStack {
            // Background Gradient
            BrandGradient()
                .ignoresSafeArea()
            
            // Fixed-height container - NO SCROLLING
            VStack(spacing: 0) {
                Spacer(minLength: dynamicSpacing * 0.5)
                
                // Logo Section with conditional decorative elements
                ZStack {
                    // Floating paw prints - hidden on small screens
                    if !isSmallScreen {
                        ForEach(0..<4) { i in
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: pawPrintSize))
                                .foregroundColor(.white.opacity(0.1))
                                .offset(
                                    x: CGFloat(i * (isIPad ? 60 : 40) - (isIPad ? 90 : 60)),
                                    y: CGFloat(i * (isIPad ? 45 : 30) - (isIPad ? 67 : 45))
                                )
                                .rotationEffect(.degrees(Double(i * 15)))
                        }
                    }
                    
                    // Reduced glow on small screens
                    Circle()
                        .fill(Color.white.opacity(isSmallScreen ? 0.05 : 0.1))
                        .frame(width: logoCircleSize, height: logoCircleSize)
                        .blur(radius: isSmallScreen ? 10 : (isIPad ? 40 : 20))
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: logoSize, height: logoSize)
                        .shadow(
                            color: .black.opacity(isSmallScreen ? 0.2 : 0.3),
                            radius: isSmallScreen ? 10 : (isIPad ? 40 : 20),
                            x: 0,
                            y: isSmallScreen ? 5 : 10
                        )
                        .scaleEffect(animateLogo ? 1.03 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                            value: animateLogo
                        )
                }
                .onAppear { animateLogo = true }
                
                Spacer(minLength: dynamicSpacing * 0.8)
                
                // Welcome Text - Compact
                VStack(spacing: dynamicSpacing * 0.5) {
                    Text("landing.welcome".localized)
                        .font(.system(size: welcomeTitleSize, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .shadow(
                            color: .black.opacity(0.3),
                            radius: isSmallScreen ? 2 : 4,
                            x: 0,
                            y: 2
                        )
                        .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                        .id(localizationManager.currentLanguage)
                    
                    Text("landing.welcomeDesc".localized)
                        .font(.system(size: welcomeDescSize, weight: .medium))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                        .lineSpacing(isSmallScreen ? 2 : 5)
                        .shadow(
                            color: .black.opacity(0.2),
                            radius: isSmallScreen ? 1 : 2,
                            x: 0,
                            y: 1
                        )
                        .id(localizationManager.currentLanguage)
                }
                
                Spacer(minLength: dynamicSpacing)
                
                // Legal Section - Compact
                VStack(spacing: dynamicSpacing) {
                    // Compact Medical Disclaimer Box
                    HStack(alignment: .top, spacing: dynamicSpacing * 0.8) {
                        Image(systemName: "exclamationmark.shield.fill")
                            .font(.system(size: disclaimerIconSize))
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.0))
                            .padding(.top, 2)
                        
                        Text("disclaimer.medicalText".localized)
                            .font(.system(size: disclaimerTextSize, weight: .medium))
                            .foregroundColor(.white.opacity(0.95))
                            .multilineTextAlignment(.leading)
                            .lineLimit(isSmallScreen ? 6 : nil)
                            .minimumScaleFactor(0.9)
                            .lineSpacing(isSmallScreen ? 1 : 2)
                            .fixedSize(horizontal: false, vertical: true)
                            .id(localizationManager.currentLanguage)
                    }
                    .padding(disclaimerPadding)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(isIPad ? CornerRadius.large : CornerRadius.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: isIPad ? CornerRadius.large : CornerRadius.medium)
                            .stroke(Color.white.opacity(0.25), lineWidth: isIPad ? 2.5 : 1.5)
                    )
                    .shadow(
                        color: .black.opacity(0.2),
                        radius: isSmallScreen ? 4 : 8,
                        x: 0,
                        y: 4
                    )
                    
                    // Compact Consent Checkboxes
                    VStack(alignment: .leading, spacing: dynamicSpacing * 0.8) {
                        consentRow(
                            isActive: acceptedTerms,
                            textKey: "landing.acceptTerms",
                            linkKey: "landing.terms",
                            action: { acceptedTerms.toggle() },
                            linkAction: { showTerms = true }
                        )
                        
                        consentRow(
                            isActive: acceptedPrivacy,
                            textKey: "landing.acceptPrivacy",
                            linkKey: "landing.privacyPolicy",
                            action: { acceptedPrivacy.toggle() },
                            linkAction: { showPrivacy = true }
                        )
                    }
                }
                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                .frame(maxWidth: maxContentWidth)
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: dynamicSpacing)
                
                // Bottom Button Section (Fixed at bottom)
                VStack {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        // GDPR-Compliance: Speichere Zustimmungsdatum
                        UserDefaults.standard.set(Date(), forKey: "privacyConsentDate")
                        UserDefaults.standard.set(true, forKey: "hasAcceptedTerms")
                        UserDefaults.standard.set(true, forKey: "hasAcceptedPrivacy")
                        UserDefaults.standard.synchronize()
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            hasSeenOnboarding = true
                        }
                    }) {
                        HStack(spacing: isIPad ? Spacing.lg : Spacing.md) {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: buttonIconSize, weight: .bold))
                            Text("landing.getStarted".localized)
                                .font(.system(size: buttonTextSize, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonHeight)
                        .background(
                            (!acceptedTerms || !acceptedPrivacy)
                                ? LinearGradient(
                                    colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [
                                        Color(red: 0.04, green: 0.48, blue: 0.39),
                                        Color(red: 0.08, green: 0.42, blue: 0.58)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .cornerRadius(isIPad ? CornerRadius.xlarge : CornerRadius.large)
                        .shadow(
                            color: (!acceptedTerms || !acceptedPrivacy) ? Color.clear : Color.black.opacity(0.3),
                            radius: isIPad ? 20 : 12,
                            x: 0,
                            y: 6
                        )
                    }
                    .disabled(!acceptedTerms || !acceptedPrivacy)
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                    .padding(.top, dynamicSpacing)
                    .padding(.bottom, isIPad ? Spacing.xxxl : Spacing.xl)
                    .frame(maxWidth: maxContentWidth)
                    .frame(maxWidth: .infinity)
                }
                .background(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.35)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
            }
            .frame(maxHeight: .infinity)
        }
        .sheet(isPresented: $showTerms) {
            TermsOfServiceView()
                .environmentObject(localizationManager)
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyPolicyView()
                .environmentObject(localizationManager)
        }
    }
    
    // Custom Consent Row helper
    private func consentRow(isActive: Bool, textKey: String, linkKey: String, action: @escaping () -> Void, linkAction: @escaping () -> Void) -> some View {
        HStack(spacing: isIPad ? Spacing.xl : Spacing.md) {
            Button(action: action) {
            ZStack {
                    RoundedRectangle(cornerRadius: isIPad ? 10 : 6)
                        .fill(isActive ? Color.white.opacity(0.25) : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: isIPad ? 10 : 6)
                                .stroke(Color.white.opacity(isActive ? 1.0 : 0.7), lineWidth: isIPad ? 3.5 : 2.5)
                        )
                        .frame(width: checkboxSize, height: checkboxSize)
                    
                    if isActive {
                        Image(systemName: "checkmark")
                            .font(.system(size: isIPad ? 24 : 14, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            HStack(spacing: isIPad ? 8 : 4) {
                Text(textKey.localized)
                    .font(.system(size: checkboxTextSize, weight: .medium))
                    .foregroundColor(.white.opacity(0.95))
                
                Button(action: linkAction) {
                    Text(linkKey.localized)
                        .font(.system(size: checkboxTextSize, weight: .bold))
                        .foregroundColor(.white)
                        .underline()
                }
            }
            .id(localizationManager.currentLanguage)
            
            Spacer()
        }
    }
}

#Preview {
    LandingView(hasSeenOnboarding: .constant(false))
}

