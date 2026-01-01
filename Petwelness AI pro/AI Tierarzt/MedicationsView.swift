//
//  MedicationsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct MedicationsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddMedication = false
    @State private var selectedMedication: Medication? = nil
    @State private var medicationToDelete: Medication? = nil
    @State private var showDeleteConfirmation = false
    
    var medications: [Medication] {
        healthRecordManager.getMedications(for: pet.id)
    }
    
    var activeMedications: [Medication] {
        medications.filter { $0.isActive }
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
                        
                        Text("medications.title".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddMedication = true }) {
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
                            if !activeMedications.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Medications List
                            if medications.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                medicationsListView
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
            .sheet(isPresented: $showAddMedication) {
                AddMedicationView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(item: $selectedMedication) { medication in
                EditMedicationView(healthRecordManager: healthRecordManager, medication: medication)
                    .environmentObject(localizationManager)
            }
            .alert("Medikament löschen", isPresented: $showDeleteConfirmation) {
                Button("Abbrechen", role: .cancel) {
                    medicationToDelete = nil
                }
                Button("Löschen", role: .destructive) {
                    if let medication = medicationToDelete {
                        healthRecordManager.deleteMedication(medication)
                        // Lösche auch die Benachrichtigungen
                        NotificationManager.shared.cancelMedicationReminder(medication: medication)
                        medicationToDelete = nil
                    }
                }
            } message: {
                if let medication = medicationToDelete {
                    Text(String(format: "common.deleteItemConfirm".localized, medication.name))
                        .id(localizationManager.currentLanguage)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "pills.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentOrange)
                
                Text("medications.active".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(activeMedications.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.brandPrimary)
            }
            
            Text("\(activeMedications.count) " + "medications.beingAdministered".localized)
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
    
    private var medicationsListView: some View {
        // Performance: Verwende LazyVStack für bessere Performance bei vielen Medikamenten
        LazyVStack(spacing: Spacing.md) {
            ForEach(medications) { medication in
                MedicationCard(
                    medication: medication,
                    onTap: {
                        selectedMedication = medication
                    },
                    onDelete: {
                        medicationToDelete = medication
                        showDeleteConfirmation = true
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "pills.fill")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("medications.noMedications".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("medications.addToTrack".localized)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct MedicationCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let medication: Medication
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
                    
                    Image(systemName: "pills.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentOrange)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(medication.name)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        if medication.isActive {
                            Text("common.active".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.smallCaption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.accentGreen)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text("\(medication.dosage) • \(medication.frequency)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("\(LocalizedStrings.get("medications.since")) \(medication.startDate, format: .dateTime.day().month().year())")
                        .id(localizationManager.currentLanguage)
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
            }
        }
    }
}

// MARK: - Add Medication View
struct AddMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var name = ""
    @State private var dosage = ""
    @State private var frequency: String = LocalizedStrings.get("medications.frequency.daily")
    @State private var times: [Date] = [Date()]
    @State private var startDate = Date()
    @State private var endDate: Date? = nil
    @State private var hasEndDate = false
    @State private var notes = ""
    @State private var notificationsEnabled = true
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isAddMedicationFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !dosage.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var frequencies: [String] {
        [
            "medications.frequency.daily".localized,
            "medications.frequency.twiceDaily".localized,
            "medications.frequency.threeTimesDaily".localized,
            "medications.frequency.weekly".localized,
            "medications.frequency.asNeeded".localized
        ]
    }
    private var dosageChips: [String] {
        [
            "medications.dosage.quarterTab".localized,
            "medications.dosage.halfTab".localized,
            "medications.dosage.oneTab".localized,
            "medications.dosage.twoTab".localized,
            "medications.dosage.twoPointFiveMl".localized,
            "medications.dosage.fiveMl".localized,
            "medications.dosage.tenMl".localized,
            "medications.dosage.twoDrops".localized,
            "medications.dosage.fiveDrops".localized,
            "medications.dosage.oneCapsule".localized
        ]
    }
    
    // Anzahl der benötigten Uhrzeiten basierend auf Häufigkeit
    private var numberOfTimes: Int {
        let daily = "medications.frequency.daily".localized
        let weekly = "medications.frequency.weekly".localized
        let asNeeded = "medications.frequency.asNeeded".localized
        let twiceDaily = "medications.frequency.twiceDaily".localized
        let threeTimesDaily = "medications.frequency.threeTimesDaily".localized
        
        switch frequency {
        case daily, weekly, asNeeded:
            return 1
        case twiceDaily:
            return 2
        case threeTimesDaily:
            return 3
        default:
            return 1
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Header mit Icon
                        headerView
                        
                        // Form
                        VStack(spacing: Spacing.lg) {
                            // Medikamentenname
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("medications.name".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                TextField("medications.namePlaceholder".localized, text: $name)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            // Dosierung
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("medications.dosage".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                TextField("medications.dosagePlaceholder".localized, text: $dosage)
                                    .textFieldStyle(AppTextFieldStyle())
                                
                                // Dosierungs-Chips
                                dosageChipsView
                            }
                            
                            // Häufigkeit
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.textSecondary)
                                    Text("medications.frequency".localized)
                                        .font(.bodyTextBold)
                                        .foregroundColor(.textPrimary)
                                        .id(localizationManager.currentLanguage)
                                }
                                
                                Picker("medications.frequency".localized, selection: $frequency) {
                                    ForEach(frequencies, id: \.self) { freq in
                                        Text(freq).tag(freq)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            // Uhrzeiten
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text(numberOfTimes > 1 ? "medications.times".localized : "medications.time".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                ForEach(0..<numberOfTimes, id: \.self) { index in
                                    HStack {
                                        if numberOfTimes > 1 {
                                            Text("\(index + 1).")
                                                .font(.bodyText)
                                                .foregroundColor(.textSecondary)
                                                .frame(width: 30)
                                        }
                                        
                                        TextField("--:--", text: Binding(
                                            get: {
                                                let formatter = DateFormatter()
                                                formatter.timeStyle = .short
                                                return formatter.string(from: times[safe: index] ?? Date())
                                            },
                                            set: { _ in }
                                        ))
                                        .disabled(true)
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: Binding(
                                            get: { times[safe: index] ?? Date() },
                                            set: { newValue in
                                                if times.count <= index {
                                                    times.append(contentsOf: Array(repeating: Date(), count: index + 1 - times.count))
                                                }
                                                times[index] = newValue
                                            }
                                        ), displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                    }
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                                }
                            }
                            .onChange(of: frequency) { _ in
                                // Passe die Anzahl der Zeiten an
                                let neededCount = numberOfTimes
                                if times.count < neededCount {
                                    // Füge fehlende Zeiten hinzu
                                    let currentTime = times.first ?? Date()
                                    times.append(contentsOf: Array(repeating: currentTime, count: neededCount - times.count))
                                } else if times.count > neededCount {
                                    // Entferne überschüssige Zeiten
                                    times = Array(times.prefix(neededCount))
                                }
                            }
                            
                            // Startdatum
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.textSecondary)
                                    Text("medications.startDate".localized)
                                        .font(.bodyTextBold)
                                        .foregroundColor(.textPrimary)
                                        .id(localizationManager.currentLanguage)
                                }
                                
                                HStack {
                                    TextField("tt.mm.jjjj", text: Binding(
                                        get: {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "dd.MM.yyyy"
                                            return formatter.string(from: startDate)
                                        },
                                        set: { _ in }
                                    ))
                                    .disabled(true)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: $startDate, displayedComponents: .date)
                                        .labelsHidden()
                                }
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            // Enddatum
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("medications.endDate".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                HStack {
                                    TextField("tt.mm.jjjj", text: Binding(
                                        get: {
                                            if let endDate = endDate {
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "dd.MM.yyyy"
                                                return formatter.string(from: endDate)
                                            }
                                            return ""
                                        },
                                        set: { _ in }
                                    ))
                                    .disabled(true)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: Binding(
                                        get: { endDate ?? Date() },
                                        set: { endDate = $0 }
                                    ), displayedComponents: .date)
                                    .labelsHidden()
                                }
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            // Notizen
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("medications.notes".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                TextEditor(text: $notes)
                                    .frame(minHeight: 100)
                                    .padding(Spacing.sm)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            // Benachrichtigungen
                            notificationsToggleView
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        
                        // Save Button
                        PrimaryButton("medications.add".localized, icon: "plus", isDisabled: !isAddMedicationFormValid) {
                            // Validierung
                            let validation = InputValidator.shared.validateMedication(name: name, dosage: dosage)
                            if !validation.isValid {
                                ErrorHandler.shared.handle(.validationFailed(validation.errorMessage ?? "Ungültige Eingabe"))
                                return
                            }
                            
                            // Formatiere Uhrzeiten für Notes
                            let formatter = DateFormatter()
                            formatter.timeStyle = .short
                            let timesString = times.map { formatter.string(from: $0) }.joined(separator: ", ")
                            
                            var finalNotes = notes
                            if !timesString.isEmpty {
                                let timesNote = "Uhrzeiten: \(timesString)"
                                if finalNotes.isEmpty {
                                    finalNotes = timesNote
                                } else {
                                    finalNotes = "\(timesNote)\n\n\(finalNotes)"
                                }
                            }
                            
                            let medication = Medication(
                                petId: pet.id,
                                name: name.trimmingCharacters(in: .whitespaces),
                                dosage: dosage.trimmingCharacters(in: .whitespaces),
                                frequency: frequency,
                                startDate: startDate,
                                endDate: endDate,
                                notes: finalNotes,
                                isActive: true // Immer aktiv beim Erstellen
                            )
                            
                            print("💊 Neues Medikament erstellt: \(medication.name)")
                            print("   - isActive: \(medication.isActive)")
                            print("   - frequency: \(medication.frequency)")
                            print("   - startDate: \(medication.startDate)")
                            print("   - endDate: \(medication.endDate?.description ?? "kein Enddatum")")
                            
                            healthRecordManager.addMedication(medication)
                            
                            // Zeige Interstitial Ad nach Medikament hinzufügen (maximaler Profit)
                            AdManager.shared.showInterstitialAfterAction()
                            
                            // Schedule notification if enabled in settings
                            let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                            let isAuthorized = NotificationManager.shared.checkAuthorizationStatusSync()
                            
                            print("🔔 Benachrichtigungen aktiviert: \(notificationsEnabled), Berechtigt: \(isAuthorized)")
                            
                            if notificationsEnabled && isAuthorized {
                                print("📅 Plane Benachrichtigung für neues Medikament...")
                                NotificationManager.shared.scheduleMedicationReminder(medication: medication, petName: pet.name)
                            } else {
                                print("⚠️ Benachrichtigung nicht geplant: enabled=\(notificationsEnabled), authorized=\(isAuthorized)")
                            }
                            dismiss()
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || dosage.trimmingCharacters(in: .whitespaces).isEmpty)
                        .opacity(name.isEmpty ? 0.5 : 1.0)
                        .padding(.horizontal, Spacing.xl)
                        
                        // Tipp
                        tipView
                            .padding(.horizontal, Spacing.xl)
                            .padding(.bottom, Spacing.xl)
                    }
                    .padding(.top, Spacing.lg)
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .topTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .padding(Spacing.md)
                }
                .padding(Spacing.lg)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(LinearGradient.brand)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "pills.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text("medications.add".localized)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("medications.manage".localized)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
        }
        .padding(.top, Spacing.xl)
    }
    
    // MARK: - Dosage Chips View
    private var dosageChipsView: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            let firstRow = Array(dosageChips.prefix(6))
            let secondRow = Array(dosageChips.suffix(4))
            
            HStack(spacing: Spacing.xs) {
                ForEach(firstRow, id: \.self) { chip in
                    Button(action: {
                        dosage = chip
                    }) {
                        Text(chip)
                            .font(.caption)
                            .foregroundColor(.brandPrimary)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xs)
                            .background(Color.brandPrimary.opacity(0.1))
                            .cornerRadius(CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(Color.brandPrimary.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            
            HStack(spacing: Spacing.xs) {
                ForEach(secondRow, id: \.self) { chip in
                    Button(action: {
                        dosage = chip
                    }) {
                        Text(chip)
                            .font(.caption)
                            .foregroundColor(.brandPrimary)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xs)
                            .background(Color.brandPrimary.opacity(0.1))
                            .cornerRadius(CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(Color.brandPrimary.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(.top, Spacing.xs)
    }
    
    // MARK: - Notifications Toggle View
    private var notificationsToggleView: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: "bell.fill")
                .font(.system(size: 20))
                .foregroundColor(.brandPrimary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("medications.notifications".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                    .id(localizationManager.currentLanguage)
                
                Text("medications.receiveReminders".localized)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .id(localizationManager.currentLanguage)
            }
            
            Spacer()
            
            Toggle("", isOn: $notificationsEnabled)
                .labelsHidden()
        }
        .padding(Spacing.md)
        .background(Color.brandPrimary.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
    }
    
    // MARK: - Tip View
    private var tipView: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
            
            Text("medications.tip".localized)
                .font(.caption)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .id(localizationManager.currentLanguage)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.medium)
    }
    
}

// MARK: - Edit Medication View
struct EditMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let medication: Medication
    
    @State private var name: String
    @State private var dosage: String
    @State private var frequency: String
    @State private var times: [Date]
    @State private var startDate: Date
    @State private var endDate: Date?
    @State private var hasEndDate: Bool
    @State private var notes: String
    @State private var isActive: Bool
    @State private var notificationsEnabled = true
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isEditMedicationFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !dosage.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var frequencies: [String] {
        [
            "medications.frequency.daily".localized,
            "medications.frequency.twiceDaily".localized,
            "medications.frequency.threeTimesDaily".localized,
            "medications.frequency.weekly".localized,
            "medications.frequency.asNeeded".localized
        ]
    }
    private var dosageChips: [String] {
        [
            "medications.dosage.quarterTab".localized,
            "medications.dosage.halfTab".localized,
            "medications.dosage.oneTab".localized,
            "medications.dosage.twoTab".localized,
            "medications.dosage.twoPointFiveMl".localized,
            "medications.dosage.fiveMl".localized,
            "medications.dosage.tenMl".localized,
            "medications.dosage.twoDrops".localized,
            "medications.dosage.fiveDrops".localized,
            "medications.dosage.oneCapsule".localized
        ]
    }
    
    // Anzahl der benötigten Uhrzeiten basierend auf Häufigkeit
    private var numberOfTimes: Int {
        let daily = "medications.frequency.daily".localized
        let weekly = "medications.frequency.weekly".localized
        let asNeeded = "medications.frequency.asNeeded".localized
        let twiceDaily = "medications.frequency.twiceDaily".localized
        let threeTimesDaily = "medications.frequency.threeTimesDaily".localized
        
        switch frequency {
        case daily, weekly, asNeeded:
            return 1
        case twiceDaily:
            return 2
        case threeTimesDaily:
            return 3
        default:
            return 1
        }
    }
    
    init(healthRecordManager: HealthRecordManager, medication: Medication) {
        self.healthRecordManager = healthRecordManager
        self.medication = medication
        
        // Extrahiere Uhrzeiten aus Notes
        let extractedTimes = EditMedicationView.extractTimes(from: medication.notes)
        let cleanNotes = EditMedicationView.removeTimesFromNotes(medication.notes)
        
        _name = State(initialValue: medication.name)
        _dosage = State(initialValue: medication.dosage)
        _frequency = State(initialValue: medication.frequency)
        _times = State(initialValue: extractedTimes.isEmpty ? [Date()] : extractedTimes)
        _startDate = State(initialValue: medication.startDate)
        _endDate = State(initialValue: medication.endDate)
        _hasEndDate = State(initialValue: medication.endDate != nil)
        _notes = State(initialValue: cleanNotes)
        _isActive = State(initialValue: medication.isActive)
    }
    
    // Helper: Extrahiere Uhrzeiten aus Notes
    private static func extractTimes(from notes: String) -> [Date] {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        if notes.contains("Uhrzeiten:") {
            let components = notes.components(separatedBy: "Uhrzeiten:")
            if components.count > 1 {
                let timesString = components[1].components(separatedBy: "\n\n").first ?? ""
                let timeStrings = timesString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                return timeStrings.compactMap { formatter.date(from: String($0)) }
            }
        }
        return []
    }
    
    // Helper: Entferne Uhrzeiten aus Notes
    private static func removeTimesFromNotes(_ notes: String) -> String {
        if notes.contains("Uhrzeiten:") {
            let components = notes.components(separatedBy: "Uhrzeiten:")
            if components.count > 1 {
                let afterTimes = components[1].components(separatedBy: "\n\n")
                if afterTimes.count > 1 {
                    return afterTimes[1].trimmingCharacters(in: .whitespaces)
                }
            }
            return components[0].trimmingCharacters(in: .whitespaces)
        }
        return notes
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Header mit Icon
                        headerView
                        
                        // Form
                        VStack(spacing: Spacing.lg) {
                            // Medikamentenname
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("medications.name".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                TextField("medications.namePlaceholder".localized, text: $name)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            // Dosierung
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("medications.dosage".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                TextField("medications.dosagePlaceholder".localized, text: $dosage)
                                    .textFieldStyle(AppTextFieldStyle())
                                
                                // Dosierungs-Chips
                                dosageChipsView
                            }
                            
                            // Häufigkeit
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.textSecondary)
                                    Text("medications.frequency".localized)
                                        .font(.bodyTextBold)
                                        .foregroundColor(.textPrimary)
                                        .id(localizationManager.currentLanguage)
                                }
                                
                                Picker("medications.frequency".localized, selection: $frequency) {
                                    ForEach(frequencies, id: \.self) { freq in
                                        Text(freq).tag(freq)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            // Uhrzeiten
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text(numberOfTimes > 1 ? "medications.times".localized : "medications.time".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                ForEach(0..<numberOfTimes, id: \.self) { index in
                                    HStack {
                                        if numberOfTimes > 1 {
                                            Text("\(index + 1).")
                                                .font(.bodyText)
                                                .foregroundColor(.textSecondary)
                                                .frame(width: 30)
                                        }
                                        
                                        TextField("--:--", text: Binding(
                                            get: {
                                                let formatter = DateFormatter()
                                                formatter.timeStyle = .short
                                                return formatter.string(from: times[safe: index] ?? Date())
                                            },
                                            set: { _ in }
                                        ))
                                        .disabled(true)
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: Binding(
                                            get: { times[safe: index] ?? Date() },
                                            set: { newValue in
                                                if times.count <= index {
                                                    times.append(contentsOf: Array(repeating: Date(), count: index + 1 - times.count))
                                                }
                                                times[index] = newValue
                                            }
                                        ), displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                    }
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                                }
                            }
                            .onChange(of: frequency) { _ in
                                let neededCount = numberOfTimes
                                if times.count < neededCount {
                                    let currentTime = times.first ?? Date()
                                    times.append(contentsOf: Array(repeating: currentTime, count: neededCount - times.count))
                                } else if times.count > neededCount {
                                    times = Array(times.prefix(neededCount))
                                }
                            }
                            
                            // Startdatum
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.textSecondary)
                                    Text("medications.startDate".localized)
                                        .font(.bodyTextBold)
                                        .foregroundColor(.textPrimary)
                                        .id(localizationManager.currentLanguage)
                                }
                                
                                HStack {
                                    TextField("tt.mm.jjjj", text: Binding(
                                        get: {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "dd.MM.yyyy"
                                            return formatter.string(from: startDate)
                                        },
                                        set: { _ in }
                                    ))
                                    .disabled(true)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: $startDate, displayedComponents: .date)
                                        .labelsHidden()
                                }
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            // Enddatum
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("medications.endDate".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                HStack {
                                    TextField("tt.mm.jjjj", text: Binding(
                                        get: {
                                            if let endDate = endDate {
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "dd.MM.yyyy"
                                                return formatter.string(from: endDate)
                                            }
                                            return ""
                                        },
                                        set: { _ in }
                                    ))
                                    .disabled(true)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: Binding(
                                        get: { endDate ?? Date() },
                                        set: { endDate = $0 }
                                    ), displayedComponents: .date)
                                    .labelsHidden()
                                }
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            // Notizen
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("medications.notes".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                    .id(localizationManager.currentLanguage)
                                
                                TextEditor(text: $notes)
                                    .frame(minHeight: 100)
                                    .padding(Spacing.sm)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            // Benachrichtigungen
                            notificationsToggleView
                            
                            // Aktiv Status
                            Toggle("medications.isActive".localized, isOn: $isActive)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        
                        // Save Button
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark", isDisabled: !isEditMedicationFormValid) {
                            // Formatiere Uhrzeiten für Notes
                            let formatter = DateFormatter()
                            formatter.timeStyle = .short
                            let timesString = times.map { formatter.string(from: $0) }.joined(separator: ", ")
                            
                            var finalNotes = notes
                            if !timesString.isEmpty {
                                let timesNote = "Uhrzeiten: \(timesString)"
                                if finalNotes.isEmpty {
                                    finalNotes = timesNote
                                } else {
                                    finalNotes = "\(timesNote)\n\n\(finalNotes)"
                                }
                            }
                            
                            var updated = medication
                            updated.name = name
                            updated.dosage = dosage
                            updated.frequency = frequency
                            updated.startDate = startDate
                            updated.endDate = endDate
                            updated.notes = finalNotes
                            updated.isActive = isActive
                            healthRecordManager.updateMedication(updated)
                            dismiss()
                        }
                        .disabled(name.isEmpty)
                        .opacity(name.isEmpty ? 0.5 : 1.0)
                        .padding(.horizontal, Spacing.xl)
                        
                        // Tipp
                        tipView
                            .padding(.horizontal, Spacing.xl)
                            .padding(.bottom, Spacing.xl)
                    }
                    .padding(.top, Spacing.lg)
                }
            }
            .onAppear {
                // Initialisiere die Zeiten basierend auf der Häufigkeit
                let neededCount = numberOfTimes
                if times.count != neededCount {
                    let currentTime = times.first ?? Date()
                    times = Array(repeating: currentTime, count: neededCount)
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .topTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .padding(Spacing.md)
                }
                .padding(Spacing.lg)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(LinearGradient.brand)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "pills.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text("medications.edit".localized)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("medications.manage".localized)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
        }
        .padding(.top, Spacing.xl)
    }
    
    // MARK: - Dosage Chips View
    private var dosageChipsView: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            let firstRow = Array(dosageChips.prefix(6))
            let secondRow = Array(dosageChips.suffix(4))
            
            HStack(spacing: Spacing.xs) {
                ForEach(firstRow, id: \.self) { chip in
                    Button(action: {
                        dosage = chip
                    }) {
                        Text(chip)
                            .font(.caption)
                            .foregroundColor(.brandPrimary)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xs)
                            .background(Color.brandPrimary.opacity(0.1))
                            .cornerRadius(CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(Color.brandPrimary.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            
            HStack(spacing: Spacing.xs) {
                ForEach(secondRow, id: \.self) { chip in
                    Button(action: {
                        dosage = chip
                    }) {
                        Text(chip)
                            .font(.caption)
                            .foregroundColor(.brandPrimary)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xs)
                            .background(Color.brandPrimary.opacity(0.1))
                            .cornerRadius(CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(Color.brandPrimary.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(.top, Spacing.xs)
    }
    
    // MARK: - Notifications Toggle View
    private var notificationsToggleView: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: "bell.fill")
                .font(.system(size: 20))
                .foregroundColor(.brandPrimary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("medications.notifications".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Text("medications.receiveReminders".localized)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $notificationsEnabled)
                .labelsHidden()
        }
        .padding(Spacing.md)
        .background(Color.brandPrimary.opacity(0.1))
        .cornerRadius(CornerRadius.medium)
    }
    
    // MARK: - Tip View
    private var tipView: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
            
            Text("medications.tip".localized)
                .font(.caption)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Array Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

