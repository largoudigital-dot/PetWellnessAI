//
//  PetProfileView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI
import UIKit

struct PetProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var appState: AppState
    @ObservedObject var petManager: PetManager
    @StateObject private var healthRecordManager = HealthRecordManager()
    let pet: Pet
    
    // Aktuelles Pet aus dem Manager holen (wird automatisch aktualisiert)
    var currentPet: Pet {
        petManager.pets.first { $0.id == pet.id } ?? pet
    }
    
    @State private var showEditPet = false
    @State private var showChat = false
    @State private var showSymptoms = false
    @State private var showDeleteConfirmation = false
    @State private var showMedications = false
    @State private var showVaccinations = false
    @State private var showAppointments = false
    @State private var showConsultations = false
    @State private var showExpenses = false
    @State private var showVeterinarians = false
    @State private var showWeight = false
    @State private var showFeeding = false
    @State private var showPhotos = false
    @State private var showInteractions = false
    @State private var showSymptomEntries = false
    @State private var showWaterIntake = false
    @State private var showActivities = false
    @State private var showBathroom = false
    @State private var showGrooming = false
    @State private var showExercise = false
    @State private var showJournal = false
    @State private var showDocuments = false
    @State private var showCalendar = false
    @State private var showCharts = false
    @State private var showPhotoAnalysis = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        let pet = currentPet // Verwende aktuelles Pet
        
        return NavigationView {
            ZStack {
                // Background with Paw Prints
                PawPrintBackground(opacity: 0.036, size: 45, spacing: 90)
                
                VStack(spacing: 0) {
                    // Header Bar
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                        }
                        
                        Spacer()
                        
                        Text("petProfile.title".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showEditPet = true }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                        }
                    }
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.md)
                    .background(Color.backgroundPrimary)
                    
                    ScrollView {
                        VStack(spacing: Spacing.xl) {
                            // Profile Header Card
                            profileHeaderCard
                            .padding(.top, Spacing.md)
                        
                            // Quick Actions
                            quickActionsView
                            
                            // Gesundheitsakte
                            healthRecordsView
                            
                            // Additional Categories
                            additionalCategoriesView
                            
                            // Delete Button
                            deleteButtonView
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showEditPet) {
                EditPetView(petManager: petManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showChat) {
                ChatView()
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showSymptoms) {
                SymptomInputView()
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showMedications) {
                MedicationsView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showVaccinations) {
                VaccinationsView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showAppointments) {
                AppointmentsView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showConsultations) {
                ConsultationsView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showExpenses) {
                ExpensesView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showVeterinarians) {
                VeterinariansView(healthRecordManager: healthRecordManager)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showWeight) {
                WeightView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showFeeding) {
                FeedingView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showPhotos) {
                PhotosView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showInteractions) {
                InteractionsView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showSymptomEntries) {
                SymptomsView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showWaterIntake) {
                WaterIntakeView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showActivities) {
                ActivitiesView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showBathroom) {
                BathroomView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showGrooming) {
                GroomingView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showExercise) {
                ExerciseView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showJournal) {
                JournalView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showDocuments) {
                DocumentsView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showCalendar) {
                CalendarView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showCharts) {
                ChartsView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showPhotoAnalysis) {
                PhotoAnalysisView()
                    .environmentObject(localizationManager)
                    .environmentObject(appState)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .onChange(of: selectedImage) { newImage in
                guard let image = newImage, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
                
                // Verwende currentPet statt pet für aktuelle Daten
                let currentPet = petManager.pets.first { $0.id == pet.id } ?? pet
                
                // 1. Automatisch Foto zur Galerie hinzufügen
                let photo = PetPhoto(
                    petId: currentPet.id,
                    date: Date(),
                    title: "",
                    notes: "",
                    imageData: imageData
                )
                healthRecordManager.addPhoto(photo)
                
                // 2. Als Profilbild speichern
                var updatedPet = currentPet
                updatedPet.profileImageData = imageData
                petManager.updatePet(updatedPet)
                
                // Zeige Interstitial Ad nach Aktion
                AdManager.shared.showInterstitialAfterAction()
                
                // Warte kurz, damit die View aktualisiert wird, dann reset
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    selectedImage = nil
                }
            }
            .alert("petProfile.deletePet".localized, isPresented: $showDeleteConfirmation) {
                Button("common.cancel".localized, role: .cancel) { }
                Button("common.delete".localized, role: .destructive) {
                    petManager.deletePet(pet)
                    dismiss()
                }
            } message: {
                Text(String(format: "petProfile.deleteConfirmMessage".localized, pet.name))
            }
        }
    }
    
    // MARK: - Profile Header Card
    private var profileHeaderCard: some View {
        VStack(spacing: 0) {
            // Gradient Background
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.7, blue: 0.8), // Teal
                        Color(red: 0.3, green: 0.75, blue: 0.6)  // Green
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 180)
                .cornerRadius(CornerRadius.large)
                
                VStack(spacing: Spacing.md) {
                    // Avatar und Info Section
                    HStack(alignment: .top, spacing: Spacing.md) {
                        // Avatar
                        ZStack(alignment: .bottomTrailing) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 70, height: 70)
                                
                                // Zeige selectedImage, wenn vorhanden (neues Foto), sonst Profilbild oder Emoji
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                } else if let imageData = pet.profileImageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                } else {
                                    Text(pet.emoji)
                                        .font(.system(size: 40))
                                }
                            }
                            
                            // Kamera Button
                            Button(action: {
                                showImagePicker = true
                            }) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Pet Info
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pet.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(pet.type) • \(pet.age) " + "petProfile.ageYears".localized)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.lg)
                    
                    // Status Cards
                    HStack(spacing: Spacing.md) {
                        // Status Card
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(pet.healthStatus == "Gesund" ? Color.accentGreen : Color.accentOrange)
                                    .frame(width: 6, height: 6)
                                
                                Text("petProfile.status".localized)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Text(pet.healthStatus == "Gesund" ? "pet.healthy".localized : "pet.unhealthy".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Spacing.md)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(CornerRadius.medium)
                        
                        // Letzter Check Card
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("petProfile.lastCheck".localized)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 2) {
                                    Text(pet.lastCheck, format: .dateTime.day())
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text(pet.lastCheck, format: .dateTime.month(.abbreviated))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Text(pet.lastCheck, format: .dateTime.year())
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Spacing.md)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(CornerRadius.medium)
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, Spacing.lg)
                }
            }
        }
        .shadow(color: Color.black.opacity(0.2), radius: 14, x: 0, y: 7)
    }
    
    // MARK: - Quick Actions
    private var quickActionsView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: Spacing.sm),
            GridItem(.flexible(), spacing: Spacing.sm)
        ], spacing: Spacing.sm) {
            QuickActionProfileButton(
                icon: "message.fill",
                title: "petProfile.startChat".localized,
                color: .brandPrimary
            ) {
                showChat = true
            }
            
            QuickActionProfileButton(
                icon: "stethoscope",
                title: "petProfile.symptoms".localized,
                color: .brandPrimary
            ) {
                showSymptoms = true
            }
            
            QuickActionProfileButton(
                icon: "calendar",
                title: "calendar.title".localized,
                color: .accentBlue
            ) {
                showCalendar = true
            }
            
            QuickActionProfileButton(
                icon: "chart.line.uptrend.xyaxis",
                title: "charts.title".localized,
                color: .accentPurple
            ) {
                showCharts = true
            }
            
            QuickActionProfileButton(
                icon: "sparkles",
                title: "photoAnalysis.title".localized,
                color: .accentOrange
            ) {
                showPhotoAnalysis = true
            }
            
            QuickActionProfileButton(
                icon: "doc.fill",
                title: "petProfile.healthReport".localized,
                color: .accentGreen
            ) {
                if let url = ShareManager.shared.generatePDFReport(pet: pet, healthRecordManager: healthRecordManager) {
                    ShareManager.shared.sharePDF(url: url)
                }
            }
        }
        .padding(.top, Spacing.sm)
    }
    
    // MARK: - Health Records
    private var healthRecordsView: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("petProfile.healthRecord".localized)
                .font(.sectionTitle)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.md)
            
            VStack(spacing: Spacing.xs) {
                let medications = healthRecordManager.getMedications(for: pet.id)
                let activeMedications = medications.filter { $0.isActive }
                HealthRecordRow(
                    icon: "pills.fill",
                    iconColor: .accentOrange,
                    title: "petProfile.medications".localized,
                    subtitle: activeMedications.isEmpty ? "petProfile.noCurrentMedications".localized : "\(activeMedications.count) " + (activeMedications.count == 1 ? "medications.active".localized : "medications.active".localized)
                ) {
                    showMedications = true
                }
                
                // Banner Ad nach Medicamentos
                if AdManager.shared.shouldShowAds {
                    BannerAdView()
                        .frame(height: 50)
                        .padding(.vertical, Spacing.sm)
                }
                
                let vaccinations = healthRecordManager.getVaccinations(for: pet.id)
                HealthRecordRow(
                    icon: "calendar",
                    iconColor: .accentBlue,
                    title: "petProfile.vaccinations".localized,
                    subtitle: vaccinations.isEmpty ? "petProfile.noVaccinations".localized : "\(vaccinations.count) " + (vaccinations.count == 1 ? "vaccination" : "vaccinations")
                ) {
                    showVaccinations = true
                }
                
                let consultations = healthRecordManager.getConsultations(for: pet.id)
                HealthRecordRow(
                    icon: "stethoscope",
                    iconColor: .brandPrimary,
                    title: "petProfile.consultations".localized,
                    subtitle: consultations.isEmpty ? "petProfile.noConsultations".localized : "\(consultations.count) " + (consultations.count == 1 ? "consultation" : "consultations")
                ) {
                    showConsultations = true
                }
                
                // Banner Ad nach Consultas
                if AdManager.shared.shouldShowAds {
                    BannerAdView()
                        .frame(height: 50)
                        .padding(.vertical, Spacing.sm)
                }
                
                let expenses = healthRecordManager.getExpenses(for: pet.id)
                let totalExpenses = healthRecordManager.getTotalExpenses(for: pet.id)
                HealthRecordRow(
                    icon: "eurosign.circle.fill",
                    iconColor: .accentGreen,
                    title: "petProfile.expenses".localized,
                    subtitle: expenses.isEmpty ? "petProfile.noExpenses".localized : String(format: "%.2f %@ " + "petProfile.total".localized, totalExpenses, LocalizedStrings.currencySymbol())
                ) {
                    showExpenses = true
                }
                
                let veterinarians = healthRecordManager.veterinarians
                HealthRecordRow(
                    icon: "person.crop.circle.fill",
                    iconColor: .accentBlue,
                    title: "petProfile.veterinarians".localized,
                    subtitle: veterinarians.isEmpty ? "petProfile.noVeterinarians".localized : "\(veterinarians.count) " + (veterinarians.count == 1 ? "veterinarian" : "veterinarians")
                ) {
                    showVeterinarians = true
                }
                
                let appointments = healthRecordManager.getAppointments(for: pet.id)
                let upcomingAppointments = appointments.filter { $0.date > Date() && !$0.isCompleted }
                HealthRecordRow(
                    icon: "calendar",
                    iconColor: .accentPurple,
                    title: "petProfile.appointments".localized,
                    subtitle: appointments.isEmpty ? "petProfile.noAppointments".localized : "\(upcomingAppointments.count) " + "petProfile.upcomingAppointments".localized
                ) {
                    showAppointments = true
                }
                
                // Banner Ad nach Citas
                if AdManager.shared.shouldShowAds {
                    BannerAdView()
                        .frame(height: 50)
                        .padding(.vertical, Spacing.sm)
                }
                
                let weightRecords = healthRecordManager.getWeightRecords(for: pet.id)
                let latestWeight = weightRecords.first
                HealthRecordRow(
                    icon: "scalemass",
                    iconColor: .accentOrange,
                    title: "petProfile.weight".localized,
                    subtitle: latestWeight == nil ? "petProfile.noEntries".localized : String(format: "%.1f kg", latestWeight!.weight)
                ) {
                    showWeight = true
                }
                
                let feedingRecords = healthRecordManager.getFeedingRecords(for: pet.id)
                HealthRecordRow(
                    icon: "fork.knife",
                    iconColor: .accentGreen,
                    title: "petProfile.feeding".localized,
                    subtitle: feedingRecords.isEmpty ? "petProfile.noEntries".localized : "\(feedingRecords.count) " + (feedingRecords.count == 1 ? "petProfile.entry".localized : "petProfile.entries".localized)
                ) {
                    showFeeding = true
                }
            }
        }
    }
    
    // MARK: - Additional Categories
    private var additionalCategoriesView: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("petProfile.additionalCategories".localized)
                .font(.sectionTitle)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.md)
            
            VStack(spacing: Spacing.xs) {
                let photos = healthRecordManager.getPhotos(for: pet.id)
                HealthRecordRow(
                    icon: "camera.fill",
                    iconColor: .accentBlue,
                    title: "petProfile.photoGallery".localized,
                    subtitle: photos.isEmpty ? "petProfile.noPhotos".localized : "\(photos.count) " + (photos.count == 1 ? "petProfile.photo".localized : "petProfile.photos".localized)
                ) {
                    showPhotos = true
                }
                
                let interactions = healthRecordManager.getInteractions(for: pet.id)
                HealthRecordRow(
                    icon: "exclamationmark.triangle.fill",
                    iconColor: .accentRed,
                    title: "petProfile.interactions".localized,
                    subtitle: interactions.isEmpty ? "petProfile.noAllergies".localized : "\(interactions.count) " + (interactions.count == 1 ? "petProfile.entry".localized : "petProfile.entries".localized)
                ) {
                    showInteractions = true
                }
                
                let symptoms = healthRecordManager.getSymptoms(for: pet.id)
                HealthRecordRow(
                    icon: "heart.fill",
                    iconColor: .accentRed,
                    title: "petProfile.symptoms".localized,
                    subtitle: symptoms.isEmpty ? "petProfile.noEntries".localized : "\(symptoms.count) " + (symptoms.count == 1 ? "petProfile.entry".localized : "petProfile.entries".localized)
                ) {
                    showSymptomEntries = true
                }
                
                let waterIntakes = healthRecordManager.getWaterIntakes(for: pet.id)
                let todayWater = healthRecordManager.getTodayWaterIntake(for: pet.id)
                HealthRecordRow(
                    icon: "drop.fill",
                    iconColor: .accentBlue,
                    title: "petProfile.waterIntake".localized,
                    subtitle: todayWater > 0 ? String(format: "%.0f " + "petProfile.mlToday".localized, todayWater) : "petProfile.noEntries".localized
                ) {
                    showWaterIntake = true
                }
                
                let activities = healthRecordManager.getActivities(for: pet.id)
                HealthRecordRow(
                    icon: "figure.walk",
                    iconColor: .accentGreen,
                    title: "petProfile.activity".localized,
                    subtitle: activities.isEmpty ? "petProfile.noEntries".localized : "\(activities.count) " + (activities.count == 1 ? "petProfile.entry".localized : "petProfile.entries".localized)
                ) {
                    showActivities = true
                }
                
                let bathroomRecords = healthRecordManager.getBathroomRecords(for: pet.id)
                HealthRecordRow(
                    icon: "toilet.fill",
                    iconColor: .brown,
                    title: "petProfile.bathroom".localized,
                    subtitle: bathroomRecords.isEmpty ? "petProfile.noEntries".localized : "\(bathroomRecords.count) " + (bathroomRecords.count == 1 ? "petProfile.entry".localized : "petProfile.entries".localized)
                ) {
                    showBathroom = true
                }
                
                let groomingRecords = healthRecordManager.getGroomingRecords(for: pet.id)
                HealthRecordRow(
                    icon: "scissors",
                    iconColor: .accentPurple,
                    title: "petProfile.grooming".localized,
                    subtitle: groomingRecords.isEmpty ? "petProfile.noReminders".localized : "\(groomingRecords.count) " + (groomingRecords.count == 1 ? "petProfile.entry".localized : "petProfile.entries".localized)
                ) {
                    showGrooming = true
                }
                
                let exerciseRecords = healthRecordManager.getExerciseRecords(for: pet.id)
                HealthRecordRow(
                    icon: "figure.run",
                    iconColor: .accentOrange,
                    title: "petProfile.exercise".localized,
                    subtitle: exerciseRecords.isEmpty ? "petProfile.noEntries".localized : "\(exerciseRecords.count) " + (exerciseRecords.count == 1 ? "petProfile.entry".localized : "petProfile.entries".localized)
                ) {
                    showExercise = true
                }
                
                let journalEntries = healthRecordManager.getJournalEntries(for: pet.id)
                HealthRecordRow(
                    icon: "book.fill",
                    iconColor: .accentBlue,
                    title: "petProfile.journal".localized,
                    subtitle: journalEntries.isEmpty ? "petProfile.noEntries".localized : "\(journalEntries.count) " + (journalEntries.count == 1 ? "petProfile.entry".localized : "petProfile.entries".localized)
                ) {
                    showJournal = true
                }
                
                let documents = healthRecordManager.getDocuments(for: pet.id)
                HealthRecordRow(
                    icon: "doc.fill",
                    iconColor: .textSecondary,
                    title: "petProfile.documents".localized,
                    subtitle: documents.isEmpty ? "petProfile.noDocuments".localized : "\(documents.count) " + (documents.count == 1 ? "petProfile.document".localized : "petProfile.documentPlural".localized)
                ) {
                    showDocuments = true
                }
            }
        }
    }
    
    // MARK: - Delete Button
    private var deleteButtonView: some View {
        Button(action: {
            showDeleteConfirmation = true
        }) {
            HStack(spacing: Spacing.md) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.accentRed)
                    .frame(width: 40, height: 40)
                    .background(Color.accentRed.opacity(0.1))
                    .cornerRadius(CornerRadius.small)
                
                Text("petProfile.deletePetButton".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.accentRed)
                
                Spacer()
            }
            .padding(Spacing.lg)
            .background(Color.accentRed.opacity(0.1))
            .cornerRadius(CornerRadius.large)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Quick Action Profile Button
