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
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Bild Header
                    if let imageName = emergency.imageName {
                        ZStack(alignment: .bottomLeading) {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .clipped()
                                .overlay(
                                    LinearGradient(
                                        colors: [Color.clear, Color.black.opacity(0.5)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack {
                                    Image(systemName: emergency.severity == .critical ? "exclamationmark.triangle.fill" : "info.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text(emergency.severity.localizedName)
                                        .font(.bodyTextBold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, Spacing.md)
                                        .padding(.vertical, Spacing.sm)
                                        .background(emergency.severity.color.opacity(0.9))
                                        .cornerRadius(CornerRadius.medium)
                                }
                                
                                Text(emergency.localizedTitle)
                                    .font(.appSubtitle)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                                
                                Text(categoryName)
                                    .font(.bodyText)
                                    .foregroundColor(.white.opacity(0.9))
                                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                            }
                            .padding(Spacing.lg)
                        }
                        .cornerRadius(CornerRadius.large)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    } else {
                        // Fallback Header ohne Bild
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            HStack {
                                Image(systemName: emergency.severity == .critical ? "exclamationmark.triangle.fill" : "info.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(emergency.severity.color)
                                
                                Spacer()
                                
                                Text(emergency.severity.localizedName)
                                    .font(.bodyTextBold)
                                    .foregroundColor(emergency.severity.color)
                                    .padding(.horizontal, Spacing.md)
                                    .padding(.vertical, Spacing.sm)
                                    .background(emergency.severity.backgroundColor)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            Text(emergency.localizedTitle)
                                .font(.appSubtitle)
                                .foregroundColor(.textPrimary)
                            
                            Text(categoryName)
                                .font(.bodyText)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(Spacing.lg)
                        .background(emergency.severity.backgroundColor)
                        .cornerRadius(CornerRadius.large)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.large)
                                .stroke(emergency.severity.color.opacity(0.3), lineWidth: 2)
                        )
                    }
                    
                    // Warning
                    if let warning = emergency.localizedWarning {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.accentRed)
                            
                            Text(warning)
                                .font(.bodyTextBold)
                                .foregroundColor(.accentRed)
                        }
                        .padding(Spacing.lg)
                        .background(Color.accentRed.opacity(0.1))
                        .cornerRadius(CornerRadius.large)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.large)
                                .stroke(Color.accentRed.opacity(0.3), lineWidth: 2)
                        )
                    }
                    
                    // Symptome
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "list.bullet.clipboard.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.brandPrimary)
                            
                            Text("emergency.symptoms".localized)
                                .font(.sectionTitle)
                                .foregroundColor(.textPrimary)
                        }
                        
                        VStack(spacing: Spacing.sm) {
                            ForEach(emergency.localizedSymptoms, id: \.self) { symptom in
                                HStack(spacing: Spacing.md) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.brandPrimary)
                                    
                                    Text(symptom)
                                        .font(.bodyText)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, Spacing.xs)
                            }
                        }
                    }
                    .padding(Spacing.lg)
                    .background(
                        LinearGradient(
                            colors: [Color.backgroundSecondary, Color.backgroundSecondary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(CornerRadius.large)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.large)
                            .stroke(Color.brandPrimary.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Erste-Hilfe-Schritte
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "cross.case.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.accentRed)
                            
                            Text("emergency.firstAidSteps".localized)
                                .font(.sectionTitle)
                                .foregroundColor(.textPrimary)
                        }
                        
                        VStack(spacing: Spacing.md) {
                            ForEach(Array(emergency.localizedSteps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: Spacing.md) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.brandPrimary, Color.brandPrimary.opacity(0.8)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 32, height: 32)
                                            .shadow(color: Color.brandPrimary.opacity(0.3), radius: 4, x: 0, y: 2)
                                        
                                        Text("\(index + 1)")
                                            .font(.bodyTextBold)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(step)
                                        .font(.bodyText)
                                        .foregroundColor(.textPrimary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer()
                                }
                                .padding(Spacing.md)
                                .background(
                                    index % 2 == 0 
                                        ? Color.backgroundSecondary.opacity(0.5)
                                        : Color.clear
                                )
                                .cornerRadius(CornerRadius.medium)
                            }
                        }
                    }
                    .padding(Spacing.lg)
                    .background(
                        LinearGradient(
                            colors: [Color.backgroundSecondary, Color.backgroundSecondary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(CornerRadius.large)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.large)
                            .stroke(Color.accentRed.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Notfall-Kontakt Button
                    Button(action: {
                        showContactAlert = true
                    }) {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "phone.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                            Text("emergency.contactVet".localized)
                                .font(.bodyTextBold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(Spacing.lg)
                        .background(
                            LinearGradient(
                                colors: [Color.accentRed, Color.accentRed.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(CornerRadius.large)
                        .shadow(color: Color.accentRed.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, Spacing.md)
                }
                .padding(Spacing.xl)
            }
        }
        .navigationTitle(emergency.localizedTitle)
        .navigationBarTitleDisplayMode(.inline)
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

