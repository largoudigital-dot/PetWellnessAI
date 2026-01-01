//
//  TutorialsView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct TutorialsView: View {
    @State private var selectedCategory: TutorialCategory?
    @Environment(\.dismiss) var dismiss
    
    enum TutorialCategory: String, CaseIterable {
        case care = "Pflege"
        case nutrition = "Ernährung"
        case training = "Training"
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header mit Back-Button
                headerView
                    .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Categories
                        VStack(spacing: Spacing.lg) {
                            TutorialCategoryCard(
                                category: .care,
                                icon: "scissors",
                                title: "tutorials.careTutorials".localized,
                                description: "tutorials.careDescription".localized,
                                imageName: "Pflege-Tutorial",
                                color: .accentGreen
                            ) {
                                selectedCategory = .care
                            }
                            
                            TutorialCategoryCard(
                                category: .nutrition,
                                icon: "fork.knife",
                                title: "tutorials.nutritionTutorials".localized,
                                description: "tutorials.nutritionDescription".localized,
                                imageName: "Ernährung-Tutorial",
                                color: .accentBlue
                            ) {
                                selectedCategory = .nutrition
                            }
                            
                            TutorialCategoryCard(
                                category: .training,
                                icon: "figure.walk",
                                title: "tutorials.trainingTutorials".localized,
                                description: "tutorials.trainingDescription".localized,
                                imageName: "Training-Tutorial",
                                color: .accentOrange
                            ) {
                                selectedCategory = .training
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.md)
                        
                        // Selected Category Details
                        if let category = selectedCategory {
                            categoryDetailView(for: category)
                                .padding(.horizontal, Spacing.xl)
                        }
                    }
                    .padding(.bottom, Spacing.xxl)
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
            
            // Titel zentriert
            Text("tutorials.title".localized)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            // Unsichtbarer Platzhalter für Balance
            Color.clear
                .frame(minWidth: 80)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, 12)
        .frame(height: 44)
        .background(Color.backgroundPrimary)
    }
    
    @ViewBuilder
    private func categoryDetailView(for category: TutorialCategory) -> some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Divider()
                .padding(.vertical, Spacing.md)
            
            switch category {
            case .care:
                careTutorialsView
            case .nutrition:
                nutritionTutorialsView
            case .training:
                trainingTutorialsView
            }
        }
    }
    
    // MARK: - Care Tutorials
    private var careTutorialsView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("tutorials.care".localized)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.bottom, Spacing.sm)
            
            VStack(spacing: Spacing.md) {
                TutorialItemRow(
                    icon: "scissors",
                    title: "tutorials.furCare".localized,
                    description: "tutorials.furCareDesc".localized,
                    steps: ["tutorials.step.preparation".localized, "tutorials.step.brushing".localized, "tutorials.step.combing".localized, "tutorials.step.completion".localized],
                    color: .accentGreen
                )
                
                TutorialItemRow(
                    icon: "pawprint.fill",
                    title: "tutorials.nailClipping".localized,
                    description: "tutorials.nailClippingDesc".localized,
                    steps: ["tutorials.step.preparation".localized, "tutorials.step.checkNails".localized, "tutorials.step.cutting".localized, "tutorials.step.aftercare".localized],
                    color: .accentGreen
                )
                
                TutorialItemRow(
                    icon: "mouth.fill",
                    title: "tutorials.dentalCare".localized,
                    description: "tutorials.dentalCareDesc".localized,
                    steps: ["tutorials.step.prepareToothbrush".localized, "tutorials.step.cleaning".localized, "tutorials.step.rinsing".localized, "tutorials.step.check".localized],
                    color: .accentGreen
                )
                
                TutorialItemRow(
                    icon: "drop.fill",
                    title: "tutorials.bathing".localized,
                    description: "tutorials.bathingDesc".localized,
                    steps: ["tutorials.step.preparation".localized, "tutorials.step.water".localized, "tutorials.step.shampoo".localized, "tutorials.step.drying".localized],
                    color: .accentGreen
                )
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
    
    // MARK: - Nutrition Tutorials
    private var nutritionTutorialsView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("tutorials.nutrition".localized)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.bottom, Spacing.sm)
            
            VStack(spacing: Spacing.md) {
                TutorialItemRow(
                    icon: "fork.knife",
                    title: "tutorials.foodPreparation".localized,
                    description: "tutorials.foodPreparationDesc".localized,
                    steps: ["tutorials.step.checkIngredients".localized, "tutorials.step.cooking".localized, "tutorials.step.portioning".localized, "tutorials.step.serving".localized],
                    color: .accentBlue
                )
                
                TutorialItemRow(
                    icon: "scalemass.fill",
                    title: "tutorials.portionSizes".localized,
                    description: "tutorials.portionSizesDesc".localized,
                    steps: ["tutorials.step.checkWeight".localized, "tutorials.step.calculation".localized, "tutorials.step.measuring".localized, "tutorials.step.check".localized],
                    color: .accentBlue
                )
                
                TutorialItemRow(
                    icon: "leaf.fill",
                    title: "tutorials.healthySnacks".localized,
                    description: "tutorials.healthySnacksDesc".localized,
                    steps: ["tutorials.step.selection".localized, "tutorials.step.amount".localized, "tutorials.step.timing".localized, "tutorials.step.check".localized],
                    color: .accentBlue
                )
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
    
    // MARK: - Training Tutorials
    private var trainingTutorialsView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("tutorials.training".localized)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.bottom, Spacing.sm)
            
            VStack(spacing: Spacing.md) {
                TutorialItemRow(
                    icon: "figure.walk",
                    title: "tutorials.walks".localized,
                    description: "tutorials.walksDesc".localized,
                    steps: ["tutorials.step.preparation".localized, "tutorials.step.route".localized, "tutorials.step.pace".localized, "tutorials.step.completion".localized],
                    color: .accentOrange
                )
                
                TutorialItemRow(
                    icon: "gamecontroller.fill",
                    title: "tutorials.games".localized,
                    description: "tutorials.gamesDesc".localized,
                    steps: ["tutorials.step.gameSelection".localized, "tutorials.step.preparation".localized, "tutorials.step.execution".localized, "tutorials.step.completion".localized],
                    color: .accentOrange
                )
                
                TutorialItemRow(
                    icon: "figure.run",
                    title: "tutorials.exercises".localized,
                    description: "tutorials.exercisesDesc".localized,
                    steps: ["tutorials.step.warmup".localized, "tutorials.step.exercise".localized, "tutorials.step.cooldown".localized, "tutorials.step.recovery".localized],
                    color: .accentOrange
                )
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
}

// MARK: - Tutorial Category Card
struct TutorialCategoryCard: View {
    let category: TutorialsView.TutorialCategory
    let icon: String
    let title: String
    let description: String
    let imageName: String
    let color: Color
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                // Icon in farbigem Quadrat
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.backgroundSecondary)
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Tutorial Item Row
struct TutorialItemRow: View {
    let icon: String
    let title: String
    let description: String
    let steps: [String]
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.md) {
                // Icon in farbigem Quadrat
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            // Steps
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(spacing: Spacing.xs) {
                        ZStack {
                            Circle()
                                .fill(color)
                                .frame(width: 24, height: 24)
                            
                            Text("\(index + 1)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text(step)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(.leading, 66)
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
    }
}

