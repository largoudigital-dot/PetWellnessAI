//
//  InputValidator.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation

// MARK: - Input Validator
class InputValidator {
    static let shared = InputValidator()
    
    private init() {}
    
    // MARK: - Pet Validation
    func validatePet(name: String, type: String, breed: String) -> (isValid: Bool, errorMessage: String?) {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Der Name darf nicht leer sein")
        }
        
        if name.count > 50 {
            return (false, "Der Name ist zu lang (max. 50 Zeichen)")
        }
        
        if type.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Die Tierart muss angegeben werden")
        }
        
        if breed.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Die Rasse muss angegeben werden")
        }
        
        return (true, nil)
    }
    
    // MARK: - Medication Validation
    func validateMedication(name: String, dosage: String) -> (isValid: Bool, errorMessage: String?) {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Der Medikamentenname darf nicht leer sein")
        }
        
        if name.count > 100 {
            return (false, "Der Medikamentenname ist zu lang (max. 100 Zeichen)")
        }
        
        if dosage.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Die Dosierung muss angegeben werden")
        }
        
        return (true, nil)
    }
    
    // MARK: - Appointment Validation
    func validateAppointment(title: String, date: Date) -> (isValid: Bool, errorMessage: String?) {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Der Titel darf nicht leer sein")
        }
        
        if title.count > 100 {
            return (false, "Der Titel ist zu lang (max. 100 Zeichen)")
        }
        
        if date < Date() {
            return (false, "Das Datum darf nicht in der Vergangenheit liegen")
        }
        
        return (true, nil)
    }
    
    // MARK: - Vaccination Validation
    func validateVaccination(name: String, date: Date) -> (isValid: Bool, errorMessage: String?) {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Der Impfname darf nicht leer sein")
        }
        
        if name.count > 100 {
            return (false, "Der Impfname ist zu lang (max. 100 Zeichen)")
        }
        
        return (true, nil)
    }
    
    // MARK: - General String Validation
    func validateString(_ string: String, fieldName: String, maxLength: Int = 500, required: Bool = false) -> (isValid: Bool, errorMessage: String?) {
        if required && string.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "\(fieldName) darf nicht leer sein")
        }
        
        if string.count > maxLength {
            return (false, "\(fieldName) ist zu lang (max. \(maxLength) Zeichen)")
        }
        
        return (true, nil)
    }
    
    // MARK: - Date Validation
    func validateDate(_ date: Date, mustBeFuture: Bool = false, mustBePast: Bool = false) -> (isValid: Bool, errorMessage: String?) {
        if mustBeFuture && date < Date() {
            return (false, "Das Datum muss in der Zukunft liegen")
        }
        
        if mustBePast && date > Date() {
            return (false, "Das Datum muss in der Vergangenheit liegen")
        }
        
        return (true, nil)
    }
    
    // MARK: - Number Validation
    func validateNumber(_ number: Double, fieldName: String, min: Double? = nil, max: Double? = nil) -> (isValid: Bool, errorMessage: String?) {
        if let min = min, number < min {
            return (false, "\(fieldName) muss mindestens \(min) sein")
        }
        
        if let max = max, number > max {
            return (false, "\(fieldName) darf höchstens \(max) sein")
        }
        
        return (true, nil)
    }
}



