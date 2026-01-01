//
//  BackupManager.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation

class BackupManager {
    static let shared = BackupManager()
    
    private let backupKey = "app_backups"
    
    func createBackup(petManager: PetManager, healthRecordManager: HealthRecordManager) -> BackupData? {
        let backup = BackupData(
            pets: petManager.pets,
            medications: healthRecordManager.medications,
            vaccinations: healthRecordManager.vaccinations,
            appointments: healthRecordManager.appointments,
            consultations: healthRecordManager.consultations,
            expenses: healthRecordManager.expenses,
            veterinarians: healthRecordManager.veterinarians,
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
            backupDate: Date()
        )
        
        if let encoded = try? JSONEncoder().encode(backup) {
            saveBackup(encoded)
            return backup
        }
        
        return nil
    }
    
    func restoreBackup(petManager: PetManager, healthRecordManager: HealthRecordManager) -> Bool {
        guard let backupData = loadBackup(),
              let backup = try? JSONDecoder().decode(BackupData.self, from: backupData) else {
            return false
        }
        
        petManager.pets = backup.pets
        healthRecordManager.medications = backup.medications
        healthRecordManager.vaccinations = backup.vaccinations
        healthRecordManager.appointments = backup.appointments
        healthRecordManager.consultations = backup.consultations
        healthRecordManager.expenses = backup.expenses
        healthRecordManager.veterinarians = backup.veterinarians
        healthRecordManager.weightRecords = backup.weightRecords
        healthRecordManager.feedingRecords = backup.feedingRecords
        healthRecordManager.photos = backup.photos
        healthRecordManager.interactions = backup.interactions
        healthRecordManager.symptoms = backup.symptoms
        healthRecordManager.waterIntakes = backup.waterIntakes
        healthRecordManager.activities = backup.activities
        healthRecordManager.bathroomRecords = backup.bathroomRecords
        healthRecordManager.groomingRecords = backup.groomingRecords
        healthRecordManager.exerciseRecords = backup.exerciseRecords
        healthRecordManager.journalEntries = backup.journalEntries
        healthRecordManager.documents = backup.documents
        
        return true
    }
    
    private func saveBackup(_ data: Data) {
        UserDefaults.standard.set(data, forKey: backupKey)
    }
    
    private func loadBackup() -> Data? {
        return UserDefaults.standard.data(forKey: backupKey)
    }
    
    func exportBackupToFile() -> URL? {
        guard let backupData = loadBackup() else { return nil }
        
        let fileName = "AI_Tierarzt_Backup_\(Date().timeIntervalSince1970).json"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try backupData.write(to: tempURL)
            return tempURL
        } catch {
            return nil
        }
    }
    
    func importBackupFromFile(url: URL) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            saveBackup(data)
            return true
        } catch {
            return false
        }
    }
}

struct BackupData: Codable {
    let pets: [Pet]
    let medications: [Medication]
    let vaccinations: [Vaccination]
    let appointments: [Appointment]
    let consultations: [Consultation]
    let expenses: [Expense]
    let veterinarians: [Veterinarian]
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
    let backupDate: Date
}














