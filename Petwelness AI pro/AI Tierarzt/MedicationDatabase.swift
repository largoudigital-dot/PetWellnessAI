//
//  MedicationDatabase.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation

struct MedicationDatabase {
    static let medications: [MedicationInfo] = [
        // Common medications
        MedicationInfo(name: "medication.db.antibiotic", category: "medication.db.category.antibiotic", commonDosage: "medication.db.dosage.varies"),
        MedicationInfo(name: "medication.db.antiparasitic", category: "medication.db.category.antiparasitic", commonDosage: "medication.db.dosage.varies"),
        MedicationInfo(name: "medication.db.antihistamine", category: "medication.db.category.antihistamine", commonDosage: "medication.db.dosage.varies"),
        MedicationInfo(name: "medication.db.painRelief", category: "medication.db.category.painRelief", commonDosage: "medication.db.dosage.varies"),
        MedicationInfo(name: "medication.db.antiInflammatory", category: "medication.db.category.antiInflammatory", commonDosage: "medication.db.dosage.varies"),
        MedicationInfo(name: "medication.db.vitamin", category: "medication.db.category.vitamin", commonDosage: "medication.db.dosage.varies"),
        MedicationInfo(name: "medication.db.heartworm", category: "medication.db.category.heartworm", commonDosage: "medication.db.dosage.monthly"),
        MedicationInfo(name: "medication.db.fleaTick", category: "medication.db.category.fleaTick", commonDosage: "medication.db.dosage.monthly")
    ]
    
    static func search(_ query: String) -> [MedicationInfo] {
        let queryLower = query.lowercased()
        return medications.filter { medication in
            medication.name.localized.lowercased().contains(queryLower) ||
            medication.category.localized.lowercased().contains(queryLower)
        }
    }
}

struct MedicationInfo: Identifiable {
    let id = UUID()
    let name: String // Localization key
    let category: String // Localization key
    let commonDosage: String // Localization key
    
    var localizedName: String {
        name.localized
    }
    
    var localizedCategory: String {
        category.localized
    }
    
    var localizedDosage: String {
        commonDosage.localized
    }
}
