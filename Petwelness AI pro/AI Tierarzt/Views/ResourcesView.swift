//
//  ResourcesView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct ResourcesView: View {
    @State private var selectedResource: ResourceType?
    @State private var selectedGuide: GuideType?
    @State private var showCitations = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    enum ResourceType {
        case tips
        case guides
        case faq
    }
    
    enum GuideType: String, Identifiable {
        case firstSteps
        case healthGuide
        case careGuide
        
        var id: String { rawValue }
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
                        // Prominenter medizinischer Disclaimer Banner
                        medicalDisclaimerBanner
                            .padding(.top, isIPad ? Spacing.lg : Spacing.md)
                        
                        // Resource Categories
                        VStack(spacing: Spacing.lg) {
                            ResourceCategoryCard(
                                type: .tips,
                                icon: "lightbulb.fill",
                                title: "resources.tipsAndTricks".localized,
                                description: "resources.tipsDescription".localized,
                                imageName: "Tipps-Guide",
                                color: .accentYellow
                            ) {
                                selectedResource = .tips
                            }
                            
                            ResourceCategoryCard(
                                type: .guides,
                                icon: "doc.text.fill",
                                title: "resources.guides".localized,
                                description: "resources.guidesDescription".localized,
                                imageName: "Guides-Resource",
                                color: .accentBlue
                            ) {
                                selectedResource = .guides
                            }
                            
                            ResourceCategoryCard(
                                type: .faq,
                                icon: "questionmark.circle.fill",
                                title: "resources.faqSupport".localized,
                                description: "resources.faqDescription".localized,
                                imageName: "FAQ-Support",
                                color: .accentPurple
                            ) {
                                selectedResource = .faq
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.md)
                        
                        // Banner Ad zwischen Haupt-Kategorien und FAQ-Bereich
                        if AdManager.shared.shouldShowBannerAds {
                            BannerAdView()
                                .frame(height: 50)
                                .padding(.horizontal, Spacing.xl)
                                .padding(.vertical, Spacing.md)
                        }
                        
                        // Selected Resource Details
                        if let resource = selectedResource {
                            resourceDetailView(for: resource)
                                .padding(.horizontal, Spacing.xl)
                        }
                    }
                    .padding(.bottom, Spacing.xxl)
                }
            }
        }
        .fullScreenCover(item: $selectedGuide) { guide in
            GuideDetailView(guideType: guide)
        }
        .sheet(isPresented: $showCitations) {
            MedicalCitationsView()
                .environmentObject(localizationManager)
        }
    }
    
    // Prominenter medizinischer Disclaimer Banner
    private var medicalDisclaimerBanner: some View {
        VStack(spacing: isIPad ? 6 : 4) {
            HStack(spacing: isIPad ? 8 : 6) {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.system(size: isIPad ? 18 : 14, weight: .semibold))
                    .foregroundColor(.accentRed)
                
                Text("disclaimer.medical".localized)
                    .font(.system(size: isIPad ? 16 : 12, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .id(localizationManager.currentLanguage)
            }
            
            Text("disclaimer.medicalText".localized)
                .font(.system(size: isIPad ? 14 : 11))
                .foregroundColor(.textPrimary.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(isIPad ? 4 : 2)
                .id(localizationManager.currentLanguage)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, isIPad ? Spacing.lg : Spacing.md)
        .padding(.vertical, isIPad ? Spacing.md : Spacing.sm)
        .background(Color.accentRed.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 12 : 8)
                .stroke(Color.accentRed.opacity(0.3), lineWidth: isIPad ? 2 : 1.5)
        )
        .padding(.horizontal, isIPad ? Spacing.md : Spacing.sm)
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
            Text("resources.title".localized)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            // Citations-Button (prominent platziert)
            Button(action: {
                showCitations = true
            }) {
                HStack(spacing: isIPad ? 6 : 4) {
                    Image(systemName: "book.fill")
                        .font(.system(size: isIPad ? 20 : 16, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                    if isIPad {
                        Text("citations.title".localized)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.brandPrimary)
                    }
                }
            }
            .frame(width: isIPad ? 120 : 44, height: isIPad ? 44 : 32)
            .contentShape(Rectangle())
            .buttonStyle(PlainButtonStyle())
            .id(localizationManager.currentLanguage)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, 12)
        .frame(height: 44)
        .background(Color.backgroundPrimary)
    }
    
    @ViewBuilder
    private func resourceDetailView(for resource: ResourceType) -> some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Divider()
                .padding(.vertical, Spacing.md)
            
            switch resource {
            case .tips:
                tipsView
            case .guides:
                guidesView
            case .faq:
                faqView
            }
        }
    }
    
    // MARK: - Tips View
    private var tipsView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("resources.tipsAndTricks".localized)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.bottom, Spacing.sm)
            
            // Top Tips Header
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.accentYellow)
                    .font(.system(size: 18))
                Text("resources.topTips".localized)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            .padding(.bottom, Spacing.sm)
            
            VStack(spacing: Spacing.md) {
                ResourceTipRowWithImage(
                    icon: "heart.fill",
                    title: "resources.health".localized,
                    tips: [
                        "resources.healthTip1".localized,
                        "resources.healthTip2".localized,
                        "resources.healthTip3".localized
                    ],
                    color: Color.accentRed,
                    imageName: ""
                )
                
                ResourceTipRowWithImage(
                    icon: "fork.knife",
                    title: "resources.nutrition".localized,
                    tips: [
                        "resources.nutritionTip1".localized,
                        "resources.nutritionTip2".localized,
                        "resources.nutritionTip3".localized
                    ],
                    color: Color.accentBlue,
                    imageName: ""
                )
                
                ResourceTipRowWithImage(
                    icon: "figure.walk",
                    title: "resources.activity".localized,
                    tips: [
                        "resources.activityTip1".localized,
                        "resources.activityTip2".localized,
                        "resources.activityTip3".localized
                    ],
                    color: Color.accentGreen,
                    imageName: ""
                )
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
    
    // MARK: - Guides View
    private var guidesView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("resources.guides".localized)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.bottom, Spacing.sm)
            
            VStack(spacing: Spacing.md) {
                Button(action: {
                    selectedGuide = .firstSteps
                }) {
                    GuideRow(
                        icon: "book.fill",
                        title: "resources.firstSteps".localized,
                        description: "resources.firstStepsDesc".localized,
                        steps: 12,
                        color: Color.accentBlue
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    selectedGuide = .healthGuide
                }) {
                    GuideRow(
                        icon: "heart.text.square.fill",
                        title: "resources.healthGuide".localized,
                        description: "resources.healthGuideDesc".localized,
                        steps: 18,
                        color: Color.accentRed
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    selectedGuide = .careGuide
                }) {
                    GuideRow(
                        icon: "scissors",
                        title: "resources.careGuide".localized,
                        description: "resources.careGuideDesc".localized,
                        steps: 15,
                        color: Color.accentGreen
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
    
    // MARK: - FAQ View
    private var faqView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("resources.faqSupport".localized)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.bottom, Spacing.sm)
            
            VStack(spacing: Spacing.md) {
                FAQRow(
                    question: "resources.faq1".localized,
                    answer: "resources.faq1Answer".localized,
                    color: Color.accentPurple
                )
                
                FAQRow(
                    question: "resources.faq2".localized,
                    answer: "resources.faq2Answer".localized,
                    color: Color.accentPurple
                )
                
                FAQRow(
                    question: "resources.faq3".localized,
                    answer: "resources.faq3Answer".localized,
                    color: Color.accentPurple
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

// MARK: - Resource Category Card
struct ResourceCategoryCard: View {
    let type: ResourcesView.ResourceType
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

// MARK: - Resource Tip Row
struct ResourceTipRow: View {
    let icon: String
    let title: String
    let tips: [String]
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
                
                Text(title)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: Spacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(color)
                        
                        Text(tip)
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

// MARK: - Resource Tip Row With Image
struct ResourceTipRowWithImage: View {
    let icon: String
    let title: String
    let tips: [String]
    let color: Color
    let imageName: String
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
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
                
                Text(title)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: Spacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(color)
                        
                        Text(tip)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Guide Row
struct GuideRow: View {
    let icon: String
    let title: String
    let description: String
    let steps: Int
    let color: Color
    
    var body: some View {
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
                
                Text("\(steps) " + "resources.steps".localized)
                    .font(.caption)
                    .foregroundColor(color)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
}

// MARK: - FAQ Row
struct FAQRow: View {
    let question: String
    let answer: String
    let color: Color
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: Spacing.md) {
                    // Icon in farbigem Quadrat
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color.opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(color)
                    }
                    
                    Text(question)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.textTertiary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(answer)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .padding(.leading, 66)
                    .transition(.opacity)
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
}

