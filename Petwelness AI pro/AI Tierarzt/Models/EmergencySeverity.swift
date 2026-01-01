//
//  EmergencySeverity.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI

enum EmergencySeverity: String, Codable, CaseIterable {
    case critical = "critical"
    case high = "high"
    case medium = "medium"
    
    var color: Color {
        switch self {
        case .critical:
            return .red
        case .high:
            return .orange
        case .medium:
            return .yellow
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .critical:
            return Color.red.opacity(0.1)
        case .high:
            return Color.orange.opacity(0.1)
        case .medium:
            return Color.yellow.opacity(0.1)
        }
    }
    
    var localizedName: String {
        switch self {
        case .critical:
            return "severity.critical".localized
        case .high:
            return "severity.high".localized
        case .medium:
            return "severity.medium".localized
        }
    }
}

