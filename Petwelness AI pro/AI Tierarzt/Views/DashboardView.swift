//
//  DashboardView.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var petManager = PetManager()
    @StateObject private var healthRecordManager = HealthRecordManager()
    @State private var selectedTimeframe: Timeframe = .today
    @Environment(\.dismiss) var dismiss
    
    enum Timeframe: String, CaseIterable {
        case today
        case week
        case month
        case year
        
        var localizedName: String {
            switch self {
            case .today:
                return "dashboard.today".localized
            case .week:
                return "dashboard.thisWeek".localized
            case .month:
                return "dashboard.thisMonth".localized
            case .year:
                return "dashboard.thisYear".localized
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header mit Back-Button
                headerView
                    .padding(.top, 8)
                
                if petManager.pets.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: Spacing.xl) {
                            // Timeframe Selector
                            Picker("dashboard.timeframe".localized, selection: $selectedTimeframe) {
                                ForEach(Timeframe.allCases, id: \.self) { timeframe in
                                    Text(timeframe.localizedName).tag(timeframe)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal, Spacing.xl)
                            .padding(.top, Spacing.md)
                            
                            // Health Score Card
                            healthScoreCard
                            
                            // Quick Stats
                            quickStatsGrid
                            
                            // Today's Overview
                            todaysOverviewCard
                            
                            // Trends & Statistics
                            trendsCard
                            
                            // Reminders
                            remindersCard
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xxl)
                    }
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
            Text("dashboard.title".localized)
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
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 60))
                .foregroundColor(.brandPrimary)
            
            Text("dashboard.noPets".localized)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text("dashboard.addPetToSee".localized)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Health Score
    private var healthScore: Int {
        // Berechne Health Score basierend auf verschiedenen Faktoren
        var score = 100
        
        // Reduziere Score basierend auf Symptomen
        let recentSymptoms = healthRecordManager.symptoms.filter { symptom in
            Calendar.current.isDate(symptom.date, inSameDayAs: Date()) ||
            Calendar.current.isDate(symptom.date, equalTo: Date(), toGranularity: .day)
        }
        score -= recentSymptoms.count * 5
        
        // Reduziere Score wenn Medikamente fehlen
        let missedMedications = healthRecordManager.medications.filter { medication in
            medication.isActive && medication.startDate < Date()
        }
        if missedMedications.isEmpty {
            score -= 10
        }
        
        // Reduziere Score wenn keine Aktivität heute
        let todayActivities = healthRecordManager.activities.filter { activity in
            Calendar.current.isDateInToday(activity.date)
        }
        if todayActivities.isEmpty {
            score -= 5
        }
        
        return max(0, min(100, score))
    }
    
    // MARK: - Health Score Card
    private var healthScoreCard: some View {
        let score = healthScore
        let progress = Double(score) / 100.0
        
        return VStack(spacing: Spacing.md) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentRed)
                
                Text("health.score".localized)
                    .font(.sectionTitle)
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            ZStack {
                Circle()
                    .stroke(Color.accentRed.opacity(0.2), lineWidth: 12)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [Color.accentRed, Color.accentOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: Spacing.xs) {
                    Text("\(score)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("health.outOf".localized)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Text(score >= 80 ? "health.status.good".localized : score >= 60 ? "health.status.attention".localized : "health.status.consult".localized)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
    
    // MARK: - Today Tasks Count
    private var todayTasksCount: Int {
        let todayMedications = healthRecordManager.medications.filter { medication in
            medication.isActive && Calendar.current.isDateInToday(medication.startDate)
        }
        let todayAppointments = healthRecordManager.appointments.filter { appointment in
            Calendar.current.isDateInToday(appointment.date)
        }
        let todayFeedings = healthRecordManager.feedingRecords.filter { feeding in
            Calendar.current.isDateInToday(feeding.time)
        }
        return todayMedications.count + todayAppointments.count + todayFeedings.count
    }
    
    // MARK: - Medications Due Count
    private var medicationsDueCount: Int {
        let today = Date()
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: today) ?? today
        
        return healthRecordManager.medications.filter { medication in
            guard medication.isActive else { return false }
            
            // Prüfe ob Medikament abgelaufen ist
            if let endDate = medication.endDate, endDate < today {
                return false
            }
            
            // Zähle alle aktiven Medikamente:
            // 1. Medikamente die heute oder in der Zukunft starten (innerhalb der nächsten 7 Tage)
            // 2. Medikamente die bereits gestartet wurden aber noch aktiv sind
            let isStartingSoon = medication.startDate >= today && medication.startDate <= nextWeek
            let isCurrentlyActive = medication.startDate <= today && (medication.endDate == nil || medication.endDate! >= today)
            
            return isStartingSoon || isCurrentlyActive
        }.count
    }
    
    // MARK: - Today Activity Minutes
    private var todayActivityMinutes: Int {
        let todayActivities = healthRecordManager.activities.filter { activity in
            Calendar.current.isDateInToday(activity.date)
        }
        return todayActivities.reduce(0) { $0 + $1.duration }
    }
    
    // MARK: - Today Feedings Count
    private var todayFeedingsCount: Int {
        let todayFeedings = healthRecordManager.feedingRecords.filter { feeding in
            Calendar.current.isDateInToday(feeding.time)
        }
        return todayFeedings.count
    }
    
    // MARK: - Quick Stats Grid
    private var quickStatsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: Spacing.md),
            GridItem(.flexible(), spacing: Spacing.md)
        ], spacing: Spacing.md) {
            DashboardStatCard(
                icon: "calendar.badge.clock",
                title: "dashboard.today".localized,
                value: "\(todayTasksCount)",
                subtitle: "dashboard.tasks".localized,
                color: Color.brandPrimary
            )
            
            DashboardStatCard(
                icon: "pills.fill",
                title: "dashboard.medications".localized,
                value: "\(medicationsDueCount)",
                subtitle: "dashboard.open".localized,
                color: Color.accentOrange
            )
            
            DashboardStatCard(
                icon: "figure.walk",
                title: "dashboard.activity".localized,
                value: "\(todayActivityMinutes)",
                subtitle: "dashboard.minutes".localized,
                color: Color.accentGreen
            )
            
            DashboardStatCard(
                icon: "fork.knife",
                title: "dashboard.meals".localized,
                value: "\(todayFeedingsCount)",
                subtitle: "dashboard.today".localized,
                color: Color.accentBlue
            )
        }
    }
    
    // MARK: - Today's Overview
    private var todaysOverviewCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 24))
                    .foregroundColor(.brandPrimary)
                
                Text("dashboard.todayOverview".localized)
                    .font(.sectionTitle)
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: Spacing.sm) {
                // Medikamente (heute oder laufende)
                let today = Date()
                let todayMedications = healthRecordManager.medications.filter { medication in
                    guard medication.isActive else { return false }
                    
                    // Prüfe ob Medikament abgelaufen ist
                    if let endDate = medication.endDate, endDate < today {
                        return false
                    }
                    
                    // Zeige Medikamente die heute starten ODER bereits gestartet wurden aber noch aktiv sind
                    let startsToday = Calendar.current.isDateInToday(medication.startDate)
                    let isCurrentlyActive = medication.startDate <= today && (medication.endDate == nil || medication.endDate! >= today)
                    
                    return startsToday || isCurrentlyActive
                }.prefix(3)
                
                ForEach(Array(todayMedications), id: \.id) { medication in
                    OverviewRow(
                        icon: "pills.fill",
                        title: medication.name,
                        subtitle: medication.dosage,
                        status: .pending,
                        color: .accentOrange
                    )
                }
                
                // Fütterungen
                let todayFeedings = healthRecordManager.feedingRecords.filter { feeding in
                    Calendar.current.isDateInToday(feeding.time)
                }.prefix(3)
                
                ForEach(Array(todayFeedings), id: \.id) { feeding in
                    OverviewRow(
                        icon: "fork.knife",
                        title: feeding.foodName,
                        subtitle: feeding.foodType,
                        status: .completed,
                        color: .accentBlue
                    )
                }
                
                // Aktivitäten
                let todayActivities = healthRecordManager.activities.filter { activity in
                    Calendar.current.isDateInToday(activity.date)
                }.prefix(3)
                
                ForEach(Array(todayActivities), id: \.id) { activity in
                    OverviewRow(
                        icon: "figure.walk",
                        title: activity.activityType,
                        subtitle: "\(activity.duration) Minuten",
                        status: .completed,
                        color: .accentGreen
                    )
                }
                
                if todayMedications.isEmpty && todayFeedings.isEmpty && todayActivities.isEmpty {
                    Text("dashboard.noActivitiesToday".localized)
                        .font(.bodyText)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(Spacing.md)
                }
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
    
    // MARK: - Trends Card
    private var trendsCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 24))
                    .foregroundColor(.brandPrimary)
                
                Text("dashboard.trends".localized)
                    .font(.sectionTitle)
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: Spacing.md) {
                // Gewichtstrend
                let recentWeights = healthRecordManager.weightRecords.sorted { $0.date > $1.date }.prefix(2)
                let weightChange: String = {
                    if recentWeights.count >= 2 {
                        let diff = recentWeights.first!.weight - recentWeights.last!.weight
                        return diff >= 0 ? "+\(String(format: "%.1f", diff)) kg" : "\(String(format: "%.1f", diff)) kg"
                    }
                    return "dashboard.noData".localized
                }()
                
                let currentWeight = recentWeights.first?.weight ?? 0.0
                
                TrendRow(
                    title: "dashboard.weight".localized,
                    current: currentWeight > 0 ? "\(String(format: "%.1f", currentWeight)) kg" : "dashboard.noData".localized,
                    change: weightChange,
                    trend: recentWeights.count >= 2 && (recentWeights.first!.weight - recentWeights.last!.weight) >= 0 ? .up : .down,
                    color: .accentGreen
                )
                
                // Aktivitätstrend
                let todayActivities = healthRecordManager.activities.filter { activity in
                    Calendar.current.isDateInToday(activity.date)
                }
                let yesterdayActivities = healthRecordManager.activities.filter { activity in
                    Calendar.current.isDate(activity.date, inSameDayAs: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
                }
                let todayMinutes = todayActivities.reduce(0) { $0 + $1.duration }
                let yesterdayMinutes = yesterdayActivities.reduce(0) { $0 + $1.duration }
                let activityChange = todayMinutes - yesterdayMinutes
                
                TrendRow(
                    title: "dashboard.activity".localized,
                    current: "\(todayMinutes) " + "dashboard.minPerDay".localized,
                    change: activityChange >= 0 ? "+\(activityChange) " + "dashboard.min".localized : "\(activityChange) " + "dashboard.min".localized,
                    trend: activityChange >= 0 ? .up : .down,
                    color: .accentBlue
                )
                
                // Gesundheits-Score Trend
                TrendRow(
                    title: "dashboard.health".localized,
                    current: "\(healthScore)/100",
                    change: "+0 " + "dashboard.points".localized,
                    trend: .stable,
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
    
    // MARK: - Reminders Card
    private var remindersCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentOrange)
                
                Text("dashboard.reminders".localized)
                    .font(.sectionTitle)
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: Spacing.sm) {
                // Anstehende Medikamente (heute und in der Zukunft)
                let today = Date()
                let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: today) ?? today
                
                let upcomingMedications = healthRecordManager.medications.filter { medication in
                    guard medication.isActive else { return false }
                    
                    // Prüfe ob Medikament abgelaufen ist
                    if let endDate = medication.endDate, endDate < today {
                        return false
                    }
                    
                    // Zeige Medikamente die:
                    // 1. Heute oder in der Zukunft starten (innerhalb der nächsten 7 Tage)
                    // 2. Bereits gestartet wurden aber noch aktiv sind (innerhalb der nächsten 7 Tage)
                    let isStartingSoon = medication.startDate >= today && medication.startDate <= nextWeek
                    let isCurrentlyActive = medication.startDate <= today && (medication.endDate == nil || medication.endDate! >= today)
                    
                    return isStartingSoon || isCurrentlyActive
                }.sorted { medication1, medication2 in
                    // Sortiere nach: zuerst heute, dann nach Datum
                    let date1 = medication1.startDate > today ? medication1.startDate : today
                    let date2 = medication2.startDate > today ? medication2.startDate : today
                    return date1 < date2
                }.prefix(3)
                
                ForEach(Array(upcomingMedications), id: \.id) { medication in
                    ReminderRow(
                        icon: "pills.fill",
                        title: medication.name,
                        time: formatDate(medication.startDate),
                        isCompleted: false,
                        color: .accentOrange
                    )
                }
                
                // Anstehende Termine
                let upcomingAppointments = healthRecordManager.appointments.filter { appointment in
                    appointment.date >= Date() && appointment.date <= Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
                }.sorted { $0.date < $1.date }.prefix(3)
                
                ForEach(Array(upcomingAppointments), id: \.id) { appointment in
                    ReminderRow(
                        icon: "calendar",
                        title: appointment.title,
                        time: formatDate(appointment.date),
                        isCompleted: false,
                        color: .accentBlue
                    )
                }
                
                // Anstehende Impfungen
                let upcomingVaccinations = healthRecordManager.vaccinations.filter { vaccination in
                    if let nextDate = vaccination.nextDueDate {
                        return nextDate >= Date() && nextDate <= Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
                    }
                    return false
                }.sorted { ($0.nextDueDate ?? Date()) < ($1.nextDueDate ?? Date()) }.prefix(3)
                
                ForEach(Array(upcomingVaccinations), id: \.id) { vaccination in
                    ReminderRow(
                        icon: "syringe.fill",
                        title: vaccination.name,
                        time: formatDate(vaccination.nextDueDate ?? Date()),
                        isCompleted: false,
                        color: .accentPurple
                    )
                }
                
                if upcomingMedications.isEmpty && upcomingAppointments.isEmpty && upcomingVaccinations.isEmpty {
                    Text("dashboard.noReminders".localized)
                        .font(.bodyText)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(Spacing.md)
                }
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
    
    // MARK: - Helper Functions
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.timeStyle = .short
            return "Heute, \(formatter.string(from: date))"
        } else if Calendar.current.isDateInTomorrow(date) {
            formatter.timeStyle = .short
            return "Morgen, \(formatter.string(from: date))"
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}

