//
//  MoreView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct MoreView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var selectedFeature: MoreFeature?
    
    var body: some View {
        ZStack {
            // Background with Paw Prints
            PawPrintBackground(opacity: 0.036, size: 45, spacing: 90)
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                        // Header mit Gradient
                        ZStack {
                            LinearGradient(
                                colors: [Color.brandPrimary.opacity(0.15), Color.brandPrimary.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(height: 160)
                            .cornerRadius(CornerRadius.large)
                            
                            VStack(spacing: Spacing.sm) {
                                Image(systemName: "square.grid.2x2.fill")
                                    .font(.system(size: 45))
                                    .foregroundColor(.brandPrimary)
                                
                                Text("more.title".localized)
                                    .font(.appTitle)
                                    .foregroundColor(.textPrimary)
                                
                                Text("more.subtitle".localized)
                                    .font(.bodyText)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.xl)
                        
                        // Banner Ad unter dem Header
                        if AdManager.shared.shouldShowBannerAds {
                            BannerAdView()
                                .frame(height: 50)
                                .padding(.horizontal, Spacing.xl)
                                .padding(.top, Spacing.md)
                        }
                        
                        // Features Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: Spacing.md),
                            GridItem(.flexible(), spacing: Spacing.md)
                        ], spacing: Spacing.md) {
                            // Intelligente Dashboards
                            Button(action: {
                                selectedFeature = .dashboards
                            }) {
                                MoreFeatureCardContent(
                                    icon: "chart.bar.xaxis",
                                    title: "more.intelligentDashboards".localized,
                                    description: "more.dailyOverview".localized,
                                    color: .brandPrimary
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Image-Tutorials
                            Button(action: {
                                selectedFeature = .tutorials
                            }) {
                                MoreFeatureCardContent(
                                    icon: "photo.on.rectangle.angled",
                                    title: "more.imageTutorials".localized,
                                    description: "more.careNutrition".localized,
                                    color: .accentGreen
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Gamification
                            Button(action: {
                                selectedFeature = .gamification
                            }) {
                                MoreFeatureCardContent(
                                    icon: "trophy.fill",
                                    title: "gamification.title".localized,
                                    description: "more.playfulMotivation".localized,
                                    color: .accentOrange
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Ressourcen & Tipps
                            Button(action: {
                                selectedFeature = .resources
                            }) {
                                MoreFeatureCardContent(
                                    icon: "book.fill",
                                    title: "more.resources".localized,
                                    description: "more.tipsGuides".localized,
                                    color: .accentPurple
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, Spacing.xl)
                    }
                    .padding(.bottom, 50) // Platz für navigation bar
                }
        }
        .fullScreenCover(item: $selectedFeature) { feature in
            switch feature {
            case .dashboards:
                DashboardView()
            case .tutorials:
                TutorialsView()
            case .gamification:
                GamificationView()
            case .resources:
                ResourcesView()
            }
        }
    }
    
    // MARK: - Dashboards View (Legacy - kann entfernt werden wenn Navigation funktioniert)
    private var dashboardsView: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 24))
                        .foregroundColor(.brandPrimary)
                }
                
                Text("more.intelligentDashboards".localized)
                    .font(.sectionTitle)
                    .foregroundColor(.textPrimary)
            }
            
            Text("more.dashboardsDescription".localized)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: Spacing.sm) {
                DashboardFeatureRow(
                    icon: "calendar.badge.clock",
                    title: "dashboard.dailyOverview".localized,
                    description: "dashboard.dailyOverviewDesc".localized
                )
                
                DashboardFeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "dashboard.trendsStatistics".localized,
                    description: "dashboard.trendsStatisticsDesc".localized
                )
                
                DashboardFeatureRow(
                    icon: "bell.badge.fill",
                    title: "dashboard.reminders".localized,
                    description: "dashboard.remindersDesc".localized
                )
                
                DashboardFeatureRow(
                    icon: "heart.text.square.fill",
                    title: "dashboard.healthScore".localized,
                    description: "dashboard.healthScoreDesc".localized
                )
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
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Tutorials View
    private var tutorialsView: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.accentGreen.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 24))
                        .foregroundColor(.accentGreen)
                }
                
                Text("more.imageTutorials".localized)
                    .font(.sectionTitle)
                    .foregroundColor(.textPrimary)
            }
            
            Text("more.imageTutorialsDescription".localized)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: Spacing.sm) {
                TutorialCategoryRow(
                    icon: "scissors",
                    title: "tutorials.careTutorials".localized,
                    description: "tutorials.careDescription".localized,
                    imageName: "Pflege-Tutorial"
                )
                
                TutorialCategoryRow(
                    icon: "fork.knife",
                    title: "tutorials.nutritionTutorials".localized,
                    description: "tutorials.nutritionDescription".localized,
                    imageName: "Ernährung-Tutorial"
                )
                
                TutorialCategoryRow(
                    icon: "figure.walk",
                    title: "tutorials.movementTraining".localized,
                    description: "tutorials.movementTrainingDesc".localized,
                    imageName: "Training-Tutorial"
                )
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
                .stroke(Color.accentGreen.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Gamification View
    private var gamificationView: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.accentOrange.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentOrange)
                }
                
                Text("gamification.title".localized)
                    .font(.sectionTitle)
                    .foregroundColor(.textPrimary)
            }
            
            Text("more.gamificationDescription".localized)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: Spacing.sm) {
                GamificationFeatureRow(
                    icon: "star.fill",
                    title: "Achievements",
                    description: "Erfolge freischalten: 30 Tage Medikamente, 100 Spaziergänge",
                    color: .accentOrange
                )
                
                GamificationFeatureRow(
                    icon: "flame.fill",
                    title: "Streaks",
                    description: "Tägliche Routinen aufrechterhalten - aktuelle Serie: 7 Tage",
                    color: .accentRed
                )
                
                GamificationFeatureRow(
                    icon: "medal.fill",
                    title: "Badges",
                    description: "Abzeichen sammeln: Pflege-Meister, Ernährungs-Experte",
                    color: .accentPurple
                )
                
                GamificationFeatureRow(
                    icon: "gift.fill",
                    title: "Belohnungen",
                    description: "Punkte sammeln und Belohnungen freischalten",
                    color: .accentGreen
                )
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
                .stroke(Color.accentOrange.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Resources View
    private var resourcesView: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.accentPurple.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "book.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentPurple)
                }
                
                Text("more.resourcesAndTips".localized)
                    .font(.sectionTitle)
                    .foregroundColor(.textPrimary)
            }
            
            Text("more.resourcesDescription".localized)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: Spacing.sm) {
                ResourceRow(
                    icon: "lightbulb.fill",
                    title: "resources.tipsAndTricks".localized,
                    description: "resources.tipsDescription".localized,
                    imageName: "Tipps-Guide"
                )
                
                ResourceRow(
                    icon: "doc.text.fill",
                    title: "resources.guides".localized,
                    description: "resources.guidesDescription".localized,
                    imageName: "Guides-Resource"
                )
                
                ResourceRow(
                    icon: "questionmark.circle.fill",
                    title: "resources.faqSupport".localized,
                    description: "resources.faqDescription".localized,
                    imageName: "FAQ-Support"
                )
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
                .stroke(Color.accentPurple.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Enums
enum MoreFeature: Identifiable {
    case dashboards
    case tutorials
    case gamification
    case resources
    
    var id: String {
        switch self {
        case .dashboards: return "dashboards"
        case .tutorials: return "tutorials"
        case .gamification: return "gamification"
        case .resources: return "resources"
        }
    }
}

// MARK: - Feature Card Content (für NavigationLink)
struct MoreFeatureCardContent: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 70, height: 70)
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
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
                .stroke(color.opacity(colorScheme == .dark ? 0.3 : 0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.15), radius: 8, x: 0, y: 4)
        .contentShape(Rectangle())
    }
}

