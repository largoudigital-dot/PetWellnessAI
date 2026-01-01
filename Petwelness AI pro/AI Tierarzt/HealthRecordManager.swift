//
//  HealthRecordManager.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation
import SwiftUI

class HealthRecordManager: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var vaccinations: [Vaccination] = []
    @Published var appointments: [Appointment] = []
    @Published var veterinarians: [Veterinarian] = []
    @Published var expenses: [Expense] = []
    @Published var consultations: [Consultation] = []
    @Published var weightRecords: [WeightRecord] = []
    @Published var feedingRecords: [FeedingRecord] = []
    @Published var photos: [PetPhoto] = []
    @Published var interactions: [Interaction] = []
    @Published var symptoms: [Symptom] = []
    @Published var waterIntakes: [WaterIntake] = []
    @Published var activities: [ActivityRecord] = []
    @Published var bathroomRecords: [BathroomRecord] = []
    @Published var groomingRecords: [GroomingRecord] = []
    @Published var exerciseRecords: [ExerciseRecord] = []
    @Published var journalEntries: [JournalEntry] = []
    @Published var documents: [Document] = []
    
    private let medicationsKey = "saved_medications"
    private let vaccinationsKey = "saved_vaccinations"
    private let appointmentsKey = "saved_appointments"
    private let veterinariansKey = "saved_veterinarians"
    private let expensesKey = "saved_expenses"
    private let consultationsKey = "saved_consultations"
    private let weightRecordsKey = "saved_weight_records"
    private let feedingRecordsKey = "saved_feeding_records"
    private let photosKey = "saved_photos"
    private let interactionsKey = "saved_interactions"
    private let symptomsKey = "saved_symptoms"
    private let waterIntakesKey = "saved_water_intakes"
    private let activitiesKey = "saved_activities"
    private let bathroomRecordsKey = "saved_bathroom_records"
    private let groomingRecordsKey = "saved_grooming_records"
    private let exerciseRecordsKey = "saved_exercise_records"
    private let journalEntriesKey = "saved_journal_entries"
    private let documentsKey = "saved_documents"
    
    init() {
        loadAll()
    }
    
    // MARK: - Medications
    func addMedication(_ medication: Medication) {
        medications.append(medication)
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveMedications()
    }
    
    func updateMedication(_ medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index] = medication
            PerformanceCache.shared.invalidateCache() // Cache invalidieren
            saveMedications()
        }
    }
    
    func deleteMedication(_ medication: Medication) {
        medications.removeAll { $0.id == medication.id }
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveMedications()
    }
    
    func getMedications(for petId: UUID) -> [Medication] {
        // Performance: Verwende Cache wenn möglich
        return PerformanceCache.shared.getMedications(for: petId, from: medications)
    }
    
    func markMedicationAsTaken(medicationId: UUID, time: Date) -> Bool {
        guard let index = medications.firstIndex(where: { $0.id == medicationId }) else {
            ErrorHandler.shared.handle(.validationFailed("Medikament nicht gefunden"))
            return false
        }
        
        // Füge Einnahme-Zeit zu Notes hinzu
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let timeString = formatter.string(from: time)
        
        var updatedMedication = medications[index]
        let takenNote = "\n✅ Eingenommen: \(timeString)"
        updatedMedication.notes = updatedMedication.notes + takenNote
        
        medications[index] = updatedMedication
        saveMedications()
        
        print("✅ Medikament \(updatedMedication.name) als eingenommen markiert um \(timeString)")
        return true
    }
    
    // MARK: - Vaccinations
    func addVaccination(_ vaccination: Vaccination) {
        vaccinations.append(vaccination)
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveVaccinations()
    }
    
    func updateVaccination(_ vaccination: Vaccination) {
        if let index = vaccinations.firstIndex(where: { $0.id == vaccination.id }) {
            vaccinations[index] = vaccination
            PerformanceCache.shared.invalidateCache() // Cache invalidieren
            saveVaccinations()
        }
    }
    
    func deleteVaccination(_ vaccination: Vaccination) {
        vaccinations.removeAll { $0.id == vaccination.id }
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveVaccinations()
    }
    
    func getVaccinations(for petId: UUID) -> [Vaccination] {
        // Performance: Verwende Cache wenn möglich
        return PerformanceCache.shared.getVaccinations(for: petId, from: vaccinations)
    }
    
    func markVaccinationAsCompleted(vaccinationId: UUID) -> Bool {
        guard let index = vaccinations.firstIndex(where: { $0.id == vaccinationId }) else {
            ErrorHandler.shared.handle(.validationFailed("Impfung nicht gefunden"))
            return false
        }
        
        var updatedVaccination = vaccinations[index]
        updatedVaccination.isCompleted = true
        updatedVaccination.date = Date() // Aktualisiere Datum auf heute
        
        vaccinations[index] = updatedVaccination
        saveVaccinations()
        
        // Lösche alte Benachrichtigung
        NotificationManager.shared.cancelVaccinationReminder(vaccination: updatedVaccination)
        
        print("✅ Impfung \(updatedVaccination.name) als abgeschlossen markiert")
        return true
    }
    
    // MARK: - Appointments
    func addAppointment(_ appointment: Appointment) {
        appointments.append(appointment)
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveAppointments()
    }
    
    func updateAppointment(_ appointment: Appointment) {
        if let index = appointments.firstIndex(where: { $0.id == appointment.id }) {
            appointments[index] = appointment
            PerformanceCache.shared.invalidateCache() // Cache invalidieren
            saveAppointments()
        }
    }
    
    func deleteAppointment(_ appointment: Appointment) {
        appointments.removeAll { $0.id == appointment.id }
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveAppointments()
    }
    
    func getAppointments(for petId: UUID) -> [Appointment] {
        // Performance: Verwende Cache wenn möglich
        return PerformanceCache.shared.getAppointments(for: petId, from: appointments)
    }
    
    func markAppointmentAsCompleted(appointmentId: UUID) -> Bool {
        guard let index = appointments.firstIndex(where: { $0.id == appointmentId }) else {
            ErrorHandler.shared.handle(.validationFailed("Termin nicht gefunden"))
            return false
        }
        
        var updatedAppointment = appointments[index]
        updatedAppointment.isCompleted = true
        
        appointments[index] = updatedAppointment
        saveAppointments()
        
        // Lösche alte Benachrichtigung
        NotificationManager.shared.cancelAppointmentReminder(appointment: updatedAppointment)
        
        print("✅ Termin \(updatedAppointment.title) als abgeschlossen markiert")
        return true
    }
    
    // MARK: - Veterinarians
    func addVeterinarian(_ veterinarian: Veterinarian) {
        veterinarians.append(veterinarian)
        saveVeterinarians()
    }
    
    func updateVeterinarian(_ veterinarian: Veterinarian) {
        if let index = veterinarians.firstIndex(where: { $0.id == veterinarian.id }) {
            veterinarians[index] = veterinarian
            saveVeterinarians()
        }
    }
    
    func deleteVeterinarian(_ veterinarian: Veterinarian) {
        veterinarians.removeAll { $0.id == veterinarian.id }
        saveVeterinarians()
    }
    
    // MARK: - Expenses
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveExpenses()
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            PerformanceCache.shared.invalidateCache() // Cache invalidieren
            saveExpenses()
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveExpenses()
    }
    
    func getExpenses(for petId: UUID) -> [Expense] {
        expenses.filter { $0.petId == petId }
    }
    
    func getTotalExpenses(for petId: UUID) -> Double {
        getExpenses(for: petId).reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - Consultations
    func addConsultation(_ consultation: Consultation) {
        consultations.append(consultation)
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveConsultations()
    }
    
    func updateConsultation(_ consultation: Consultation) {
        if let index = consultations.firstIndex(where: { $0.id == consultation.id }) {
            consultations[index] = consultation
            PerformanceCache.shared.invalidateCache() // Cache invalidieren
            saveConsultations()
        }
    }
    
    func deleteConsultation(_ consultation: Consultation) {
        consultations.removeAll { $0.id == consultation.id }
        PerformanceCache.shared.invalidateCache() // Cache invalidieren
        saveConsultations()
    }
    
    func getConsultations(for petId: UUID) -> [Consultation] {
        consultations.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Weight Records
    func addWeightRecord(_ record: WeightRecord) {
        weightRecords.append(record)
        saveWeightRecords()
    }
    
    func updateWeightRecord(_ record: WeightRecord) {
        if let index = weightRecords.firstIndex(where: { $0.id == record.id }) {
            weightRecords[index] = record
            saveWeightRecords()
        }
    }
    
    func deleteWeightRecord(_ record: WeightRecord) {
        weightRecords.removeAll { $0.id == record.id }
        saveWeightRecords()
    }
    
    func getWeightRecords(for petId: UUID) -> [WeightRecord] {
        weightRecords.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    func getLatestWeight(for petId: UUID) -> WeightRecord? {
        getWeightRecords(for: petId).first
    }
    
    // MARK: - Feeding Records
    func addFeedingRecord(_ record: FeedingRecord) {
        feedingRecords.append(record)
        saveFeedingRecords()
    }
    
    func updateFeedingRecord(_ record: FeedingRecord) {
        if let index = feedingRecords.firstIndex(where: { $0.id == record.id }) {
            feedingRecords[index] = record
            saveFeedingRecords()
        }
    }
    
    func deleteFeedingRecord(_ record: FeedingRecord) {
        feedingRecords.removeAll { $0.id == record.id }
        saveFeedingRecords()
    }
    
    func getFeedingRecords(for petId: UUID) -> [FeedingRecord] {
        feedingRecords.filter { $0.petId == petId }.sorted { $0.time > $1.time }
    }
    
    // MARK: - Photos
    func addPhoto(_ photo: PetPhoto) {
        photos.append(photo)
        savePhotos()
    }
    
    func updatePhoto(_ photo: PetPhoto) {
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index] = photo
            savePhotos()
        }
    }
    
    func deletePhoto(_ photo: PetPhoto) {
        photos.removeAll { $0.id == photo.id }
        savePhotos()
    }
    
    func getPhotos(for petId: UUID) -> [PetPhoto] {
        photos.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Interactions
    func addInteraction(_ interaction: Interaction) {
        interactions.append(interaction)
        saveInteractions()
    }
    
    func updateInteraction(_ interaction: Interaction) {
        if let index = interactions.firstIndex(where: { $0.id == interaction.id }) {
            interactions[index] = interaction
            saveInteractions()
        }
    }
    
    func deleteInteraction(_ interaction: Interaction) {
        interactions.removeAll { $0.id == interaction.id }
        saveInteractions()
    }
    
    func getInteractions(for petId: UUID) -> [Interaction] {
        interactions.filter { $0.petId == petId }.sorted { $0.dateDiscovered > $1.dateDiscovered }
    }
    
    // MARK: - Symptoms
    func addSymptom(_ symptom: Symptom) {
        symptoms.append(symptom)
        saveSymptoms()
    }
    
    func updateSymptom(_ symptom: Symptom) {
        if let index = symptoms.firstIndex(where: { $0.id == symptom.id }) {
            symptoms[index] = symptom
            saveSymptoms()
        }
    }
    
    func deleteSymptom(_ symptom: Symptom) {
        symptoms.removeAll { $0.id == symptom.id }
        saveSymptoms()
    }
    
    func getSymptoms(for petId: UUID) -> [Symptom] {
        symptoms.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Water Intakes
    func addWaterIntake(_ intake: WaterIntake) {
        waterIntakes.append(intake)
        saveWaterIntakes()
    }
    
    func updateWaterIntake(_ intake: WaterIntake) {
        if let index = waterIntakes.firstIndex(where: { $0.id == intake.id }) {
            waterIntakes[index] = intake
            saveWaterIntakes()
        }
    }
    
    func deleteWaterIntake(_ intake: WaterIntake) {
        waterIntakes.removeAll { $0.id == intake.id }
        saveWaterIntakes()
    }
    
    func getWaterIntakes(for petId: UUID) -> [WaterIntake] {
        waterIntakes.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    func getTodayWaterIntake(for petId: UUID) -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        return waterIntakes
            .filter { $0.petId == petId && $0.date >= today }
            .reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - Activities
    func addActivity(_ activity: ActivityRecord) {
        activities.append(activity)
        saveActivities()
    }
    
    func updateActivity(_ activity: ActivityRecord) {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index] = activity
            saveActivities()
        }
    }
    
    func deleteActivity(_ activity: ActivityRecord) {
        activities.removeAll { $0.id == activity.id }
        saveActivities()
    }
    
    func getActivities(for petId: UUID) -> [ActivityRecord] {
        activities.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Bathroom Records
    func addBathroomRecord(_ record: BathroomRecord) {
        bathroomRecords.append(record)
        saveBathroomRecords()
    }
    
    func updateBathroomRecord(_ record: BathroomRecord) {
        if let index = bathroomRecords.firstIndex(where: { $0.id == record.id }) {
            bathroomRecords[index] = record
            saveBathroomRecords()
        }
    }
    
    func deleteBathroomRecord(_ record: BathroomRecord) {
        bathroomRecords.removeAll { $0.id == record.id }
        saveBathroomRecords()
    }
    
    func getBathroomRecords(for petId: UUID) -> [BathroomRecord] {
        bathroomRecords.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Grooming Records
    func addGroomingRecord(_ record: GroomingRecord) {
        groomingRecords.append(record)
        saveGroomingRecords()
    }
    
    func updateGroomingRecord(_ record: GroomingRecord) {
        if let index = groomingRecords.firstIndex(where: { $0.id == record.id }) {
            groomingRecords[index] = record
            saveGroomingRecords()
        }
    }
    
    func deleteGroomingRecord(_ record: GroomingRecord) {
        groomingRecords.removeAll { $0.id == record.id }
        saveGroomingRecords()
    }
    
    func getGroomingRecords(for petId: UUID) -> [GroomingRecord] {
        groomingRecords.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Exercise Records
    func addExerciseRecord(_ record: ExerciseRecord) {
        exerciseRecords.append(record)
        saveExerciseRecords()
    }
    
    func updateExerciseRecord(_ record: ExerciseRecord) {
        if let index = exerciseRecords.firstIndex(where: { $0.id == record.id }) {
            exerciseRecords[index] = record
            saveExerciseRecords()
        }
    }
    
    func deleteExerciseRecord(_ record: ExerciseRecord) {
        exerciseRecords.removeAll { $0.id == record.id }
        saveExerciseRecords()
    }
    
    func getExerciseRecords(for petId: UUID) -> [ExerciseRecord] {
        exerciseRecords.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Journal Entries
    func addJournalEntry(_ entry: JournalEntry) {
        journalEntries.append(entry)
        saveJournalEntries()
    }
    
    func updateJournalEntry(_ entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index] = entry
            saveJournalEntries()
        }
    }
    
    func deleteJournalEntry(_ entry: JournalEntry) {
        journalEntries.removeAll { $0.id == entry.id }
        saveJournalEntries()
    }
    
    func getJournalEntries(for petId: UUID) -> [JournalEntry] {
        journalEntries.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Documents
    func addDocument(_ document: Document) {
        documents.append(document)
        saveDocuments()
    }
    
    func updateDocument(_ document: Document) {
        if let index = documents.firstIndex(where: { $0.id == document.id }) {
            documents[index] = document
            saveDocuments()
        }
    }
    
    func deleteDocument(_ document: Document) {
        documents.removeAll { $0.id == document.id }
        saveDocuments()
    }
    
    func getDocuments(for petId: UUID) -> [Document] {
        documents.filter { $0.petId == petId }.sorted { $0.date > $1.date }
    }
    
    // MARK: - Save/Load Helpers
    private func saveData<T: Codable>(_ data: T, key: String, typeName: String) {
        do {
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: key)
            print("✅ \(typeName) erfolgreich gespeichert")
        } catch {
            ErrorHandler.shared.handle(.dataEncodingFailed("\(typeName) konnten nicht gespeichert werden: \(error.localizedDescription)"))
        }
    }
    
    private func loadData<T: Codable>(_ type: T.Type, key: String, typeName: String, setter: @escaping ([T]) -> Void) where T: Codable {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            print("ℹ️ Keine gespeicherten \(typeName) gefunden")
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode([T].self, from: data)
            setter(decoded)
            print("✅ \(typeName) erfolgreich geladen: \(decoded.count)")
        } catch {
            ErrorHandler.shared.handle(.dataDecodingFailed("\(typeName) konnten nicht geladen werden: \(error.localizedDescription)"))
            // Versuche alte Daten zu löschen, falls sie korrupt sind
            UserDefaults.standard.removeObject(forKey: key)
            setter([])
        }
    }
    
    // MARK: - Save/Load
    private func saveMedications() {
        saveData(medications, key: medicationsKey, typeName: "Medikamente")
    }
    
    private func saveVaccinations() {
        saveData(vaccinations, key: vaccinationsKey, typeName: "Impfungen")
    }
    
    private func saveAppointments() {
        saveData(appointments, key: appointmentsKey, typeName: "Termine")
    }
    
    private func saveVeterinarians() {
        saveData(veterinarians, key: veterinariansKey, typeName: "Tierärzte")
    }
    
    private func saveExpenses() {
        saveData(expenses, key: expensesKey, typeName: "Ausgaben")
    }
    
    private func saveConsultations() {
        saveData(consultations, key: consultationsKey, typeName: "Konsultationen")
    }
    
    private func saveWeightRecords() {
        saveData(weightRecords, key: weightRecordsKey, typeName: "Gewichtsaufzeichnungen")
    }
    
    private func saveFeedingRecords() {
        saveData(feedingRecords, key: feedingRecordsKey, typeName: "Fütterungsaufzeichnungen")
    }
    
    private func savePhotos() {
        saveData(photos, key: photosKey, typeName: "Fotos")
    }
    
    private func saveInteractions() {
        saveData(interactions, key: interactionsKey, typeName: "Interaktionen")
    }
    
    private func saveSymptoms() {
        saveData(symptoms, key: symptomsKey, typeName: "Symptome")
    }
    
    private func saveWaterIntakes() {
        saveData(waterIntakes, key: waterIntakesKey, typeName: "Wasseraufnahme")
    }
    
    private func saveActivities() {
        saveData(activities, key: activitiesKey, typeName: "Aktivitäten")
    }
    
    private func saveBathroomRecords() {
        saveData(bathroomRecords, key: bathroomRecordsKey, typeName: "Toilettengänge")
    }
    
    private func saveGroomingRecords() {
        saveData(groomingRecords, key: groomingRecordsKey, typeName: "Pflegeaufzeichnungen")
    }
    
    private func saveExerciseRecords() {
        saveData(exerciseRecords, key: exerciseRecordsKey, typeName: "Bewegungsaufzeichnungen")
    }
    
    private func saveJournalEntries() {
        saveData(journalEntries, key: journalEntriesKey, typeName: "Tagebucheinträge")
    }
    
    private func saveDocuments() {
        saveData(documents, key: documentsKey, typeName: "Dokumente")
    }
    
    private func loadAll() {
        loadMedications()
        loadVaccinations()
        loadAppointments()
        loadVeterinarians()
        loadExpenses()
        loadConsultations()
        loadWeightRecords()
        loadFeedingRecords()
        loadPhotos()
        loadInteractions()
        loadSymptoms()
        loadWaterIntakes()
        loadActivities()
        loadBathroomRecords()
        loadGroomingRecords()
        loadExerciseRecords()
        loadJournalEntries()
        loadDocuments()
    }
    
    private func loadMedications() {
        loadData(Medication.self, key: medicationsKey, typeName: "Medikamente") { [weak self] in
            self?.medications = $0
        }
    }
    
    private func loadVaccinations() {
        loadData(Vaccination.self, key: vaccinationsKey, typeName: "Impfungen") { [weak self] in
            self?.vaccinations = $0
        }
    }
    
    private func loadAppointments() {
        loadData(Appointment.self, key: appointmentsKey, typeName: "Termine") { [weak self] in
            self?.appointments = $0
        }
    }
    
    private func loadVeterinarians() {
        loadData(Veterinarian.self, key: veterinariansKey, typeName: "Tierärzte") { [weak self] in
            self?.veterinarians = $0
        }
    }
    
    private func loadExpenses() {
        loadData(Expense.self, key: expensesKey, typeName: "Ausgaben") { [weak self] in
            self?.expenses = $0
        }
    }
    
    private func loadConsultations() {
        loadData(Consultation.self, key: consultationsKey, typeName: "Konsultationen") { [weak self] in
            self?.consultations = $0
        }
    }
    
    private func loadWeightRecords() {
        loadData(WeightRecord.self, key: weightRecordsKey, typeName: "Gewichtsaufzeichnungen") { [weak self] in
            self?.weightRecords = $0
        }
    }
    
    private func loadFeedingRecords() {
        loadData(FeedingRecord.self, key: feedingRecordsKey, typeName: "Fütterungsaufzeichnungen") { [weak self] in
            self?.feedingRecords = $0
        }
    }
    
    private func loadPhotos() {
        loadData(PetPhoto.self, key: photosKey, typeName: "Fotos") { [weak self] in
            self?.photos = $0
        }
    }
    
    private func loadInteractions() {
        loadData(Interaction.self, key: interactionsKey, typeName: "Interaktionen") { [weak self] in
            self?.interactions = $0
        }
    }
    
    private func loadSymptoms() {
        loadData(Symptom.self, key: symptomsKey, typeName: "Symptome") { [weak self] in
            self?.symptoms = $0
        }
    }
    
    private func loadWaterIntakes() {
        loadData(WaterIntake.self, key: waterIntakesKey, typeName: "Wasseraufnahme") { [weak self] in
            self?.waterIntakes = $0
        }
    }
    
    private func loadActivities() {
        loadData(ActivityRecord.self, key: activitiesKey, typeName: "Aktivitäten") { [weak self] in
            self?.activities = $0
        }
    }
    
    private func loadBathroomRecords() {
        loadData(BathroomRecord.self, key: bathroomRecordsKey, typeName: "Toilettengänge") { [weak self] in
            self?.bathroomRecords = $0
        }
    }
    
    private func loadGroomingRecords() {
        loadData(GroomingRecord.self, key: groomingRecordsKey, typeName: "Pflegeaufzeichnungen") { [weak self] in
            self?.groomingRecords = $0
        }
    }
    
    private func loadExerciseRecords() {
        loadData(ExerciseRecord.self, key: exerciseRecordsKey, typeName: "Bewegungsaufzeichnungen") { [weak self] in
            self?.exerciseRecords = $0
        }
    }
    
    private func loadJournalEntries() {
        loadData(JournalEntry.self, key: journalEntriesKey, typeName: "Tagebucheinträge") { [weak self] in
            self?.journalEntries = $0
        }
    }
    
    private func loadDocuments() {
        loadData(Document.self, key: documentsKey, typeName: "Dokumente") { [weak self] in
            self?.documents = $0
        }
    }
    
    // MARK: - Delete All Data
    func deleteAllData() {
        medications.removeAll()
        vaccinations.removeAll()
        appointments.removeAll()
        veterinarians.removeAll()
        expenses.removeAll()
        consultations.removeAll()
        weightRecords.removeAll()
        feedingRecords.removeAll()
        photos.removeAll()
        interactions.removeAll()
        symptoms.removeAll()
        waterIntakes.removeAll()
        activities.removeAll()
        bathroomRecords.removeAll()
        groomingRecords.removeAll()
        exerciseRecords.removeAll()
        journalEntries.removeAll()
        documents.removeAll()
        
        // Lösche alle UserDefaults Keys
        let keys = [
            medicationsKey, vaccinationsKey, appointmentsKey,
            veterinariansKey, expensesKey, consultationsKey,
            weightRecordsKey, feedingRecordsKey, photosKey,
            interactionsKey, symptomsKey, waterIntakesKey,
            activitiesKey, bathroomRecordsKey, groomingRecordsKey,
            exerciseRecordsKey, journalEntriesKey, documentsKey,
            "saved_chat_messages"
        ]
        
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}



