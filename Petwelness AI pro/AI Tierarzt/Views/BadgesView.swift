//
//  BadgesView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct BadgesView: View {
    @StateObject private var petManager = PetManager()
    @StateObject private var healthRecordManager = HealthRecordManager()
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Header
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "medal.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentPurple)
                        
                        Text("gamification.badges".localized)
                            .font(.appTitle)
                            .foregroundColor(.textPrimary)
                        
                        Text("gamification.collectBadges".localized)
                            .font(.bodyText)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Badges Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Spacing.md) {
                        // Pflege Badge
                        let groomingUnlocked = healthRecordManager.groomingRecords.count >= 10
                        BadgeItem(
                            icon: "scissors",
                            title: "badges.careMaster".localized,
                            isUnlocked: groomingUnlocked,
                            color: .accentGreen
                        )
                        
                        // Ernährung Badge
                        let feedingUnlocked = healthRecordManager.feedingRecords.count >= 50
                        BadgeItem(
                            icon: "fork.knife",
                            title: "badges.nutritionExpert".localized,
                            isUnlocked: feedingUnlocked,
                            color: .accentBlue
                        )
                        
                        // Aktivität Badge
                        let activityUnlocked = healthRecordManager.activities.count >= 50
                        BadgeItem(
                            icon: "figure.walk",
                            title: "badges.activityChampion".localized,
                            isUnlocked: activityUnlocked,
                            color: .accentOrange
                        )
                        
                        // Gesundheit Badge
                        let healthUnlocked = healthRecordManager.weightRecords.count >= 10
                        BadgeItem(
                            icon: "heart.fill",
                            title: "badges.healthPro".localized,
                            isUnlocked: healthUnlocked,
                            color: .accentRed
                        )
                        
                        // Medikamente Badge
                        let medicationUnlocked = healthRecordManager.medications.count >= 5
                        BadgeItem(
                            icon: "pills.fill",
                            title: "badges.medicationExpert".localized,
                            isUnlocked: medicationUnlocked,
                            color: .accentOrange
                        )
                        
                        // Impfungen Badge
                        let vaccinationUnlocked = healthRecordManager.vaccinations.filter({ $0.isCompleted }).count >= 3
                        BadgeItem(
                            icon: "syringe.fill",
                            title: "badges.vaccinationPro".localized,
                            isUnlocked: vaccinationUnlocked,
                            color: .accentPurple
                        )
                        
                        // Termine Badge
                        let appointmentUnlocked = healthRecordManager.appointments.filter({ $0.isCompleted }).count >= 5
                        BadgeItem(
                            icon: "calendar",
                            title: "badges.appointmentMaster".localized,
                            isUnlocked: appointmentUnlocked,
                            color: .accentBlue
                        )
                        
                        // Tagebuch Badge
                        let journalUnlocked = healthRecordManager.journalEntries.count >= 10
                        BadgeItem(
                            icon: "book.fill",
                            title: "achievements.journalWriter".localized,
                            isUnlocked: journalUnlocked,
                            color: .accentPurple
                        )
                        
                        // Haustiere Badge
                        let petsUnlocked = petManager.pets.count >= 3
                        BadgeItem(
                            icon: "pawprint.fill",
                            title: "badges.multiPet".localized,
                            isUnlocked: petsUnlocked,
                            color: .accentGreen
                        )
                    }
                    .padding(.horizontal, Spacing.xl)
                }
                .padding(.bottom, Spacing.xxl)
            }
        }
        .navigationTitle("gamification.badges".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

