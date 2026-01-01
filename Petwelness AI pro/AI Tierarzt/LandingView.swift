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
    
    var body: some View {
        ZStack {
            // Background Gradient
            BrandGradient()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.sm) {
                        Spacer(minLength: 20)
                        
                        // Logo Section with floating paw prints
                        ZStack {
                            // Floating paw prints in background
                            ForEach(0..<4) { i in
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.1))
                                    .offset(x: CGFloat(i * 40 - 60), y: CGFloat(i * 30 - 45))
                                    .rotationEffect(.degrees(Double(i * 15)))
                            }
                            
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 200, height: 200)
                                .blur(radius: 20)
                            
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                                .scaleEffect(animateLogo ? 1.03 : 1.0)
                                .animation(Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: animateLogo)
                        }
                        .onAppear { animateLogo = true }
                        .padding(.top, -Spacing.md)
                        
                        // Welcome Text
                        VStack(spacing: Spacing.lg) {
                            Text("landing.welcome".localized)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                .padding(.horizontal, Spacing.xl)
                                .id(localizationManager.currentLanguage)
                            
                            Text("landing.welcomeDesc".localized)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Spacing.xl)
                                .lineSpacing(5)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                .id(localizationManager.currentLanguage)
                        }
                        
                        // Legal Section Card
                        VStack(spacing: Spacing.lg) {
                            // Medical Disclaimer Box
                            HStack(alignment: .top, spacing: Spacing.md) {
                                Image(systemName: "exclamationmark.shield.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.0)) // Dunkleres Gelb
                                
                                Text("disclaimer.medicalText".localized)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.95))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .id(localizationManager.currentLanguage)
                            }
                            .padding(Spacing.lg)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.medium)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            // Consent Checkboxes
                            VStack(alignment: .leading, spacing: Spacing.md) {
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
                            .padding(.top, Spacing.sm)
                        }
                        .padding(.horizontal, Spacing.xl)
                        
                        Spacer(minLength: 40)
                    }
                }
                
                // Bottom Button Section (Fixed at bottom)
                VStack {
                    PrimaryButton("landing.getStarted".localized, icon: "pawprint.fill", isDisabled: !acceptedTerms || !acceptedPrivacy) {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        // GDPR-Compliance: Speichere Zustimmungsdatum
                        UserDefaults.standard.set(Date(), forKey: "privacyConsentDate")
                        UserDefaults.standard.set(true, forKey: "hasAcceptedTerms")
                        UserDefaults.standard.set(true, forKey: "hasAcceptedPrivacy")
                        UserDefaults.standard.synchronize()
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            hasSeenOnboarding = true
                        }
                    }
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.lg)
                    .padding(.bottom, Spacing.xxl)
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
        HStack(spacing: Spacing.md) {
            Button(action: action) {
            ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isActive ? Color.white.opacity(0.25) : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white.opacity(isActive ? 1.0 : 0.7), lineWidth: 2.5)
                        )
                        .frame(width: 24, height: 24)
                    
                    if isActive {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            HStack(spacing: 4) {
                Text(textKey.localized)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.95))
                
                Button(action: linkAction) {
                    Text(linkKey.localized)
                        .font(.system(size: 15, weight: .bold))
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