// MARK: - Feature Card (für Button-Action)
struct MoreFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            MoreFeatureCardContent(
                icon: icon,
                title: title,
                description: description,
                color: color
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Dashboard Feature Row
struct DashboardFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .fill(
                        LinearGradient(
                            colors: [Color.brandPrimary.opacity(0.15), Color.brandPrimary.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.brandPrimary)
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
        }
        .padding(Spacing.md)
        .background(
            LinearGradient(
                colors: [Color.backgroundPrimary, Color.backgroundPrimary.opacity(0.5)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.brandPrimary.opacity(0.05), lineWidth: 1)
        )
    }
}

// MARK: - Tutorial Category Row
struct TutorialCategoryRow: View {
    let icon: String
    let title: String
    let description: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Bild
            if let image = UIImage(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .stroke(Color.accentGreen.opacity(0.2), lineWidth: 1)
                    )
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(
                            LinearGradient(
                                colors: [Color.accentGreen.opacity(0.15), Color.accentGreen.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                    
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.accentGreen)
                }
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
        .padding(Spacing.md)
        .background(
            LinearGradient(
                colors: [Color.backgroundPrimary, Color.backgroundPrimary.opacity(0.5)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.accentGreen.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Gamification Feature Row
struct GamificationFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
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
            
            Spacer()
        }
        .padding(Spacing.md)
        .background(Color.backgroundPrimary)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Resource Row
struct ResourceRow: View {
    let icon: String
    let title: String
    let description: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Bild
            if let image = UIImage(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .stroke(Color.accentPurple.opacity(0.2), lineWidth: 1)
                    )
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(
                            LinearGradient(
                                colors: [Color.accentPurple.opacity(0.15), Color.accentPurple.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                    
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.accentPurple)
                }
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
        .padding(Spacing.md)
        .background(
            LinearGradient(
                colors: [Color.backgroundPrimary, Color.backgroundPrimary.opacity(0.5)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(Color.accentPurple.opacity(0.1), lineWidth: 1)
        )
    }
}

