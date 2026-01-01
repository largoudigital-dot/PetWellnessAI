//
//  LocalizationManager.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String = "en" // English as default
    
    private let languageKey = "selectedLanguage"
    
    // Wichtige Sprachen mit Englisch als Standard
    let availableLanguages: [(code: String, name: String, native: String, flag: String)] = [
        ("en", "English", "English", "🇬🇧"),           // Standard
        ("de", "German", "Deutsch", "🇩🇪"),
        ("es", "Spanish", "Español", "🇪🇸"),
        ("fr", "French", "Français", "🇫🇷"),
        ("it", "Italian", "Italiano", "🇮🇹"),
        ("pt", "Portuguese", "Português", "🇵🇹"),
        ("nl", "Dutch", "Nederlands", "🇳🇱"),
        ("pl", "Polish", "Polski", "🇵🇱"),
        ("ru", "Russian", "Русский", "🇷🇺"),
        ("tr", "Turkish", "Türkçe", "🇹🇷"),
        ("ja", "Japanese", "日本語", "🇯🇵"),
        ("zh", "Chinese", "中文", "🇨🇳"),
        ("ko", "Korean", "한국어", "🇰🇷"),
        ("ar", "Arabic", "العربية", "🇦🇪"),
        ("hi", "Hindi", "हिन्दी", "🇮🇳"),
        ("pt-BR", "Portuguese (Brazil)", "Português (Brasil)", "🇧🇷"),
        ("zh-Hans", "Chinese (Simplified)", "中文 (简体)", "🇨🇳"),
        ("zh-Hant", "Chinese (Traditional)", "中文 (繁體)", "🇹🇼")
    ]
    
    var supportedLanguageCodes: [String] {
        availableLanguages.map { $0.code }
    }
    
    private init() {
        loadLanguage()
    }
    
    // MARK: - Language Detection
    func detectLanguage() {
        // Check if user has already selected a language
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           supportedLanguageCodes.contains(savedLanguage) {
            currentLanguage = savedLanguage
            setLanguage(savedLanguage)
            return
        }
        
        // Detect system language
        let systemLanguage = Locale.preferredLanguages.first ?? "en"
        let languageCode = extractLanguageCode(from: systemLanguage)
        
        if supportedLanguageCodes.contains(languageCode) {
            // System language is supported
            currentLanguage = languageCode
            setLanguage(languageCode)
        } else {
            // System language not supported -> Use English (default)
            currentLanguage = "en"
            setLanguage("en")
        }
    }
    
    // MARK: - Extract Language Code
    private func extractLanguageCode(from locale: String) -> String {
        // "de-DE" -> "de", "zh-Hans" -> "zh-Hans", "pt-BR" -> "pt-BR"
        let components = locale.split(separator: "-")
        if components.count >= 2 {
            let region = String(components[1])
            // Check for special cases
            if locale.hasPrefix("zh") {
                if region == "Hans" || region == "CN" || region == "SG" {
                    return "zh-Hans"
                } else if region == "Hant" || region == "TW" || region == "HK" {
                    return "zh-Hant"
                }
            }
            if locale.hasPrefix("pt") {
                if region == "BR" {
                    return "pt-BR"
                }
            }
        }
        return String(components[0])
    }
    
    // MARK: - Set Language
    func setLanguage(_ languageCode: String) {
        guard supportedLanguageCodes.contains(languageCode) else {
            // Fallback to English if not supported
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.currentLanguage = "en"
                UserDefaults.standard.set("en", forKey: self.languageKey)
                self.updateAppLanguage("en")
            }
            return
        }
        
        // Update on main thread to trigger UI updates
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentLanguage = languageCode
            UserDefaults.standard.set(languageCode, forKey: self.languageKey)
            self.updateAppLanguage(languageCode)
        }
    }
    
    // MARK: - Update App Language
    private func updateAppLanguage(_ languageCode: String) {
        // Set app language in UserDefaults
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Trigger UI update (currentLanguage is already set in setLanguage)
        objectWillChange.send()
        
        // Post notification for language change
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
    
    // MARK: - Load Language
    private func loadLanguage() {
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           supportedLanguageCodes.contains(savedLanguage) {
            currentLanguage = savedLanguage
        } else {
            // First time use - detect language
            detectLanguage()
        }
    }
    
    // MARK: - Helper Methods
    func getLanguageName(for code: String) -> String {
        availableLanguages.first(where: { $0.code == code })?.native ?? "English"
    }
    
    func getLanguageFlag(for code: String) -> String {
        availableLanguages.first(where: { $0.code == code })?.flag ?? "🇬🇧"
    }
}

