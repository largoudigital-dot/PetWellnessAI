//
//  PetManager.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation
import SwiftUI

class PetManager: ObservableObject {
    @Published var pets: [Pet] = []
    
    private let petsKey = "saved_pets"
    
    init() {
        loadPets()
    }
    
    func addPet(_ pet: Pet) {
        pets.append(pet)
        savePets()
    }
    
    func updatePet(_ pet: Pet) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index] = pet
            savePets()
        }
    }
    
    func deletePet(_ pet: Pet) {
        pets.removeAll { $0.id == pet.id }
        savePets()
    }
    
    private func savePets() {
        do {
            let encoded = try JSONEncoder().encode(pets)
            UserDefaults.standard.set(encoded, forKey: petsKey)
            print("✅ Haustiere erfolgreich gespeichert: \(pets.count)")
        } catch {
            ErrorHandler.shared.handle(.dataEncodingFailed("Haustiere konnten nicht gespeichert werden: \(error.localizedDescription)"))
        }
    }
    
    private func loadPets() {
        guard let data = UserDefaults.standard.data(forKey: petsKey) else {
            print("ℹ️ Keine gespeicherten Haustiere gefunden")
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode([Pet].self, from: data)
            pets = decoded
            print("✅ Haustiere erfolgreich geladen: \(pets.count)")
        } catch {
            ErrorHandler.shared.handle(.dataDecodingFailed("Haustiere konnten nicht geladen werden: \(error.localizedDescription)"))
            // Versuche alte Daten zu löschen, falls sie korrupt sind
            UserDefaults.standard.removeObject(forKey: petsKey)
            pets = []
        }
    }
    
    // MARK: - Delete All Data
    func deleteAllData() {
        pets.removeAll()
        UserDefaults.standard.removeObject(forKey: petsKey)
    }
}





