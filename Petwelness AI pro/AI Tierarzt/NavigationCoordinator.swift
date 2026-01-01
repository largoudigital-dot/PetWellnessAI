//
//  NavigationCoordinator.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation
import SwiftUI

// MARK: - Navigation Coordinator
class NavigationCoordinator: ObservableObject {
    static let shared = NavigationCoordinator()
    
    @Published var navigationTarget: NavigationTarget?
    @Published var selectedPetId: UUID?
    @Published var selectedMedicationId: UUID?
    @Published var selectedAppointmentId: UUID?
    @Published var selectedVaccinationId: UUID?
    
    enum NavigationTarget: Equatable {
        case medication(UUID, UUID) // medicationId, petId
        case appointment(UUID, UUID) // appointmentId, petId
        case vaccination(UUID, UUID) // vaccinationId, petId
        case petProfile(UUID) // petId
    }
    
    private init() {
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        // Medikament öffnen
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("OpenMedication"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let userInfo = notification.userInfo,
               let medicationIdString = userInfo["medicationId"] as? String,
               let petIdString = userInfo["petId"] as? String,
               let medicationId = UUID(uuidString: medicationIdString),
               let petId = UUID(uuidString: petIdString) {
                self?.navigateToMedication(medicationId: medicationId, petId: petId)
            }
        }
        
        // Termin öffnen
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("OpenAppointment"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let userInfo = notification.userInfo,
               let appointmentIdString = userInfo["appointmentId"] as? String,
               let petIdString = userInfo["petId"] as? String,
               let appointmentId = UUID(uuidString: appointmentIdString),
               let petId = UUID(uuidString: petIdString) {
                self?.navigateToAppointment(appointmentId: appointmentId, petId: petId)
            }
        }
        
        // Impfung öffnen
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("OpenVaccination"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let userInfo = notification.userInfo,
               let vaccinationIdString = userInfo["vaccinationId"] as? String,
               let petIdString = userInfo["petId"] as? String,
               let vaccinationId = UUID(uuidString: vaccinationIdString),
               let petId = UUID(uuidString: petIdString) {
                self?.navigateToVaccination(vaccinationId: vaccinationId, petId: petId)
            }
        }
    }
    
    func navigateToMedication(medicationId: UUID, petId: UUID) {
        DispatchQueue.main.async {
            self.selectedPetId = petId
            self.selectedMedicationId = medicationId
            self.navigationTarget = .medication(medicationId, petId)
            print("🧭 Navigiere zu Medikament: \(medicationId) für Pet: \(petId)")
        }
    }
    
    func navigateToAppointment(appointmentId: UUID, petId: UUID) {
        DispatchQueue.main.async {
            self.selectedPetId = petId
            self.selectedAppointmentId = appointmentId
            self.navigationTarget = .appointment(appointmentId, petId)
            print("🧭 Navigiere zu Termin: \(appointmentId) für Pet: \(petId)")
        }
    }
    
    func navigateToVaccination(vaccinationId: UUID, petId: UUID) {
        DispatchQueue.main.async {
            self.selectedPetId = petId
            self.selectedVaccinationId = vaccinationId
            self.navigationTarget = .vaccination(vaccinationId, petId)
            print("🧭 Navigiere zu Impfung: \(vaccinationId) für Pet: \(petId)")
        }
    }
    
    func clearNavigation() {
        navigationTarget = nil
        selectedPetId = nil
        selectedMedicationId = nil
        selectedAppointmentId = nil
        selectedVaccinationId = nil
    }
}

