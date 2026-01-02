//
//  FirebaseManager.swift
//  AI Tierarzt
//
//  Created for Firebase Integration
//

import Foundation
#if canImport(FirebaseCore)
import FirebaseCore
import FirebaseAnalytics
#endif
#if canImport(FirebaseRemoteConfig)
import FirebaseRemoteConfig
#endif

class FirebaseManager {
    static let shared = FirebaseManager()
    
    #if canImport(FirebaseRemoteConfig)
    private lazy var remoteConfig: RemoteConfig = {
        return RemoteConfig.remoteConfig()
    }()
    #endif
    
    // WICHTIG: Alle Ad Unit IDs werden AUSSCHLIESSLICH von Firebase Remote Config geladen
    // Keine hardcodierten Werte in der App - alles wird über Firebase Console gesteuert
    
    private var isConfigured = false
    
    private init() {
        // Remote Config wird erst nach Firebase.configure() initialisiert
    }
    
    func configure() {
        #if canImport(FirebaseCore)
        // Firebase wird automatisch über GoogleService-Info.plist konfiguriert
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            print("✅ Firebase konfiguriert")
        } else {
            print("ℹ️ Firebase bereits konfiguriert")
        }
        
        // Jetzt kann Remote Config initialisiert werden
        if !isConfigured {
            configureRemoteConfig()
            isConfigured = true
        }
        #else
        print("⚠️ Firebase Framework nicht gefunden. Füge Firebase SDK hinzu.")
        #endif
    }
    
    // MARK: - Remote Config Setup
    private func configureRemoteConfig() {
        #if canImport(FirebaseRemoteConfig)
        let settings = RemoteConfigSettings()
        // WICHTIG: minimumFetchInterval = 0 bedeutet sofortiges Neuladen möglich
        // Änderungen in Firebase werden sofort angezeigt (kein 1-Stunden-Cache)
        settings.minimumFetchInterval = 0 // Sofortiges Neuladen möglich
        print("🔧 Remote Config: Sofortiges Neuladen aktiviert (minimumFetchInterval = 0)")
        remoteConfig.configSettings = settings
        
        // WICHTIG: Keine Default-Werte - alle Ad Unit IDs müssen in Firebase Remote Config konfiguriert sein
        // Wenn Firebase Remote Config nicht verfügbar ist, werden keine Ads geladen
        remoteConfig.setDefaults([:])
        
        // Lade Remote Config beim Start
        fetchRemoteConfig()
        #else
        print("⚠️ Firebase Remote Config nicht verfügbar")
        #endif
    }
    
    func fetchRemoteConfig(completion: ((Bool) -> Void)? = nil) {
        #if canImport(FirebaseRemoteConfig)
        print("🔄 Lade Firebase Remote Config...")
        remoteConfig.fetch { [weak self] status, error in
            guard let self = self else {
                completion?(false)
                return
            }
            
            if let error = error {
                print("❌ Remote Config Fetch Fehler: \(error.localizedDescription)")
                completion?(false)
                return
            }
            
            if status == .success {
                self.remoteConfig.activate { changed, error in
                    if let error = error {
                        print("❌ Remote Config Activate Fehler: \(error.localizedDescription)")
                        completion?(false)
                    } else {
                        print("✅ Remote Config geladen (geändert: \(changed))")
                        if changed {
                            print("📝 WICHTIG: Remote Config Werte haben sich geändert!")
                            print("   - ads_enabled: \(self.getBool(key: "ads_enabled"))")
                            print("   - banner_enabled: \(self.getBool(key: "banner_enabled"))")
                            print("   - interstitial_enabled: \(self.getBool(key: "interstitial_enabled"))")
                        }
                        completion?(true)
                    }
                }
            } else {
                print("⚠️ Remote Config Fetch Status: \(status.rawValue)")
                completion?(false)
            }
        }
        #else
        completion?(false)
        #endif
    }
    
    // MARK: - Force Fetch Remote Config (ignoriert minimumFetchInterval)
    func forceFetchRemoteConfig(completion: ((Bool) -> Void)? = nil) {
        #if canImport(FirebaseRemoteConfig)
        print("🔄 Force Fetch: Lade Firebase Remote Config sofort (ignoriert Cache)...")
        // Temporär minimumFetchInterval auf 0 setzen für sofortiges Neuladen
        let originalInterval = remoteConfig.configSettings.minimumFetchInterval
        let tempSettings = RemoteConfigSettings()
        tempSettings.minimumFetchInterval = 0
        remoteConfig.configSettings = tempSettings
        
        fetchRemoteConfig { [weak self] success in
            // Stelle originales Interval wieder her
            if let self = self {
                let restoreSettings = RemoteConfigSettings()
                restoreSettings.minimumFetchInterval = originalInterval
                self.remoteConfig.configSettings = restoreSettings
            }
            completion?(success)
        }
        #else
        completion?(false)
        #endif
    }
    
    // MARK: - Remote Config Getters
    func getString(key: String) -> String {
        #if canImport(FirebaseRemoteConfig)
        // Prüfe ob Firebase konfiguriert ist
        guard isConfigured else {
            print("⚠️ Firebase Remote Config nicht konfiguriert - kann \(key) nicht laden")
            return ""
        }
        let configValue = remoteConfig.configValue(forKey: key)
        let stringValue = configValue.stringValue
        // WICHTIG: Nur Werte von Firebase Remote Config verwenden - keine Fallbacks
        if !stringValue.isEmpty {
            return stringValue
        } else {
            print("⚠️ Firebase Remote Config: \(key) ist leer oder nicht konfiguriert")
            return ""
        }
        #else
        print("⚠️ Firebase Remote Config nicht verfügbar - kann \(key) nicht laden")
        return ""
        #endif
    }
    
    func getBool(key: String) -> Bool {
        #if canImport(FirebaseRemoteConfig)
        // Prüfe ob Firebase konfiguriert ist
        guard isConfigured else {
            print("⚠️ Firebase Remote Config nicht konfiguriert - kann \(key) nicht laden")
            return false
        }
        return remoteConfig.configValue(forKey: key).boolValue
        #else
        print("⚠️ Firebase Remote Config nicht verfügbar - kann \(key) nicht laden")
        return false
        #endif
    }
    
    func getInt(key: String) -> Int {
        #if canImport(FirebaseRemoteConfig)
        // Prüfe ob Firebase konfiguriert ist
        guard isConfigured else {
            print("⚠️ Firebase Remote Config nicht konfiguriert - kann \(key) nicht laden")
            return 0
        }
        let configValue = remoteConfig.configValue(forKey: key)
        let numberValue = configValue.numberValue
        // WICHTIG: Nur Werte von Firebase Remote Config verwenden
        return numberValue.intValue
        #else
        print("⚠️ Firebase Remote Config nicht verfügbar - kann \(key) nicht laden")
        return 0
        #endif
    }
    
    func getDouble(key: String) -> Double {
        #if canImport(FirebaseRemoteConfig)
        // Prüfe ob Firebase konfiguriert ist
        guard isConfigured else {
            print("⚠️ Firebase Remote Config nicht konfiguriert - kann \(key) nicht laden")
            return 0.0
        }
        let configValue = remoteConfig.configValue(forKey: key)
        let numberValue = configValue.numberValue
        // WICHTIG: Nur Werte von Firebase Remote Config verwenden
        return numberValue.doubleValue
        #else
        print("⚠️ Firebase Remote Config nicht verfügbar - kann \(key) nicht laden")
        return 0.0
        #endif
    }
    
    // MARK: - Analytics Events
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent(name, parameters: parameters)
        print("📊 Analytics Event: \(name)")
        #else
        print("📊 Analytics Event (ohne Firebase): \(name)")
        #endif
    }
    
    // Ad-related Events
    func logAdImpression(adType: String, adUnitID: String) {
        logEvent("ad_impression", parameters: [
            "ad_type": adType,
            "ad_unit_id": adUnitID
        ])
    }
    
    func logAdClick(adType: String, adUnitID: String) {
        // WICHTIG: "ad_click" ist ein reservierter Event-Name in Firebase Analytics
        // Verwende stattdessen einen benutzerdefinierten Namen
        logEvent("ad_\(adType)_present", parameters: [
            "ad_type": adType,
            "ad_unit_id": adUnitID
        ])
    }
    
    func logAdRewardEarned(adType: String, rewardType: String, rewardAmount: Int) {
        logEvent("ad_reward_earned", parameters: [
            "ad_type": adType,
            "reward_type": rewardType,
            "reward_amount": rewardAmount
        ])
    }
    
    func logAdError(adType: String, error: String) {
        logEvent("ad_error", parameters: [
            "ad_type": adType,
            "error": error
        ])
    }
    
    // User Actions
    func logScreenView(screenName: String) {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
        #else
        logEvent("screen_view", parameters: ["screen_name": screenName])
        #endif
    }
    
    func logButtonClick(buttonName: String, screenName: String) {
        logEvent("button_click", parameters: [
            "button_name": buttonName,
            "screen_name": screenName
        ])
    }
}