struct QuickActionProfileButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs * 0.85) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .medium)) // 20 * 0.85 = 17
                    .foregroundColor(color)
                    .frame(width: 37, height: 37) // 44 * 0.85 = 37.4
                    .background(color.opacity(0.1))
                    .cornerRadius(CornerRadius.small * 0.85)
                
                Text(title)
                    .font(.system(size: 9, weight: .medium)) // 11 * 0.85 = 9.35
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md * 0.85)
            .padding(.horizontal, Spacing.sm * 0.85)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.medium * 0.85)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .contentShape(Rectangle()) // Macht die ganze Fläche klickbar
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Health Record Row
struct HealthRecordRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(iconColor)
                    .cornerRadius(CornerRadius.medium)
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.md)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.large)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Edit Pet View
struct EditPetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var petManager: PetManager
    let pet: Pet
    
    @State private var name: String
    @State private var type: String
    @State private var breed: String
    @State private var age: String
    @State private var selectedEmoji: String
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showEmojiPicker = false
    @State private var usePhoto = true
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isEditPetFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !breed.trimmingCharacters(in: .whitespaces).isEmpty &&
        !age.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(age) != nil
    }
    
    init(petManager: PetManager, pet: Pet) {
        self.petManager = petManager
        self.pet = pet
        _name = State(initialValue: pet.name)
        _type = State(initialValue: pet.type)
        _breed = State(initialValue: pet.breed)
        _age = State(initialValue: "\(pet.age)")
        _selectedEmoji = State(initialValue: pet.emoji)
        // Lade Profilbild, falls vorhanden
        if let imageData = pet.profileImageData, let uiImage = UIImage(data: imageData) {
            _selectedImage = State(initialValue: uiImage)
            _usePhoto = State(initialValue: true)
        } else {
            _usePhoto = State(initialValue: false)
        }
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
                                ZStack {
                                    Circle()
                                        .fill(Color.brandPrimaryLight)
                                        .frame(width: 160, height: 160)
                                    
                                    if let image = selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 160, height: 160)
                                            .clipShape(Circle())
                                    } else if let imageData = pet.profileImageData, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 160, height: 160)
                                            .clipShape(Circle())
                                    } else {
                                        Text(selectedEmoji)
                                            .font(.system(size: 80))
                                    }
                                }
                                
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .frame(width: 36, height: 36)
                                        .background(Color.gray)
                                        .clipShape(Circle())
                                }
                            }
                            
                            HStack(spacing: Spacing.md) {
                                Button(action: {
                                    usePhoto = true
                                    showImagePicker = true
                                }) {
                                    HStack(spacing: Spacing.sm) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 16))
                                        Text("petProfile.uploadPhoto".localized)
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
                                        Text("petProfile.chooseEmoji".localized)
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
                        
                        // Form Fields
                        VStack(spacing: Spacing.lg) {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("addPet.name".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("addPet.namePlaceholder".localized, text: $name)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("petProfile.breed".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("addPet.breedPlaceholder".localized, text: $breed)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
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
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark", isDisabled: !isEditPetFormValid) {
                            if let ageInt = Int(age), !name.isEmpty {
                                var updatedPet = pet
                                updatedPet.name = name
                                updatedPet.breed = breed
                                updatedPet.age = ageInt
                                updatedPet.emoji = selectedEmoji
                                
                                // Profilbild speichern, wenn ein Foto ausgewählt wurde
                                if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                                    updatedPet.profileImageData = imageData
                                } else if !usePhoto {
                                    // Wenn Emoji gewählt wurde, Profilbild löschen
                                    updatedPet.profileImageData = nil
                                }
                                
                                petManager.updatePet(updatedPet)
                                dismiss()
                            }
                        }
                        .padding(.top, Spacing.lg)
                        .padding(.top, Spacing.lg)
                    }
                    .padding(Spacing.xl)
                    .padding(.bottom, Spacing.xl)
                }
            }
            .navigationTitle("petProfile.editPet".localized)
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
}

