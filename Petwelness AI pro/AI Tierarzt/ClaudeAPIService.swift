//
//  ClaudeAPIService.swift
//  AI Tierarzt
//
//  Created for Claude Sonnet 4.5 Integration
//

import Foundation
import UIKit

class ClaudeAPIService {
    static let shared = ClaudeAPIService()
    
    // API Key für Anthropic Claude (erhältlich unter: https://console.anthropic.com/)
    // Anleitung: 1. Gehe zu https://console.anthropic.com/
    //            2. Erstelle ein Konto oder melde dich an
    //            3. Gehe zu "API Keys" und erstelle einen neuen Key
    //            4. Kopiere den Key und füge ihn unten ein
    // WICHTIG: API Key nicht in Git committen! Verwende Environment Variable oder lokale Konfiguration
    private let apiKey = "YOUR_CLAUDE_API_KEY"
    private let baseURL = "https://api.anthropic.com/v1/messages"
    private let modelName = "claude-sonnet-4-5-20250929"
    
    // Message Limit
    private let dailyLimit = 20
    
    private func getSystemPrompt(for language: String) -> String {
        let baseInstruction = """
        Du bist ein hilfreicher AI-Assistent für Tiergesundheit. Deine Aufgabe ist es, Tierbesitzern bei Fragen zur Gesundheit ihrer Haustiere zu helfen.
        
        WICHTIGE REGELN:
        - Du darfst KEINE medizinische Diagnose stellen
        - Du sollst IMMER am Anfang oder Ende deiner Antwort deutlich betonen: "⚠️ WICHTIG: Diese App ersetzt KEINEN Tierarzt. Bei gesundheitlichen Problemen sollte IMMER ein Tierarzt konsultiert werden."
        - Du sollst immer empfehlen, einen Tierarzt zu konsultieren
        - Du kannst allgemeine Informationen und Ratschläge geben
        - Du sollst auf Notfälle hinweisen (z.B. wenn sofort ein Tierarzt aufgesucht werden sollte)
        - Sei freundlich, professionell und hilfreich
        - Antworte IMMER in der gleichen Sprache, die der Benutzer verwendet
        
        BEI FOTOS:
        - Analysiere das Foto sorgfältig und beschreibe, was du siehst
        - Frage nach zusätzlichen Details, wenn nötig
        - Gib hilfreiche Ratschläge basierend auf dem, was du im Foto siehst
        - Empfehle IMMER einen Tierarztbesuch für eine genaue Diagnose
        - Betone IMMER, dass die App keinen Tierarzt ersetzt
        
        Antworte immer mit Emojis für bessere Lesbarkeit und sei präzise und hilfreich.
        """
        
        switch language {
        case "es":
            return """
            Eres un asistente de IA útil para la salud de las mascotas. Tu tarea es ayudar a los dueños de mascotas con preguntas sobre la salud de sus animales.
            
            REGLAS IMPORTANTES:
            - NO debes hacer diagnósticos médicos
            - Debes SIEMPRE al principio o al final de tu respuesta enfatizar claramente: "⚠️ IMPORTANTE: Esta aplicación NO reemplaza a un veterinario. En caso de problemas de salud, SIEMPRE se debe consultar a un veterinario."
            - Siempre debes recomendar consultar a un veterinario
            - Puedes dar información general y consejos
            - Debes indicar emergencias
            - Sé amable, profesional y útil
            - Responde SIEMPRE en el mismo idioma que usa el usuario
            
            CON FOTOS:
            - Analiza la foto cuidadosamente y describe lo que ves
            - Pregunta por detalles adicionales si es necesario
            - Da consejos útiles basados en lo que ves en la foto
            - Siempre recomienda una visita al veterinario para un diagnóstico preciso
            - Enfatiza SIEMPRE que la aplicación no reemplaza a un veterinario
            
            Responde siempre con emojis para mejor legibilidad y sé preciso y útil.
            """
        case "en":
            return """
            You are a helpful AI assistant for pet health. Your task is to help pet owners with questions about their pets' health.
            
            IMPORTANT RULES:
            - You MUST NOT make medical diagnoses
            - You MUST ALWAYS at the beginning or end of your response clearly emphasize: "⚠️ IMPORTANT: This app does NOT replace a veterinarian. For health problems, a veterinarian should ALWAYS be consulted."
            - You should always recommend consulting a veterinarian
            - You can provide general information and advice
            - You should indicate emergencies
            - Be friendly, professional, and helpful
            - ALWAYS respond in the same language the user uses
            
            WITH PHOTOS:
            - Analyze the photo carefully and describe what you see
            - Ask for additional details if needed
            - Provide helpful advice based on what you see in the photo
            - Always recommend a veterinarian visit for accurate diagnosis
            - ALWAYS emphasize that the app does not replace a veterinarian
            
            Always respond with emojis for better readability and be precise and helpful.
            """
        case "fr":
            return """
            Vous êtes un assistant IA utile pour la santé des animaux de compagnie. Votre tâche est d'aider les propriétaires d'animaux avec des questions sur la santé de leurs animaux.
            
            RÈGLES IMPORTANTES:
            - Vous NE DEVEZ PAS poser de diagnostics médicaux
            - Vous devez TOUJOURS au début ou à la fin de votre réponse mettre clairement l'accent sur: "⚠️ IMPORTANT: Cette application ne remplace PAS un vétérinaire. En cas de problèmes de santé, un vétérinaire doit TOUJOURS être consulté."
            - Vous devez toujours recommander de consulter un vétérinaire
            - Vous pouvez fournir des informations générales et des conseils
            - Vous devez indiquer les urgences
            - Soyez amical, professionnel et utile
            - Répondez TOUJOURS dans la même langue que l'utilisateur
            
            AVEC LES PHOTOS:
            - Analysez la photo attentivement et décrivez ce que vous voyez
            - Demandez des détails supplémentaires si nécessaire
            - Fournissez des conseils utiles basés sur ce que vous voyez dans la photo
            - Recommandez toujours une visite vétérinaire pour un diagnostic précis
            - Mettez TOUJOURS l'accent sur le fait que l'application ne remplace pas un vétérinaire
            
            Répondez toujours avec des emojis pour une meilleure lisibilité et soyez précis et utile.
            """
        default:
            return baseInstruction
        }
    }
    
