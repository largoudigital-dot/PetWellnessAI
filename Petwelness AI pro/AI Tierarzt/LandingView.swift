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
    
    // Adaptive sizes for iPad
    private var logoSize: CGFloat { isIPad ? 280 : 160 }
    private var logoCircleSize: CGFloat { isIPad ? 360 : 200 }
    private var welcomeTitleSize: CGFloat { isIPad ? 64 : 36 }
    private var welcomeDescSize: CGFloat { isIPad ? 30 : 18 }
    private var disclaimerIconSize: CGFloat { isIPad ? 32 : 20 }
    private var disclaimerTextSize: CGFloat { isIPad ? 20 : 13 }
    private var checkboxSize: CGFloat { isIPad ? 36 : 24 }
    private var checkboxTextSize: CGFloat { isIPad ? 22 : 15 }
    private var buttonHeight: CGFloat { isIPad ? 90 : 60 }
    private var buttonTextSize: CGFloat { isIPad ? 28 : 18 }
    private var buttonIconSize: CGFloat { isIPad ? 30 : 18 }
    private var pawPrintSize: CGFloat { isIPad ? 60 : 40 }
    private var maxContentWidth: CGFloat { isIPad ? 800 : .infinity }
    
    var body: some View {
        ZStack {
            // Background Gradient
            BrandGradient()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isIPad ? Spacing.lg : Spacing.sm) {
                        Spacer(minLength: isIPad ? 60 : 20)
                        
                        // Logo Section with floating paw prints
                        ZStack {
                            // Floating paw prints in background
                            ForEach(0..<4) { i in
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: pawPrintSize))
                                    .foregroundColor(.white.opacity(0.1))
                                    .offset(x: CGFloat(i * (isIPad ? 60 : 40) - (isIPad ? 90 : 60)), y: CGFloat(i * (isIPad ? 45 : 30) - (isIPad ? 67 : 45)))
                                    .rotationEffect(.degrees(Double(i * 15)))
                            }
                            
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: logoCircleSize, height: logoCircleSize)
                                .blur(radius: isIPad ? 40 : 20)
                            
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: logoSize, height: logoSize)
                                .shadow(color: .black.opacity(0.3), radius: isIPad ? 40 : 20, x: 0, y: 10)
                                .scaleEffect(animateLogo ? 1.03 : 1.0)
                                .animation(Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: animateLogo)
                        }
                        .onAppear { animateLogo = true }
                        .padding(.top, isIPad ? -Spacing.lg : -Spacing.md)
                        .padding(.bottom, isIPad ? Spacing.xl : 0)
                        
                        // Welcome Text
                        VStack(spacing: isIPad ? Spacing.xxl : Spacing.lg) {
                            Text("landing.welcome".localized)
                                .font(.system(size: welcomeTitleSize, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black.opacity(0.3), radius: isIPad ? 8 : 4, x: 0, y: 2)
                                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                                .padding(.bottom, isIPad ? Spacing.md : 0)
                                .id(localizationManager.currentLanguage)
                            
                            Text("landing.welcomeDesc".localized)
                                .font(.system(size: welcomeDescSize, weight: .medium))
                                .foregroundColor(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                                .lineSpacing(isIPad ? 10 : 5)
                                .shadow(color: .black.opacity(0.2), radius: isIPad ? 4 : 2, x: 0, y: 1)
                                .id(localizationManager.currentLanguage)
                        }
                        .padding(.bottom, isIPad ? Spacing.xl : Spacing.md)
                        
                        // Legal Section Card
                        VStack(spacing: isIPad ? Spacing.xl : Spacing.lg) {
                            // Medical Disclaimer Box
                            HStack(alignment: .top, spacing: isIPad ? Spacing.xl : Spacing.md) {
                                Image(systemName: "exclamationmark.shield.fill")
                                    .font(.system(size: disclaimerIconSize))
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.0)) // Dunkleres Gelb
                                    .padding(.top, isIPad ? 4 : 2)
                                
                                Text("disclaimer.medicalText".localized)
                                    .font(.system(size: disclaimerTextSize, weight: .medium))
                                    .foregroundColor(.white.opacity(0.95))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .id(localizationManager.currentLanguage)
                            }
                            .padding(isIPad ? Spacing.xxl : Spacing.lg)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(isIPad ? CornerRadius.large : CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: isIPad ? CornerRadius.large : CornerRadius.medium)
                                    .stroke(Color.white.opacity(0.25), lineWidth: isIPad ? 2.5 : 1.5)
                            )
                            .shadow(color: .black.opacity(0.2), radius: isIPad ? 16 : 8, x: 0, y: 4)
                            
                            // Consent Checkboxes
                            VStack(alignment: .leading, spacing: isIPad ? Spacing.lg : Spacing.md) {
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
                            .padding(.top, isIPad ? Spacing.md : Spacing.sm)
                        }
                        .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                        .frame(maxWidth: maxContentWidth)
                        .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: isIPad ? 60 : 40)
                    }
                }
                
                // Bottom Button Section (Fixed at bottom)
                VStack {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        // GDPR-Compliance: Speichere Zustimmungsdatum
                        UserDefaults.standard.set(Date(), forKey: "privacyConsentDate")
                        UserDefaults.standard.set(true, forKey: "hasAcceptedTerms")
                        UserDefaults.standard.set(true, forKey: "hasAcceptedPrivacy")
                        UserDefaults.standard.synchronize()
                        
                        // Error Handling: Prüfe ob Speicherung erfolgreich war
                        guard UserDefaults.standard.bool(forKey: "hasAcceptedTerms") &&
                              UserDefaults.standard.bool(forKey: "hasAcceptedPrivacy") else {
                            // Fehler beim Speichern - zeige Fehler (sollte nicht passieren)
                            print("⚠️ Fehler beim Speichern der Zustimmung")
                            return
                        }
                        
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
                        .shadow(color: (!acceptedTerms || !acceptedPrivacy) ? Color.clear : Color.black.opacity(0.3), radius: isIPad ? 20 : 12, x: 0, y: 6)
                    }
                    .disabled(!acceptedTerms || !acceptedPrivacy)
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                    .padding(.top, isIPad ? Spacing.xxl : Spacing.lg)
                    .padding(.bottom, isIPad ? Spacing.xxxl : Spacing.xxl)
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

