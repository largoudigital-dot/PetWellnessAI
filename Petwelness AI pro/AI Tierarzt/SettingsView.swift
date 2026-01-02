//
//  SettingsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var systemColorScheme
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("colorSchemeMode") private var colorSchemeMode = "light" // Standard: Light Mode
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("autoDesignUpdates") private var autoDesignUpdates = true
    @AppStorage("autoModeEnabled") private var autoModeEnabled = false // Standard: Manuell
    
    @StateObject private var petManager = PetManager()
    @StateObject private var healthRecordManager = HealthRecordManager()
    
    @State private var showExportData = false
    @State private var showDeleteConfirmation = false
    @State private var showPrivacyPolicy = false
    @State private var showImprint = false
    @State private var showTerms = false
    @State private var showHelp = false
    
    // Bestimme aktuellen ColorScheme basierend auf Einstellungen
    private var currentColorScheme: ColorScheme {
        if autoModeEnabled {
            return systemColorScheme
        } else {
            return colorSchemeMode == "dark" ? .dark : .light
        }
    }
    
    // Version aus Bundle laden
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    var body: some View {
        ZStack {
            // Background with Paw Prints
            PawPrintBackground(opacity: 0.036, size: 45, spacing: 90)
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Custom Header
                    HStack {
                        Text("settings.title".localized)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.xl)
                    .padding(.top, Spacing.md)
                    
                    // Banner Ad am oberen Bildrand (unter "Paramètres")
                    if AdManager.shared.shouldShowBannerAds {
                        BannerAdView()
                            .frame(height: 50)
                            .padding(.horizontal, Spacing.xl)
                            .padding(.top, Spacing.md)
                    }
                    
                        // Darstellung / Appearance
                        VStack(alignment: .leading, spacing: Spacing.lg) {
                            Text("settings.appearance".localized)
                                .font(.sectionTitle)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            VStack(spacing: 0) {
                                // Immer neues Design
                                HStack(spacing: Spacing.md) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 1.0))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: Spacing.xs) {
                                        Text("settings.alwaysNewDesign".localized)
                                            .font(.bodyTextBold)
                                            .foregroundColor(.textPrimary)
                                        
                                        Text("settings.autoDesignUpdates".localized)
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $autoDesignUpdates)
                                        .labelsHidden()
                                        .tint(.green)
                                }
                                .padding(Spacing.lg)
                                
                                Divider()
                                    .padding(.horizontal, Spacing.xl)
                                
                                // Automatisch Option
                                HStack(spacing: Spacing.md) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "circle.lefthalf.filled")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 1.0))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: Spacing.xs) {
                                        Text("settings.automatic".localized)
                                            .font(.bodyTextBold)
                                            .foregroundColor(.textPrimary)
                                        
                                        Text("settings.useSystemSetting".localized)
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { autoModeEnabled },
                                        set: { newValue in
                                            autoModeEnabled = newValue
                                            if newValue {
                                                colorSchemeMode = "auto"
                                            } else {
                                                // Wenn automatisch ausgeschaltet, setze auf aktuelles System-Theme
                                                if colorSchemeMode == "auto" {
                                                    colorSchemeMode = systemColorScheme == .dark ? "dark" : "light"
                                                }
                                            }
                                            // Force update
                                            UserDefaults.standard.set(newValue, forKey: "autoModeEnabled")
                                            UserDefaults.standard.synchronize()
                                        }
                                    ))
                                        .labelsHidden()
                                        .tint(.green)
                                }
                                .padding(Spacing.lg)
                                
                                Divider()
                                    .padding(.horizontal, Spacing.xl)
                                
                                // Design-Modus mit Segmented Control
                                HStack(spacing: Spacing.md) {
                                    VStack(alignment: .leading, spacing: Spacing.xs) {
                                        Text("settings.designMode".localized)
                                            .font(.bodyTextBold)
                                            .foregroundColor(.textPrimary)
                                        
                                        Text(autoModeEnabled ? "settings.autoActive".localized : "settings.manualSelect".localized)
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    // Segmented Control Style Picker
                                    HStack(spacing: 0) {
                                        // Light Mode Button
                                        Button(action: {
                                            // Deaktiviere automatisch zuerst
                                            autoModeEnabled = false
                                            
                                            // Dann setze Light Mode
                                            colorSchemeMode = "light"
                                            
                                            // Force immediate update
                                            UserDefaults.standard.set("light", forKey: "colorSchemeMode")
                                            UserDefaults.standard.set(false, forKey: "autoModeEnabled")
                                            UserDefaults.standard.synchronize()
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(colorSchemeMode == "light" && !autoModeEnabled ? (currentColorScheme == .dark ? Color(white: 0.3) : Color(white: 0.3)) : Color.clear)
                                                    .frame(width: 50, height: 36)
                                                
                                                // Sonnen-Symbol - immer sichtbar
                                                Image(systemName: "sun.max.fill")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(
                                                        colorSchemeMode == "light" && !autoModeEnabled ? 
                                                        .white : 
                                                        (currentColorScheme == .dark ? 
                                                         Color(white: 0.7) : // Hellgrau im Dark Mode Hintergrund
                                                         Color(white: 0.5))  // Mittelgrau im Light Mode Hintergrund
                                                    )
                                            }
                                        }
                                        
                                        // Dark Mode Button
                                        Button(action: {
                                            // Deaktiviere automatisch zuerst
                                            autoModeEnabled = false
                                            
                                            // Dann setze Dark Mode
                                            colorSchemeMode = "dark"
                                            
                                            // Force immediate update
                                            UserDefaults.standard.set("dark", forKey: "colorSchemeMode")
                                            UserDefaults.standard.set(false, forKey: "autoModeEnabled")
                                            UserDefaults.standard.synchronize()
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(colorSchemeMode == "dark" && !autoModeEnabled ? Color(red: 0.2, green: 0.6, blue: 1.0) : Color.clear)
                                                    .frame(width: 50, height: 36)
                                                
                                                // Mond-Symbol - immer sichtbar mit besserer Kontrastfarbe
                                                Image(systemName: "moon.fill")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(
                                                        colorSchemeMode == "dark" && !autoModeEnabled ? 
                                                        .white : 
                                                        (currentColorScheme == .dark ? 
                                                         Color(white: 0.7) : // Hellgrau im Dark Mode Hintergrund
                                                         Color(white: 0.5))  // Mittelgrau im Light Mode Hintergrund
                                                    )
                                            }
                                        }
                                    }
                                    .padding(2)
                                    .background(
                                        // Hintergrund passt sich an Dark Mode an
                                        currentColorScheme == .dark ? 
                                        Color(white: 0.2) : 
                                        Color(white: 0.9)
                                    )
                                    .cornerRadius(10)
                                }
                                .padding(Spacing.lg)
                                .opacity(autoModeEnabled ? 0.6 : 1.0)
                            }
                            .background(Color.backgroundSecondary)
                            .cornerRadius(CornerRadius.large)
                            .padding(.horizontal, Spacing.xl)
                        }
                        .padding(.top, Spacing.lg)
                        
                        // Sprache / Language
                        VStack(alignment: .leading, spacing: Spacing.lg) {
                            Text("settings.language".localized)
                                .font(.sectionTitle)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            // Alle Sprachen in einem Container
                            VStack(spacing: 0) {
                                ForEach(Array(localizationManager.availableLanguages.enumerated()), id: \.element.code) { index, language in
                                    LanguageRow(
                                        name: language.native,
                                        flag: language.flag,
                                        isSelected: localizationManager.currentLanguage == language.code
                                    ) {
                                        localizationManager.setLanguage(language.code)
                                    }
                                    
                                    // Divider zwischen allen Einträgen außer dem letzten
                                    if index < localizationManager.availableLanguages.count - 1 {
                                        Divider()
                                            .padding(.horizontal, Spacing.xl)
                                    }
                                }
                            }
                            .background(Color.backgroundSecondary)
                            .cornerRadius(CornerRadius.large)
                            .padding(.horizontal, Spacing.xl)
                        }
                        .padding(.top, Spacing.lg)
                        
                        // Benachrichtigungen
                        VStack(alignment: .leading, spacing: Spacing.lg) {
                            Text("settings.notifications".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.sectionTitle)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            VStack(spacing: 0) {
                                HStack(spacing: Spacing.md) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "bell.fill")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 1.0))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: Spacing.xs) {
                                        Text("settings.reminders".localized)
                                            .id(localizationManager.currentLanguage)
                                            .font(.bodyTextBold)
                                            .foregroundColor(.textPrimary)
                                        
                                        Text("settings.notificationsForMedications".localized)
                                            .id(localizationManager.currentLanguage)
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { 
                                            notificationsEnabled && NotificationManager.shared.isAuthorized
                                        },
                                        set: { newValue in
                                            if newValue {
                                                // Prüfe zuerst den aktuellen Status synchron
                                                let currentStatus = NotificationManager.shared.getAuthorizationStatus()
                                                print("🔔 Benachrichtigungsstatus: \(currentStatus.rawValue)")
                                                
                                                if currentStatus == .authorized {
                                                    // Bereits autorisiert, aktiviere einfach
                                                    print("✅ Bereits autorisiert, plane Benachrichtigungen...")
                                                    notificationsEnabled = true
                                                    NotificationManager.shared.isAuthorized = true
                                                    
                                                    // Plane alle Benachrichtigungen neu
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        scheduleAllActiveMedications()
                                                    }
                                                    
                                                    // Zeige geplante Benachrichtigungen nach kurzer Verzögerung
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        NotificationManager.shared.listPendingNotifications()
                                                    }
                                                } else if currentStatus == .notDetermined {
                                                    // Frage nach Berechtigung
                                                    print("❓ Frage nach Benachrichtigungsberechtigung...")
                                                    NotificationManager.shared.requestAuthorization { granted in
                                                        if granted {
                                                            print("✅ Berechtigung erteilt!")
                                                            notificationsEnabled = true
                                                            
                                                            // Plane alle Benachrichtigungen neu
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                                scheduleAllActiveMedications()
                                                            }
                                                            
                                                            // Zeige geplante Benachrichtigungen nach kurzer Verzögerung
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                NotificationManager.shared.listPendingNotifications()
                                                            }
                                                        } else {
                                                            print("❌ Berechtigung verweigert")
                                                            notificationsEnabled = false
                                                        }
                                                    }
                                                } else {
                                                    // Berechtigung wurde verweigert, öffne Einstellungen
                                                    print("⚠️ Berechtigung wurde verweigert, öffne Einstellungen...")
                                                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                                        UIApplication.shared.open(settingsUrl)
                                                    }
                                                    notificationsEnabled = false
                                                }
                                            } else {
                                                print("🔕 Benachrichtigungen deaktiviert")
                                                notificationsEnabled = false
                                                NotificationManager.shared.cancelAllNotifications()
                                            }
                                        }
                                    ))
                                        .labelsHidden()
                                        .tint(.green)
                                    
                                }
                                .padding(Spacing.lg)
                                
                                Divider()
                                    .padding(.horizontal, Spacing.xl)
                                
                                HStack(spacing: Spacing.md) {
                                    Image(systemName: "info.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.textSecondary)
                                        .frame(width: 40)
                                    
                                    VStack(alignment: .leading, spacing: Spacing.xs) {
                                        Text("settings.permissions".localized)
                                            .id(localizationManager.currentLanguage)
                                            .font(.bodyTextBold)
                                            .foregroundColor(.textPrimary)
                                        
                                        Text("settings.activateNotificationsInSettings".localized)
                                            .id(localizationManager.currentLanguage)
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button("settings.open".localized) {
                                        if let url = URL(string: UIApplication.openSettingsURLString) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.brandPrimary)
                                }
                                .padding(Spacing.lg)
                            }
                            .background(Color.backgroundSecondary)
                            .cornerRadius(CornerRadius.large)
                            .padding(.horizontal, Spacing.xl)
                        }
                        
                        // Daten
                        VStack(alignment: .leading, spacing: Spacing.lg) {
                            Text("settings.data".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.sectionTitle)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            VStack(spacing: Spacing.md) {
                                SettingsRow(
                                    icon: "trash.fill",
                                    iconColor: .accentRed,
                                    title: "settings.deleteAllData".localized,
                                    description: "settings.removeAllPetsAndHealthData".localized,
                                    localizationManager: localizationManager,
                                    action: {
                                        showDeleteConfirmation = true
                                    }
                                )
                            }
                            .padding(.horizontal, Spacing.xl)
                        }
                        
                        // App-Informationen
                        VStack(alignment: .leading, spacing: Spacing.lg) {
                            Text("settings.appInfo".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.sectionTitle)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, Spacing.xl)
                            
                            VStack(spacing: Spacing.md) {
                                SettingsInfoRow(
                                    icon: "info.circle.fill",
                                    iconColor: .accentBlue,
                                    title: "settings.version".localized,
                                    description: appVersion,
                                    showArrow: false,
                                    localizationManager: localizationManager,
                                    action: nil
                                )
                                
                                SettingsInfoRow(
                                    icon: "lock.fill",
                                    iconColor: .accentPurple,
                                    title: "settings.privacyPolicy".localized,
                                    description: "settings.privacyInfo".localized,
                                    showArrow: true,
                                    localizationManager: localizationManager,
                                    action: {
                                        showPrivacyPolicy = true
                                    }
                                )
                                
                                SettingsInfoRow(
                                    icon: "info.circle.fill",
                                    iconColor: .accentBlue,
                                    title: "settings.imprint".localized,
                                    description: "settings.contactAndLegal".localized,
                                    showArrow: true,
                                    localizationManager: localizationManager,
                                    action: {
                                        showImprint = true
                                    }
                                )
                                
                                SettingsInfoRow(
                                    icon: "doc.text.fill",
                                    iconColor: .accentOrange,
                                    title: "settings.terms".localized,
                                    description: "settings.generalTerms".localized,
                                    showArrow: true,
                                    localizationManager: localizationManager,
                                    action: {
                                        showTerms = true
                                    }
                                )
                                
                                SettingsInfoRow(
                                    icon: "questionmark.circle.fill",
                                    iconColor: .accentOrange,
                                    title: "settings.helpSupport".localized,
                                    description: "settings.faqAndInstructions".localized,
                                    showArrow: true,
                                    localizationManager: localizationManager,
                                    action: {
                                        showHelp = true
                                    }
                                )
                            }
                            .padding(.horizontal, Spacing.xl)
                        }
                        .padding(.bottom, 50) // Platz für navigation bar
                    }
                }
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
                .environmentObject(localizationManager)
        }
        .sheet(isPresented: $showImprint) {
            ImprintView()
                .environmentObject(localizationManager)
        }
        .sheet(isPresented: $showTerms) {
            TermsOfServiceView()
                .environmentObject(localizationManager)
        }
        .sheet(isPresented: $showHelp) {
            HelpSupportView()
                .environmentObject(localizationManager)
        }
        .onAppear {
            // Prüfe Benachrichtigungsberechtigung beim Öffnen der Einstellungen
            NotificationManager.shared.checkAuthorizationStatus()
            
            // Wenn Benachrichtigungen aktiviert sind, aber keine Berechtigung vorhanden ist, deaktiviere den Toggle
            if notificationsEnabled && !NotificationManager.shared.isAuthorized {
                notificationsEnabled = false
            }
        }
        .alert("settings.deleteAllDataQuestion".localized, isPresented: $showDeleteConfirmation) {
            Button("common.cancel".localized, role: .cancel) {}
            Button("common.delete".localized, role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("settings.deleteAllDataWarning".localized)
                .id(localizationManager.currentLanguage)
        }
    }
    
    // MARK: - Export Data
    private func exportAllData() {
        let exportData = AppDataExport(
            pets: petManager.pets,
            medications: healthRecordManager.medications,
            vaccinations: healthRecordManager.vaccinations,
            appointments: healthRecordManager.appointments,
            veterinarians: healthRecordManager.veterinarians,
            expenses: healthRecordManager.expenses,
            consultations: healthRecordManager.consultations,
            weightRecords: healthRecordManager.weightRecords,
            feedingRecords: healthRecordManager.feedingRecords,
            photos: healthRecordManager.photos,
            interactions: healthRecordManager.interactions,
            symptoms: healthRecordManager.symptoms,
            waterIntakes: healthRecordManager.waterIntakes,
            activities: healthRecordManager.activities,
            bathroomRecords: healthRecordManager.bathroomRecords,
            groomingRecords: healthRecordManager.groomingRecords,
            exerciseRecords: healthRecordManager.exerciseRecords,
            journalEntries: healthRecordManager.journalEntries,
            documents: healthRecordManager.documents,
            exportDate: Date()
        )
        
        if let jsonData = try? JSONEncoder().encode(exportData),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            // Erstelle temporäre Datei
            let fileName = "AI_Tierarzt_Export_\(Date().timeIntervalSince1970).json"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try jsonString.write(to: tempURL, atomically: true, encoding: .utf8)
                let activityVC = UIActivityViewController(
                    activityItems: [tempURL],
                    applicationActivities: nil
                )
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(activityVC, animated: true)
                }
            } catch {
                print("Fehler beim Export: \(error)")
            }
        }
    }
    
    // MARK: - Delete All Data
    private func deleteAllData() {
        petManager.deleteAllData()
        healthRecordManager.deleteAllData()
        NotificationManager.shared.cancelAllNotifications()
        dismiss()
    }
    
    // MARK: - Notifications
    private func scheduleAllActiveMedications() {
        print("🔄 ========== PLANE ALLE AKTIVEN BENACHRICHTIGUNGEN ==========")
        
        // Prüfe zuerst die Berechtigung
        let authorized = NotificationManager.shared.checkAuthorizationStatusSync()
        guard authorized else {
            print("❌ KEINE BEREchtigung - Benachrichtigungen können nicht geplant werden")
            return
        }
        print("✅ Berechtigung vorhanden")
        
        // Medikamente
        let activeMedications = healthRecordManager.medications.filter { medication in
            let isActive = medication.isActive
            let notExpired = medication.endDate == nil || medication.endDate! > Date()
            return isActive && notExpired
        }
        print("📋 Gefundene aktive Medikamente: \(activeMedications.count) von \(healthRecordManager.medications.count) insgesamt")
        
        if activeMedications.isEmpty {
            print("⚠️ KEINE AKTIVEN MEDIKAMENTE GEFUNDEN!")
            print("   - Gesamt Medikamente: \(healthRecordManager.medications.count)")
            print("   - Aktive Medikamente: \(healthRecordManager.medications.filter { $0.isActive }.count)")
        }
        
        for medication in activeMedications {
            if let pet = petManager.pets.first(where: { $0.id == medication.petId }) {
                print("  💊 Plane Benachrichtigung für: \(medication.name)")
                print("     - Häufigkeit: \(medication.frequency)")
                print("     - Startdatum: \(medication.startDate)")
                print("     - Enddatum: \(medication.endDate?.description ?? "kein Enddatum")")
                print("     - Aktiv: \(medication.isActive)")
                NotificationManager.shared.scheduleMedicationReminder(medication: medication, petName: pet.name)
            } else {
                print("  ⚠️ Kein Haustier gefunden für Medikament: \(medication.name) (petId: \(medication.petId))")
            }
        }
        
        // Impfungen
        let upcomingVaccinations = healthRecordManager.vaccinations.filter { 
            guard let nextDue = $0.nextDueDate else { return false }
            return nextDue > Date() && !$0.isCompleted
        }
        print("📋 Gefundene anstehende Impfungen: \(upcomingVaccinations.count)")
        
        for vaccination in upcomingVaccinations {
            if let pet = petManager.pets.first(where: { $0.id == vaccination.petId }) {
                print("  💉 Plane Benachrichtigung für Impfung: \(vaccination.name)")
                NotificationManager.shared.scheduleVaccinationReminder(vaccination: vaccination, petName: pet.name)
            }
        }
        
        // Termine
        let upcomingAppointments = healthRecordManager.appointments.filter { 
            $0.date > Date() && !$0.isCompleted
        }
        print("📋 Gefundene anstehende Termine: \(upcomingAppointments.count)")
        
        for appointment in upcomingAppointments {
            if let pet = petManager.pets.first(where: { $0.id == appointment.petId }) {
                print("  📅 Plane Benachrichtigung für Termin: \(appointment.title) am \(appointment.date)")
                NotificationManager.shared.scheduleAppointmentReminder(appointment: appointment, petName: pet.name)
            }
        }
        
        print("🔄 ========== FERTIG ==========")
        
        // Zeige alle geplanten Benachrichtigungen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NotificationManager.shared.listPendingNotifications()
        }
    }
    
    // MARK: - Backup
    private func createBackup() {
        if let backup = BackupManager.shared.createBackup(petManager: petManager, healthRecordManager: healthRecordManager) {
            if let url = BackupManager.shared.exportBackupToFile() {
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(activityVC, animated: true)
                }
            }
        }
    }
    
    private func restoreBackup() {
        // In a real implementation, you would use a document picker
        // For now, we'll restore from the saved backup
        if BackupManager.shared.restoreBackup(petManager: petManager, healthRecordManager: healthRecordManager) {
            // Show success message
        }
    }
}

