//
//  EmergencyView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct EmergencyView: View {
    @StateObject private var viewModel = PetFirstAidViewModel()
    @State private var selectedCategory: PetCategory?
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
                    VStack(spacing: Spacing.xl) {
                        // Erste Hilfe für Tiere Card (Rosa)
                        VStack(spacing: Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(Color.accentRed.opacity(0.15))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "cross.case.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.accentRed)
                            }
                            .padding(.top, Spacing.lg)
                            
                            Text("emergency.title".localized)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text("emergency.immediateHelp".localized)
                                .font(.system(size: 15))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, Spacing.lg)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(Spacing.xl)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadius.large)
                                .fill(Color.pink.opacity(0.1))
                        )
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.lg)
                        
                        // Tierärztlicher Notdienst Button (Rot)
                        Button(action: {
                            if let url = URL(string: "tel://116117") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack(spacing: Spacing.md) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                Text("emergency.veterinaryEmergency".localized + ": 116 117")
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
                        
                        // Tierkategorien
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("emergency.categories".localized)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            VStack(spacing: Spacing.md) {
                                ForEach(viewModel.categories) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        HStack(spacing: Spacing.md) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.brandPrimary.opacity(0.15))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: category.icon)
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.brandPrimary)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(category.localizedName)
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(.textPrimary)
                                                
                                                Text("\(category.emergencies.count) " + "emergency.emergencies".localized)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.textSecondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14))
                                                .foregroundColor(.textSecondary)
                                        }
                                        .padding(Spacing.md)
                                        .background(Color.backgroundSecondary)
                                        .cornerRadius(CornerRadius.medium)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, Spacing.xl)
                        }
                        .padding(.top, Spacing.lg)
                        .padding(.bottom, Spacing.xl)
                    }
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
            .safeAreaInset(edge: .bottom) {
                // Banner Ad am unteren Rand (über Safe Area)
                if AdManager.shared.shouldShowAds {
                    BannerAdView()
                        .frame(height: 50)
                        .background(Color.backgroundPrimary)
                }
            }
            .fullScreenCover(item: $selectedCategory) { category in
                EmergencyListView(category: category)
            }
        }
    }
}

extension PetCategory {
    var localizedName: String {
        switch icon {
        case "pawprint.fill":
            return "petCategory.dog".localized
        case "cat.fill":
            return "petCategory.cat".localized
        case "hare.fill":
            return "petCategory.smallAnimals".localized
        default:
            return name
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
