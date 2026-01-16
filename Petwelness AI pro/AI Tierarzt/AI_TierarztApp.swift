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
        // Fehlerbehandlung: Kein Crash wenn Notification Delegate fehlschlägt
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        print("✅ Notification Delegate gesetzt")
        
        // WICHTIG: Firebase ZUERST konfigurieren, bevor irgendetwas anderes passiert
        // Fehlerbehandlung: Kein Crash wenn Firebase nicht verfügbar ist
        // Firebase.configure() wirft keine Exceptions, aber prüfe ob es erfolgreich war
        FirebaseManager.shared.configure()
        
        // Prüfe Application ID SOFORT
        // Fehlerbehandlung: Kein Crash wenn Application ID fehlt
        // KEIN Fehler-Dialog - App funktioniert auch ohne Ads
        if let appID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String,
           !appID.isEmpty {
            print("✅ AdMob Application ID gefunden im init: \(appID)")
        } else {
            print("⚠️ AdMob Application ID nicht gefunden (nicht kritisch - Ads werden nicht geladen)")
            // KEIN Fehler-Dialog - App funktioniert auch ohne Ads
        }
        
        // AdMob initialisieren (nach Firebase)
        // Verwende DispatchQueue.main.async um sicherzustellen, dass es nach dem init passiert
        DispatchQueue.main.async {
            // WICHTIG: Setze Flags zurück BEVOR AdMob initialisiert wird
            // Damit beim ersten Klick nach App-Start Interstitial sofort erscheint
            AdManager.shared.resetFirstInterstitialFlag()
            
            // Fehlerbehandlung: initializeAdMob() wirft keine Exceptions
            // Alle Fehler werden intern behandelt und geloggt
            // KEIN Fehler-Dialog wird angezeigt
            AdManager.shared.initializeAdMob()
            
            // Ads werden jetzt direkt in initializeAdMob() geladen
            // Zusätzlich: Prüfe nach 3 Sekunden ob ALLE Ads geladen wurden
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                print("🔍 Prüfe Ad-Status nach 3 Sekunden...")
                
                // Prüfe Banner Ad (wird automatisch geladen wenn BannerAdView erstellt wird)
                if AdManager.shared.bannerEnabled {
                    print("✅ Banner Ad ist aktiviert (wird geladen wenn BannerAdView erstellt wird)")
                } else {
                    print("⚠️ Banner Ad ist deaktiviert (banner_enabled = false)")
                }
                
                // Prüfe Interstitial Ad
                if AdManager.shared.isInterstitialReady {
                    print("✅ Interstitial Ad ist beim App-Start bereit!")
                } else {
                    print("⚠️ Interstitial Ad noch nicht bereit - versuche erneut zu laden...")
                    if AdManager.shared.interstitialEnabled {
                        AdManager.shared.loadInterstitialAd()
                    } else {
                        print("⚠️ Interstitial Ad ist deaktiviert (interstitial_enabled = false)")
                    }
                }
                
                // Prüfe Rewarded Ad
                if AdManager.shared.isRewardedReady {
                    print("✅ Rewarded Ad ist beim App-Start bereit!")
                } else {
                    print("⚠️ Rewarded Ad noch nicht bereit - versuche erneut zu laden...")
                    if AdManager.shared.rewardedEnabled {
                        AdManager.shared.loadRewardedAd()
                    } else {
                        print("⚠️ Rewarded Ad ist deaktiviert (rewarded_enabled = false)")
                    }
                }
                
                print("✅ Ad-Loading-Check abgeschlossen")
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
