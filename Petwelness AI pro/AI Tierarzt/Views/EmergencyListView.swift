//
//  EmergencyListView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct EmergencyListView: View {
    let category: PetCategory
    @State private var selectedEmergency: Emergency?
    @Environment(\.dismiss) var dismiss
    
    private var localizedCategoryName: String {
        switch category.icon {
        case "pawprint.fill":
            return "petCategory.dog".localized
        case "cat.fill":
            return "petCategory.cat".localized
        case "hare.fill":
            return "petCategory.smallAnimals".localized
        default:
            return category.name
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header mit Back-Button - oben fixiert
                headerView
                    .padding(.top, 8) // Padding für Status Bar
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Notfälle
                        VStack(spacing: Spacing.lg) {
                            ForEach(category.emergencies) { emergency in
                                Button(action: {
                                    selectedEmergency = emergency
                                }) {
                                    EmergencyCard(emergency: emergency)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.md)
                    }
                    .padding(.bottom, Spacing.xl)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            // Banner Ad am unteren Rand (über Safe Area)
            if AdManager.shared.shouldShowBannerAds {
                BannerAdView()
                    .frame(height: 50)
                    .background(Color.backgroundPrimary)
            }
        }
        .fullScreenCover(item: $selectedEmergency) { emergency in
            EmergencyDetailView(emergency: emergency, categoryName: localizedCategoryName)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack(alignment: .center) {
            // Back Button links - grüner Pfeil + Text
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                    
                    Text("common.back".localized)
                        .font(.system(size: 17))
                        .foregroundColor(.brandPrimary)
                }
            }
            .frame(minWidth: 80, alignment: .leading)
            
            Spacer()
            
            // Titel zentriert mit Icon - grünes Icon + schwarzer Text
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.brandPrimary)
                
                Text(localizedCategoryName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            // Unsichtbarer Platzhalter für Balance (gleiche Breite wie Back-Button)
            Color.clear
                .frame(minWidth: 80)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, 12)
        .frame(height: 44)
        .background(Color.backgroundPrimary)
    }
}

struct EmergencyCard: View {
    let emergency: Emergency
    
    var body: some View {
        VStack(spacing: 0) {
            // Bild oben
            if let imageName = emergency.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [Color.clear, Color.black.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            
            // Content unten
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: emergency.severity == .critical ? "exclamationmark.triangle.fill" : "info.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(emergency.severity.color)
                    
                    Text(emergency.localizedTitle)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Severity Badge
                    Text(emergency.severity.localizedName)
                        .font(.caption)
                        .foregroundColor(emergency.severity.color)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, 4)
                        .background(emergency.severity.backgroundColor)
                        .cornerRadius(8)
                }
                
                // Symptome Preview
                if !emergency.localizedSymptoms.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("symptoms.title".localized + ":")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text(emergency.localizedSymptoms.prefix(3).joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding(Spacing.lg)
            .background(emergency.severity.backgroundColor)
        }
        .cornerRadius(CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .stroke(emergency.severity.color.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
