//
//  HomeView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @StateObject private var petManager = PetManager()
    @StateObject private var navigationCoordinator = NavigationCoordinator.shared
    @StateObject private var healthRecordManager = HealthRecordManager()
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var appState: AppState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @AppStorage("colorSchemeMode") private var colorSchemeMode = "light" // Standard: Light Mode
    @AppStorage("autoModeEnabled") private var autoModeEnabled = true
    @State private var showAddPet = false
    @State private var showSymptoms = false
    @State private var showPhotoAnalysis = false
    @State private var showEmergency = false
    @State private var selectedPet: Pet? = nil
    @State private var showMedications = false
    @State private var showAppointments = false
    @State private var showVaccinations = false
    @State private var selectedMedication: Medication? = nil
    @State private var selectedAppointment: Appointment? = nil
    @State private var selectedVaccination: Vaccination? = nil
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    // Adaptive sizes for iPad
    private var heroHeight: CGFloat { isIPad ? 160 : 112 }
    private var appNameSize: CGFloat { isIPad ? 34 : 23 }
    private var taglineSize: CGFloat { isIPad ? 16 : 10 }
    private var sectionTitleSize: CGFloat { isIPad ? 24 : 20 }
    private var maxContentWidth: CGFloat { isIPad ? 1000 : .infinity }
    
    var pets: [Pet] {
        petManager.pets
    }
    
    var body: some View {
            ZStack {
                // Background with Paw Prints
                PawPrintBackground(opacity: 0.036, size: 45, spacing: 90)
                
                ScrollView {
                VStack(spacing: isIPad ? Spacing.xl : Spacing.lg) {
                        // Hero Section with Gradient
                        heroSectionView
                    
                    // Quick Dashboard Overview - immer anzeigen
                    quickDashboardView
                        
                        // Quick Actions - 2x2 Grid
                        quickActionsView
                        
                        // Pets Section
                        petsSectionView
                    }
                    .padding(.horizontal, isIPad ? Spacing.xxxl : Spacing.xl)
                .padding(.top, isIPad ? Spacing.lg : Spacing.md)
                .padding(.bottom, isIPad ? 120 : 100) // Genug Platz für navigation bar + Safe Area
                    .frame(maxWidth: maxContentWidth)
                    .frame(maxWidth: .infinity)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .allowsHitTesting(true)
            .sheet(isPresented: $showAddPet) {
                AddPetView(petManager: petManager)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showSymptoms) {
                SymptomInputView()
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showPhotoAnalysis) {
                PhotoAnalysisView()
                    .environmentObject(LocalizationManager.shared)
                    .environmentObject(localizationManager)
                    .environmentObject(appState)
            }
            .sheet(isPresented: $showEmergency) {
                EmergencyView()
                    .environmentObject(localizationManager)
                    .environmentObject(appState)
            }
            .onChange(of: navigationCoordinator.navigationTarget) { target in
                handleNavigation(target: target)
            }
            .sheet(item: $selectedPet) { pet in
                PetProfileView(petManager: petManager, pet: pet)
                    .environmentObject(localizationManager)
                    .environmentObject(appState)
            }
            .sheet(isPresented: $showMedications) {
                if let pet = findPet(by: navigationCoordinator.selectedPetId) {
                    MedicationsView(healthRecordManager: healthRecordManager, pet: pet)
                        .environmentObject(localizationManager)
                }
            }
            .sheet(isPresented: $showAppointments) {
                if let pet = findPet(by: navigationCoordinator.selectedPetId) {
                    AppointmentsView(healthRecordManager: healthRecordManager, pet: pet)
                        .environmentObject(localizationManager)
                }
            }
            .sheet(isPresented: $showVaccinations) {
                if let pet = findPet(by: navigationCoordinator.selectedPetId) {
                    VaccinationsView(healthRecordManager: healthRecordManager, pet: pet)
                        .environmentObject(localizationManager)
                }
            }
            .sheet(item: $selectedMedication) { medication in
                if let pet = findPet(by: medication.petId) {
                    EditMedicationView(healthRecordManager: healthRecordManager, medication: medication)
                        .environmentObject(localizationManager)
                }
            }
            .sheet(item: $selectedAppointment) { appointment in
                if let pet = findPet(by: appointment.petId) {
                    EditAppointmentView(healthRecordManager: healthRecordManager, appointment: appointment)
                        .environmentObject(localizationManager)
                }
            }
            .sheet(item: $selectedVaccination) { vaccination in
                if let pet = findPet(by: vaccination.petId) {
                    EditVaccinationView(healthRecordManager: healthRecordManager, vaccination: vaccination)
                        .environmentObject(localizationManager)
            }
        }
    }
    
    // MARK: - Navigation Handler
    private func handleNavigation(target: NavigationCoordinator.NavigationTarget?) {
        guard let target = target else { return }
        
        switch target {
        case .medication(let medicationId, let petId):
            // Finde Pet und öffne Pet Profile, dann Medikamente
            if let pet = findPet(by: petId) {
                selectedPet = pet
                // Warte kurz, dann öffne Medikamente
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showMedications = true
                    // Finde das spezifische Medikament
                    if let medication = healthRecordManager.medications.first(where: { $0.id == medicationId }) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            selectedMedication = medication
                        }
                    }
                }
            }
            navigationCoordinator.clearNavigation()
            
        case .appointment(let appointmentId, let petId):
            if let pet = findPet(by: petId) {
                selectedPet = pet
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showAppointments = true
                    if let appointment = healthRecordManager.appointments.first(where: { $0.id == appointmentId }) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            selectedAppointment = appointment
                        }
                    }
                }
            }
            navigationCoordinator.clearNavigation()
            
        case .vaccination(let vaccinationId, let petId):
            if let pet = findPet(by: petId) {
                selectedPet = pet
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showVaccinations = true
                    if let vaccination = healthRecordManager.vaccinations.first(where: { $0.id == vaccinationId }) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            selectedVaccination = vaccination
                        }
                    }
                }
            }
            navigationCoordinator.clearNavigation()
            
        case .petProfile(let petId):
            if let pet = findPet(by: petId) {
                selectedPet = pet
            }
            navigationCoordinator.clearNavigation()
        }
    }
    
    private func findPet(by id: UUID?) -> Pet? {
        guard let id = id else { return nil }
        return petManager.pets.first { $0.id == id }
    }
    
    // MARK: - Hero Section
    private var heroSectionView: some View {
        VStack(spacing: 0) {
            ZStack {
                BrandGradient()
                    .frame(height: heroHeight)
                    .cornerRadius(isIPad ? CornerRadius.xlarge : CornerRadius.large)
                
                // Paw Pattern Overlay
                HStack {
                    Spacer()
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: isIPad ? 120 : 84))
                        .foregroundColor(.white.opacity(0.1))
                        .offset(x: isIPad ? 30 : 22, y: isIPad ? 30 : 22)
                        .rotationEffect(.degrees(-15))
                }
                .clipped()
                
                VStack(spacing: Spacing.xs) {
                    HStack {
                        VStack(alignment: .leading, spacing: isIPad ? 6 : 3) {
                            Text("app.name".localized)
                                .font(.system(size: appNameSize, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("app.tagline".localized)
                                .font(.system(size: taglineSize, weight: .medium))
                                .foregroundColor(.white.opacity(0.95))
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        // Theme Toggle Switch
                        ThemeToggleSwitch(
                            isDarkMode: Binding(
                                get: { colorSchemeMode == "dark" },
                                set: { isDark in
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        if autoModeEnabled {
                                            autoModeEnabled = false
                                        }
                                        colorSchemeMode = isDark ? "dark" : "light"
                                    }
                                }
                            )
                        )
                    }
                    .padding(isIPad ? Spacing.lg : Spacing.md)
                }
            }
        }
    }
    
    // MARK: - Quick Dashboard
    private var quickDashboardView: some View {
        VStack(spacing: Spacing.md) {
            // Health Score Card
            let healthScore = calculateHealthScore()
            let progress = Double(healthScore) / 100.0
            
            VStack(spacing: isIPad ? Spacing.md : Spacing.sm) {
                HStack(alignment: .center) {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: isIPad ? 26 : 18))
                        .foregroundColor(.accentRed)
                    
                    Text("health.score".localized)
                        .font(.system(size: isIPad ? 22 : 15, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Text("\(healthScore)")
                        .font(.system(size: isIPad ? 32 : 22, weight: .bold))
                        .foregroundColor(.accentRed)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: isIPad ? 6 : 4)
                            .fill(Color.accentRed.opacity(0.2))
                            .frame(height: isIPad ? 8 : 6)
                        
                        RoundedRectangle(cornerRadius: isIPad ? 6 : 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color.accentRed, Color.accentOrange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: isIPad ? 8 : 6)
                    }
                }
                .frame(height: isIPad ? 8 : 6)
            }
            .padding(isIPad ? Spacing.lg : Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? CornerRadius.large : 16)
                    .fill(Color.backgroundSecondary)
            )
            
            // Banner Ad zwischen Score de santé und Tracking-Karten
            if AdManager.shared.shouldShowBannerAds {
                BannerAdView()
                    .frame(height: 50)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.sm)
            }
            
            // Quick Stats - Horizontal Row
            HStack(spacing: Spacing.xs) {
                QuickStatCard(
                    icon: "calendar.badge.clock",
                    value: "\(todayTasksCount)",
                    subtitle: "dashboard.tasks".localized,
                    color: .brandPrimary
                )
                
                QuickStatCard(
                    icon: "pills.fill",
                    value: "\(medicationsDueCount)",
                    subtitle: "dashboard.medications".localized,
                    color: .accentOrange
                )
                
                QuickStatCard(
                    icon: "figure.walk",
                    value: "\(todayActivityMinutes)",
                    subtitle: "dashboard.minutes".localized,
                    color: .accentGreen
                )
                
                QuickStatCard(
                    icon: "fork.knife",
                    value: "\(todayFeedingsCount)",
                    subtitle: "dashboard.meals".localized,
                    color: .accentBlue
                )
            }
        }
    }
    
    private func calculateHealthScore() -> Int {
        // Wenn keine Haustiere vorhanden sind, Score = 0
        if petManager.pets.isEmpty {
            return 0
        }
        
        var score = 100
        
        // Reduziere Score basierend auf Symptomen heute
        let recentSymptoms = healthRecordManager.symptoms.filter { symptom in
            Calendar.current.isDate(symptom.date, inSameDayAs: Date())
        }
        score -= recentSymptoms.count * 5
        
        // Reduziere Score wenn Medikamente verpasst wurden (nur wenn Medikamente vorhanden sind)
        let activeMedications = healthRecordManager.medications.filter { medication in
            medication.isActive && medication.startDate <= Date() && (medication.endDate == nil || medication.endDate! >= Date())
        }
        
        if !activeMedications.isEmpty {
            // Prüfe ob Medikamente heute eingenommen wurden
            let todayMedicationsTaken = activeMedications.filter { medication in
                // Prüfe ob Medikament heute eingenommen wurde (vereinfacht: wenn startDate heute ist)
                Calendar.current.isDateInToday(medication.startDate)
            }
            
            // Wenn Medikamente vorhanden sind, aber keine heute eingenommen wurden, reduziere Score
            if todayMedicationsTaken.isEmpty && activeMedications.contains(where: { Calendar.current.isDateInToday($0.startDate) == false }) {
                score -= 5
            }
        }
        
        // Reduziere Score wenn keine Aktivität heute (nur wenn Haustiere vorhanden sind)
        let todayActivities = healthRecordManager.activities.filter { activity in
            Calendar.current.isDateInToday(activity.date)
        }
        if todayActivities.isEmpty {
            score -= 5
        }
        
        return max(0, min(100, score))
    }
    
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
    
    private var todayActivityMinutes: Int {
        let todayActivities = healthRecordManager.activities.filter { activity in
            Calendar.current.isDateInToday(activity.date)
        }
        return todayActivities.reduce(0) { $0 + $1.duration }
    }
    
    private var todayFeedingsCount: Int {
        let todayFeedings = healthRecordManager.feedingRecords.filter { feeding in
            Calendar.current.isDateInToday(feeding.time)
        }
        return todayFeedings.count
    }
    
    // MARK: - Quick Actions
    private var quickActionsView: some View {
        VStack(spacing: isIPad ? Spacing.md : Spacing.sm) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: isIPad ? Spacing.md : Spacing.sm),
                GridItem(.flexible(), spacing: isIPad ? Spacing.md : Spacing.sm)
            ], spacing: isIPad ? Spacing.md : Spacing.sm) {
                // Symptome eingeben
                QuickActionCard(
                    icon: "stethoscope",
                    title: "action.symptoms".localized,
                    description: "action.symptomsDesc".localized,
                    iconColor: .brandPrimary,
                    backgroundColor: Color(red: 0.85, green: 0.95, blue: 0.92)
                ) {
                    showSymptoms = true
                }
                
                // Foto-Analyse
                QuickActionCard(
                    icon: "camera.fill",
                    title: "action.photo".localized,
                    description: "action.photoDesc".localized,
                    iconColor: .accentGreen,
                    backgroundColor: Color(red: 0.85, green: 0.95, blue: 0.85)
                ) {
                    // Öffne Foto-Auswahl und dann direkt zum Chat
                    showPhotoAnalysis = true
                }
                
                // AI-Chat
                QuickActionCard(
                    icon: "message.fill",
                    title: "action.chat".localized,
                    description: "action.chatDesc".localized,
                    iconColor: Color(red: 0.0, green: 0.5, blue: 1.0), // Blau wie Navigation Bar Button
                    backgroundColor: Color(red: 0.9, green: 0.95, blue: 1.0) // Helleres Blau für besseren Kontrast
                ) {
                    // Wechsel zu Chat-Tab in Navigation Bar
                    appState.selectedTab = 4
                }
                
                // Notfall
                QuickActionCard(
                    icon: "exclamationmark.triangle.fill",
                    title: "action.emergency".localized,
                    description: "action.emergencyDesc".localized,
                    iconColor: .accentRed,
                    backgroundColor: Color(red: 1.0, green: 0.90, blue: 0.90),
                    isEmergency: true
                ) {
                    showEmergency = true
                }
            }
        }
    }
    
    // MARK: - Pets Section
    private var petsSectionView: some View {
        VStack(alignment: .leading, spacing: isIPad ? Spacing.xl : Spacing.lg) {
            HStack {
                Text("pets.myPets".localized)
                    .font(.system(size: sectionTitleSize, weight: .semibold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: isIPad ? Spacing.md : Spacing.sm) {
                    Button(action: {
                        showAddPet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: isIPad ? 22 : 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: isIPad ? 50 : 36, height: isIPad ? 50 : 36)
                            .background(LinearGradient.brand)
                            .cornerRadius(isIPad ? CornerRadius.medium : CornerRadius.small)
                            .shadow(color: Color.black.opacity(0.15), radius: isIPad ? 6 : 4, x: 0, y: 2)
                    }
                }
            }
            
            if pets.isEmpty {
                emptyStateView
            } else {
                // Performance: LazyVStack für bessere Performance bei vielen Haustieren
                ForEach(pets) { pet in
                    PetCard(pet: pet, selectedPet: $selectedPet, petManager: petManager)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        Button(action: {
            showAddPet = true
        }) {
            VStack {
                // Empty card placeholder
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .fill(Color.backgroundSecondary)
                    .frame(height: 100)
                    .overlay(
                        VStack(spacing: Spacing.sm) {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.textSecondary)
                            
                            Text("pets.noPets".localized)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
}

// MARK: - Pet Model
struct Pet: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var type: String
    var breed: String
    var age: Int
    var emoji: String
    var healthStatus: String
    var lastCheck: Date
    var profileImageData: Data? // Profilbild als Data
    
    init(id: UUID = UUID(), name: String, type: String, breed: String, age: Int, emoji: String, healthStatus: String = "Gesund", lastCheck: Date = Date(), profileImageData: Data? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.breed = breed
        self.age = age
        self.emoji = emoji
        self.healthStatus = healthStatus
        self.lastCheck = lastCheck
        self.profileImageData = profileImageData
    }
    
    // Hashable conformance - use id for hashing
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable conformance (required for Hashable)
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Pet Card
struct PetCard: View {
    let pet: Pet
    @Binding var selectedPet: Pet?
    @ObservedObject var petManager: PetManager
    @EnvironmentObject var localizationManager: LocalizationManager
    
    // Aktuelles Pet aus dem Manager holen (wird automatisch aktualisiert)
    var currentPet: Pet {
        petManager.pets.first { $0.id == pet.id } ?? pet
    }
    
    var body: some View {
        let pet = currentPet // Verwende aktuelles Pet
        Button(action: {
            // Setze selectedPet, das Sheet öffnet sich automatisch
            selectedPet = pet
        }) {
            HStack(spacing: Spacing.sm) {
                // Avatar with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.brandPrimary.opacity(0.2), Color.brandPrimary.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 58, height: 58)
                    
                    if let imageData = pet.profileImageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 58, height: 58)
                            .clipShape(Circle())
                    } else {
                        Text(pet.emoji)
                            .font(.system(size: 36))
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 3) {
                    Text(pet.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Text("\(pet.type) • \(pet.breed)")
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(pet.healthStatus == "Gesund" ? Color.accentGreen : Color.accentOrange)
                            .frame(width: 5, height: 5)
                        
                        Text(pet.healthStatus == "Gesund" ? "pet.healthy".localized : "pet.unhealthy".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.system(size: 10))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.sm)
            .background(
                LinearGradient(
                    colors: [
                        Color.backgroundSecondary,
                        Color.backgroundSecondary.opacity(0.5)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(CornerRadius.small)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(Color.brandPrimary.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Add Pet View
struct AddPetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var petManager: PetManager
    
    @State private var name = ""
    @State private var type = "Dog"
    @State private var breed = ""
    @State private var age = ""
    @State private var selectedEmoji = "🐕"
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showEmojiPicker = false
    @State private var usePhoto = true
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isAddPetFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !breed.trimmingCharacters(in: .whitespaces).isEmpty &&
        !age.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(age) != nil
    }
    
    var petTypes: [(String, String)] {
        [
            ("Dog", "🐕"),
            ("Cat", "🐱"),
            ("Bird", "🐦"),
            ("Rodent", "🐹"),
            ("Reptile", "🦎"),
            ("Other", "pawprint.fill")
        ]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Avatar Section
                        VStack(spacing: Spacing.lg) {
                            ZStack(alignment: .bottomTrailing) {
                                // Large Avatar Circle
                                ZStack {
                                    Circle()
                                        .fill(Color.brandPrimaryLight)
                                        .frame(width: 112, height: 112)
                                    
                                    if let image = selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 112, height: 112)
                                            .clipShape(Circle())
                                    } else {
                                        Text(selectedEmoji)
                                            .font(.system(size: 56))
                                    }
                                }
                                
                                // Camera Button
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .frame(width: 32, height: 32)
                                        .background(Color.gray)
                                        .clipShape(Circle())
                                }
                            }
                            
                            // Photo/Emoji Selection Buttons
                            HStack(spacing: Spacing.md) {
                                Button(action: {
                                    usePhoto = true
                                    showImagePicker = true
                                }) {
                                    HStack(spacing: Spacing.sm) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 16))
                                        Text("addPet.uploadPhoto".localized)
                                            .font(.bodyTextBold)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(Spacing.md)
                                    .background(LinearGradient.brand)
                                    .cornerRadius(CornerRadius.medium)
                                }
                                
                                Button(action: {
                                    usePhoto = false
                                    showEmojiPicker = true
                                }) {
                                    HStack(spacing: Spacing.sm) {
                                        Text("😊")
                                            .font(.system(size: 16))
                                        Text("addPet.chooseEmoji".localized)
                                            .font(.bodyTextBold)
                                    }
                                    .foregroundColor(.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(CornerRadius.medium)
                                }
                            }
                        }
                        .padding(.top, Spacing.xl)
                        
                        // Tierart Selection
                        VStack(alignment: .leading, spacing: Spacing.lg) {
                            Text("addPet.petType".localized)
                                .font(.bodyTextBold)
                                .foregroundColor(.textPrimary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: Spacing.md) {
                                ForEach(petTypes, id: \.0) { petType, emoji in
                                    PetTypeButton(
                                        title: getPetTypeLocalized(petType),
                                        emoji: emoji,
                                        isSelected: type == petType
                                    ) {
                                        type = petType
                                        if emoji != "pawprint.fill" {
                                            selectedEmoji = emoji
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Form Fields
                        VStack(spacing: Spacing.lg) {
                            // Name
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("addPet.name".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("addPet.namePlaceholder".localized, text: $name)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            // Breed
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("addPet.breed".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("addPet.breedPlaceholder".localized, text: $breed)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            // Age
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("addPet.age".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("addPet.agePlaceholder".localized, text: $age)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        
                        // Save Button
                        PrimaryButton("addPet.title".localized, icon: "checkmark", isDisabled: !isAddPetFormValid) {
                            // Validierung
                            let validation = InputValidator.shared.validatePet(name: name, type: type, breed: breed)
                            if !validation.isValid {
                                ErrorHandler.shared.handle(.validationFailed(validation.errorMessage ?? "Ungültige Eingabe"))
                                return
                            }
                            
                            let ageInt = Int(age) ?? 0
                            // Convert localized type back to English for storage
                            let storedType = getStoredPetType(type)
                            
                            // Profilbild speichern, wenn ein Foto ausgewählt wurde
                            var profileImageData: Data? = nil
                            if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                                profileImageData = imageData
                            }
                            
                            let newPet = Pet(
                                name: name.trimmingCharacters(in: .whitespaces),
                                type: storedType,
                                breed: breed.trimmingCharacters(in: .whitespaces),
                                age: ageInt,
                                emoji: selectedEmoji,
                                profileImageData: profileImageData
                            )
                            petManager.addPet(newPet)
                            
                            // Zeige Interstitial Ad nach Aktion
                            AdManager.shared.showInterstitialAfterAction()
                            
                            // Frage nach Benachrichtigungsberechtigung, wenn noch nicht erteilt
                            let notificationStatus = NotificationManager.shared.getAuthorizationStatus()
                            if notificationStatus == .notDetermined {
                                print("🔔 Tierprofil erstellt: Frage nach Benachrichtigungsberechtigung...")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    NotificationManager.shared.requestAuthorization { granted in
                                        if granted {
                                            print("✅ Benachrichtigungsberechtigung erteilt")
                                        } else {
                                            print("⚠️ Benachrichtigungsberechtigung verweigert")
                                        }
                                    }
                                }
                            }
                            
                            dismiss()
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || breed.trimmingCharacters(in: .whitespaces).isEmpty)
                        .padding(.top, Spacing.lg)
                    }
                    .padding(Spacing.xl)
                }
            }
            .navigationTitle("addPet.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showEmojiPicker) {
                EmojiPickerView(selectedEmoji: $selectedEmoji)
            }
        }
    }
    
    // Helper function to get localized pet type
    private func getPetTypeLocalized(_ type: String) -> String {
        switch type {
        case "Dog": return "addPet.petType.dog".localized
        case "Cat": return "addPet.petType.cat".localized
        case "Bird": return "addPet.petType.bird".localized
        case "Rodent": return "addPet.petType.rodent".localized
        case "Reptile": return "addPet.petType.reptile".localized
        case "Other": return "addPet.petType.other".localized
        default: return type
        }
    }
    
    // Helper function to convert localized type to stored type
    private func getStoredPetType(_ localizedType: String) -> String {
        // Map localized types back to English for storage
        let typeMap: [String: String] = [
            "addPet.petType.dog".localized: "Hund",
            "addPet.petType.cat".localized: "Katze",
            "addPet.petType.bird".localized: "Vogel",
            "addPet.petType.rodent".localized: "Nagetier",
            "addPet.petType.reptile".localized: "Reptil",
            "addPet.petType.other".localized: "Andere"
        ]
        return typeMap[localizedType] ?? localizedType
    }
}

struct PetTypeButton: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                if emoji == "pawprint.fill" {
                    Image(systemName: emoji)
                        .font(.system(size: 26))
                        .foregroundColor(.textSecondary)
                } else {
                    Text(emoji)
                        .font(.system(size: 26))
                }
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(
                isSelected ?
                Color.brandPrimary.opacity(0.15) :
                Color.backgroundSecondary
            )
            .cornerRadius(CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(
                        isSelected ?
                        Color.brandPrimary :
                        Color.textTertiary.opacity(0.3),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmojiPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedEmoji: String
    
    let emojis = ["🐕", "🐱", "🐦", "🐹", "🐰", "🐭", "🦎", "🐢", "🐠", "🐴", "🐷", "🐮", "🐸", "🐨", "🐼"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Spacing.lg) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button(action: {
                            selectedEmoji = emoji
                            dismiss()
                        }) {
                            Text(emoji)
                                .font(.system(size: 40))
                                .frame(width: 70, height: 70)
                                .background(
                                    selectedEmoji == emoji ?
                                    Color.brandPrimary.opacity(0.2) :
                                    Color.backgroundSecondary
                                )
                                .cornerRadius(CornerRadius.medium)
                        }
                    }
                }
                .padding(Spacing.xl)
            }
            .navigationTitle("Emoji wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Text Field Style
struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(Spacing.md)
            .background(Color.backgroundTertiary)
            .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Quick Stat Card
struct QuickStatCard: View {
    let icon: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(subtitle)
                .font(.system(size: 9))
                .foregroundColor(.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xs)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundSecondary)
        )
    }
}

#Preview {
    HomeView()
}

