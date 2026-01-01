//
//  RewardsView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct RewardsView: View {
    @StateObject private var petManager = PetManager()
    @StateObject private var healthRecordManager = HealthRecordManager()
    
    private var totalPoints: Int {
        var points = 0
        
        // Punkte für verschiedene Aktivitäten
        points += healthRecordManager.medications.count * 5
        points += healthRecordManager.feedingRecords.count * 2
        points += healthRecordManager.activities.count * 3
        points += healthRecordManager.weightRecords.count * 5
        points += healthRecordManager.vaccinations.filter { $0.isCompleted }.count * 10
        points += healthRecordManager.appointments.filter { $0.isCompleted }.count * 8
        points += healthRecordManager.journalEntries.count * 3
        points += healthRecordManager.photos.count * 2
        points += healthRecordManager.groomingRecords.count * 4
        points += healthRecordManager.exerciseRecords.count * 3
        points += petManager.pets.count * 20
        
        // Streak Bonus
        let currentStreak = calculateCurrentStreak()
        points += currentStreak * 5
        
        return points
    }
    
    private func calculateCurrentStreak() -> Int {
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        while true {
            let hasActivity = healthRecordManager.medications.contains { medication in
                Calendar.current.isDate(medication.startDate, inSameDayAs: currentDate)
            } || healthRecordManager.feedingRecords.contains { feeding in
                Calendar.current.isDate(feeding.time, inSameDayAs: currentDate)
            } || healthRecordManager.activities.contains { activity in
                Calendar.current.isDate(activity.date, inSameDayAs: currentDate)
            } || healthRecordManager.weightRecords.contains { weight in
                Calendar.current.isDate(weight.date, inSameDayAs: currentDate)
            }
            
            if hasActivity {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Header
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "gift.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentGreen)
                        
                        Text("rewards.title".localized)
                            .font(.appTitle)
                            .foregroundColor(.textPrimary)
                        
                        Text("rewards.collectAndUnlock".localized)
                            .font(.bodyText)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Current Points
                    VStack(spacing: Spacing.md) {
                        Text("rewards.yourPoints".localized)
                            .font(.sectionTitle)
                            .foregroundColor(.textPrimary)
                        
                        Text("\(totalPoints)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.accentGreen)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.backgroundSecondary)
                    )
                    .padding(.horizontal, Spacing.xl)
                    
                    // Info Card
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.accentBlue)
                        
                        Text("rewards.pointsSystem".localized)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("rewards.pointsDescription".localized)
                            .font(.bodyText)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.md)
                        
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentGreen)
                                Text("rewards.medicationPoints".localized)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentGreen)
                                Text("rewards.feedingPoints".localized)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentGreen)
                                Text("rewards.activityPoints".localized)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentGreen)
                                Text("rewards.weightPoints".localized)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentGreen)
                                Text("rewards.dailyStreakPoints".localized)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .padding(.top, Spacing.sm)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.backgroundSecondary)
                    )
                    .padding(.horizontal, Spacing.xl)
                }
                .padding(.bottom, Spacing.xxl)
            }
        }
        .navigationTitle("Belohnungen")
        .navigationBarTitleDisplayMode(.inline)
    }
}

