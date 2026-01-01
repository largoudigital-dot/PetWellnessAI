//
//  GroqAPIService.swift
//  AI Tierarzt
//
//  Created for AI Chat Integration
//

import Foundation
import UIKit

class GroqAPIService {
    static let shared = GroqAPIService()
    
    // API Key für Groq
    // Bitte tragen Sie hier Ihren Groq API Key ein (erhältlich unter: https://console.groq.com/)
    private let apiKey = "YOUR_GROQ_API_KEY"
    private let baseURL = "https://api.groq.com/openai/v1/chat/completions"
    
    // Modelle
    private let textModel = "llama-3.1-8b-instant"
    // Vision-Modell: Aktuell deaktiviert, verwende Text-Modell mit Bildbeschreibung
    // private let visionModel = "llama-3.2-90b-vision-preview" // Deaktiviert
    
    // Message Limit
    private let dailyLimit = 10
    
    private func getSystemPrompt(for language: String) -> String {
        let basePrompt = """
        Du bist ein hilfreicher AI-Assistent für Tiergesundheit. Deine Aufgabe ist es, Tierbesitzern bei Fragen zur Gesundheit ihrer Haustiere zu helfen.
        
        WICHTIGE REGELN:
        - Du darfst KEINE medizinische Diagnose stellen
        - Du sollst immer empfehlen, einen Tierarzt zu konsultieren
        - Du kannst allgemeine Informationen und Ratschläge geben
        - Du sollst auf Notfälle hinweisen (z.B. wenn sofort ein Tierarzt aufgesucht werden sollte)
        - Sei freundlich, professionell und hilfreich
        - Antworte IMMER in der gleichen Sprache, die der Benutzer verwendet
        
        WICHTIG BEI FOTOS:
        - Wenn der Benutzer ein Foto hochgeladen hat, frage nach einer detaillierten Beschreibung (Art des Tieres, Alter, sichtbare Symptome, Verhalten)
        - Gib basierend auf der Beschreibung hilfreiche Ratschläge
        - Erkläre NICHT, dass du das Foto nicht sehen kannst - sei proaktiv und hilfreich
        - Frage gezielt nach Details, die für eine Einschätzung wichtig sind
        
        Antworte immer mit Emojis für bessere Lesbarkeit und sei präzise und hilfreich.
        """
        
        // Sprachspezifische Anpassungen
        switch language {
        case "es":
            return """
            Eres un asistente de IA útil para la salud de las mascotas. Tu tarea es ayudar a los dueños de mascotas con preguntas sobre la salud de sus animales.
            
            REGLAS IMPORTANTES:
            - NO debes hacer diagnósticos médicos
            - Siempre debes recomendar consultar a un veterinario
            - Puedes dar información general y consejos
            - Debes indicar emergencias (por ejemplo, cuándo se debe visitar a un veterinario inmediatamente)
            - Sé amable, profesional y útil
            - Responde SIEMPRE en el mismo idioma que usa el usuario
            
            IMPORTANTE CON FOTOS:
            - Si el usuario ha subido una foto, pregunta por una descripción detallada (tipo de animal, edad, síntomas visibles, comportamiento)
            - Da consejos útiles basados en la descripción
            - NO expliques que no puedes ver la foto - sé proactivo y útil
            - Pregunta específicamente por detalles importantes para una evaluación
            
            Responde siempre con emojis para mejor legibilidad y sé preciso y útil.
            """
        case "en":
            return """
            You are a helpful AI assistant for pet health. Your task is to help pet owners with questions about their pets' health.
            
            IMPORTANT RULES:
            - You MUST NOT make medical diagnoses
            - You should always recommend consulting a veterinarian
            - You can provide general information and advice
            - You should indicate emergencies (e.g., when a veterinarian should be visited immediately)
            - Be friendly, professional, and helpful
            - ALWAYS respond in the same language the user uses
            
            IMPORTANT WITH PHOTOS:
            - If the user has uploaded a photo, ask for a detailed description (type of animal, age, visible symptoms, behavior)
            - Provide helpful advice based on the description
            - Do NOT explain that you cannot see the photo - be proactive and helpful
            - Ask specifically for details that are important for an assessment
            
            Always respond with emojis for better readability and be precise and helpful.
            """
        case "fr":
            return """
            Vous êtes un assistant IA utile pour la santé des animaux de compagnie. Votre tâche est d'aider les propriétaires d'animaux avec des questions sur la santé de leurs animaux.
            
            RÈGLES IMPORTANTES:
            - Vous NE DEVEZ PAS poser de diagnostics médicaux
            - Vous devez toujours recommander de consulter un vétérinaire
            - Vous pouvez fournir des informations générales et des conseils
            - Vous devez indiquer les urgences (par exemple, quand un vétérinaire doit être consulté immédiatement)
            - Soyez amical, professionnel et utile
            - Répondez TOUJOURS dans la même langue que l'utilisateur
            
            IMPORTANT AVEC LES PHOTOS:
            - Si l'utilisateur a téléchargé une photo, demandez une description détaillée (type d'animal, âge, symptômes visibles, comportement)
            - Fournissez des conseils utiles basés sur la description
            - N'expliquez PAS que vous ne pouvez pas voir la photo - soyez proactif et utile
            - Demandez spécifiquement des détails importants pour une évaluation
            
            Répondez toujours avec des emojis pour une meilleure lisibilité et soyez précis et utile.
            """
        default: // Deutsch als Standard
            return basePrompt
        }
    }
    
