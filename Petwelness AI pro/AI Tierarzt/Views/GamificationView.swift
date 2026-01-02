//
//  GamificationView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct GamificationView: View {
    @StateObject private var petManager = PetManager()
    @StateObject private var healthRecordManager = HealthRecordManager()
    @Environment(\.dismiss) var dismiss
    
    enum GamificationFeature {
        case achievements
        case streaks
        case badges
        case rewards
    }
    
    var body: some View {
        NavigationStack {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header mit Back-Button
                    headerView
                        .padding(.top, 8)
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Header
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentOrange)
                        
                                Text("gamification.title".localized)
                            .font(.appTitle)
                            .foregroundColor(.textPrimary)
                        
                                Text("gamification.subtitle".localized)
                            .font(.bodyText)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.xl)
                    
                    // Current Stats
                    currentStatsCard
                    
                    // Banner Ad unter "Votre progression" Box vor "Succès" Liste
                    if AdManager.shared.shouldShowBannerAds {
                        BannerAdView()
                            .frame(height: 50)
                            .padding(.horizontal, Spacing.xl)
                            .padding(.vertical, Spacing.md)
                    }
                    
                    // Features
                    VStack(spacing: Spacing.lg) {
                                NavigationLink(destination: AchievementsView()) {
                                    GamificationFeatureCardContent(
                            icon: "star.fill",
                                        title: "gamification.achievements".localized,
                                        description: "gamification.unlockAchievements".localized,
                            color: .accentOrange
                                    )
                        }
                        
                                NavigationLink(destination: StreaksView()) {
                                    GamificationFeatureCardContent(
                            icon: "flame.fill",
                                        title: "streaks.title".localized,
                                        description: "streaks.subtitle".localized,
                            color: .accentRed
                                    )
                        }
                        
                                NavigationLink(destination: BadgesView()) {
                                    GamificationFeatureCardContent(
                            icon: "medal.fill",
                                        title: "gamification.badges".localized,
                                        description: "gamification.collectBadges".localized,
                            color: .accentPurple
                                    )
                        }
                        
                                NavigationLink(destination: RewardsView()) {
                                    GamificationFeatureCardContent(
                            icon: "gift.fill",
                                        title: "rewards.title".localized,
                                        description: "gamification.collectPoints".localized,
                            color: .accentGreen
                                    )
                        }
                    }
                            .padding(.horizontal, Spacing.xl)
                        }
                        .padding(.bottom, Spacing.xxl)
                    }
                }
            }
            .navigationBarHidden(true)
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
            Text("gamification.title".localized)
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
    
    // MARK: - Calculated Stats
    
    private var totalAchievements: Int {
        var count = 0
        
        // Medikamente Achievement
        let medicationDays = Set(healthRecordManager.medications.map { Calendar.current.startOfDay(for: $0.startDate) }).count
        if medicationDays >= 30 { count += 1 }
        
        // Aktivitäten Achievement
        let activityCount = healthRecordManager.activities.count
        if activityCount >= 100 { count += 1 }
        
        // Gesundheitschecks Achievement
        let healthCheckCount = healthRecordManager.weightRecords.count + healthRecordManager.symptoms.count
        if healthCheckCount >= 50 { count += 1 }
        
        // Fütterungen Achievement
        let feedingDays = Set(healthRecordManager.feedingRecords.map { Calendar.current.startOfDay(for: $0.time) }).count
        if feedingDays >= 30 { count += 1 }
        
        // Termine Achievement
        let appointmentCount = healthRecordManager.appointments.filter { $0.isCompleted }.count
        if appointmentCount >= 10 { count += 1 }
        
        // Impfungen Achievement
        let vaccinationCount = healthRecordManager.vaccinations.filter { $0.isCompleted }.count
        if vaccinationCount >= 5 { count += 1 }
        
        // Tagebuch Achievement
        let journalCount = healthRecordManager.journalEntries.count
        if journalCount >= 20 { count += 1 }
        
        // Fotos Achievement
        let photoCount = healthRecordManager.photos.count
        if photoCount >= 50 { count += 1 }
        
        // Haustiere Achievement
        if petManager.pets.count >= 3 { count += 1 }
        
        // Konsultationen Achievement
        let consultationCount = healthRecordManager.consultations.count
        if consultationCount >= 5 { count += 1 }
        
        // Pflege Achievement
        let groomingCount = healthRecordManager.groomingRecords.count
        if groomingCount >= 20 { count += 1 }
        
        // Übungen Achievement
        let exerciseCount = healthRecordManager.exerciseRecords.count
        if exerciseCount >= 30 { count += 1 }
        
        return count
    }
    
    private var currentStreak: Int {
        // Berechne aktuellen Streak basierend auf täglichen Aktivitäten
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
    
    private var totalBadges: Int {
        var count = 0
        
        // Pflege Badge
        if healthRecordManager.groomingRecords.count >= 10 { count += 1 }
        
        // Ernährung Badge
        if healthRecordManager.feedingRecords.count >= 50 { count += 1 }
        
        // Aktivität Badge
        if healthRecordManager.activities.count >= 50 { count += 1 }
        
        // Gesundheit Badge
        if healthRecordManager.weightRecords.count >= 10 { count += 1 }
        
        // Medikamente Badge
        if healthRecordManager.medications.count >= 5 { count += 1 }
        
        // Impfungen Badge
        if healthRecordManager.vaccinations.filter({ $0.isCompleted }).count >= 3 { count += 1 }
        
        // Termine Badge
        if healthRecordManager.appointments.filter({ $0.isCompleted }).count >= 5 { count += 1 }
        
        // Tagebuch Badge
        if healthRecordManager.journalEntries.count >= 10 { count += 1 }
        
        return count
    }
    
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
        
        // Bonus für Streaks
        points += currentStreak * 5
        
        return points
    }
    
    // MARK: - Current Stats Card
    private var currentStatsCard: some View {
        VStack(spacing: Spacing.md) {
            Text("gamification.yourProgress".localized)
                .font(.sectionTitle)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.xs) {
                    Text("\(totalAchievements)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.accentOrange)
                    
                    Text("gamification.achievements".localized)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                VStack(spacing: Spacing.xs) {
                    Text("\(currentStreak)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.accentRed)
                    
                    Text("gamification.daysStreak".localized)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                VStack(spacing: Spacing.xs) {
                    Text("\(totalBadges)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.accentPurple)
                    
                    Text("gamification.badges".localized)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                VStack(spacing: Spacing.xs) {
                    Text("\(totalPoints)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.accentGreen)
                    
                    Text("gamification.points".localized)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
        .padding(.horizontal, Spacing.xl)
    }
    
}

// MARK: - Gamification Feature Card Content
struct GamificationFeatureCardContent: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28))
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
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.lg)
            .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Achievement Row
struct AchievementRow: View {
    let icon: String
    let title: String
    let description: String
    let progress: Double
    let isUnlocked: Bool
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(isUnlocked ? color.opacity(0.15) : Color.textTertiary.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(isUnlocked ? color : .textTertiary)
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
                
                if isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentGreen)
                }
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.textTertiary.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            
            Text("\(Int(progress * 100))" + " " + "gamification.percentComplete".localized)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundTertiary)
        )
    }
}

// MARK: - Streak Row
struct StreakRow: View {
    let icon: String
    let title: String
    let description: String
    let currentStreak: Int
    let bestStreak: Int
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
            
            VStack(alignment: .trailing, spacing: Spacing.xs) {
                Text("\(currentStreak) 🔥")
                    .font(.bodyTextBold)
                    .foregroundColor(color)
                
                Text("gamification.best".localized + " \(bestStreak)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundTertiary)
        )
    }
}

// MARK: - Badge Item
struct BadgeItem: View {
    let icon: String
    let title: String
    let isUnlocked: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color.opacity(0.15) : Color.textTertiary.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(isUnlocked ? color : .textTertiary)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.accentGreen)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundTertiary)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Reward Row
struct RewardRow: View {
    let icon: String
    let title: String
    let description: String
    let points: Int
    let currentPoints: Int
    let color: Color
    
    var canAfford: Bool {
        currentPoints >= points
    }
    
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
            
            Button(action: {}) {
                Text("gamification.redeem".localized)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.xs)
                    .background(canAfford ? color : Color.textTertiary)
                    .cornerRadius(CornerRadius.small)
                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 2)
            }
            .disabled(!canAfford)
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundTertiary)
        )
    }
}
