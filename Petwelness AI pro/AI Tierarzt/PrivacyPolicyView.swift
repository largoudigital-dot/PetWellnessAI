//
//  PrivacyPolicyView.swift
//  AI Tierarzt
//
//  Created for Privacy Policy and Data Protection
//

import SwiftUI

struct PrivacyPolicyView: View {
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
                            Text("privacy.title".localized)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text("privacy.lastUpdated".localized)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.xl)
                        
                        // Content Sections
                        VStack(alignment: .leading, spacing: Spacing.xl) {
                            PrivacySection(
                                title: "privacy.dataCollection.title".localized,
                                content: "privacy.dataCollection.content".localized
                            )
                            
                            PrivacySection(
                                title: "privacy.dataUsage.title".localized,
                                content: "privacy.dataUsage.content".localized
                            )
                            
                            PrivacySection(
                                title: "privacy.dataStorage.title".localized,
                                content: "privacy.dataStorage.content".localized
                            )
                            
                            PrivacySection(
                                title: "privacy.dataSharing.title".localized,
                                content: "privacy.dataSharing.content".localized
                            )
                            
                            PrivacySection(
                                title: "privacy.userRights.title".localized,
                                content: "privacy.userRights.content".localized
                            )
                            
                            PrivacySection(
                                title: "privacy.contact.title".localized,
                                content: "privacy.contact.content".localized
                            )
                            
                            // Privacy Policy Website Link
                            if let privacyURL = URL(string: "https://devlargou.com/PetWellnessAI/Privacy-Policy") {
                                VStack(alignment: .leading, spacing: Spacing.sm) {
                                    Text("privacy.viewOnline".localized)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.textPrimary)
                                    
                                    Link(destination: privacyURL) {
                                        HStack {
                                            Image(systemName: "link.circle.fill")
                                                .foregroundColor(.brandPrimary)
                                            Text("privacy.openInBrowser".localized)
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
            .navigationTitle("privacy.title".localized)
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

struct PrivacySection: View {
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


