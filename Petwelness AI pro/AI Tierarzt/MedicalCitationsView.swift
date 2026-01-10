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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var titleSize: CGFloat { isIPad ? 32 : 24 }
    private var subtitleSize: CGFloat { isIPad ? 18 : 14 }
    private var sectionTitleSize: CGFloat { isIPad ? 24 : 20 }
    private var maxContentWidth: CGFloat { isIPad ? 800 : .infinity }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: isIPad ? Spacing.xxl : Spacing.xl) {
                        // Header Section
                        VStack(alignment: .leading, spacing: isIPad ? Spacing.lg : Spacing.md) {
                            Text("citations.title".localized)
                                .font(.system(size: titleSize, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .id(localizationManager.currentLanguage)
                            
                            Text("citations.subtitle".localized)
                                .font(.system(size: subtitleSize))
                                .foregroundColor(.textSecondary)
                                .id(localizationManager.currentLanguage)
                        }
                        .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.lg)
                        .padding(.top, isIPad ? Spacing.xl : Spacing.lg)
                        
                        // Disclaimer Box (Modernisiert)
                        VStack(alignment: .leading, spacing: isIPad ? Spacing.md : Spacing.sm) {
                            HStack(alignment: .top, spacing: isIPad ? Spacing.lg : Spacing.md) {
                                Image(systemName: "exclamationmark.shield.fill")
                                    .font(.system(size: isIPad ? 24 : 20, weight: .semibold))
                                    .foregroundColor(.accentOrange)
                                
                                Text("citations.disclaimer".localized)
                                    .font(.system(size: isIPad ? 16 : 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(isIPad ? Spacing.xl : Spacing.lg)
                        .background(Color.accentOrange.opacity(0.1))
                        .cornerRadius(isIPad ? CornerRadius.large : CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: isIPad ? CornerRadius.large : CornerRadius.medium)
                                .stroke(Color.accentOrange.opacity(0.3), lineWidth: isIPad ? 2 : 1.5)
                        )
                        .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.lg)
                    
                        // Citations Section
                        VStack(alignment: .leading, spacing: isIPad ? Spacing.xl : Spacing.lg) {
                            Text("citations.sources".localized)
                                .font(.system(size: sectionTitleSize, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .id(localizationManager.currentLanguage)
                                .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.lg)
                            
                            // Citation Items
                            VStack(spacing: isIPad ? Spacing.lg : Spacing.md) {
                                CitationItem(
                                    title: "citations.source1.title".localized,
                                    description: "citations.source1.description".localized,
                                    url: "https://www.merckvetmanual.com",
                                    icon: "book.fill",
                                    isIPad: isIPad
                                )
                                .id(localizationManager.currentLanguage)
                                
                                CitationItem(
                                    title: "citations.source2.title".localized,
                                    description: "citations.source2.description".localized,
                                    url: "https://www.veterinarypracticenews.com",
                                    icon: "newspaper.fill",
                                    isIPad: isIPad
                                )
                                .id(localizationManager.currentLanguage)
                                
                                CitationItem(
                                    title: "citations.source3.title".localized,
                                    description: "citations.source3.description".localized,
                                    url: "https://www.avma.org",
                                    icon: "building.2.fill",
                                    isIPad: isIPad
                                )
                                .id(localizationManager.currentLanguage)
                                
                                CitationItem(
                                    title: "citations.source4.title".localized,
                                    description: "citations.source4.description".localized,
                                    url: "https://www.vetmed.wisc.edu",
                                    icon: "graduationcap.fill",
                                    isIPad: isIPad
                                )
                                .id(localizationManager.currentLanguage)
                                
                                CitationItem(
                                    title: "citations.source5.title".localized,
                                    description: "citations.source5.description".localized,
                                    url: "https://www.veterinarymedicine.com",
                                    icon: "stethoscope",
                                    isIPad: isIPad
                                )
                                .id(localizationManager.currentLanguage)
                            }
                            .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.lg)
                        }
                        .padding(.top, isIPad ? Spacing.xl : Spacing.lg)
                        
                        // Additional Information
                        VStack(alignment: .leading, spacing: isIPad ? Spacing.md : Spacing.sm) {
                            Text("citations.note".localized)
                                .font(.system(size: isIPad ? 16 : 14))
                                .foregroundColor(.textSecondary)
                                .lineSpacing(isIPad ? 6 : 4)
                                .id(localizationManager.currentLanguage)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(isIPad ? Spacing.xl : Spacing.lg)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(isIPad ? CornerRadius.large : CornerRadius.medium)
                        .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.lg)
                        .padding(.top, isIPad ? Spacing.lg : Spacing.md)
                        .padding(.bottom, isIPad ? Spacing.xxl : Spacing.xl)
                    }
                    .frame(maxWidth: maxContentWidth)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: isIPad ? 20 : 18))
                            .foregroundColor(.textPrimary)
                            .frame(width: isIPad ? 44 : 32, height: isIPad ? 44 : 32)
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
    let isIPad: Bool
    
    private var iconSize: CGFloat { isIPad ? 56 : 44 }
    private var iconCircleSize: CGFloat { isIPad ? 64 : 52 }
    private var titleSize: CGFloat { isIPad ? 20 : 16 }
    private var descriptionSize: CGFloat { isIPad ? 15 : 13 }
    private var urlSize: CGFloat { isIPad ? 13 : 11 }
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(alignment: .top, spacing: isIPad ? Spacing.lg : Spacing.md) {
                // Icon mit besserem Design
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.brandPrimary.opacity(0.15), Color.brandPrimary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: iconCircleSize, height: iconCircleSize)
                    
                    Image(systemName: icon)
                        .font(.system(size: iconSize * 0.45, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                }
                
                // Content
                VStack(alignment: .leading, spacing: isIPad ? Spacing.sm : Spacing.xs) {
                    Text(title)
                        .font(.system(size: titleSize, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(description)
                        .font(.system(size: descriptionSize))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(isIPad ? 4 : 2)
                    
                    // URL mit besserem Design
                    HStack(spacing: isIPad ? 6 : 4) {
                        Text(url.replacingOccurrences(of: "https://www.", with: "").replacingOccurrences(of: "https://", with: ""))
                            .font(.system(size: urlSize, weight: .medium))
                            .foregroundColor(.brandPrimary)
                        
                        Image(systemName: "arrow.up.right.square.fill")
                            .font(.system(size: urlSize + 2))
                            .foregroundColor(.brandPrimary)
                    }
                    .padding(.top, isIPad ? 4 : 2)
                }
                
                Spacer()
                
                // Chevron Icon
                Image(systemName: "chevron.right")
                    .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(isIPad ? Spacing.xl : Spacing.lg)
            .background(Color.backgroundSecondary)
            .cornerRadius(isIPad ? CornerRadius.large : CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? CornerRadius.large : CornerRadius.medium)
                    .stroke(Color.brandPrimary.opacity(0.2), lineWidth: isIPad ? 2 : 1.5)
            )
            .shadow(color: Color.black.opacity(0.05), radius: isIPad ? 8 : 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MedicalCitationsView()
        .environmentObject(LocalizationManager.shared)
}




