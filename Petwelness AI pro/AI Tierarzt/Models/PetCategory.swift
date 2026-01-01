//
//  PetCategory.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import Foundation

struct PetCategory: Identifiable, Codable {
    let id: UUID
    let name: String
    let icon: String
    var emergencies: [Emergency]
    
    init(id: UUID = UUID(), name: String, icon: String, emergencies: [Emergency]) {
        self.id = id
        self.name = name
        self.icon = icon
        self.emergencies = emergencies
    }
}