    private init() {}
    
    private func createImageDescriptionRequest(message: String, language: String) -> String {
        switch language {
        case "de":
            return """
            \(message)
            
            Ich habe ein Foto meines Haustieres hochgeladen. Bitte frage mich nach einer detaillierten Beschreibung:
            - Art des Tieres (Hund, Katze, etc.)
            - Alter und Rasse
            - Was genau auf dem Foto zu sehen ist (sichtbare Symptome, Verhalten, Körperteile)
            - Wie lange das Problem schon besteht
            - Weitere relevante Informationen
            
            Basierend auf meiner Beschreibung gib mir dann hilfreiche Ratschläge.
            """
        case "es":
            return """
            \(message)
            
            He subido una foto de mi mascota. Por favor, pregúntame por una descripción detallada:
            - Tipo de animal (perro, gato, etc.)
            - Edad y raza
            - Qué se ve exactamente en la foto (síntomas visibles, comportamiento, partes del cuerpo)
            - Cuánto tiempo lleva el problema
            - Información adicional relevante
            
            Basándote en mi descripción, dame consejos útiles.
            """
        case "fr":
            return """
            \(message)
            
            J'ai téléchargé une photo de mon animal. Veuillez me demander une description détaillée:
            - Type d'animal (chien, chat, etc.)
            - Âge et race
            - Ce qui est exactement visible sur la photo (symptômes visibles, comportement, parties du corps)
            - Depuis combien de temps le problème existe
            - Informations supplémentaires pertinentes
            
            Sur la base de ma description, donnez-moi des conseils utiles.
            """
        default: // English
            return """
            \(message)
            
            I have uploaded a photo of my pet. Please ask me for a detailed description:
            - Type of animal (dog, cat, etc.)
            - Age and breed
            - What exactly is visible in the photo (visible symptoms, behavior, body parts)
            - How long the problem has existed
            - Additional relevant information
            
            Based on my description, give me helpful advice.
            """
        }
    }
    