    private init() {}
    
    func hasValidAPIKey() -> Bool {
        return !apiKey.isEmpty && apiKey != "YOUR_CLAUDE_API_KEY"
    }
    
    func sendMessage(_ message: String, imageData: Data? = nil, conversationHistory: [ChatMessage] = [], language: String = "de") async throws -> String {
        guard !apiKey.isEmpty, apiKey != "YOUR_CLAUDE_API_KEY" else {
            print("❌ Claude API Key fehlt")
            throw APIError.missingAPIKey
        }
        
        // Prüfe Limit
        if getMessagesSentToday() >= dailyLimit {
            throw APIError.limitReached
        }
        
        print("📤 Claude: Bereite Anfrage vor...")
        print("📤 Claude: Nachricht: \(message.prefix(50))...")
        print("📤 Claude: Bild vorhanden: \(imageData != nil)")
        if let imageData = imageData {
            print("📤 Claude: Bildgröße: \(imageData.count) bytes")
        }
        
        // Erstelle Messages Array
        var messages: [[String: Any]] = []
        
        // Füge Chat-Verlauf hinzu (letzte 20 Nachrichten für besseren Kontext)
        for chatMessage in conversationHistory.suffix(20) {
            messages.append([
                "role": chatMessage.isUser ? "user" : "assistant",
                "content": [["type": "text", "text": chatMessage.text]]
            ])
        }
        
        // Füge aktuelle Nachricht hinzu
        var currentContent: [[String: Any]] = [["type": "text", "text": message]]
        
        // Füge Bild hinzu, falls vorhanden
        if let imageData = imageData {
            print("📤 Claude: Konvertiere Bild zu Base64...")
            let base64Image = imageData.base64EncodedString()
            print("📤 Claude: Base64-Länge: \(base64Image.count) Zeichen")
            currentContent.append([
                "type": "image",
                "source": [
                    "type": "base64",
                    "media_type": "image/jpeg",
                    "data": base64Image
                ]
            ])
            print("✅ Claude: Bild zu Content hinzugefügt")
        }
        
        messages.append([
            "role": "user",
            "content": currentContent
        ])
        
        let requestBody: [String: Any] = [
            "model": modelName,
            "max_tokens": 2000,
            "system": getSystemPrompt(for: language),
            "messages": messages
        ]
        
        print("📤 Claude: Request Body erstellt")
        print("📤 Claude: Messages: \(messages.count) Einträge")
        
        guard let url = URL(string: baseURL) else {
            print("❌ Claude: Ungültige URL")
            throw APIError.invalidURL
        }
        
        print("📤 Claude: URL: \(baseURL)")
        print("📤 Claude: Sende Request...")
        print("📤 Claude: API Key (erste 20 Zeichen): \(String(apiKey.prefix(20)))...")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        // Anthropic API verwendet x-api-key Header
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        print("📤 Claude: Request Body Größe: \(request.httpBody?.count ?? 0) bytes")
        print("📤 Claude: Headers gesetzt - x-api-key: \(String(apiKey.prefix(10)))..., anthropic-version: 2023-06-01")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("📥 Claude: HTTP Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            print("❌ Claude: HTTP Fehler \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("❌ Claude: Response Text: \(responseString)")
            }
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("❌ Claude: Error Data: \(errorData)")
                if let error = errorData["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    print("❌ Claude: Error Message: \(message)")
                    throw APIError.apiError(message)
                }
            }
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        print("✅ Claude: Response erhalten, parse JSON...")
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("❌ Claude: JSON Parsing fehlgeschlagen")
            throw APIError.invalidResponse
        }
        
        print("✅ Claude: JSON geparst")
        guard let content = json["content"] as? [[String: Any]],
              let firstContent = content.first,
              let text = firstContent["text"] as? String else {
            print("❌ Claude: Kein Text in Response gefunden")
            print("📋 Claude: JSON Keys: \(json.keys)")
            throw APIError.invalidResponse
        }
        
        print("✅ Claude: Antwort erfolgreich erhalten (\(text.count) Zeichen)")
        
        // Zähler erhöhen
        incrementMessageCount()
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Usage Limit Helpers
    private func getMessagesSentToday() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = UserDefaults.standard.object(forKey: "claude_limit_date") as? Date ?? .distantPast
        
        if !Calendar.current.isDate(today, inSameDayAs: lastDate) {
            // Neuer Tag, Zähler zurücksetzen
            UserDefaults.standard.set(0, forKey: "claude_message_count")
            UserDefaults.standard.set(today, forKey: "claude_limit_date")
            return 0
        }
        
        return UserDefaults.standard.integer(forKey: "claude_message_count")
    }
    
    private func incrementMessageCount() {
        let count = getMessagesSentToday()
        UserDefaults.standard.set(count + 1, forKey: "claude_message_count")
    }
}

