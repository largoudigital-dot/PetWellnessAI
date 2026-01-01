//
//  StreaksView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct StreaksView: View {
    @StateObject private var healthRecordManager = HealthRecordManager()
    
    private var currentStreak: Int {
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
    
    private func calculateMedicationStreak() -> Int {
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        while true {
            let hasMedication = healthRecordManager.medications.contains { medication in
                Calendar.current.isDate(medication.startDate, inSameDayAs: currentDate)
            }
            
            if hasMedication {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func calculateFeedingStreak() -> Int {
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        while true {
            let hasFeeding = healthRecordManager.feedingRecords.contains { feeding in
                Calendar.current.isDate(feeding.time, inSameDayAs: currentDate)
            }
            
            if hasFeeding {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func calculateActivityStreak() -> Int {
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        while true {
            let hasActivity = healthRecordManager.activities.contains { activity in
                Calendar.current.isDate(activity.date, inSameDayAs: currentDate)
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
                        Image(systemName: "flame.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentRed)
                        
                        Text("streaks.title".localized)
                            .font(.appTitle)
                            .foregroundColor(.textPrimary)
                        
                        Text("streaks.subtitle".localized)
                            .font(.bodyText)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Streaks List
                    VStack(spacing: Spacing.md) {
                        // Tägliche Routine Streak
                        StreakRow(
                            icon: "flame.fill",
                            title: "streaks.dailyRoutine".localized,
                            description: "\(currentStreak) " + "streaks.daysInRow".localized,
                            currentStreak: currentStreak,
                            bestStreak: max(currentStreak, UserDefaults.standard.integer(forKey: "best_streak")),
                            color: .accentRed
                        )
                        
                        // Medikamente Streak
                        let medicationStreak = calculateMedicationStreak()
                        StreakRow(
                            icon: "pills.fill",
                            title: "streaks.medications".localized,
                            description: "\(medicationStreak) " + "streaks.daysInRow".localized,
                            currentStreak: medicationStreak,
                            bestStreak: max(medicationStreak, UserDefaults.standard.integer(forKey: "best_medication_streak")),
                            color: .accentOrange
                        )
                        
                        // Fütterungen Streak
                        let feedingStreak = calculateFeedingStreak()
                        StreakRow(
                            icon: "fork.knife",
                            title: "streaks.feedings".localized,
                            description: "\(feedingStreak) " + "streaks.daysInRow".localized,
                            currentStreak: feedingStreak,
                            bestStreak: max(feedingStreak, UserDefaults.standard.integer(forKey: "best_feeding_streak")),
                            color: .accentBlue
                        )
                        
                        // Aktivitäten Streak
                        let activityStreak = calculateActivityStreak()
                        StreakRow(
                            icon: "figure.walk",
                            title: "streaks.activities".localized,
                            description: "\(activityStreak) " + "streaks.daysInRow".localized,
                            currentStreak: activityStreak,
                            bestStreak: max(activityStreak, UserDefaults.standard.integer(forKey: "best_activity_streak")),
                            color: .accentGreen
                        )
                    }
                    .padding(.horizontal, Spacing.xl)
                }
                .padding(.bottom, Spacing.xxl)
            }
        }
        .navigationTitle("streaks.title".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

