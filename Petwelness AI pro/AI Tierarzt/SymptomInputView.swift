//
//  SymptomInputView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct SymptomInputView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var appState: AppState
    @StateObject private var adManager = AdManager.shared
    @State private var selectedSymptoms: Set<String> = []
    @State private var additionalNotes = ""
    
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
                            .font(.system(size: 18))
                            .foregroundColor(.brandPrimary)
                    }
                    
                    Spacer()
                    
                    Text("symptomInput.title".localized)
                        .id(localizationManager.currentLanguage)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                            .foregroundColor(.clear)
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.md)
                .background(Color.backgroundPrimary)
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Symptom Grid
                        VStack(alignment: .leading, spacing: Spacing.lg) {
                            Text("symptomInput.commonSymptoms".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: Spacing.md),
                                GridItem(.flexible(), spacing: Spacing.md)
                            ], spacing: Spacing.md) {
                                ForEach(commonSymptoms) { symptom in
                                    SymptomSelectionCard(
                                        symptom: symptom,
                                        isSelected: selectedSymptoms.contains(symptom.name),
                                        localizationManager: localizationManager
                                    ) {
                                        if selectedSymptoms.contains(symptom.name) {
                                            selectedSymptoms.remove(symptom.name)
                                        } else {
                                            selectedSymptoms.insert(symptom.name)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, Spacing.xl)
                        }
                        .padding(.top, Spacing.lg)
                        
                        // Banner Ad unter "Symptômes courants" Grid vor "Description supplémentaire"
                        if AdManager.shared.shouldShowBannerAds {
                            BannerAdView()
                                .frame(height: 50)
                                .padding(.horizontal, Spacing.xl)
                                .padding(.vertical, Spacing.sm)
                        }
                        
                        // Additional Notes
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("symptomInput.additionalDescription".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.bodyTextBold)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            TextEditor(text: $additionalNotes)
                                .frame(minHeight: 120)
                                .padding(Spacing.md)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(CornerRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                                        .stroke(Color.textTertiary.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal, Spacing.xl)
                        }
                        
                        // Submit Button
                        PrimaryButton("symptomInput.startAnalysis".localized, icon: "arrow.right") {
                            // WICHTIG: Erst Aktion ausführen (Navigation), dann Ad zeigen
                            // Navigiere zuerst zum Chat
                            navigateToChat()
                            
                            // Zeige Interstitial Ad NACH der Aktion (wenn Bedingungen erfüllt)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                adManager.showInterstitialAfterAction()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                        .disabled(selectedSymptoms.isEmpty && additionalNotes.isEmpty)
                        .opacity(selectedSymptoms.isEmpty && additionalNotes.isEmpty ? 0.5 : 1.0)
                        .id(localizationManager.currentLanguage)
                    }
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Image(systemName: symptom.icon)
                    .font(.system(size: 24))
                    .foregroundColor(symptom.iconColor)
                    .frame(height: 32)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(symptom.name.localized)
                    .id(localizationManager.currentLanguage)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Text(symptom.category.localized)
                    .id(localizationManager.currentLanguage)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.lg)
            .background(
                isSelected ?
                Color.brandPrimary.opacity(0.1) :
                Color.backgroundSecondary
            )
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(
                        isSelected ?
                        Color.brandPrimary :
                        Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


