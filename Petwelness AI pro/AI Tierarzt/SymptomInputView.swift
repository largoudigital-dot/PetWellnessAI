//
//  SymptomInputView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct SymptomInputView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var appState: AppState
    @StateObject private var adManager = AdManager.shared
    @State private var selectedSymptoms: Set<String> = []
    @State private var additionalNotes = ""
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    // Adaptive sizes for iPad
    private var titleSize: CGFloat { isIPad ? 24 : 16 }
    private var sectionTitleSize: CGFloat { isIPad ? 22 : 16 }
    private var maxContentWidth: CGFloat { isIPad ? 1000 : .infinity }
    
    var commonSymptoms: [SymptomData] {
        [
            SymptomData(icon: "thermometer", iconColor: .accentRed, name: "symptoms.fever", category: "symptoms.category.general"),
            SymptomData(icon: "face.dashed.fill", iconColor: .accentGreen, name: "symptoms.vomiting", category: "symptoms.category.digestion"),
            SymptomData(icon: "zzz", iconColor: .accentBlue, name: "symptoms.fatigue", category: "symptoms.category.general"),
            SymptomData(icon: "figure.walk", iconColor: .white, name: "symptoms.lameness", category: "symptoms.category.movement"),
            SymptomData(icon: "eye.fill", iconColor: .brown, name: "symptoms.eyeProblems", category: "symptoms.category.eyes"),
            SymptomData(icon: "fork.knife", iconColor: .white, name: "symptoms.lossOfAppetite", category: "symptoms.category.digestion")
        ]
    }
    
    private func navigateToChat() {
        // Speichere Symptome und Notizen in AppState
        appState.setChatData(
            symptoms: Array(selectedSymptoms),
            notes: additionalNotes,
            photo: nil
        )
        dismiss() // Schließe SymptomInputView
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                appState.selectedTab = 4 // Navigiere zu Chat Tab (Tab 4)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: isIPad ? 24 : 18))
                            .foregroundColor(.brandPrimary)
                    }
                    .frame(width: isIPad ? 44 : 32, height: isIPad ? 44 : 32)
                    
                    Spacer()
                    
                    Text("symptomInput.title".localized)
                        .id(localizationManager.currentLanguage)
                        .font(.system(size: titleSize, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .font(.system(size: isIPad ? 24 : 18))
                            .foregroundColor(.clear)
                    }
                    .frame(width: isIPad ? 44 : 32, height: isIPad ? 44 : 32)
                }
                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                .padding(.vertical, isIPad ? Spacing.lg : Spacing.md)
                .background(Color.backgroundPrimary)
                
                ScrollView {
                    VStack(spacing: isIPad ? Spacing.xxl : Spacing.xl) {
                        // Symptom Grid
                        VStack(alignment: .leading, spacing: isIPad ? Spacing.xl : Spacing.lg) {
                            Text("symptomInput.commonSymptoms".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.system(size: sectionTitleSize, weight: .semibold))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: isIPad ? Spacing.lg : Spacing.md),
                                GridItem(.flexible(), spacing: isIPad ? Spacing.lg : Spacing.md)
                            ], spacing: isIPad ? Spacing.lg : Spacing.md) {
                                ForEach(commonSymptoms) { symptom in
                                    SymptomSelectionCard(
                                        symptom: symptom,
                                        isSelected: selectedSymptoms.contains(symptom.name),
                                        localizationManager: localizationManager,
                                        isIPad: isIPad
                                    ) {
                                        if selectedSymptoms.contains(symptom.name) {
                                            selectedSymptoms.remove(symptom.name)
                                        } else {
                                            selectedSymptoms.insert(symptom.name)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                        }
                        .padding(.top, isIPad ? Spacing.xl : Spacing.lg)
                        
                        // Banner Ad unter "Symptômes courants" Grid vor "Description supplémentaire"
                        if AdManager.shared.shouldShowBannerAds {
                            BannerAdView()
                                .frame(height: 50)
                                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                                .padding(.vertical, isIPad ? Spacing.md : Spacing.sm)
                        }
                        
                        // Additional Notes
                        VStack(alignment: .leading, spacing: isIPad ? Spacing.lg : Spacing.md) {
                            Text("symptomInput.additionalDescription".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.system(size: sectionTitleSize, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                            
                            TextEditor(text: $additionalNotes)
                                .frame(minHeight: isIPad ? 180 : 120)
                                .font(.system(size: isIPad ? 20 : 16))
                                .padding(isIPad ? Spacing.lg : Spacing.md)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(isIPad ? CornerRadius.large : CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: isIPad ? CornerRadius.large : CornerRadius.medium)
                                        .stroke(Color.textTertiary.opacity(0.3), lineWidth: isIPad ? 1.5 : 1)
                                )
                                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                        }
                        
                        // Submit Button
                        Button(action: {
                            // WICHTIG: Erst Aktion ausführen (Navigation), dann Ad zeigen
                            // Navigiere zuerst zum Chat
                            navigateToChat()
                            
                            // Zeige Interstitial Ad NACH der Aktion (wenn Bedingungen erfüllt)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                adManager.showInterstitialAfterAction()
                            }
                        }) {
                            HStack(spacing: isIPad ? Spacing.lg : Spacing.md) {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: isIPad ? 26 : 18, weight: .bold))
                                Text("symptomInput.startAnalysis".localized)
                                    .font(.system(size: isIPad ? 24 : 18, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: isIPad ? 80 : 60)
                            .background(
                                (selectedSymptoms.isEmpty && additionalNotes.isEmpty)
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
                            .shadow(color: (selectedSymptoms.isEmpty && additionalNotes.isEmpty) ? Color.clear : Color.black.opacity(0.3), radius: isIPad ? 16 : 12, x: 0, y: 6)
                        }
                        .disabled(selectedSymptoms.isEmpty && additionalNotes.isEmpty)
                        .buttonStyle(ScaleButtonStyle())
                        .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                        .padding(.bottom, isIPad ? Spacing.xxl : Spacing.xl)
                        .id(localizationManager.currentLanguage)
                    }
                    .frame(maxWidth: maxContentWidth)
                    .frame(maxWidth: .infinity)
                }
            }
            .onAppear {
                // Lade Interstitial Ad beim Erscheinen
                adManager.loadInterstitialAd()
            }
        }
    }
}