    func sendMessage(_ message: String, imageData: Data? = nil, conversationHistory: [ChatMessage] = [], language: String = "de", skipVision: Bool = false) async throws -> String {
        // Wenn ein Bild vorhanden ist, verwende Text-basierte Lösung
        if let imageData = imageData {
            print("📸 Bild erkannt, verwende Text-basierte Lösung...")
                    // Erstelle eine intelligente Nachricht, die nach einer Beschreibung fragt
                    let fallbackMessage = createImageDescriptionRequest(message: message, language: language)
                    // Verwende Groq Text-Modell mit der angepassten Nachricht
                return try await sendMessage(fallbackMessage, imageData: nil, conversationHistory: conversationHistory, language: language, skipVision: true)
        }
        
        // Prüfe Limit
        if getMessagesSentToday() >= dailyLimit {
            throw APIError.limitReached
        }
        
        guard !apiKey.isEmpty, apiKey != "YOUR_GROQ_API_KEY" else {
            throw APIError.missingAPIKey
        }
        
        var messages: [[String: Any]] = [
            ["role": "system", "content": getSystemPrompt(for: language)]
        ]
        
        // Konvertiere Chat-Verlauf zu API-Format
        for chatMessage in conversationHistory {
            messages.append([
                "role": chatMessage.isUser ? "user" : "assistant",
                "content": chatMessage.text
            ])
        }
        
        // Aktuelle Nachricht (mit oder ohne Bild)
        // Hinweis: Vision-Modell ist aktuell nicht verfügbar, verwende Text-Modell
        if imageData != nil {
            // Wenn Bild vorhanden, formuliere die Nachricht so, dass die KI proaktiv hilft
            let enhancedMessage = language == "de" 
                ? "\(message)\n\nIch habe ein Foto meines Haustieres hochgeladen. Bitte frage mich nach einer detaillierten Beschreibung (Art des Tieres, Alter, sichtbare Symptome, Verhalten) und gib mir dann hilfreiche Ratschläge."
                : language == "es"
                ? "\(message)\n\nHe subido una foto de mi mascota. Por favor, pregúntame por una descripción detallada (tipo de animal, edad, síntomas visibles, comportamiento) y luego dame consejos útiles."
                : language == "fr"
                ? "\(message)\n\nJ'ai téléchargé une photo de mon animal. Veuillez me demander une description détaillée (type d'animal, âge, symptômes visibles, comportement) puis me donner des conseils utiles."
                : "\(message)\n\nI have uploaded a photo of my pet. Please ask me for a detailed description (type of animal, age, visible symptoms, behavior) and then give me helpful advice."
            
            messages.append([
                "role": "user",
                "content": enhancedMessage
            ])
        } else {
            messages.append([
                "role": "user",
                "content": message
            ])
        }
        
        let requestBody: [String: Any] = [
            "model": textModel, // Verwende immer Text-Modell, da Vision-Modell deaktiviert
            "messages": messages,
            "temperature": 0.7,
            "max_tokens": 1000
        ]
        
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorMessage = errorData["error"] as? [String: Any],
               let message = errorMessage["message"] as? String {
                throw APIError.apiError(message)
            }
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let messageDict = firstChoice["message"] as? [String: Any],
              let content = messageDict["content"] as? String else {
            throw APIError.invalidResponse
        }
        
        // Zähler erhöhen
        incrementMessageCount()
        
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Usage Limit Helpers
    private func getMessagesSentToday() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = UserDefaults.standard.object(forKey: "ai_limit_date") as? Date ?? .distantPast
        
        if !Calendar.current.isDate(today, inSameDayAs: lastDate) {
            // Neuer Tag, Zähler zurücksetzen
            UserDefaults.standard.set(0, forKey: "ai_message_count")
            UserDefaults.standard.set(today, forKey: "ai_limit_date")
            return 0
        }
        
        return UserDefaults.standard.integer(forKey: "ai_message_count")
    }
    
    private func incrementMessageCount() {
        let count = getMessagesSentToday()
        UserDefaults.standard.set(count + 1, forKey: "ai_message_count")
    }
}

// APIError enum wurde in separate Datei APIError.swift verschoben

