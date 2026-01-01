//
//  AchievementsView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct AchievementsView: View {
    @StateObject private var healthRecordManager = HealthRecordManager()
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Header
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentOrange)
                        
                        Text("gamification.achievements".localized)
                            .font(.appTitle)
                            .foregroundColor(.textPrimary)
                        
                        Text("gamification.unlockAchievements".localized)
                            .font(.bodyText)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Achievements List
                    VStack(spacing: Spacing.md) {
                        // Medikamente Achievement
                        let medicationDays = Set(healthRecordManager.medications.map { Calendar.current.startOfDay(for: $0.startDate) }).count
                        let medicationProgress = min(1.0, Double(medicationDays) / 30.0)
                        AchievementRow(
                            icon: "pills.fill",
                            title: "achievements.medicationMaster".localized,
                            description: "achievements.medicationMasterDesc".localized,
                            progress: medicationProgress,
                            isUnlocked: medicationDays >= 30,
                            color: .accentOrange
                        )
                        
                        // Aktivitäten Achievement
                        let activityCount = healthRecordManager.activities.count
                        let activityProgress = min(1.0, Double(activityCount) / 100.0)
                        AchievementRow(
                            icon: "figure.walk",
                            title: "achievements.walkChampion".localized,
                            description: "achievements.walkChampionDesc".localized,
                            progress: activityProgress,
                            isUnlocked: activityCount >= 100,
                            color: .accentGreen
                        )
                        
                        // Gesundheitschecks Achievement
                        let healthCheckCount = healthRecordManager.weightRecords.count + healthRecordManager.symptoms.count
                        let healthProgress = min(1.0, Double(healthCheckCount) / 50.0)
                        AchievementRow(
                            icon: "heart.fill",
                            title: "achievements.healthExpert".localized,
                            description: "achievements.healthExpertDesc".localized,
                            progress: healthProgress,
                            isUnlocked: healthCheckCount >= 50,
                            color: .accentRed
                        )
                        
                        // Fütterungen Achievement
                        let feedingDays = Set(healthRecordManager.feedingRecords.map { Calendar.current.startOfDay(for: $0.time) }).count
                        let feedingProgress = min(1.0, Double(feedingDays) / 30.0)
                        AchievementRow(
                            icon: "fork.knife",
                            title: "achievements.nutritionMaster".localized,
                            description: "achievements.nutritionMasterDesc".localized,
                            progress: feedingProgress,
                            isUnlocked: feedingDays >= 30,
                            color: .accentBlue
                        )
                        
                        // Termine Achievement
                        let appointmentCount = healthRecordManager.appointments.filter { $0.isCompleted }.count
                        let appointmentProgress = min(1.0, Double(appointmentCount) / 10.0)
                        AchievementRow(
                            icon: "calendar",
                            title: "achievements.appointmentPro".localized,
                            description: "achievements.appointmentProDesc".localized,
                            progress: appointmentProgress,
                            isUnlocked: appointmentCount >= 10,
                            color: .accentPurple
                        )
                        
                        // Impfungen Achievement
                        let vaccinationCount = healthRecordManager.vaccinations.filter { $0.isCompleted }.count
                        let vaccinationProgress = min(1.0, Double(vaccinationCount) / 5.0)
                        AchievementRow(
                            icon: "syringe.fill",
                            title: "achievements.vaccinationMaster".localized,
                            description: "achievements.vaccinationMasterDesc".localized,
                            progress: vaccinationProgress,
                            isUnlocked: vaccinationCount >= 5,
                            color: .accentPurple
                        )
                        
                        // Tagebuch Achievement
                        let journalCount = healthRecordManager.journalEntries.count
                        let journalProgress = min(1.0, Double(journalCount) / 20.0)
                        AchievementRow(
                            icon: "book.fill",
                            title: "achievements.journalWriter".localized,
                            description: "achievements.journalWriterDesc".localized,
                            progress: journalProgress,
                            isUnlocked: journalCount >= 20,
                            color: .accentBlue
                        )
                        
                        // Fotos Achievement
                        let photoCount = healthRecordManager.photos.count
                        let photoProgress = min(1.0, Double(photoCount) / 50.0)
                        AchievementRow(
                            icon: "photo.fill",
                            title: "achievements.photoCollector".localized,
                            description: "achievements.photoCollectorDesc".localized,
                            progress: photoProgress,
                            isUnlocked: photoCount >= 50,
                            color: .accentGreen
                        )
                    }
                    .padding(.horizontal, Spacing.xl)
                }
                .padding(.bottom, Spacing.xxl)
            }
        }
        .navigationTitle("gamification.achievements".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

