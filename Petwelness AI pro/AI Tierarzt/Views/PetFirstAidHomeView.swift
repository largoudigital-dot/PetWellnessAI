//
//  PetFirstAidHomeView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct PetFirstAidHomeView: View {
    @StateObject private var viewModel = PetFirstAidViewModel()
    @State private var selectedCategory: PetCategory?
    @State private var selectedEmergency: Emergency?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                        // Header Card mit hellem rosa Hintergrund (Dark Mode angepasst)
                        ZStack {
                            RoundedRectangle(cornerRadius: CornerRadius.large)
                                .fill(colorScheme == .dark ? Color(red: 0.3, green: 0.2, blue: 0.2) : Color(red: 1.0, green: 0.9, blue: 0.9))
                                .frame(height: 180)
                            
                            VStack(spacing: Spacing.md) {
                                Image(systemName: "cross.case.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.accentRed)
                                
                                Text("firstAid.title".localized)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                Text("firstAid.subtitle".localized)
                                    .font(.system(size: 16))
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.xl)
                        
                        // Notfall-Kontakt Button
                        Button(action: {
                            if let url = URL(string: "tel://116117") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack(spacing: Spacing.md) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                Text("emergency.service".localized)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(Spacing.lg)
                            .background(Color.accentRed)
                            .cornerRadius(CornerRadius.large)
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, Spacing.xl)
                        
                        // Banner Ad unter dem Service d'Urgence Button
                        if AdManager.shared.shouldShowBannerAds {
                            BannerAdView()
                                .frame(height: 50)
                                .padding(.horizontal, Spacing.xl)
                                .padding(.top, Spacing.sm)
                        }
                        
                        // Kategorien
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("firstAid.categories".localized)
                                .font(.sectionTitle)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            ForEach(viewModel.filteredCategories) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    CategoryCard(category: category)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, Spacing.xl)
                        }
                        .padding(.bottom, 50) // Platz für navigation bar
                    }
                }
        }
        .fullScreenCover(item: $selectedCategory) { category in
            EmergencyListView(category: category)
        }
    }
}

struct CategoryCard: View {
    let category: PetCategory
    @Environment(\.colorScheme) var colorScheme
    
    private var cardBackgroundColor: Color {
        Color.backgroundSecondary
    }
    
    private var iconBackgroundColor: Color {
        Color.accentGreen.opacity(0.15)
    }
    
    private var iconColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
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
        HStack(spacing: Spacing.md) {
            // Icon in hellgrünem Kreis
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 50, height: 50)
                
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(localizedCategoryName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text("\(category.emergencies.count) \("emergency.plural".localized)")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 4, x: 0, y: 2)
    }
}
