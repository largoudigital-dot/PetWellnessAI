//
//  ErrorHandler.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation
import SwiftUI

// MARK: - Error Types
enum AppError: LocalizedError {
    case dataSaveFailed(String)
    case dataLoadFailed(String)
    case dataEncodingFailed(String)
    case dataDecodingFailed(String)
    case validationFailed(String)
    case networkError(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .dataSaveFailed(let message):
            return "Fehler beim Speichern: \(message)"
        case .dataLoadFailed(let message):
            return "Fehler beim Laden: \(message)"
        case .dataEncodingFailed(let message):
            return "Fehler beim Kodieren: \(message)"
        case .dataDecodingFailed(let message):
            return "Fehler beim Dekodieren: \(message)"
        case .validationFailed(let message):
            return "Validierungsfehler: \(message)"
        case .networkError(let message):
            return "Netzwerkfehler: \(message)"
        case .unknownError(let message):
            return "Unbekannter Fehler: \(message)"
        }
    }
}

// MARK: - Error Handler
class ErrorHandler: ObservableObject {
    static let shared = ErrorHandler()
    
    @Published var currentError: AppError?
    @Published var showError = false
    @Published var errorMessage = ""
    
    private init() {}
    
    func handle(_ error: AppError) {
        DispatchQueue.main.async {
            self.currentError = error
            self.errorMessage = error.localizedDescription
            self.showError = true
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    func handle(_ error: Error) {
        let appError = AppError.unknownError(error.localizedDescription)
        handle(appError)
    }
    
    func clearError() {
        currentError = nil
        showError = false
        errorMessage = ""
    }
}

// MARK: - Error Alert Modifier
struct ErrorAlertModifier: ViewModifier {
    @ObservedObject var errorHandler: ErrorHandler
    
    func body(content: Content) -> some View {
        content
            .alert("Fehler", isPresented: $errorHandler.showError) {
                Button("OK") {
                    errorHandler.clearError()
                }
            } message: {
                Text(errorHandler.errorMessage)
            }
    }
}

extension View {
    func errorAlert() -> some View {
        modifier(ErrorAlertModifier(errorHandler: ErrorHandler.shared))
    }
}



