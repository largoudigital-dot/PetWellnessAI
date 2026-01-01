//
//  AI_TierarztApp.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI
import UserNotifications

@main
struct AI_TierarztApp: App {
    @AppStorage("colorSchemeMode") private var colorSchemeMode = "light" // Standard: Light Mode
    @AppStorage("hasAcceptedPrivacy") private var hasAcceptedPrivacy = false
    
    init() {
        // WICHTIG: Notification Delegate ZUERST setzen
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        print("✅ Notification Delegate gesetzt")
        
        // WICHTIG: Firebase ZUERST konfigurieren, bevor irgendetwas anderes passiert
        FirebaseManager.shared.configure()
        
        // Prüfe Application ID SOFORT
        if let appID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String,
           !appID.isEmpty {
            print("✅ AdMob Application ID gefunden im init: \(appID)")
        } else {
            print("❌ FEHLER: GADApplicationIdentifier nicht in Info.plist gefunden!")
            print("❌ Stelle sicher, dass die Application ID in Info.plist gesetzt ist.")
        }
        
        // AdMob initialisieren (nach Firebase)
        // Verwende DispatchQueue.main.async um sicherzustellen, dass es nach dem init passiert
        DispatchQueue.main.async {
            // WICHTIG: Setze Flags zurück BEVOR AdMob initialisiert wird
            // Damit beim ersten Klick nach App-Start Interstitial sofort erscheint
            AdManager.shared.resetFirstInterstitialFlag()
            
            AdManager.shared.initializeAdMob()
            
            // Ads werden jetzt direkt in initializeAdMob() geladen
            // Zusätzlich: Prüfe nach 3 Sekunden ob Ads geladen wurden
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if AdManager.shared.isInterstitialReady {
                    print("✅ Interstitial Ad ist beim App-Start bereit!")
                } else {
                    print("⚠️ Interstitial Ad noch nicht bereit - versuche erneut zu laden...")
                    AdManager.shared.loadInterstitialAd()
                }
                
                if AdManager.shared.isRewardedReady {
                    print("✅ Rewarded Ad ist beim App-Start bereit!")
                } else {
                    print("⚠️ Rewarded Ad noch nicht bereit - versuche erneut zu laden...")
                    AdManager.shared.loadRewardedAd()
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if hasAcceptedPrivacy {
                ContentView()
                    .environmentObject(LocalizationManager.shared)
                    .environmentObject(AppState.shared)
                    .preferredColorScheme(colorSchemeMode == "dark" ? .dark : (colorSchemeMode == "light" ? .light : nil))
                    .onAppear {
                        FirebaseManager.shared.logScreenView(screenName: "ContentView")
                    }
            } else {
                LandingView(hasSeenOnboarding: $hasAcceptedPrivacy)
                    .environmentObject(LocalizationManager.shared)
                    .preferredColorScheme(colorSchemeMode == "dark" ? .dark : (colorSchemeMode == "light" ? .light : nil))
                    .onAppear {
                        FirebaseManager.shared.logScreenView(screenName: "LandingView")
                    }
            }
        }
    }
}
