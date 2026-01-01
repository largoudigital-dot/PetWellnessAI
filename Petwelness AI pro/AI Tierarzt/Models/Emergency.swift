//
//  Emergency.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import Foundation

struct Emergency: Identifiable, Codable {
    let id: UUID
    let title: String
    let severity: EmergencySeverity
    let symptoms: [String]
    let steps: [String]
    let warning: String?
    let imageName: String?
    
    init(id: UUID = UUID(), title: String, severity: EmergencySeverity, symptoms: [String], steps: [String], warning: String? = nil, imageName: String? = nil) {
        self.id = id
        self.title = title
        self.severity = severity
        self.symptoms = symptoms
        self.steps = steps
        self.warning = warning
        self.imageName = imageName
    }
}

