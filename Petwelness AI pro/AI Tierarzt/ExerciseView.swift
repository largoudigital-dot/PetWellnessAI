//
//  ExerciseView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct ExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddExercise = false
    @State private var selectedRecord: ExerciseRecord? = nil
    @State private var showEditExercise = false
    
    var exerciseRecords: [ExerciseRecord] {
        healthRecordManager.getExerciseRecords(for: pet.id)
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
                        
                        Text("exercise.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddExercise = true }) {
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
                            if !exerciseRecords.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Exercise Records List
                            if exerciseRecords.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                exerciseRecordsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddExercise) {
                AddExerciseView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditExercise) {
                if let record = selectedRecord {
                    EditExerciseView(healthRecordManager: healthRecordManager, record: record)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "figure.run")
                    .font(.system(size: 24))
                    .foregroundColor(.accentOrange)
                
                Text("exercise.sessions".localized)
                    .id(localizationManager.currentLanguage)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(exerciseRecords.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentOrange)
            }
            
            let totalDuration = exerciseRecords.reduce(0) { $0 + $1.duration }
            Text("\(LocalizedStrings.get("exercise.total")): \(totalDuration) \(LocalizedStrings.get("activities.minutes"))")
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.accentOrange.opacity(0.1), Color.accentOrange.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var exerciseRecordsListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(exerciseRecords) { record in
                ExerciseRecordCard(
                    record: record,
                    onTap: {
                        selectedRecord = record
                        showEditExercise = true
                    },
                    onDelete: {
                        healthRecordManager.deleteExerciseRecord(record)
                    }
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "figure.run")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("exercise.noSessions".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("exercise.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct ExerciseRecordCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let record: ExerciseRecord
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentOrange.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "figure.run")
                        .font(.system(size: 20))
                        .foregroundColor(.accentOrange)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(record.exerciseType)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        Text("\(record.duration) Min")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        if let distance = record.distance {
                            Text("• \(String(format: "%.1f", distance)) km")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Text(record.date, format: .dateTime.day().month().year())
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

// MARK: - Add Exercise View
struct AddExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var exerciseType = ""
    @State private var duration: String = ""
    @State private var distance: String = ""
    @State private var hasDistance = false
    @State private var date = Date()
    @State private var notes = ""
    
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
                                Text("exercise.exerciseType".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("exercise.exerciseTypePlaceholder".localized, text: $exerciseType)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("exercise.duration".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("exercise.durationPlaceholder".localized, text: $duration)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Toggle("exercise.setDistance".localized, isOn: $hasDistance)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyText)
                                    .foregroundColor(.textPrimary)
                                
                                if hasDistance {
                                    HStack {
                                        TextField("exercise.distancePlaceholder".localized, text: $distance)
                                            .id(localizationManager.currentLanguage)
                                            .keyboardType(.decimalPad)
                                            .textFieldStyle(AppTextFieldStyle())
                                        
                                        Text("km")
                                            .foregroundColor(.textSecondary)
                                    }
                                }
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
                        PrimaryButton("exercise.addSession".localized, icon: "checkmark") {
                            if !exerciseType.isEmpty, let durationValue = Int(duration) {
                                let record = ExerciseRecord(
                                    petId: pet.id,
                                    exerciseType: exerciseType,
                                    duration: durationValue,
                                    date: date,
                                    distance: hasDistance ? Double(distance.replacingOccurrences(of: ",", with: ".")) : nil,
                                    notes: notes
                                )
                                healthRecordManager.addExerciseRecord(record)
                                
                                // Zeige Interstitial Ad nach Aktion
                                AdManager.shared.showInterstitialAfterAction()
                                
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                        .id(localizationManager.currentLanguage)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("exercise.addTitle".localized)
                .id(localizationManager.currentLanguage)
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

// MARK: - Edit Exercise View
struct EditExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let record: ExerciseRecord
    
    @State private var exerciseType: String
    @State private var duration: String
    @State private var distance: String
    @State private var hasDistance: Bool
    @State private var date: Date
    @State private var notes: String
    
    init(healthRecordManager: HealthRecordManager, record: ExerciseRecord) {
        self.healthRecordManager = healthRecordManager
        self.record = record
        _exerciseType = State(initialValue: record.exerciseType)
        _duration = State(initialValue: "\(record.duration)")
        _distance = State(initialValue: record.distance != nil ? String(format: "%.1f", record.distance!) : "")
        _hasDistance = State(initialValue: record.distance != nil)
        _date = State(initialValue: record.date)
        _notes = State(initialValue: record.notes)
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
                                Text("exercise.exerciseType".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("exercise.exerciseTypePlaceholder".localized, text: $exerciseType)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("exercise.duration".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("exercise.durationPlaceholder".localized, text: $duration)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Toggle("exercise.setDistance".localized, isOn: $hasDistance)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyText)
                                    .foregroundColor(.textPrimary)
                                
                                if hasDistance {
                                    HStack {
                                        TextField("exercise.distancePlaceholder".localized, text: $distance)
                                            .id(localizationManager.currentLanguage)
                                            .keyboardType(.decimalPad)
                                            .textFieldStyle(AppTextFieldStyle())
                                        
                                        Text("km")
                                            .foregroundColor(.textSecondary)
                                    }
                                }
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
                        PrimaryButton("common.saveChanges".localized, icon: "checkmark") {
                            if !exerciseType.isEmpty, let durationValue = Int(duration) {
                                var updated = record
                                updated.exerciseType = exerciseType
                                updated.duration = durationValue
                                updated.date = date
                                updated.distance = hasDistance ? Double(distance.replacingOccurrences(of: ",", with: ".")) : nil
                                updated.notes = notes
                                healthRecordManager.updateExerciseRecord(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                        .id(localizationManager.currentLanguage)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("exercise.editTitle".localized)
                .id(localizationManager.currentLanguage)
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


