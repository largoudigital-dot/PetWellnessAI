//
//  VaccinationsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct VaccinationsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddVaccination = false
    @State private var selectedVaccination: Vaccination? = nil
    @State private var showEditVaccination = false
    @State private var vaccinationToDelete: Vaccination? = nil
    @State private var showDeleteConfirmation = false
    
    var vaccinations: [Vaccination] {
        healthRecordManager.getVaccinations(for: pet.id).sorted { $0.date > $1.date }
    }
    
    var upcomingVaccinations: [Vaccination] {
        vaccinations.filter { vaccination in
            if let nextDue = vaccination.nextDueDate {
                return nextDue > Date() && !vaccination.isCompleted
            }
            return false
        }
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
                        
                        Text("petProfile.vaccinations".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddVaccination = true }) {
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
                            if !upcomingVaccinations.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Vaccinations List
                            if vaccinations.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                vaccinationsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl) // safeAreaInset passt automatisch an
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
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddVaccination) {
                AddVaccinationView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditVaccination) {
                if let vaccination = selectedVaccination {
                    EditVaccinationView(healthRecordManager: healthRecordManager, vaccination: vaccination)
                        .environmentObject(localizationManager)
                }
            }
            .alert("Impfung löschen", isPresented: $showDeleteConfirmation) {
                Button("Abbrechen", role: .cancel) {
                    vaccinationToDelete = nil
                }
                Button("Löschen", role: .destructive) {
                    if let vaccination = vaccinationToDelete {
                        healthRecordManager.deleteVaccination(vaccination)
                        // Lösche auch die Benachrichtigungen
                        NotificationManager.shared.cancelVaccinationReminder(vaccination: vaccination)
                        vaccinationToDelete = nil
                    }
                }
            } message: {
                if let vaccination = vaccinationToDelete {
                    Text(String(format: "common.deleteItemConfirm".localized, vaccination.name))
                        .id(localizationManager.currentLanguage)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 24))
                    .foregroundColor(.accentBlue)
                
                Text("vaccinations.due".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(upcomingVaccinations.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentOrange)
            }
            
            if let nextVaccination = upcomingVaccinations.first,
               let nextDue = nextVaccination.nextDueDate {
                Text("\(LocalizedStrings.get("vaccinations.nextVaccination")) \(nextDue, format: .dateTime.day().month().year())")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.accentBlue.opacity(0.1), Color.accentBlue.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var vaccinationsListView: some View {
        // Performance: Verwende LazyVStack für bessere Performance bei vielen Impfungen
        LazyVStack(spacing: Spacing.md) {
            ForEach(vaccinations) { vaccination in
                VaccinationCard(
                    vaccination: vaccination,
                    onTap: {
                        selectedVaccination = vaccination
                        showEditVaccination = true
                    },
                    onDelete: {
                        vaccinationToDelete = vaccination
                        showDeleteConfirmation = true
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("vaccinations.noEntries".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("vaccinations.emptyDescription".localized)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct VaccinationCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let vaccination: Vaccination
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var isUpcoming: Bool {
        if let nextDue = vaccination.nextDueDate {
            return nextDue > Date()
        }
        return false
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentBlue.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundColor(.accentBlue)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(vaccination.name)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        if isUpcoming {
                            Text("common.due".localized)
                                .font(.smallCaption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.accentOrange)
                                .cornerRadius(8)
                        } else if vaccination.isCompleted {
                            Text("common.completed".localized)
                                .font(.smallCaption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.accentGreen)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text("\(vaccination.date, format: .dateTime.day().month().year())")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    if let nextDue = vaccination.nextDueDate {
                        Text("\(LocalizedStrings.get("vaccinations.nextVaccination")) \(nextDue, format: .dateTime.day().month().year())")
                            .font(.smallCaption)
                            .foregroundColor(.textTertiary)
                    }
                    
                    if !vaccination.veterinarian.isEmpty {
                        Text(LocalizedStrings.get("common.veterinarian") + ": \(vaccination.veterinarian)")
                            .id(localizationManager.currentLanguage)
                            .font(.smallCaption)
                            .foregroundColor(.textTertiary)
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

// MARK: - Add Vaccination View
struct AddVaccinationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var name = ""
    @State private var date = Date()
    @State private var hasNextDueDate = false
    @State private var nextDueDate: Date? = nil
    @State private var veterinarian = ""
    @State private var notes = ""
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isAddVaccinationFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
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
                                Text("vaccinations.vaccination".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                TextField("vaccinations.namePlaceholder".localized, text: $name)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.date".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Toggle("vaccinations.setNext".localized, isOn: $hasNextDueDate)
                                    .font(.bodyText)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                if hasNextDueDate {
                                    DatePicker("vaccinations.next".localized, selection: Binding(
                                        get: { nextDueDate ?? Calendar.current.date(byAdding: .year, value: 1, to: date) ?? date },
                                        set: { nextDueDate = $0 }
                                    ), displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.veterinarian".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                TextField("appointments.veterinarianPlaceholder".localized, text: $veterinarian)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.notes".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
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
                        PrimaryButton("vaccinations.add".localized, icon: "checkmark", isDisabled: !isAddVaccinationFormValid) {
                            // Validierung
                            let validation = InputValidator.shared.validateVaccination(name: name, date: date)
                            if !validation.isValid {
                                ErrorHandler.shared.handle(.validationFailed(validation.errorMessage ?? "Ungültige Eingabe"))
                                return
                            }
                            
                            let vaccination = Vaccination(
                                petId: pet.id,
                                name: name.trimmingCharacters(in: .whitespaces),
                                date: date,
                                nextDueDate: hasNextDueDate ? nextDueDate : nil,
                                veterinarian: veterinarian.trimmingCharacters(in: .whitespaces),
                                notes: notes.trimmingCharacters(in: .whitespaces)
                            )
                            healthRecordManager.addVaccination(vaccination)
                            
                            // Zeige Interstitial Ad nach Impfung hinzufügen (maximaler Profit)
                            AdManager.shared.showInterstitialAfterAction()
                            
                            // Schedule vaccination reminder if enabled
                            let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                            let isAuthorized = NotificationManager.shared.checkAuthorizationStatusSync()
                            
                            print("💉 Neue Impfung erstellt: \(vaccination.name)")
                            print("   - Nächstes Fälligkeitsdatum: \(vaccination.nextDueDate?.description ?? "kein Datum")")
                            print("   - Benachrichtigungen aktiviert: \(notificationsEnabled), Berechtigt: \(isAuthorized)")
                            
                            if notificationsEnabled && isAuthorized {
                                if vaccination.nextDueDate != nil {
                                    print("💉 Plane Benachrichtigung für neue Impfung...")
                                    NotificationManager.shared.scheduleVaccinationReminder(vaccination: vaccination, petName: pet.name)
                                } else {
                                    print("⚠️ Kein Fälligkeitsdatum für Impfung, keine Benachrichtigung geplant")
                                }
                            } else {
                                print("⚠️ Benachrichtigung nicht geplant: enabled=\(notificationsEnabled), authorized=\(isAuthorized)")
                            }
                            dismiss()
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("vaccinations.add".localized)
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

// MARK: - Edit Vaccination View
struct EditVaccinationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let vaccination: Vaccination
    
    @State private var name: String
    @State private var date: Date
    @State private var hasNextDueDate: Bool
    @State private var nextDueDate: Date?
    @State private var veterinarian: String
    @State private var notes: String
    @State private var isCompleted: Bool
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isEditVaccinationFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(healthRecordManager: HealthRecordManager, vaccination: Vaccination) {
        self.healthRecordManager = healthRecordManager
        self.vaccination = vaccination
        _name = State(initialValue: vaccination.name)
        _date = State(initialValue: vaccination.date)
        _hasNextDueDate = State(initialValue: vaccination.nextDueDate != nil)
        _nextDueDate = State(initialValue: vaccination.nextDueDate)
        _veterinarian = State(initialValue: vaccination.veterinarian)
        _notes = State(initialValue: vaccination.notes)
        _isCompleted = State(initialValue: vaccination.isCompleted)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Form (same structure as Add)
                        VStack(spacing: Spacing.lg) {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("vaccinations.vaccination".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("vaccinations.namePlaceholder".localized, text: $name)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.date".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Toggle("vaccinations.setNext".localized, isOn: $hasNextDueDate)
                                    .font(.bodyText)
                                    .foregroundColor(.textPrimary)
                                
                                if hasNextDueDate {
                                    DatePicker("vaccinations.next".localized, selection: Binding(
                                        get: { nextDueDate ?? Calendar.current.date(byAdding: .year, value: 1, to: date) ?? date },
                                        set: { nextDueDate = $0 }
                                    ), displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("appointments.veterinarian".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("appointments.veterinarianPlaceholder".localized, text: $veterinarian)
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
                            
                            Toggle("vaccinations.completed".localized, isOn: $isCompleted)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark", isDisabled: !isEditVaccinationFormValid) {
                            if !name.isEmpty {
                                var updated = vaccination
                                updated.name = name
                                updated.date = date
                                updated.nextDueDate = hasNextDueDate ? nextDueDate : nil
                                updated.veterinarian = veterinarian
                                updated.notes = notes
                                updated.isCompleted = isCompleted
                                healthRecordManager.updateVaccination(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("vaccinations.edit".localized)
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




