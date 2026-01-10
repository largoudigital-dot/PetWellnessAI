//
//  MedicalCitationsView.swift
//  AI Tierarzt
//
//  Created for App Store Compliance - Medical Information Citations
//

import SwiftUI

struct MedicalCitationsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("citations.title".localized)
                            .font(.appTitle)
                            .foregroundColor(.textPrimary)
                            .id(localizationManager.currentLanguage)
                        
                        Text("citations.subtitle".localized)
                            .font(.bodyText)
                            .foregroundColor(.textSecondary)
                            .id(localizationManager.currentLanguage)
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.lg)
                    
                    // Disclaimer Box
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        HStack(alignment: .top, spacing: Spacing.md) {
                            Image(systemName: "exclamationmark.shield.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.accentOrange)
                            
                            Text("citations.disclaimer".localized)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                                .id(localizationManager.currentLanguage)
                        }
                    }
                    .padding(Spacing.lg)
                    .background(Color.accentOrange.opacity(0.1))
                    .cornerRadius(CornerRadius.medium)
                    .padding(.horizontal, Spacing.lg)
                    
                    // Citations Section
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        Text("citations.sources".localized)
                            .font(.sectionTitle)
                            .foregroundColor(.textPrimary)
                            .id(localizationManager.currentLanguage)
                            .padding(.horizontal, Spacing.lg)
                        
                        // Citation Items
                        VStack(spacing: Spacing.md) {
                            CitationItem(
                                title: "citations.source1.title".localized,
                                description: "citations.source1.description".localized,
                                url: "https://www.merckvetmanual.com",
                                icon: "book.fill"
                            )
                            .id(localizationManager.currentLanguage)
                            
                            CitationItem(
                                title: "citations.source2.title".localized,
                                description: "citations.source2.description".localized,
                                url: "https://www.veterinarypracticenews.com",
                                icon: "newspaper.fill"
                            )
                            .id(localizationManager.currentLanguage)
                            
                            CitationItem(
                                title: "citations.source3.title".localized,
                                description: "citations.source3.description".localized,
                                url: "https://www.avma.org",
                                icon: "building.2.fill"
                            )
                            .id(localizationManager.currentLanguage)
                            
                            CitationItem(
                                title: "citations.source4.title".localized,
                                description: "citations.source4.description".localized,
                                url: "https://www.vetmed.wisc.edu",
                                icon: "graduationcap.fill"
                            )
                            .id(localizationManager.currentLanguage)
                            
                            CitationItem(
                                title: "citations.source5.title".localized,
                                description: "citations.source5.description".localized,
                                url: "https://www.veterinarymedicine.com",
                                icon: "stethoscope"
                            )
                            .id(localizationManager.currentLanguage)
                        }
                        .padding(.horizontal, Spacing.lg)
                    }
                    .padding(.top, Spacing.lg)
                    
                    // Additional Information
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("citations.note".localized)
                            .font(.bodyText)
                            .foregroundColor(.textSecondary)
                            .id(localizationManager.currentLanguage)
                    }
                    .padding(Spacing.lg)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(CornerRadius.medium)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.md)
                    .padding(.bottom, Spacing.xl)
                }
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }
}

struct CitationItem: View {
    let title: String
    let description: String
    let url: String
    let icon: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(alignment: .top, spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.brandPrimary)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        Text(url)
                            .font(.caption)
                            .foregroundColor(.brandPrimary)
                        
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 10))
                            .foregroundColor(.brandPrimary)
                    }
                    .padding(.top, 2)
                }
                
                Spacer()
            }
            .padding(Spacing.md)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MedicalCitationsView()
        .environmentObject(LocalizationManager.shared)
}




