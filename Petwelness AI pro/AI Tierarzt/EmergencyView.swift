//
//  EmergencyView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct EmergencyView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? Spacing.xxl : Spacing.xl) {
                        // Emergency Header
                        VStack(spacing: isIPad ? Spacing.lg : Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(Color.accentRed.opacity(0.2))
                                    .frame(width: isIPad ? 140 : 100, height: isIPad ? 140 : 100)
                                
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: isIPad ? 70 : 50))
                                    .foregroundColor(.accentRed)
                            }
                            
                            Text("emergency.title".localized)
                                .font(.system(size: isIPad ? 40 : 32, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text("emergency.immediateHelp".localized)
                                .font(.system(size: isIPad ? 20 : 17))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, isIPad ? Spacing.xxxl : Spacing.xxxl)
                        
                        // Emergency Contacts
                        VStack(spacing: isIPad ? Spacing.xl : Spacing.lg) {
                            EmergencyContactCard(
                                title: "emergency.emergencyCall".localized,
                                phone: "112",
                                icon: "phone.fill",
                                color: .accentRed
                            )
                            
                            EmergencyContactCard(
                                title: "emergency.veterinaryEmergency".localized,
                                phone: "116 117",
                                icon: "phone.circle.fill",
                                color: .accentOrange
                            )
                        }
                        .padding(.horizontal, isIPad ? Spacing.xxl : Spacing.xl)
                        
                        // Emergency Tips
                        VStack(alignment: .leading, spacing: isIPad ? Spacing.lg : Spacing.md) {
                            Text("emergency.importantNotes".localized)
                                .font(.system(size: isIPad ? 22 : 18, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            VStack(alignment: .leading, spacing: isIPad ? Spacing.md : Spacing.sm) {
                                EmergencyTip(text: "emergency.tip.stayCalm".localized)
                                EmergencyTip(text: "emergency.tip.safePlace".localized)
                                EmergencyTip(text: "emergency.tip.contactVet".localized)
                                EmergencyTip(text: "emergency.tip.prepareInfo".localized)
                            }
                        }
                        .padding(isIPad ? Spacing.xl : Spacing.lg)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.horizontal, isIPad ? Spacing.xxl : Spacing.xl)
                    }
                    .padding(.bottom, isIPad ? Spacing.xxl : Spacing.xl)
                }
            }
            .navigationTitle("emergency.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}

struct EmergencyContactCard: View {
    let title: String
    let phone: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            if let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .cornerRadius(CornerRadius.medium)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text(phone)
                        .font(.bodyText)
                        .foregroundColor(.brandPrimary)
                }
                
                Spacer()
                
                Image(systemName: "phone.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.brandPrimary)
            }
            .padding(Spacing.lg)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.large)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmergencyTip: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.accentGreen)
                .padding(.top, 2)
            
            Text(text)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
        }
    }
}