// MARK: - App Data Export
struct AppDataExport: Codable {
    let pets: [Pet]
    let medications: [Medication]
    let vaccinations: [Vaccination]
    let appointments: [Appointment]
    let veterinarians: [Veterinarian]
    let expenses: [Expense]
    let consultations: [Consultation]
    let weightRecords: [WeightRecord]
    let feedingRecords: [FeedingRecord]
    let photos: [PetPhoto]
    let interactions: [Interaction]
    let symptoms: [Symptom]
    let waterIntakes: [WaterIntake]
    let activities: [ActivityRecord]
    let bathroomRecords: [BathroomRecord]
    let groomingRecords: [GroomingRecord]
    let exerciseRecords: [ExerciseRecord]
    let journalEntries: [JournalEntry]
    let documents: [Document]
    let exportDate: Date
}

// MARK: - Privacy Policy View (removed - now in PrivacyPolicyView.swift)

// MARK: - Imprint View
struct ImprintView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("settings.imprint".localized)
                        .id(localizationManager.currentLanguage)
                        .font(.sectionTitle)
                        .foregroundColor(.textPrimary)
                    
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        SectionView(
                            title: "imprint.tmgInfo".localized,
                            content: "PetWellness AI\nSupport & Development\nHannover, Germany",
                            localizationManager: localizationManager
                        )
                        
                        SectionView(
                            title: "imprint.contact".localized,
                            content: "Developer: devlargou\nE-Mail: largou.digital@gmail.com\nWeb: https://devlargou.com",
                            localizationManager: localizationManager
                        )
                        
                        SectionView(
                            title: "imprint.responsibleForContent".localized,
                            content: "devlargou\nHannover, Germany",
                            localizationManager: localizationManager
                        )
                    }
                }
                .padding(Spacing.xl)
            }
            .navigationTitle("settings.imprint".localized)
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

