//
//  ActivitiesView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct ActivitiesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddActivity = false
    @State private var selectedActivity: ActivityRecord? = nil
    @State private var showEditActivity = false
    
    var activities: [ActivityRecord] {
        healthRecordManager.getActivities(for: pet.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                        }
                        
                        Spacer()
                        
                        Text("activities.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddActivity = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                        }
                    }
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.md)
                    .background(Color.white)
                    
                    ScrollView {
                        VStack(spacing: Spacing.xl) {
                            // Summary Card
                            if !activities.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Activities List
                            if activities.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                activitiesListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddActivity) {
                AddActivityView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditActivity) {
                if let activity = selectedActivity {
                    EditActivityView(healthRecordManager: healthRecordManager, activity: activity)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "figure.walk")
                    .font(.system(size: 24))
                    .foregroundColor(.accentGreen)
                
                Text("activities.activities".localized)
                    .id(localizationManager.currentLanguage)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(activities.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentGreen)
            }
            
            let totalDuration = activities.reduce(0) { $0 + $1.duration }
            Text("\(LocalizedStrings.get("activities.total")) \(totalDuration) \(LocalizedStrings.get("activities.minutes"))")
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.accentGreen.opacity(0.1), Color.accentGreen.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var activitiesListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(activities) { activity in
                ActivityCard(
                    activity: activity,
                    onTap: {
                        selectedActivity = activity
                        showEditActivity = true
                    },
                    onDelete: {
                        healthRecordManager.deleteActivity(activity)
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "figure.walk")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("activities.noEntries".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("activities.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct ActivityCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let activity: ActivityRecord
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var intensityColor: Color {
        let intensity = activity.intensity.lowercased()
        if intensity.contains("high") || intensity.contains("hoch") || intensity.contains("haut") {
            return .accentRed
        } else if intensity.contains("medium") || intensity.contains("mittel") || intensity.contains("moyen") {
            return .accentOrange
        } else {
            return .accentGreen
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(intensityColor.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "figure.walk")
                        .font(.system(size: 20))
                        .foregroundColor(intensityColor)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(activity.activityType)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        Text("\(activity.duration) Min")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("•")
                            .foregroundColor(.textTertiary)
                        
                        Text(activity.intensity)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Text(activity.date, format: .dateTime.day().month().year())
                        .font(.smallCaption)
                        .foregroundColor(.textTertiary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.lg)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.large)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(role: .destructive, action: onDelete) {
                Label("common.delete".localized, systemImage: "trash")
                    .id(localizationManager.currentLanguage)
            }
        }
    }
}

// MARK: - Add Activity View
struct AddActivityView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var activityType = ""
    @State private var duration: String = ""
    @State private var intensity = "activities.intensity.medium"
    @State private var date = Date()
    @State private var notes = ""
    
    var intensities: [String] {
        ["activities.intensity.low", "activities.intensity.medium", "activities.intensity.high"]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Form
                        VStack(spacing: Spacing.lg) {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("activities.activityType".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("activities.activityTypePlaceholder".localized, text: $activityType)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("activities.duration".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("activities.durationPlaceholder".localized, text: $duration)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("activities.intensity".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("activities.intensity".localized, selection: $intensity) {
                                    ForEach(intensities, id: \.self) { int in
                                        Text(int.localized)
                                            .id(localizationManager.currentLanguage)
                                            .tag(int)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.dateTime".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.notes".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextEditor(text: $notes)
                                    .frame(minHeight: 100)
                                    .padding(Spacing.sm)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("activities.addActivity".localized, icon: "checkmark") {
                            if !activityType.isEmpty, let durationValue = Int(duration) {
                                let activity = ActivityRecord(
                                    petId: pet.id,
                                    activityType: activityType,
                                    duration: durationValue,
                                    intensity: intensity.localized,
                                    date: date,
                                    notes: notes
                                )
                                healthRecordManager.addActivity(activity)
                                
                                // Zeige Interstitial Ad nach Aktion
                                AdManager.shared.showInterstitialAfterAction()
                                
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("activities.addActivity".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Edit Activity View
struct EditActivityView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let activity: ActivityRecord
    
    @State private var activityType: String
    @State private var duration: String
    @State private var intensity: String
    @State private var date: Date
    @State private var notes: String
    
    var intensities: [String] {
        ["activities.intensity.low", "activities.intensity.medium", "activities.intensity.high"]
    }
    
    static func getIntensityKey(from storedIntensity: String) -> String {
        let intensityMap: [String: String] = [
            "Niedrig": "activities.intensity.low",
            "Low": "activities.intensity.low",
            "Mittel": "activities.intensity.medium",
            "Medium": "activities.intensity.medium",
            "Hoch": "activities.intensity.high",
            "High": "activities.intensity.high"
        ]
        return intensityMap[storedIntensity] ?? "activities.intensity.medium"
    }
    
    init(healthRecordManager: HealthRecordManager, activity: ActivityRecord) {
        self.healthRecordManager = healthRecordManager
        self.activity = activity
        _activityType = State(initialValue: activity.activityType)
        _duration = State(initialValue: "\(activity.duration)")
        let intensityKey = Self.getIntensityKey(from: activity.intensity)
        _intensity = State(initialValue: intensityKey)
        _date = State(initialValue: activity.date)
        _notes = State(initialValue: activity.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Form (same as Add)
                        VStack(spacing: Spacing.lg) {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("activities.activityType".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("activities.activityTypePlaceholder".localized, text: $activityType)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("activities.duration".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("activities.durationPlaceholder".localized, text: $duration)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("activities.intensity".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("activities.intensity".localized, selection: $intensity) {
                                    ForEach(intensities, id: \.self) { int in
                                        Text(int.localized).tag(int)
                                            .id(localizationManager.currentLanguage)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.date".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.notes".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextEditor(text: $notes)
                                    .frame(minHeight: 100)
                                    .padding(Spacing.sm)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark") {
                            if !activityType.isEmpty, let durationValue = Int(duration) {
                                var updated = activity
                                updated.activityType = activityType
                                updated.duration = durationValue
                                updated.intensity = intensity.localized
                                updated.date = date
                                updated.notes = notes
                                healthRecordManager.updateActivity(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("activities.editActivity".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}


