//
//  HealthRecordModels.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation

// MARK: - Medication
struct Medication: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var name: String
    var dosage: String
    var frequency: String // z.B. "2x täglich", "1x wöchentlich"
    var startDate: Date
    var endDate: Date?
    var notes: String
    var isActive: Bool
    
    init(id: UUID = UUID(), petId: UUID, name: String, dosage: String, frequency: String, startDate: Date, endDate: Date? = nil, notes: String = "", isActive: Bool = true) {
        self.id = id
        self.petId = petId
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.isActive = isActive
    }
}

// MARK: - Vaccination
struct Vaccination: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var name: String
    var date: Date
    var nextDueDate: Date?
    var veterinarian: String
    var notes: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), petId: UUID, name: String, date: Date, nextDueDate: Date? = nil, veterinarian: String = "", notes: String = "", isCompleted: Bool = true) {
        self.id = id
        self.petId = petId
        self.name = name
        self.date = date
        self.nextDueDate = nextDueDate
        self.veterinarian = veterinarian
        self.notes = notes
        self.isCompleted = isCompleted
    }
}

// MARK: - Appointment
struct Appointment: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var title: String
    var date: Date
    var veterinarian: String
    var location: String
    var notes: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), petId: UUID, title: String, date: Date, veterinarian: String = "", location: String = "", notes: String = "", isCompleted: Bool = false) {
        self.id = id
        self.petId = petId
        self.title = title
        self.date = date
        self.veterinarian = veterinarian
        self.location = location
        self.notes = notes
        self.isCompleted = isCompleted
    }
}

// MARK: - Veterinarian
struct Veterinarian: Identifiable, Codable {
    let id: UUID
    var name: String
    var clinic: String
    var phone: String
    var email: String
    var address: String
    var notes: String
    
    init(id: UUID = UUID(), name: String, clinic: String, phone: String = "", email: String = "", address: String = "", notes: String = "") {
        self.id = id
        self.name = name
        self.clinic = clinic
        self.phone = phone
        self.email = email
        self.address = address
        self.notes = notes
    }
}

// MARK: - Expense
struct Expense: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var category: String // "Medikamente", "Impfung", "Konsultation", "Operation", "Sonstiges"
    var amount: Double
    var date: Date
    var description: String
    var receiptImage: Data?
    
    init(id: UUID = UUID(), petId: UUID, category: String, amount: Double, date: Date, description: String = "", receiptImage: Data? = nil) {
        self.id = id
        self.petId = petId
        self.category = category
        self.amount = amount
        self.date = date
        self.description = description
        self.receiptImage = receiptImage
    }
}

// MARK: - Consultation
struct Consultation: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var date: Date
    var veterinarianName: String
    var reason: String
    var diagnosis: String
    var treatment: String
    var cost: Double
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, date: Date, veterinarianName: String = "", reason: String = "", diagnosis: String = "", treatment: String = "", cost: Double = 0, notes: String = "") {
        self.id = id
        self.petId = petId
        self.date = date
        self.veterinarianName = veterinarianName
        self.reason = reason
        self.diagnosis = diagnosis
        self.treatment = treatment
        self.cost = cost
        self.notes = notes
    }
}

// MARK: - Weight Record
struct WeightRecord: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var weight: Double
    var date: Date
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, weight: Double, date: Date, notes: String = "") {
        self.id = id
        self.petId = petId
        self.weight = weight
        self.date = date
        self.notes = notes
    }
}

// MARK: - Feeding Record
struct FeedingRecord: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var foodName: String
    var amount: String
    var time: Date
    var foodType: String // "Trocken", "Nass", "Snack"
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, foodName: String, amount: String, time: Date, foodType: String = "Trocken", notes: String = "") {
        self.id = id
        self.petId = petId
        self.foodName = foodName
        self.amount = amount
        self.time = time
        self.foodType = foodType
        self.notes = notes
    }
}

// MARK: - Pet Photo
struct PetPhoto: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var date: Date
    var title: String
    var notes: String
    var imageData: Data?
    
    init(id: UUID = UUID(), petId: UUID, date: Date, title: String = "", notes: String = "", imageData: Data? = nil) {
        self.id = id
        self.petId = petId
        self.date = date
        self.title = title
        self.notes = notes
        self.imageData = imageData
    }
}