struct SymptomData: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let name: String
    let category: String
}

struct SymptomSelectionCard: View {
    let symptom: SymptomData
    let isSelected: Bool
    let localizationManager: LocalizationManager
    let isIPad: Bool
    let action: () -> Void
    
    // Adaptive sizes for iPad
    private var iconSize: CGFloat { isIPad ? 36 : 24 }
    private var iconHeight: CGFloat { isIPad ? 48 : 32 }
    private var titleSize: CGFloat { isIPad ? 20 : 16 }
    private var categorySize: CGFloat { isIPad ? 16 : 12 }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: isIPad ? Spacing.md : Spacing.sm) {
                Image(systemName: symptom.icon)
                    .font(.system(size: iconSize))
                    .foregroundColor(symptom.iconColor)
                    .frame(height: iconHeight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(symptom.name.localized)
                    .id(localizationManager.currentLanguage)
                    .font(.system(size: titleSize, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Text(symptom.category.localized)
                    .id(localizationManager.currentLanguage)
                    .font(.system(size: categorySize))
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(isIPad ? Spacing.xl : Spacing.lg)
            .background(
                isSelected ?
                Color.brandPrimary.opacity(0.1) :
                Color.backgroundSecondary
            )
            .cornerRadius(isIPad ? CornerRadius.large : CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? CornerRadius.large : CornerRadius.medium)
                    .stroke(
                        isSelected ?
                        Color.brandPrimary :
                        Color.clear,
                        lineWidth: isIPad ? 3 : 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


