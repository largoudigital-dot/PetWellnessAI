//
//  GuideDetailView.swift
//  AI Tierarzt
//
//  Created for Guide Detail Views with content and images
//

import SwiftUI

struct GuideDetailView: View {
    let guideType: ResourcesView.GuideType
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
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
                        // Content Sections
                        VStack(spacing: Spacing.lg) {
                            ForEach(guideSteps, id: \.id) { step in
                                GuideStepCard(step: step)
                            }
                        }
                        .padding(.horizontal, isIPad ? Spacing.xxl : Spacing.xl)
                        .padding(.top, Spacing.md)
                    }
                    .padding(.bottom, Spacing.xxl)
                }
            }
            .navigationTitle(guideTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.brandPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    private var guideTitle: String {
        switch guideType {
        case .firstSteps:
            return "resources.firstSteps".localized
        case .healthGuide:
            return "resources.healthGuide".localized
        case .careGuide:
            return "resources.careGuide".localized
        }
    }
    
    private var guideSteps: [GuideStep] {
        switch guideType {
        case .firstSteps:
            return [
                GuideStep(id: 1, title: "resources.firstSteps.step1".localized, description: "resources.firstSteps.step1Desc".localized, imageName: nil),
                GuideStep(id: 2, title: "resources.firstSteps.step2".localized, description: "resources.firstSteps.step2Desc".localized, imageName: nil),
                GuideStep(id: 3, title: "resources.firstSteps.step3".localized, description: "resources.firstSteps.step3Desc".localized, imageName: nil),
                GuideStep(id: 4, title: "resources.firstSteps.step4".localized, description: "resources.firstSteps.step4Desc".localized, imageName: nil),
                GuideStep(id: 5, title: "resources.firstSteps.step5".localized, description: "resources.firstSteps.step5Desc".localized, imageName: nil),
                GuideStep(id: 6, title: "resources.firstSteps.step6".localized, description: "resources.firstSteps.step6Desc".localized, imageName: nil),
                GuideStep(id: 7, title: "resources.firstSteps.step7".localized, description: "resources.firstSteps.step7Desc".localized, imageName: nil),
                GuideStep(id: 8, title: "resources.firstSteps.step8".localized, description: "resources.firstSteps.step8Desc".localized, imageName: nil),
                GuideStep(id: 9, title: "resources.firstSteps.step9".localized, description: "resources.firstSteps.step9Desc".localized, imageName: nil),
                GuideStep(id: 10, title: "resources.firstSteps.step10".localized, description: "resources.firstSteps.step10Desc".localized, imageName: nil),
                GuideStep(id: 11, title: "resources.firstSteps.step11".localized, description: "resources.firstSteps.step11Desc".localized, imageName: nil),
                GuideStep(id: 12, title: "resources.firstSteps.step12".localized, description: "resources.firstSteps.step12Desc".localized, imageName: nil)
            ]
        case .healthGuide:
            return [
                GuideStep(id: 1, title: "resources.healthGuide.step1".localized, description: "resources.healthGuide.step1Desc".localized, imageName: nil),
                GuideStep(id: 2, title: "resources.healthGuide.step2".localized, description: "resources.healthGuide.step2Desc".localized, imageName: nil),
                GuideStep(id: 3, title: "resources.healthGuide.step3".localized, description: "resources.healthGuide.step3Desc".localized, imageName: nil),
                GuideStep(id: 4, title: "resources.healthGuide.step4".localized, description: "resources.healthGuide.step4Desc".localized, imageName: nil),
                GuideStep(id: 5, title: "resources.healthGuide.step5".localized, description: "resources.healthGuide.step5Desc".localized, imageName: nil),
                GuideStep(id: 6, title: "resources.healthGuide.step6".localized, description: "resources.healthGuide.step6Desc".localized, imageName: nil),
                GuideStep(id: 7, title: "resources.healthGuide.step7".localized, description: "resources.healthGuide.step7Desc".localized, imageName: nil),
                GuideStep(id: 8, title: "resources.healthGuide.step8".localized, description: "resources.healthGuide.step8Desc".localized, imageName: nil),
                GuideStep(id: 9, title: "resources.healthGuide.step9".localized, description: "resources.healthGuide.step9Desc".localized, imageName: nil),
                GuideStep(id: 10, title: "resources.healthGuide.step10".localized, description: "resources.healthGuide.step10Desc".localized, imageName: nil),
                GuideStep(id: 11, title: "resources.healthGuide.step11".localized, description: "resources.healthGuide.step11Desc".localized, imageName: nil),
                GuideStep(id: 12, title: "resources.healthGuide.step12".localized, description: "resources.healthGuide.step12Desc".localized, imageName: nil),
                GuideStep(id: 13, title: "resources.healthGuide.step13".localized, description: "resources.healthGuide.step13Desc".localized, imageName: nil),
                GuideStep(id: 14, title: "resources.healthGuide.step14".localized, description: "resources.healthGuide.step14Desc".localized, imageName: nil),
                GuideStep(id: 15, title: "resources.healthGuide.step15".localized, description: "resources.healthGuide.step15Desc".localized, imageName: nil),
                GuideStep(id: 16, title: "resources.healthGuide.step16".localized, description: "resources.healthGuide.step16Desc".localized, imageName: nil),
                GuideStep(id: 17, title: "resources.healthGuide.step17".localized, description: "resources.healthGuide.step17Desc".localized, imageName: nil),
                GuideStep(id: 18, title: "resources.healthGuide.step18".localized, description: "resources.healthGuide.step18Desc".localized, imageName: nil)
            ]
        case .careGuide:
            return [
                GuideStep(id: 1, title: "resources.careGuide.step1".localized, description: "resources.careGuide.step1Desc".localized, imageName: nil),
                GuideStep(id: 2, title: "resources.careGuide.step2".localized, description: "resources.careGuide.step2Desc".localized, imageName: nil),
                GuideStep(id: 3, title: "resources.careGuide.step3".localized, description: "resources.careGuide.step3Desc".localized, imageName: nil),
                GuideStep(id: 4, title: "resources.careGuide.step4".localized, description: "resources.careGuide.step4Desc".localized, imageName: nil),
                GuideStep(id: 5, title: "resources.careGuide.step5".localized, description: "resources.careGuide.step5Desc".localized, imageName: nil),
                GuideStep(id: 6, title: "resources.careGuide.step6".localized, description: "resources.careGuide.step6Desc".localized, imageName: nil),
                GuideStep(id: 7, title: "resources.careGuide.step7".localized, description: "resources.careGuide.step7Desc".localized, imageName: nil),
                GuideStep(id: 8, title: "resources.careGuide.step8".localized, description: "resources.careGuide.step8Desc".localized, imageName: nil),
                GuideStep(id: 9, title: "resources.careGuide.step9".localized, description: "resources.careGuide.step9Desc".localized, imageName: nil),
                GuideStep(id: 10, title: "resources.careGuide.step10".localized, description: "resources.careGuide.step10Desc".localized, imageName: nil),
                GuideStep(id: 11, title: "resources.careGuide.step11".localized, description: "resources.careGuide.step11Desc".localized, imageName: nil),
                GuideStep(id: 12, title: "resources.careGuide.step12".localized, description: "resources.careGuide.step12Desc".localized, imageName: nil),
                GuideStep(id: 13, title: "resources.careGuide.step13".localized, description: "resources.careGuide.step13Desc".localized, imageName: nil),
                GuideStep(id: 14, title: "resources.careGuide.step14".localized, description: "resources.careGuide.step14Desc".localized, imageName: nil),
                GuideStep(id: 15, title: "resources.careGuide.step15".localized, description: "resources.careGuide.step15Desc".localized, imageName: nil)
            ]
        }
    }
}

// MARK: - Guide Step Model
struct GuideStep: Identifiable {
    let id: Int
    let title: String
    let description: String
    let imageName: String? // Optional, da Bilder nicht mehr angezeigt werden
}

// MARK: - Guide Step Card
struct GuideStepCard: View {
    let step: GuideStep
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Step Number Badge
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: isIPad ? 40 : 32, height: isIPad ? 40 : 32)
                    
                    Text("\(step.id)")
                        .font(.system(size: isIPad ? 18 : 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text(step.title)
                    .font(.system(size: isIPad ? 20 : 18, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            // Description
            Text(step.description)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 8, x: 0, y: 4)
    }
}