// MARK: - Dashboard Stat Card
struct DashboardStatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
        )
    }
}

// MARK: - Overview Row
struct OverviewRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let status: TaskStatus
    let color: Color
    
    enum TaskStatus {
        case pending
        case inProgress
        case completed
    }
    
    var statusIcon: String {
        switch status {
        case .pending: return "clock.fill"
        case .inProgress: return "arrow.clockwise"
        case .completed: return "checkmark.circle.fill"
        }
    }
    
    var statusColor: Color {
        switch status {
        case .pending: return .accentOrange
        case .inProgress: return .accentBlue
        case .completed: return .accentGreen
        }
    }
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: statusIcon)
                .font(.system(size: 18))
                .foregroundColor(statusColor)
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundTertiary)
        )
    }
}

// MARK: - Trend Row
struct TrendRow: View {
    let title: String
    let current: String
    let change: String
    let trend: TrendDirection
    let color: Color
    
    enum TrendDirection {
        case up
        case down
        case stable
    }
    
    var trendIcon: String {
        switch trend {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .stable: return "arrow.right"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Text(current)
                    .font(.bodyText)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            HStack(spacing: Spacing.xs) {
                Image(systemName: trendIcon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                
                Text(change)
                    .font(.bodyTextBold)
                    .foregroundColor(color)
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundTertiary)
        )
    }
}

// MARK: - Reminder Row
struct ReminderRow: View {
    let icon: String
    let title: String
    let time: String
    let isCompleted: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.accentGreen)
            } else {
                Image(systemName: "circle")
                    .font(.system(size: 20))
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundTertiary)
        )
    }
}
