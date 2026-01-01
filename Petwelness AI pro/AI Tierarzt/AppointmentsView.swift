//
//  AppointmentsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct AppointmentsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddAppointment = false
    @State private var selectedAppointment: Appointment? = nil
    @State private var showEditAppointment = false
    @State private var appointmentToDelete: Appointment? = nil
    @State private var showDeleteConfirmation = false
    
    var appointments: [Appointment] {
        healthRecordManager.getAppointments(for: pet.id).sorted { $0.date < $1.date }
    }
    
    var upcomingAppointments: [Appointment] {
        appointments.filter { $0.date > Date() && !$0.isCompleted }
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
                        
                        Text("petProfile.appointments".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddAppointment = true }) {
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
                            if !upcomingAppointments.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Appointments List
                            if appointments.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                appointmentsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl) // safeAreaInset passt automatisch an
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                // Banner Ad am unteren Rand (über Safe Area)
                if AdManager.shared.shouldShowAds {
                    BannerAdView()
                        .frame(height: 50)
                        .background(Color.backgroundPrimary)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddAppointment) {
                AddAppointmentView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditAppointment) {
                if let appointment = selectedAppointment {
                    EditAppointmentView(healthRecordManager: healthRecordManager, appointment: appointment)
                        .environmentObject(localizationManager)
                }
            }
            .alert("Termin löschen", isPresented: $showDeleteConfirmation) {
                Button("Abbrechen", role: .cancel) {
                    appointmentToDelete = nil
                }
                Button("Löschen", role: .destructive) {
                    if let appointment = appointmentToDelete {
                        healthRecordManager.deleteAppointment(appointment)
                        // Lösche auch die Benachrichtigungen
                        NotificationManager.shared.cancelAppointmentReminder(appointment: appointment)
                        appointmentToDelete = nil
                    }
                }
            } message: {
                if let appointment = appointmentToDelete {
                    Text(String(format: "common.deleteItemConfirm".localized, appointment.title))
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
                    .foregroundColor(.accentPurple)
                
                Text("appointments.upcoming".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(upcomingAppointments.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.brandPrimary)
            }
            
            if let nextAppointment = upcomingAppointments.first {
                Text("\(LocalizedStrings.get("appointments.nextAppointment")) \(nextAppointment.date, format: .dateTime.day().month().year().hour().minute())")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.accentPurple.opacity(0.1), Color.accentPurple.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var appointmentsListView: some View {
        // Performance: Verwende LazyVStack für bessere Performance bei vielen Terminen
        LazyVStack(spacing: Spacing.md) {
            ForEach(appointments) { appointment in
                AppointmentCard(
                    appointment: appointment,
                    onTap: {
                        selectedAppointment = appointment
                        showEditAppointment = true
                    },
                    onDelete: {
                        appointmentToDelete = appointment
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
            
            Text("petProfile.noAppointments".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("appointments.emptyDescription".localized)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct AppointmentCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let appointment: Appointment
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var isUpcoming: Bool {
        appointment.date > Date() && !appointment.isCompleted
    }
    
    var isPast: Bool {
        appointment.date < Date() || appointment.isCompleted
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentPurple.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundColor(.accentPurple)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(appointment.title)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        if isUpcoming {
                            Text("appointments.upcomingStatus".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.smallCaption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.brandPrimary)
                                .cornerRadius(8)
                        } else if isPast {
                            Text("appointments.completedStatus".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.smallCaption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.accentGreen)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text("\(appointment.date, format: .dateTime.day().month().year().hour().minute())")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    if !appointment.veterinarian.isEmpty {
                        Text("\(LocalizedStrings.get("common.veterinarian")): \(appointment.veterinarian)")
                            .id(localizationManager.currentLanguage)
                            .font(.smallCaption)
                            .foregroundColor(.textTertiary)
                    }
                    
                    if !appointment.location.isEmpty {
                        Text("\(LocalizedStrings.get("appointments.location")): \(appointment.location)")
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

// MARK: - Add Appointment View
struct AddAppointmentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var title = ""
    @State private var date = Date()
    @State private var veterinarian = ""
    @State private var location = ""
    @State private var notes = ""
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isAddAppointmentFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
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
                                Text("common.title".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("appointments.titlePlaceholder".localized, text: $title)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("appointments.dateTime".localized)
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
                                
                                TextField("appointments.veterinarianPlaceholder".localized, text: $veterinarian)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("appointments.location".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("appointments.locationPlaceholder".localized, text: $location)
                                    .id(localizationManager.currentLanguage)
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
                        PrimaryButton("appointments.add".localized, icon: "checkmark", isDisabled: !isAddAppointmentFormValid) {
                            // Validierung
                            let validation = InputValidator.shared.validateAppointment(title: title, date: date)
                            if !validation.isValid {
                                ErrorHandler.shared.handle(.validationFailed(validation.errorMessage ?? "Ungültige Eingabe"))
                                return
                            }
                            
                            let appointment = Appointment(
                                petId: pet.id,
                                title: title.trimmingCharacters(in: .whitespaces),
                                date: date,
                                veterinarian: veterinarian.trimmingCharacters(in: .whitespaces),
                                location: location.trimmingCharacters(in: .whitespaces),
                                notes: notes.trimmingCharacters(in: .whitespaces)
                            )
                            healthRecordManager.addAppointment(appointment)
                            
                            // Zeige Interstitial Ad nach Termin erstellen (maximaler Profit)
                            AdManager.shared.showInterstitialAfterAction()
                            
                            // Schedule appointment reminder if enabled
                            let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                            let isAuthorized = NotificationManager.shared.checkAuthorizationStatusSync()
                            
                            print("📅 Neuer Termin erstellt: \(appointment.title)")
                            print("   - Datum: \(appointment.date)")
                            print("   - Benachrichtigungen aktiviert: \(notificationsEnabled), Berechtigt: \(isAuthorized)")
                            
                            if notificationsEnabled && isAuthorized {
                                print("📅 Plane Benachrichtigung für neuen Termin...")
                                NotificationManager.shared.scheduleAppointmentReminder(appointment: appointment, petName: pet.name)
                            } else {
                                print("⚠️ Benachrichtigung nicht geplant: enabled=\(notificationsEnabled), authorized=\(isAuthorized)")
                            }
                            dismiss()
                        }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("appointments.add".localized)
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

// MARK: - Edit Appointment View
struct EditAppointmentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let appointment: Appointment
    
    @State private var title: String
    @State private var date: Date
    @State private var veterinarian: String
    @State private var location: String
    @State private var notes: String
    @State private var isCompleted: Bool
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isEditAppointmentFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(healthRecordManager: HealthRecordManager, appointment: Appointment) {
        self.healthRecordManager = healthRecordManager
        self.appointment = appointment
        _title = State(initialValue: appointment.title)
        _date = State(initialValue: appointment.date)
        _veterinarian = State(initialValue: appointment.veterinarian)
        _location = State(initialValue: appointment.location)
        _notes = State(initialValue: appointment.notes)
        _isCompleted = State(initialValue: appointment.isCompleted)
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
                                Text("common.title".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("appointments.titlePlaceholder".localized, text: $title)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("appointments.dateTime".localized)
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
                                
                                TextField("appointments.veterinarianPlaceholder".localized, text: $veterinarian)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("appointments.location".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("appointments.locationPlaceholder".localized, text: $location)
                                    .id(localizationManager.currentLanguage)
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
                            
                            Toggle("appointments.completed".localized, isOn: $isCompleted)
                                .id(localizationManager.currentLanguage)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark", isDisabled: !isEditAppointmentFormValid) {
                            if !title.isEmpty {
                                var updated = appointment
                                updated.title = title
                                updated.date = date
                                updated.veterinarian = veterinarian
                                updated.location = location
                                updated.notes = notes
                                updated.isCompleted = isCompleted
                                healthRecordManager.updateAppointment(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("appointments.edit".localized)
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




