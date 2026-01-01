//
//  EmergencyDetailView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct EmergencyDetailView: View {
    let emergency: Emergency
    let categoryName: String
    @State private var showContactAlert = false
    @Environment(\.dismiss) var dismiss
    @State private var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header mit X-Button rechts - oben fixiert
                    headerView
                        .padding(.top, 8) // Padding für Status Bar
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: Spacing.lg) {
                            // Bild oben - 25% der Bildschirmhöhe
                            if let imageName = emergency.imageName {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: geometry.size.height * 0.25)
                                    .clipped()
                                    .padding(.horizontal, Spacing.xl)
                                    .padding(.top, Spacing.md)
                            }
                            
                            // Warning Banner (Rot mit weißem Text)
                            if let warning = emergency.localizedWarning {
                            HStack(spacing: Spacing.md) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                Text(warning)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(Spacing.lg)
                            .background(Color.accentRed)
                            .cornerRadius(CornerRadius.medium)
                            .padding(.horizontal, Spacing.xl)
                            .padding(.top, Spacing.md)
                        }
                    
                        // Symptome Card
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "list.bullet.clipboard.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.brandPrimary)
                                
                                Text("emergency.symptoms".localized)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                ForEach(emergency.localizedSymptoms, id: \.self) { symptom in
                                    HStack(alignment: .top, spacing: Spacing.md) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.brandPrimary)
                                        
                                        Text(symptom)
                                            .font(.system(size: 16))
                                            .foregroundColor(.textPrimary)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.vertical, Spacing.xs)
                                }
                            }
                        }
                        .padding(Spacing.lg)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.horizontal, Spacing.xl)
                        
                        // Erste-Hilfe-Schritte Card
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "cross.case.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.accentRed)
                                
                                Text("emergency.firstAidSteps".localized)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.md) {
                                ForEach(Array(emergency.localizedSteps.enumerated()), id: \.offset) { index, step in
                                    HStack(alignment: .top, spacing: Spacing.md) {
                                        // Step Number Badge - Grüner Kreis
                                        ZStack {
                                            Circle()
                                                .fill(Color.brandPrimary)
                                                .frame(width: 28, height: 28)
                                            
                                            Text("\(index + 1)")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 28)
                                        
                                        // Step Text
                                        Text(step)
                                            .font(.system(size: 16))
                                            .foregroundColor(.textPrimary)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Spacer(minLength: 0)
                                    }
                                }
                            }
                        }
                        .padding(Spacing.lg)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.horizontal, Spacing.xl)
                    
                        // Notfall-Kontakt Button
                        Button(action: {
                            showContactAlert = true
                        }) {
                            HStack(spacing: Spacing.md) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                Text("emergency.contactVet".localized)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(Spacing.lg)
                            .background(Color.accentRed)
                            .cornerRadius(CornerRadius.large)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.lg)
                        .padding(.bottom, Spacing.xl)
                        }
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
            .alert("emergency.contactAlert.title".localized, isPresented: $showContactAlert) {
                Button("common.cancel".localized, role: .cancel) { }
                Button("emergency.contactAlert.call".localized) {
                    if let url = URL(string: "tel://116117") {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text("emergency.contactAlert.message".localized)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack(alignment: .center) {
            Spacer()
            
            // Titel zentriert mit Icon - grünes Icon + schwarzer Text
            HStack(spacing: 6) {
                Image(systemName: emergency.severity == .critical ? "exclamationmark.triangle.fill" : "info.circle.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.brandPrimary)
                
                Text(emergency.localizedTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // X-Button rechts
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, 12)
        .frame(height: 44)
        .background(Color.backgroundPrimary)
    }
}