// MARK: - Terms View (Legacy - wird durch TermsOfServiceView.swift ersetzt)
struct TermsView_Legacy: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("settings.generalTerms".localized)
                        .id(localizationManager.currentLanguage)
                        .font(.sectionTitle)
                        .foregroundColor(.textPrimary)
                    
                    Text("\("privacy.asOf".localized) \(Date(), style: .date)")
                        .id(localizationManager.currentLanguage)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        SectionView(
                            title: "terms.scope".localized,
                            content: "terms.scopeContent".localized,
                            localizationManager: localizationManager
                        )
                        
                        SectionView(
                            title: "terms.services".localized,
                            content: "terms.servicesContent".localized,
                            localizationManager: localizationManager
                        )
                        
                        SectionView(
                            title: "terms.liability".localized,
                            content: "terms.liabilityContent".localized,
                            localizationManager: localizationManager
                        )
                        
                        SectionView(
                            title: "terms.dataProtection".localized,
                            content: "terms.dataProtectionContent".localized,
                            localizationManager: localizationManager
                        )
                    }
                }
                .padding(Spacing.xl)
            }
            .navigationTitle("settings.terms".localized)
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

// MARK: - Help & Support View
struct HelpSupportView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("settings.helpSupport".localized)
                        .id(localizationManager.currentLanguage)
                        .font(.sectionTitle)
                        .foregroundColor(.textPrimary)
                    
                    // Support Website Link
                    if let supportURL = URL(string: "https://devlargou.com/PetWellnessAI/support.html") {
                        Link(destination: supportURL) {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.brandPrimary)
                                Text("help.visitSupportWebsite".localized)
                                    .id(localizationManager.currentLanguage)
                                    .foregroundColor(.brandPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .foregroundColor(.brandPrimary)
                            }
                            .padding(Spacing.md)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(CornerRadius.medium)
                        }
                        .padding(.bottom, Spacing.md)
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        FAQView(
                            question: "help.howToAddPet".localized,
                            answer: "help.howToAddPetAnswer".localized,
                            localizationManager: localizationManager
                        )
                        
                        FAQView(
                            question: "help.howToAddMedication".localized,
                            answer: "help.howToAddMedicationAnswer".localized,
                            localizationManager: localizationManager
                        )
                        
                        FAQView(
                            question: "help.howToExportData".localized,
                            answer: "help.howToExportDataAnswer".localized,
                            localizationManager: localizationManager
                        )
                        
                        FAQView(
                            question: "help.isDataStoredInCloud".localized,
                            answer: "help.isDataStoredInCloudAnswer".localized,
                            localizationManager: localizationManager
                        )
                        
                        FAQView(
                            question: "help.howToDeleteAllData".localized,
                            answer: "help.howToDeleteAllDataAnswer".localized,
                            localizationManager: localizationManager
                        )
                    }
                }
                .padding(Spacing.xl)
            }
            .navigationTitle("settings.helpSupport".localized)
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

