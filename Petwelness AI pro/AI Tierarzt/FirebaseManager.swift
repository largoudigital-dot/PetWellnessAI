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
    
    // WICHTIG: Diese Werte sind NUR Fallback-Werte wenn Firebase Remote Config nicht verfügbar ist
    // In Production sollten ALLE Werte über Firebase Remote Config gesteuert werden
    // Ändern Sie diese Werte NICHT - ändern Sie stattdessen die Werte in Firebase Console
    private let defaultAdConfig: [String: Any] = [
        "ads_enabled": true,
        "banner_ad_unit_id": "ca-app-pub-3840959679571598/6293918284",
        "banner_enabled": true,
        "interstitial_ad_unit_id": "ca-app-pub-3840959679571598/3090645228",
        "interstitial_enabled": true,
        "interstitial_frequency": 3, // WICHTIG: Wird von Firebase Remote Config überschrieben - ändern Sie diesen Wert NICHT hier!
        "interstitial_min_interval": 60,
        "rewarded_ad_unit_id": "ca-app-pub-3840959679571598/3667754945",
        "rewarded_enabled": true
    ]
    
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
        settings.minimumFetchInterval = 3600 // 1 Stunde (für Production)
        // Für Development: settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        // WICHTIG: Diese Default-Werte werden NUR verwendet wenn Firebase Remote Config nicht verfügbar ist
        // In Production werden ALLE Werte von Firebase Remote Config überschrieben
        // Ändern Sie diese Werte NICHT - ändern Sie stattdessen die Werte in Firebase Console
        remoteConfig.setDefaults([
            "ads_enabled": true as NSNumber,
            "banner_ad_unit_id": "ca-app-pub-3840959679571598/6293918284" as NSString,
            "banner_enabled": true as NSNumber,
            "interstitial_ad_unit_id": "ca-app-pub-3840959679571598/3090645228" as NSString,
            "interstitial_enabled": true as NSNumber,
            "interstitial_frequency": 3 as NSNumber, // WICHTIG: Wird von Firebase Remote Config überschrieben - ändern Sie diesen Wert NICHT hier!
            "interstitial_min_interval": 60 as NSNumber,
            "rewarded_ad_unit_id": "ca-app-pub-3840959679571598/3667754945" as NSString,
            "rewarded_enabled": true as NSNumber
        ])
        
        // Lade Remote Config beim Start
        fetchRemoteConfig()
        #else
        print("⚠️ Firebase Remote Config nicht verfügbar")
        #endif
    }
    
    func fetchRemoteConfig(completion: ((Bool) -> Void)? = nil) {
        #if canImport(FirebaseRemoteConfig)
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
    
    // MARK: - Remote Config Getters
    func getString(key: String) -> String {
        #if canImport(FirebaseRemoteConfig)
        // Prüfe ob Firebase konfiguriert ist
        guard isConfigured else {
            return defaultAdConfig[key] as? String ?? ""
        }
        let configValue = remoteConfig.configValue(forKey: key)
        let stringValue = configValue.stringValue
        // Prüfe ob Wert nicht leer ist (leerer String bedeutet Default-Wert)
        if !stringValue.isEmpty {
            return stringValue
        }
        #endif
        // Fallback zu Default-Werten
        return defaultAdConfig[key] as? String ?? ""
    }
    
    func getBool(key: String) -> Bool {
        #if canImport(FirebaseRemoteConfig)
        // Prüfe ob Firebase konfiguriert ist
        guard isConfigured else {
            return defaultAdConfig[key] as? Bool ?? false
        }
        return remoteConfig.configValue(forKey: key).boolValue
        #else
        return defaultAdConfig[key] as? Bool ?? false
        #endif
    }
    
    func getInt(key: String) -> Int {
        #if canImport(FirebaseRemoteConfig)
        // Prüfe ob Firebase konfiguriert ist
        guard isConfigured else {
            return defaultAdConfig[key] as? Int ?? 0
        }
        let configValue = remoteConfig.configValue(forKey: key)
        let numberValue = configValue.numberValue
        // Verwende Remote Config Wert (auch wenn 0, da Defaults bereits gesetzt sind)
        return numberValue.intValue
        #else
        // Fallback zu Default-Werten
        return defaultAdConfig[key] as? Int ?? 0
        #endif
    }
    
    func getDouble(key: String) -> Double {
        #if canImport(FirebaseRemoteConfig)
        // Prüfe ob Firebase konfiguriert ist
        guard isConfigured else {
            return defaultAdConfig[key] as? Double ?? 0.0
        }
        let configValue = remoteConfig.configValue(forKey: key)
        let numberValue = configValue.numberValue
        // Verwende Remote Config Wert (auch wenn 0, da Defaults bereits gesetzt sind)
        return numberValue.doubleValue
        #else
        // Fallback zu Default-Werten
        return defaultAdConfig[key] as? Double ?? 0.0
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

