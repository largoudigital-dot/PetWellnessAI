//
//  Emergency+Localization.swift
//  AI Tierarzt
//
//  Created for Emergency Localization
//

import Foundation

extension Emergency {
    var localizedTitle: String {
        return title.localized
    }
    
    var localizedSymptoms: [String] {
        return symptoms.map { $0.localized }
    }
}