// MARK: - Interaction (Allergie/Unverträglichkeit)
struct Interaction: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var type: String // "Allergie", "Unverträglichkeit", "Wechselwirkung"
    var substance: String
    var reaction: String
    var severity: String // "Leicht", "Mittel", "Schwer"
    var dateDiscovered: Date
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, type: String, substance: String, reaction: String, severity: String, dateDiscovered: Date, notes: String = "") {
        self.id = id
        self.petId = petId
        self.type = type
        self.substance = substance
        self.reaction = reaction
        self.severity = severity
        self.dateDiscovered = dateDiscovered
        self.notes = notes
    }
}

// MARK: - Symptom
struct Symptom: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var symptom: String
    var severity: Int // 1-5
    var date: Date
    var duration: String
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, symptom: String, severity: Int, date: Date, duration: String = "", notes: String = "") {
        self.id = id
        self.petId = petId
        self.symptom = symptom
        self.severity = severity
        self.date = date
        self.duration = duration
        self.notes = notes
    }
}

// MARK: - Water Intake
struct WaterIntake: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var amount: Double // in ml
    var date: Date
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, amount: Double, date: Date, notes: String = "") {
        self.id = id
        self.petId = petId
        self.amount = amount
        self.date = date
        self.notes = notes
    }
}

// MARK: - Activity Record
struct ActivityRecord: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var activityType: String
    var duration: Int // in Minuten
    var intensity: String // "Niedrig", "Mittel", "Hoch"
    var date: Date
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, activityType: String, duration: Int, intensity: String = "Mittel", date: Date, notes: String = "") {
        self.id = id
        self.petId = petId
        self.activityType = activityType
        self.duration = duration
        self.intensity = intensity
        self.date = date
        self.notes = notes
    }
}

// MARK: - Bathroom Record
struct BathroomRecord: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var type: String // "Urin", "Kot"
    var consistency: String // "Normal", "Weich", "Fest", "Flüssig"
    var date: Date
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, type: String, consistency: String = "Normal", date: Date, notes: String = "") {
        self.id = id
        self.petId = petId
        self.type = type
        self.consistency = consistency
        self.date = date
        self.notes = notes
    }
}

// MARK: - Grooming Record
struct GroomingRecord: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var type: String // "Baden", "Bürsten", "Krallen", "Ohren"
    var date: Date
    var duration: Int // in Minuten
    var professional: Bool
    var cost: Double
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, type: String, date: Date, duration: Int = 0, professional: Bool = false, cost: Double = 0, notes: String = "") {
        self.id = id
        self.petId = petId
        self.type = type
        self.date = date
        self.duration = duration
        self.professional = professional
        self.cost = cost
        self.notes = notes
    }
}

// MARK: - Exercise Record
struct ExerciseRecord: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var exerciseType: String
    var distance: Double? // in km
    var duration: Int // in Minuten
    var date: Date
    var notes: String
    
    init(id: UUID = UUID(), petId: UUID, exerciseType: String, duration: Int, date: Date, distance: Double? = nil, notes: String = "") {
        self.id = id
        self.petId = petId
        self.exerciseType = exerciseType
        self.duration = duration
        self.date = date
        self.distance = distance
        self.notes = notes
    }
}

// MARK: - Journal Entry
struct JournalEntry: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var title: String
    var content: String
    var date: Date
    var mood: String // "😊", "😐", "😢", "😷", "🎉"
    
    init(id: UUID = UUID(), petId: UUID, title: String, content: String, date: Date, mood: String = "😊") {
        self.id = id
        self.petId = petId
        self.title = title
        self.content = content
        self.date = date
        self.mood = mood
    }
}

// MARK: - Document
struct Document: Identifiable, Codable {
    let id: UUID
    let petId: UUID
    var title: String
    var category: String // "Labor", "Röntgen", "Rezept", "Sonstiges"
    var date: Date
    var notes: String
    var documentData: Data?
    
    init(id: UUID = UUID(), petId: UUID, title: String, category: String = "Sonstiges", date: Date, notes: String = "", documentData: Data? = nil) {
        self.id = id
        self.petId = petId
        self.title = title
        self.category = category
        self.date = date
        self.notes = notes
        self.documentData = documentData
    }
}



