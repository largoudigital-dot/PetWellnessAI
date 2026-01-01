//
//  ConsultationsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct ConsultationsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddConsultation = false
    @State private var selectedConsultation: Consultation? = nil
    @State private var showEditConsultation = false
    
    var consultations: [Consultation] {
        healthRecordManager.getConsultations(for: pet.id)
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
                        
                        Text("consultations.title".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddConsultation = true }) {
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
                            if !consultations.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Consultations List
                            if consultations.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                consultationsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddConsultation) {
                AddConsultationView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditConsultation) {
                if let consultation = selectedConsultation {
                    EditConsultationView(healthRecordManager: healthRecordManager, consultation: consultation)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "stethoscope")
                    .font(.system(size: 24))
                    .foregroundColor(.brandPrimary)
                
                Text("consultations.total".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(consultations.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.brandPrimary)
            }
            
            let totalCost = consultations.reduce(0) { $0 + $1.cost }
            Text(LocalizedStrings.get("consultations.totalCost") + " \(String(format: "%.2f", totalCost)) \(LocalizedStrings.currencySymbol())")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.brandPrimary.opacity(0.1), Color.brandPrimary.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var consultationsListView: some View {
        // Performance: Verwende LazyVStack für bessere Performance bei vielen Konsultationen
        LazyVStack(spacing: Spacing.md) {
            ForEach(consultations) { consultation in
                ConsultationCard(
                    consultation: consultation,
                    onTap: {
                        selectedConsultation = consultation
                        showEditConsultation = true
                    },
                    onDelete: {
                        healthRecordManager.deleteConsultation(consultation)
                    }
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "stethoscope")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("consultations.noConsultations".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("consultations.emptyDescription".localized)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct ConsultationCard: View {
    let consultation: Consultation
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "stethoscope")
                        .font(.system(size: 20))
                        .foregroundColor(.brandPrimary)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(consultation.date, format: .dateTime.day().month().year())
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        if consultation.cost > 0 {
                            Text(String(format: "%.2f %@", consultation.cost, LocalizedStrings.currencySymbol()))
                                .font(.caption)
                                .foregroundColor(.accentGreen)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.accentGreen.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    if !consultation.veterinarianName.isEmpty {
                        Text(consultation.veterinarianName)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    if !consultation.reason.isEmpty {
                        Text(LocalizedStrings.get("consultations.reason") + " \(consultation.reason)")
                            .font(.smallCaption)
                            .foregroundColor(.textTertiary)
                            .lineLimit(1)
                    }
                    
                    if !consultation.diagnosis.isEmpty {
                        Text(LocalizedStrings.get("consultations.diagnosis") + " \(consultation.diagnosis)")
                            .font(.smallCaption)
                            .foregroundColor(.accentOrange)
                            .lineLimit(1)
                    }
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
            }
        }
    }
}

// MARK: - Add Consultation View
struct AddConsultationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var date = Date()
    @State private var veterinarianName = ""
    @State private var reason = ""
    @State private var diagnosis = ""
    @State private var treatment = ""
    @State private var cost: String = ""
    @State private var notes = ""
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isAddConsultationFormValid: Bool {
        !reason.trimmingCharacters(in: .whitespaces).isEmpty
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
                                Text("common.veterinarian".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("consultations.veterinarianPlaceholder".localized, text: $veterinarianName)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("consultations.reason".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("consultations.reasonPlaceholder".localized, text: $reason)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("consultations.diagnosis".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("consultations.diagnosisPlaceholder".localized, text: $diagnosis)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("consultations.treatment".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("consultations.treatmentPlaceholder".localized, text: $treatment)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("consultations.cost".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("0.00", text: $cost)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(AppTextFieldStyle())
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
                        PrimaryButton("consultations.add".localized, icon: "checkmark", isDisabled: !isAddConsultationFormValid) {
                            // Validierung
                            let costValue = Double(cost.replacingOccurrences(of: ",", with: ".")) ?? 0
                            let costValidation = InputValidator.shared.validateNumber(costValue, fieldName: "Kosten", min: 0)
                            if !costValidation.isValid {
                                ErrorHandler.shared.handle(.validationFailed(costValidation.errorMessage ?? "Ungültige Kosten"))
                                return
                            }
                            
                            let consultation = Consultation(
                                petId: pet.id,
                                date: date,
                                veterinarianName: veterinarianName.trimmingCharacters(in: .whitespaces),
                                reason: reason.trimmingCharacters(in: .whitespaces),
                                diagnosis: diagnosis.trimmingCharacters(in: .whitespaces),
                                treatment: treatment.trimmingCharacters(in: .whitespaces),
                                cost: costValue,
                                notes: notes.trimmingCharacters(in: .whitespaces)
                            )
                            healthRecordManager.addConsultation(consultation)
                            
                            // Zeige Interstitial Ad nach Aktion
                            AdManager.shared.showInterstitialAfterAction()
                            
                            dismiss()
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("consultations.addTitle".localized)
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

// MARK: - Edit Consultation View
struct EditConsultationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let consultation: Consultation
    
    @State private var date: Date
    @State private var veterinarianName: String
    @State private var reason: String
    @State private var diagnosis: String
    @State private var treatment: String
    @State private var cost: String
    @State private var notes: String
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isEditConsultationFormValid: Bool {
        !reason.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(healthRecordManager: HealthRecordManager, consultation: Consultation) {
        self.healthRecordManager = healthRecordManager
        self.consultation = consultation
        _date = State(initialValue: consultation.date)
        _veterinarianName = State(initialValue: consultation.veterinarianName)
        _reason = State(initialValue: consultation.reason)
        _diagnosis = State(initialValue: consultation.diagnosis)
        _treatment = State(initialValue: consultation.treatment)
        _cost = State(initialValue: String(format: "%.2f", consultation.cost))
        _notes = State(initialValue: consultation.notes)
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
                                Text("common.veterinarian".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("consultations.veterinarianPlaceholder".localized, text: $veterinarianName)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("consultations.reason".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("consultations.reasonPlaceholder".localized, text: $reason)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("consultations.diagnosis".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("consultations.diagnosisPlaceholder".localized, text: $diagnosis)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("consultations.treatment".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("consultations.treatmentPlaceholder".localized, text: $treatment)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("consultations.cost".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("0.00", text: $cost)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.notes".localized)
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
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark", isDisabled: !isEditConsultationFormValid) {
                            var updated = consultation
                            updated.date = date
                            updated.veterinarianName = veterinarianName
                            updated.reason = reason
                            updated.diagnosis = diagnosis
                            updated.treatment = treatment
                            updated.cost = Double(cost.replacingOccurrences(of: ",", with: ".")) ?? 0
                            updated.notes = notes
                            healthRecordManager.updateConsultation(updated)
                            dismiss()
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("consultations.edit".localized)
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
