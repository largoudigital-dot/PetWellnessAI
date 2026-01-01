//
//  AppState.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI
import UIKit

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var selectedTab: Int = 0
    
    // Chat data
    @Published var chatSymptoms: [String] = []
    @Published var chatNotes: String = ""
    @Published var chatPhoto: UIImage? = nil
    
    // Chat input state
    @Published var chatInputText: String = ""
    @Published var showChatImagePicker: Bool = false
    
    // Tab Bar Sichtbarkeit steuern
    @Published var isTabBarVisible: Bool = true
    
    // Notification Action View
    @Published var showNotificationAction: Bool = false
    @Published var notificationMedicationId: String? = nil
    @Published var notificationPetId: String? = nil
    @Published var notificationMedicationName: String? = nil
    @Published var notificationPetName: String? = nil
    
    private init() {}
    
    func setChatData(symptoms: [String], notes: String, photo: UIImage?) {
        chatSymptoms = symptoms
        chatNotes = notes
        chatPhoto = photo
    }
    
    func clearChatData() {
        chatSymptoms = []
        chatNotes = ""
        chatPhoto = nil
    }
}

