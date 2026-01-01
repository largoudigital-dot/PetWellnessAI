//
//  APIError.swift
//  AI Tierarzt
//
//  Created for API Error Handling
//

import Foundation

enum APIError: LocalizedError {
    case missingAPIKey
    case limitReached
    case invalidURL
    case invalidResponse
    case apiError(String)
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API-Schlüssel fehlt"
        case .limitReached:
            return "Tageslimit erreicht"
        case .invalidURL:
            return "Ungültige URL"
        case .invalidResponse:
            return "Ungültige Antwort vom Server"
        case .apiError(let message):
            return message
        case .httpError(let code):
            return "HTTP-Fehler: \(code)"
        }
    }
}