// MARK: - Helper Views
struct SectionView: View {
    let title: String
    let content: String
    let localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            
            Text(content)
                .id(localizationManager.currentLanguage)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.medium)
    }
}

struct FAQView: View {
    let question: String
    let answer: String
    let localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(question)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            
            Text(answer)
                .id(localizationManager.currentLanguage)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.medium)
    }
}

struct LanguageRow: View {
    let name: String
    let flag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                // Flag Emoji
                Text(flag)
                    .font(.system(size: 24))
                    .frame(width: 32)
                
                // Language Name
                Text(name)
                    .font(.bodyText)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                // Checkmark wenn ausgewählt
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let localizationManager: LocalizationManager
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(iconColor)
                    .cornerRadius(CornerRadius.small)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .id(localizationManager.currentLanguage)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text(description)
                        .id(localizationManager.currentLanguage)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
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
    }
}

struct AppearanceRow: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Icon mit Hintergrund für bessere Sichtbarkeit
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.brandPrimary)
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
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.brandPrimary)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .contentShape(Rectangle())
        .padding(Spacing.lg)
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let showArrow: Bool
    let localizationManager: LocalizationManager
    let action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(iconColor)
                    .cornerRadius(CornerRadius.small)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .id(localizationManager.currentLanguage)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text(description)
                        .id(localizationManager.currentLanguage)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(Spacing.lg)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.large)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(action == nil)
    }
}

