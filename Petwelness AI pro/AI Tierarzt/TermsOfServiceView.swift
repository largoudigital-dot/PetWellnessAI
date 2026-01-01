//
//  TermsOfServiceView.swift
//  AI Tierarzt
//
//  Created for Terms of Service
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.xl) {
                        // Header
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            Text("terms.title".localized)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text("terms.lastUpdated".localized)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.xl)
                        
                        // Medical Disclaimer (prominent)
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.accentRed)
                                
                                Text("terms.medicalDisclaimer.title".localized)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.accentRed)
                            }
                            
                            Text("terms.medicalDisclaimer.content".localized)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                                .lineSpacing(4)
                        }
                        .padding(Spacing.lg)
                        .background(Color.accentRed.opacity(0.1))
                        .cornerRadius(CornerRadius.large)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.large)
                                .stroke(Color.accentRed.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, Spacing.xl)
                        
                        // Content Sections
                        VStack(alignment: .leading, spacing: Spacing.xl) {
                            TermsSection(
                                title: "terms.acceptance.title".localized,
                                content: "terms.acceptance.content".localized
                            )
                            
                            TermsSection(
                                title: "terms.use.title".localized,
                                content: "terms.use.content".localized
                            )
                            
                            TermsSection(
                                title: "terms.limitations.title".localized,
                                content: "terms.limitations.content".localized
                            )
                            
                            TermsSection(
                                title: "terms.liability.title".localized,
                                content: "terms.liability.content".localized
                            )
                            
                            TermsSection(
                                title: "terms.changes.title".localized,
                                content: "terms.changes.content".localized
                            )
                            
                            // Terms of Service Website Link
                            if let termsURL = URL(string: "https://devlargou.com/PetWellnessAI/Terms-of-Service") {
                                VStack(alignment: .leading, spacing: Spacing.sm) {
                                    Text("terms.viewOnline".localized)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.textPrimary)
                                    
                                    Link(destination: termsURL) {
                                        HStack {
                                            Image(systemName: "link.circle.fill")
                                                .foregroundColor(.brandPrimary)
                                            Text("terms.openInBrowser".localized)
                                                .foregroundColor(.brandPrimary)
                                            Spacer()
                                            Image(systemName: "arrow.up.right.square")
                                                .foregroundColor(.brandPrimary)
                                        }
                                        .padding(Spacing.md)
                                        .background(Color.backgroundSecondary)
                                        .cornerRadius(CornerRadius.medium)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xxxl)
                    }
                }
            }
            .navigationTitle("terms.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.brandPrimary)
                    }
                }
            }
        }
    }
}

struct TermsSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text(content)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .padding(Spacing.lg)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
}


