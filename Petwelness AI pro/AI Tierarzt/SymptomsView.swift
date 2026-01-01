//
//  SymptomsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct SymptomsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddSymptom = false
    @State private var selectedSymptom: Symptom? = nil
    @State private var showEditSymptom = false
    
    var symptoms: [Symptom] {
        healthRecordManager.getSymptoms(for: pet.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                        }
                        Spacer()
                        Text("symptoms.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Button(action: { showAddSymptom = true }) {
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
                            if symptoms.isEmpty {
                                emptyStateView.padding(.top, Spacing.xxxl)
                            } else {
                                symptomsListView.padding(.top, Spacing.lg)
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddSymptom) {
                AddSymptomView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditSymptom) {
                if let symptom = selectedSymptom {
                    EditSymptomView(healthRecordManager: healthRecordManager, symptom: symptom)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var symptomsListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(symptoms) { symptom in
                SymptomCard(
                    symptom: symptom,
                    onTap: {
                        selectedSymptom = symptom
                        showEditSymptom = true
                    },
                    onDelete: {
                        healthRecordManager.deleteSymptom(symptom)
                    }
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            Text("symptoms.noSymptoms".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            Text("symptoms.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct SymptomCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let symptom: Symptom
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var severityColor: Color {
        switch symptom.severity {
        case 4...5: return .accentRed
        case 2...3: return .accentOrange
        default: return .accentGreen
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(severityColor.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(severityColor)
                }
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(symptom.symptom)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    HStack {
                        Text("\(LocalizedStrings.get("symptoms.severity")): \(symptom.severity)/5")
                            .id(localizationManager.currentLanguage)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        if !symptom.duration.isEmpty {
                            Text("• \(symptom.duration)")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    Text(symptom.date, format: .dateTime.day().month().year())
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

struct AddSymptomView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var symptom = ""
    @State private var severity = 3
    @State private var date = Date()
    @State private var duration = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        formContent
                        saveButton
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("symptoms.addTitle".localized)
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
    
    private var formContent: some View {
        VStack(spacing: Spacing.lg) {
            symptomField
            severityField
            dateField
            durationField
            notesField
        }
        .padding(Spacing.xl)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
        .padding(.top, Spacing.lg)
    }
    
    private var symptomField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("symptoms.symptom".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("symptoms.symptomPlaceholder".localized, text: $symptom)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var severityField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("symptoms.severityLabel".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            Stepper(value: $severity, in: 1...5) {
                HStack {
                    Text("\(severity)")
                        .font(.bodyTextBold)
                        .foregroundColor(.brandPrimary)
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: i <= severity ? "star.fill" : "star")
                            .foregroundColor(i <= severity ? .accentOrange : .textTertiary)
                    }
                }
            }
            .padding(Spacing.md)
            .background(Color.backgroundTertiary)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var dateField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.date".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(Spacing.md)
                .background(Color.backgroundTertiary)
                .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var durationField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("symptoms.duration".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("symptoms.durationPlaceholder".localized, text: $duration)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var notesField: some View {
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
    
    private var saveButton: some View {
        PrimaryButton("symptoms.add".localized, icon: "checkmark", isDisabled: symptom.trimmingCharacters(in: .whitespaces).isEmpty) {
            if !symptom.isEmpty {
                let symptomRecord = Symptom(
                    petId: pet.id,
                    symptom: symptom,
                    severity: severity,
                    date: date,
                    duration: duration,
                    notes: notes
                )
                healthRecordManager.addSymptom(symptomRecord)
                
                // Zeige Interstitial Ad nach Aktion
                AdManager.shared.showInterstitialAfterAction()
                
                dismiss()
            }
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.bottom, Spacing.xl)
        .id(localizationManager.currentLanguage)
    }
}

struct EditSymptomView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let symptom: Symptom
    
    @State private var symptomText: String
    @State private var severity: Int
    @State private var date: Date
    @State private var duration: String
    @State private var notes: String
    
    init(healthRecordManager: HealthRecordManager, symptom: Symptom) {
        self.healthRecordManager = healthRecordManager
        self.symptom = symptom
        _symptomText = State(initialValue: symptom.symptom)
        _severity = State(initialValue: symptom.severity)
        _date = State(initialValue: symptom.date)
        _duration = State(initialValue: symptom.duration)
        _notes = State(initialValue: symptom.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        formContent
                        saveButton
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("symptoms.editTitle".localized)
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
    
    private var formContent: some View {
        VStack(spacing: Spacing.lg) {
            symptomField
            severityField
            dateField
            durationField
            notesField
        }
        .padding(Spacing.xl)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
        .padding(.top, Spacing.lg)
    }
    
    private var symptomField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("symptoms.symptom".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("symptoms.symptomPlaceholder".localized, text: $symptomText)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var severityField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("symptoms.severityLabel".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            Stepper(value: $severity, in: 1...5) {
                HStack {
                    Text("\(severity)")
                        .font(.bodyTextBold)
                        .foregroundColor(.brandPrimary)
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: i <= severity ? "star.fill" : "star")
                            .foregroundColor(i <= severity ? .accentOrange : .textTertiary)
                    }
                }
            }
            .padding(Spacing.md)
            .background(Color.backgroundTertiary)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var dateField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.date".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(Spacing.md)
                .background(Color.backgroundTertiary)
                .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var durationField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("symptoms.duration".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("symptoms.durationPlaceholder".localized, text: $duration)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var notesField: some View {
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
    
    private var saveButton: some View {
        PrimaryButton("common.saveChanges".localized, icon: "checkmark", isDisabled: symptomText.trimmingCharacters(in: .whitespaces).isEmpty) {
            if !symptomText.isEmpty {
                var updated = symptom
                updated.symptom = symptomText
                updated.severity = severity
                updated.date = date
                updated.duration = duration
                updated.notes = notes
                healthRecordManager.updateSymptom(updated)
                dismiss()
            }
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.bottom, Spacing.xl)
        .id(localizationManager.currentLanguage)
    }
}

