//
//  AdManager.swift
//  AI Tierarzt
//
//  Created for AdMob Integration
//

import Foundation
import SwiftUI
import UIKit
import AppTrackingTransparency
import AdSupport
#if canImport(FirebaseCore)
import FirebaseCore
#endif

// MARK: - Protokolle (Dummy wenn GoogleMobileAds nicht verfügbar)
#if !canImport(GoogleMobileAds)
@objc protocol FullScreenContentDelegate: AnyObject {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd)
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error)
}

@objc protocol FullScreenPresentingAd: AnyObject {}
#endif

// MARK: - Temporäre Dummy-Klassen bis GoogleMobileAds hinzugefügt ist
// TODO: Entferne diese Dummy-Klassen, nachdem du GoogleMobileAds Framework hinzugefügt hast
#if !canImport(GoogleMobileAds)
// Dummy-Klassen für Kompilierung ohne Framework

class BannerView: UIView {
    var adUnitID: String = ""
    var rootViewController: UIViewController? = nil
    
    init(adSize: Any) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func load(_ request: Any) {}
}

class InterstitialAd: NSObject, FullScreenPresentingAd {
    weak var fullScreenContentDelegate: FullScreenContentDelegate? = nil
    func present(from: UIViewController) {}
    
    static func load(with adUnitID: String, request: Request, completionHandler: @escaping (InterstitialAd?, Error?) -> Void) {
        completionHandler(nil, NSError(domain: "AdMob", code: -1, userInfo: [NSLocalizedDescriptionKey: "GoogleMobileAds Framework nicht gefunden"]))
    }
}

class RewardedAd: NSObject, FullScreenPresentingAd {
    weak var fullScreenContentDelegate: FullScreenContentDelegate? = nil
    var adReward: AdReward = AdReward()
    func present(from: UIViewController, userDidEarnRewardHandler: @escaping () -> Void) {
        userDidEarnRewardHandler()
    }
    
    static func load(with adUnitID: String, request: Request, completionHandler: @escaping (RewardedAd?, Error?) -> Void) {
        completionHandler(nil, NSError(domain: "AdMob", code: -1, userInfo: [NSLocalizedDescriptionKey: "GoogleMobileAds Framework nicht gefunden"]))
    }
}

class AdReward: NSObject {
    var amount: NSDecimalNumber = 1
    var type: String = ""
}

class Request: NSObject {}

struct AdSizeBanner {
    static let banner = AdSizeBanner()
}

class MobileAds {
    static let shared = MobileAds()
    func start(completionHandler: ((InitializationStatus?) -> Void)?) {
        completionHandler?(nil)
    }
}

class InitializationStatus: NSObject {}

#else
import GoogleMobileAds

// Neue API verwendet Namen ohne GAD-Präfix direkt
// Die neuen Namen sind: BannerView, InterstitialAd, RewardedAd, etc.
// Keine Typealiases nötig - verwende die neuen Namen direkt
#endif

class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()
    
    // Test-Ad Unit IDs für Simulator (von Google bereitgestellt)
    private let testBannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    private let testInterstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    private let testRewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"
    
    // Prüfe ob im Simulator
    private var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    // Ad Unit IDs - Werden von Firebase Remote Config geladen (oder Test-IDs im Simulator)
    private var bannerAdUnitID: String {
        // Im Simulator: Verwende Test-IDs
        if isSimulator {
            return testBannerAdUnitID
        }
        guard isAdMobInitialized else {
            return "ca-app-pub-3840959679571598/6293918284" // Default
        }
        return FirebaseManager.shared.getString(key: "banner_ad_unit_id")
    }
    
    private var interstitialAdUnitID: String {
        // Im Simulator: Verwende Test-IDs
        if isSimulator {
            return testInterstitialAdUnitID
        }
        guard isAdMobInitialized else {
            return "ca-app-pub-3840959679571598/3090645228" // Default
        }
        return FirebaseManager.shared.getString(key: "interstitial_ad_unit_id")
    }
    
    private var rewardedAdUnitID: String {
        // Im Simulator: Verwende Test-IDs
        if isSimulator {
            return testRewardedAdUnitID
        }
        guard isAdMobInitialized else {
            return "ca-app-pub-3840959679571598/3667754945" // Default
        }
        return FirebaseManager.shared.getString(key: "rewarded_ad_unit_id")
    }
    
    // Ad Settings - Werden von Firebase Remote Config geladen
    private var adsEnabledRemote: Bool {
        guard isAdMobInitialized else {
            return true // Default: enabled
        }
        return FirebaseManager.shared.getBool(key: "ads_enabled")
    }
    
    private var bannerEnabled: Bool {
        guard isAdMobInitialized else {
            return true // Default: enabled
        }
        return FirebaseManager.shared.getBool(key: "banner_enabled")
    }
    
    private var interstitialEnabled: Bool {
        guard isAdMobInitialized else {
            print("⚠️ interstitialEnabled: AdMob nicht initialisiert, verwende Default: true")
            return true // Default: enabled
        }
        let value = FirebaseManager.shared.getBool(key: "interstitial_enabled")
        print("🔍 interstitialEnabled von Firebase: \(value)")
        return value
    }
    
    private var rewardedEnabled: Bool {
        guard isAdMobInitialized else {
            print("⚠️ rewardedEnabled: AdMob nicht initialisiert, verwende Default: true")
            return true // Default: enabled
        }
        let value = FirebaseManager.shared.getBool(key: "rewarded_enabled")
        print("🔍 rewardedEnabled von Firebase: \(value)")
        return value
    }
    
    // WICHTIG: Interstitial-Frequenz wird AUSSCHLIESSLICH über Firebase Remote Config gesteuert
    // Keine Hardcoded-Werte - alles wird von Firebase gelesen
    private var interstitialFrequency: Int {
        guard isAdMobInitialized else {
            // Fallback nur wenn Firebase nicht verfügbar ist (sollte nicht passieren)
            print("⚠️ interstitialFrequency: AdMob nicht initialisiert, verwende Fallback: 3")
            return 3 // Fallback: Alle 3 Button-Klicks (wird überschrieben sobald Firebase verfügbar ist)
        }
        // Lese Wert AUSSCHLIESSLICH aus Firebase Remote Config
        let value = FirebaseManager.shared.getInt(key: "interstitial_frequency")
        print("🔍 interstitialFrequency von Firebase Remote Config: \(value) (Interstitial nach jedem \(value). Button-Klick)")
        return value
    }
    
    private var minInterstitialInterval: TimeInterval {
        guard isAdMobInitialized else {
            print("⚠️ minInterstitialInterval: AdMob nicht initialisiert, verwende Default: 60")
            return 60 // Default
        }
        let value = FirebaseManager.shared.getInt(key: "interstitial_min_interval")
        print("🔍 minInterstitialInterval von Firebase: \(value) Sekunden")
        return TimeInterval(value)
    }
    
    // Ad Instances
    @Published var isInterstitialReady = false
    @Published var isRewardedReady = false
    
    // Tracking: Erste Aktion in dieser Session
    // WICHTIG: Wird beim App-Start zurückgesetzt, damit beim ersten Klick Interstitial sofort erscheint
    private var hasShownFirstInterstitial = false
    
    // Public Methode zum Zurücksetzen beim App-Start
    func resetFirstInterstitialFlag() {
        // Button-Klick-Zähler wird NICHT zurückgesetzt - zählt über die gesamte Session
        // Wenn Sie möchten, dass der Zähler beim App-Start zurückgesetzt wird, können Sie das hier hinzufügen:
        // actionButtonClickCount = 0
        print("✅ resetFirstInterstitialFlag() aufgerufen (Button-Klick-Zähler bleibt erhalten)")
    }
    
    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?
    
    // Ad Display Counters (für optimale Platzierung)
    private var interstitialDisplayCount = 0
    private var actionButtonClickCount = 0 // Zähler für Button-Klicks (für alle Aktionen)
    
    // Button Click Counters (für erste Klick + alle 3 Klicks Strategie)
    private var emergencyButtonClicks = 0
    private var symptomButtonClicks = 0
    private var photoAnalysisButtonClicks = 0
    
    // User Preferences
    @AppStorage("adsEnabled") var adsEnabled = true
    // Premium wurde entfernt - alle Benutzer sehen Ads
    
    // Computed Property: Kombiniert lokale Einstellung mit Remote Config
    var shouldShowAds: Bool {
        // Prüfe zuerst lokale Einstellung
        guard adsEnabled else {
            return false
        }
        
        // Prüfe ob AdMob initialisiert wurde, bevor wir auf Remote Config zugreifen
        guard isAdMobInitialized else {
            // Wenn noch nicht initialisiert, verwende nur lokale Einstellungen
            return adsEnabled
        }
        
        // WICHTIG: Prüfe Firebase Remote Config - auch im Simulator!
        // Wenn ads_enabled in Firebase auf false gesetzt ist, sollen KEINE Ads angezeigt werden
        return adsEnabled && adsEnabledRemote
    }
    
    // Consent Manager
    private let consentManager = ConsentManager.shared
    
    var isAdMobInitialized = false
    
    private override init() {
        super.init()
        
        // WICHTIG: Beim Singleton-Init: Setze Flags zurück für ersten Klick
        hasShownFirstInterstitial = false
        // lastInterstitialTime wurde entfernt - verwenden jetzt Button-Klick-Zähler
        
        // AdMob wird erst nach Firebase-Konfiguration initialisiert
        // Siehe initializeAdMob()
    }
    
    func initializeAdMob() {
        guard !isAdMobInitialized else {
            print("ℹ️ AdMob bereits initialisiert")
            return
        }
        
        // Im Simulator: Setze isAdMobInitialized sofort auf true (für Testing)
        #if targetEnvironment(simulator)
        isAdMobInitialized = true
        print("✅ Simulator: AdMob als initialisiert markiert (für Test-Ads)")
        #endif
        
        // Prüfe ob Firebase konfiguriert ist
        #if canImport(FirebaseCore)
        #if targetEnvironment(simulator)
        // Im Simulator: Prüfe Firebase, aber setze trotzdem fort (für Test-Ads)
        if FirebaseApp.app() == nil {
            print("⚠️ Simulator: Firebase nicht konfiguriert, setze trotzdem fort für Test-Ads")
        } else {
            print("✅ Firebase ist konfiguriert")
        }
        #else
        guard FirebaseApp.app() != nil else {
            print("❌ FEHLER: Firebase nicht konfiguriert! AdMob kann nicht initialisiert werden.")
            return
        }
        print("✅ Firebase ist konfiguriert")
        #endif
        #endif
        
        // Prüfe ob Application ID gesetzt ist
        #if canImport(GoogleMobileAds)
        if let appID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String,
           !appID.isEmpty {
            print("✅ AdMob Application ID gefunden: \(appID)")
        } else {
            print("❌ FEHLER: GADApplicationIdentifier nicht in Info.plist gefunden!")
            print("❌ Stelle sicher, dass die Application ID in Info.plist gesetzt ist.")
            print("❌ Verfügbare Keys in Info.plist:")
            if let infoDict = Bundle.main.infoDictionary {
                for key in infoDict.keys.sorted() {
                    print("   - \(key)")
                }
            }
            // Im Simulator: Versuche trotzdem zu initialisieren (für Test-Ads)
            #if !targetEnvironment(simulator)
            // Versuche trotzdem zu initialisieren (kann zu Crash führen)
            #endif
        }
        #endif
        
        // Lade Remote Config beim Start
        FirebaseManager.shared.fetchRemoteConfig { [weak self] success in
            if success {
                print("✅ Remote Config geladen")
                self?.printAdConfig()
            } else {
                print("⚠️ Remote Config konnte nicht geladen werden, verwende Default-Werte")
            }
        }
        
        // AdMob initialisieren (nach Firebase)
        #if canImport(GoogleMobileAds)
        MobileAds.shared.start(completionHandler: nil)
        #endif
        
        #if !targetEnvironment(simulator)
        isAdMobInitialized = true
        #endif
        
        // Reset: Beim App-Start soll erstes Interstitial wieder sofort erscheinen
        // WICHTIG: Setze zurück, damit beim ersten Klick nach App-Start Interstitial sofort erscheint
        resetFirstInterstitialFlag()
        print("✅ AdMob initialisiert")
        print("📊 Ads Status: enabled=\(adsEnabled), shouldShowAds=\(shouldShowAds)")
        
        #if !canImport(GoogleMobileAds)
        print("⚠️ WICHTIG: GoogleMobileAds Framework nicht gefunden!")
        print("⚠️ Test-Banner wird angezeigt. Füge Framework hinzu für echte Ads.")
        #endif
        
        // WICHTIG: Lade Ads SOFORT nach Initialisierung (ohne Verzögerung)
        // Ads sollen beim App-Start bereit sein
        // WICHTIG: Ads werden nur geladen wenn ads_enabled in Firebase true ist
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("🔄 Prüfe Firebase-Einstellungen vor Ad-Loading...")
            print("   - adsEnabledRemote: \(self.adsEnabledRemote)")
            print("   - interstitialEnabled: \(self.interstitialEnabled)")
            print("   - rewardedEnabled: \(self.rewardedEnabled)")
            
            if self.adsEnabledRemote {
                print("🔄 Lade Interstitial & Rewarded Ads direkt nach AdMob-Initialisierung...")
                self.loadInterstitialAd()
                self.loadRewardedAd()
                print("✅ Interstitial & Rewarded Ads werden beim App-Start geladen")
            } else {
                print("❌ ads_enabled in Firebase ist false - KEINE Ads werden geladen")
            }
        }
        
        // WICHTIG: Consent beim App-Start anfordern
        requestConsentOnStart()
        
        // Request Tracking Permission (ATT) - wird nach Consent angezeigt
        requestTrackingPermission()
    }
    
    // MARK: - Consent Request
    private func requestConsentOnStart() {
        print("🔍 Prüfe Consent-Status...")
        print("   - consentStatus: \(consentManager.consentStatus)")
        print("   - canShowAds(): \(consentManager.canShowAds())")
        
        // Wenn Consent bereits erteilt oder nicht erforderlich, nichts tun
        if consentManager.canShowAds() {
            print("✅ Consent bereits erteilt oder nicht erforderlich")
            return
        }
        
        // Wenn Consent erforderlich, aber noch nicht erteilt → Anfragen
        if consentManager.consentStatus == .required || consentManager.consentStatus == .unknown {
            print("📋 Consent erforderlich - Zeige Consent-Dialog...")
            consentManager.requestConsent { [weak self] granted in
                if granted {
                    print("✅ Consent erteilt - Lade Ads neu")
                    // Lade Ads nach Consent
                    // Banner wird automatisch neu geladen wenn BannerAdViewRepresentable aktualisiert wird
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.loadInterstitialAd()
                        self?.loadRewardedAd()
                    }
                } else {
                    print("❌ Consent verweigert - Ads werden nicht angezeigt")
                }
            }
        }
    }
    
    private func printAdConfig() {
        print("📊 Ad Config von Remote Config:")
        print("   - Banner Ad Unit ID: \(bannerAdUnitID)")
        print("   - Interstitial Ad Unit ID: \(interstitialAdUnitID)")
        print("   - Rewarded Ad Unit ID: \(rewardedAdUnitID)")
        print("   - Ads Enabled: \(adsEnabledRemote)")
        print("   - Banner Enabled: \(bannerEnabled)")
        print("   - Interstitial Enabled: \(interstitialEnabled)")
        print("   - Interstitial Frequency: \(interstitialFrequency)")
        print("   - Min Interval: \(minInterstitialInterval)s")
    }
    
    // MARK: - App Tracking Transparency (ATT)
    func requestTrackingPermission() {
        // Nur anfragen wenn Consent erteilt wurde
        guard consentManager.canShowAds() else {
            print("⚠️ ATT: Consent nicht erteilt, Tracking wird nicht angefragt")
            return
        }
        
        // Nur auf iOS 14.5+
        if #available(iOS 14.5, *) {
            // Warte kurz, damit Consent-Dialog zuerst angezeigt wird
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let status = ATTrackingManager.trackingAuthorizationStatus
                
                // Nur anfragen wenn noch nicht bestimmt
                if status == .notDetermined {
                    ATTrackingManager.requestTrackingAuthorization { authorizationStatus in
                        DispatchQueue.main.async {
                            switch authorizationStatus {
                            case .authorized:
                                print("✅ ATT: Tracking erlaubt")
                                // IDFA ist jetzt verfügbar für AdMob
                                let idfa = ASIdentifierManager.shared().advertisingIdentifier
                                print("📱 IDFA: \(idfa.uuidString)")
                                
                            case .denied:
                                print("⚠️ ATT: Tracking verweigert")
                                // AdMob kann trotzdem Ads zeigen, aber ohne Personalisierung
                                
                            case .restricted:
                                print("⚠️ ATT: Tracking eingeschränkt (Parental Controls)")
                                
                            case .notDetermined:
                                print("⚠️ ATT: Status nicht bestimmt")
                                
                            @unknown default:
                                print("⚠️ ATT: Unbekannter Status")
                            }
                        }
                    }
                } else {
                    print("ℹ️ ATT: Status bereits bestimmt: \(status.rawValue)")
                }
            }
        } else {
            print("ℹ️ ATT: Nicht verfügbar auf iOS < 14.5")
        }
    }
    
    // Prüfe ob Tracking erlaubt ist
    var isTrackingAuthorized: Bool {
        if #available(iOS 14.5, *) {
            return ATTrackingManager.trackingAuthorizationStatus == .authorized
        }
        return true // Vor iOS 14.5 war Tracking standardmäßig erlaubt
    }
    
    // MARK: - Banner Ad
    func createBannerAd() -> BannerView {
        // Debug-Logging
        print("🔍 Banner Ad Debug:")
        print("   - shouldShowAds: \(shouldShowAds)")
        print("   - adsEnabled: \(adsEnabled)")
        // Premium wurde entfernt - alle Benutzer sehen Ads
        print("   - isAdMobInitialized: \(isAdMobInitialized)")
        print("   - adsEnabledRemote: \(adsEnabledRemote)")
        print("   - bannerEnabled: \(bannerEnabled)")
        print("   - consentManager.canShowAds(): \(consentManager.canShowAds())")
        print("   - consentStatus: \(consentManager.consentStatus)")
        print("   - isSimulator: \(isSimulator)")
        print("   - bannerAdUnitID: \(bannerAdUnitID)")
        
        // WICHTIG: Prüfe Firebase Remote Config ZUERST
        // Wenn ads_enabled in Firebase auf false gesetzt ist, sollen KEINE Ads angezeigt werden
        guard adsEnabledRemote else {
            print("❌ Banner Ad: ads_enabled in Firebase ist false - Banner wird NICHT geladen")
            #if canImport(GoogleMobileAds)
            let banner = BannerView(adSize: AdSizeBanner)
            #else
            let banner = BannerView(adSize: AdSizeBanner.banner)
            #endif
            return banner
        }
        
        guard bannerEnabled else {
            print("❌ Banner Ad: banner_enabled in Firebase ist false - Banner wird NICHT geladen")
            #if canImport(GoogleMobileAds)
            let banner = BannerView(adSize: AdSizeBanner)
            #else
            let banner = BannerView(adSize: AdSizeBanner.banner)
            #endif
            return banner
        }
        
        // Prüfe Consent (im Simulator automatisch erteilt)
        #if targetEnvironment(simulator)
        // Im Simulator: Consent-Prüfung übersprungen (für Testing)
        print("✅ Simulator: Consent-Prüfung übersprungen für Banner Ad")
        #else
        guard consentManager.canShowAds() else {
            print("⚠️ Banner Ad: Consent nicht erteilt")
            #if canImport(GoogleMobileAds)
            let banner = BannerView(adSize: AdSizeBanner)
            #else
            let banner = BannerView(adSize: AdSizeBanner.banner)
            #endif
            return banner
        }
        #endif
        
        print("✅ Banner Ad: Wird geladen mit Unit ID: \(bannerAdUnitID)")
        
        #if canImport(GoogleMobileAds)
        let banner = BannerView(adSize: AdSizeBanner)
        #else
        let banner = BannerView(adSize: AdSizeBanner.banner)
        #endif
        banner.adUnitID = bannerAdUnitID
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            banner.rootViewController = rootViewController
        }
        
        // Firebase Analytics: Banner Ad wird geladen
        FirebaseManager.shared.logEvent("ad_banner_load", parameters: [
            "ad_unit_id": bannerAdUnitID
        ])
        
        banner.load(Request())
        return banner
    }
    
    // MARK: - Interstitial Ad
    func loadInterstitialAd() {
        guard adsEnabled else {
            print("⚠️ loadInterstitialAd: adsEnabled = false (lokale Einstellung)")
            return
        }
        
        // WICHTIG: Prüfe Firebase Remote Config IMMER (auch im Simulator)
        // Wenn ads_enabled in Firebase auf false gesetzt ist, sollen KEINE Ads geladen werden
        guard isAdMobInitialized else {
            print("⚠️ loadInterstitialAd: AdMob nicht initialisiert - verwende Default")
            return
        }
        
        guard adsEnabledRemote else {
            print("❌ loadInterstitialAd: ads_enabled in Firebase ist false - Interstitial wird NICHT geladen")
            return
        }
        
        // Prüfe ob Interstitial aktiviert ist
        guard interstitialEnabled else {
            print("❌ loadInterstitialAd: interstitial_enabled in Firebase ist false - Interstitial wird NICHT geladen")
            return
        }
        
        // Prüfe Consent (im Simulator automatisch erteilt)
        #if targetEnvironment(simulator)
        // Im Simulator: Immer erlauben (für Testing)
        print("✅ Simulator: Consent-Prüfung übersprungen für Interstitial Ad Loading")
        #else
        guard consentManager.canShowAds() else {
            print("⚠️ Interstitial Ad: Consent nicht erteilt")
            return
        }
        #endif
        
        print("🔍 Interstitial Ad Debug:")
        print("   - interstitialAdUnitID: \(interstitialAdUnitID)")
        print("   - isSimulator: \(isSimulator)")
        print("   - adsEnabled: \(adsEnabled)")
        print("   - adsEnabledRemote: \(adsEnabledRemote)")
        print("   - interstitialEnabled: \(interstitialEnabled)")
        print("   - consentManager.canShowAds(): \(consentManager.canShowAds())")
        
        // WICHTIG: Timing-Prüfung wird NICHT beim Laden gemacht, sondern nur beim Anzeigen!
        // Ads sollten immer geladen werden können, damit sie bereit sind wenn sie gebraucht werden.
        
        // Prüfe ob bereits ein Ad geladen ist
        if interstitialAd != nil && isInterstitialReady {
            print("ℹ️ Interstitial Ad bereits geladen - überspringe Neuladen")
            return
        }
        
        print("🔄 Lade Interstitial Ad...")
        let request = Request()
        InterstitialAd.load(with: interstitialAdUnitID, request: request) { [weak self] ad, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Interstitial Ad Fehler: \(error.localizedDescription)")
                print("   - Error Code: \((error as NSError).code)")
                print("   - Error Domain: \((error as NSError).domain)")
                print("   - Error UserInfo: \((error as NSError).userInfo)")
                FirebaseManager.shared.logAdError(adType: "interstitial", error: error.localizedDescription)
                self.isInterstitialReady = false
                self.interstitialAd = nil
                return
            }
            
            guard let ad = ad else {
                print("❌ Interstitial Ad: Ad ist nil nach dem Laden")
                self.isInterstitialReady = false
                self.interstitialAd = nil
                return
            }
            
            print("✅ Interstitial Ad erfolgreich geladen")
            print("   - Ad: \(ad)")
            print("   - Ad Unit ID: \(self.interstitialAdUnitID)")
            
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
            self.isInterstitialReady = true
            
            print("✅ Interstitial Ad bereit - isInterstitialReady = true")
            print("📊 Interstitial Ad Status: geladen und bereit für Präsentation")
            
            // Firebase Analytics: Interstitial Ad geladen
            FirebaseManager.shared.logAdImpression(adType: "interstitial", adUnitID: self.interstitialAdUnitID)
        }
    }
    
    // Prüft ob Interstitial Ad angezeigt werden soll (erster Klick oder alle X Klicks)
    func shouldShowInterstitialForButton(type: ButtonType) -> Bool {
        guard adsEnabled && adsEnabledRemote && interstitialEnabled else {
            print("⚠️ Interstitial Button: Bedingungen nicht erfüllt - adsEnabled: \(adsEnabled), adsEnabledRemote: \(adsEnabledRemote), interstitialEnabled: \(interstitialEnabled)")
            return false
        }
        
        guard isInterstitialReady else {
            print("⚠️ Interstitial Button: Ad nicht bereit, lade Ad...")
            loadInterstitialAd()
            return false
        }
        
        // WICHTIG: Timing wurde entfernt - verwenden jetzt Button-Klick-Zähler
        // Diese Methode wird nicht mehr verwendet, da showInterstitialAfterAction() jetzt den Zähler verwendet
        
        var shouldShow = false
        var clickCount = 0
        let frequency = max(interstitialFrequency, 1) // Mindestens 1
        
        switch type {
        case .emergency:
            emergencyButtonClicks += 1
            clickCount = emergencyButtonClicks
            // Erster Klick ODER alle X Klicks nach dem ersten (von Remote Config)
            shouldShow = (clickCount == 1) || (clickCount > 1 && (clickCount - 1) % frequency == 0)
            
        case .symptom:
            symptomButtonClicks += 1
            clickCount = symptomButtonClicks
            // Erster Klick ODER alle X Klicks nach dem ersten (von Remote Config)
            shouldShow = (clickCount == 1) || (clickCount > 1 && (clickCount - 1) % frequency == 0)
            
        case .photoAnalysis:
            photoAnalysisButtonClicks += 1
            clickCount = photoAnalysisButtonClicks
            // Erster Klick ODER alle X Klicks nach dem ersten (von Remote Config)
            shouldShow = (clickCount == 1) || (clickCount > 1 && (clickCount - 1) % frequency == 0)
        }
        
        if shouldShow {
            print("✅ Interstitial soll angezeigt werden (Button: \(type), Klick: \(clickCount), Frequency: \(frequency))")
        }
        
        return shouldShow
    }
    
    enum ButtonType {
        case emergency
        case symptom
        case photoAnalysis
    }
    
    func showInterstitialAd(completion: (() -> Void)? = nil) {
        print("🔍 showInterstitialAd() aufgerufen")
        print("   - adsEnabled: \(adsEnabled)")
        print("   - adsEnabledRemote: \(adsEnabledRemote)")
        print("   - interstitialEnabled: \(interstitialEnabled)")
        print("   - interstitialAd vorhanden: \(interstitialAd != nil)")
        print("   - isInterstitialReady: \(isInterstitialReady)")
        
        guard adsEnabled && adsEnabledRemote && interstitialEnabled else {
            print("❌ showInterstitialAd: Bedingungen nicht erfüllt")
            completion?()
            return
        }
        
        // WICHTIG: Prüfe ob Ad vorhanden und bereit ist
        guard let adToPresent = interstitialAd, isInterstitialReady else {
            print("⚠️ Interstitial Ad nicht bereit - lade neues Ad")
            loadInterstitialAd()
            completion?()
            return
        }
        
        // WICHTIG: Setze Ad sofort auf nil, damit es nicht mehrfach verwendet wird
        interstitialAd = nil
        isInterstitialReady = false
        print("✅ Setze interstitialAd auf nil vor der Präsentation")
        
        // Warte bis der ViewController in der Window-Hierarchie ist
        func presentAdWhenReady(attempts: Int = 0) {
            guard attempts < 30 else {
                print("❌ Konnte Interstitial Ad nicht präsentieren nach 30 Versuchen")
                loadInterstitialAd()
                completion?()
                return
            }
            
            // Finde den ViewController auf dem Main Thread
            DispatchQueue.main.async {
                // Finde den richtigen ViewController zum Präsentieren
                func findTopViewController() -> UIViewController? {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                          let rootViewController = window.rootViewController else {
                        return nil
                    }
                    
                    // Finde den obersten ViewController, der nichts präsentiert
                    func findTop(from viewController: UIViewController) -> UIViewController {
                        if let presented = viewController.presentedViewController {
                            return findTop(from: presented)
                        }
                        return viewController
                    }
                    
                    return findTop(from: rootViewController)
                }
                
                guard let topViewController = findTopViewController() else {
                    print("⏳ Versuch \(attempts + 1)/30: Warte auf ViewController...")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        presentAdWhenReady(attempts: attempts + 1)
                    }
                    return
                }
                
                // Prüfe ob ViewController View geladen ist
                guard topViewController.isViewLoaded else {
                    print("⏳ Versuch \(attempts + 1)/30: ViewController View noch nicht geladen...")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        presentAdWhenReady(attempts: attempts + 1)
                    }
                    return
                }
                
                // Prüfe ob ViewController in Window-Hierarchie ist
                guard let window = topViewController.view.window, window.isKeyWindow else {
                    print("⏳ Versuch \(attempts + 1)/30: ViewController noch nicht in Window-Hierarchie...")
                    print("   - view.window: \(topViewController.view.window != nil ? "vorhanden" : "nil")")
                    print("   - isKeyWindow: \(topViewController.view.window?.isKeyWindow ?? false)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        presentAdWhenReady(attempts: attempts + 1)
                    }
                    return
                }
                
                // Prüfe ob bereits etwas präsentiert wird
                if topViewController.presentedViewController != nil {
                    print("⏳ Versuch \(attempts + 1)/30: Warte bis präsentiertes ViewController geschlossen wird...")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        presentAdWhenReady(attempts: attempts + 1)
                    }
                    return
                }
                
                // Prüfe ob ViewController wirklich sichtbar ist
                guard !topViewController.view.isHidden,
                      topViewController.view.alpha > 0,
                      topViewController.view.superview != nil else {
                    print("⏳ Versuch \(attempts + 1)/30: ViewController View noch nicht sichtbar...")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        presentAdWhenReady(attempts: attempts + 1)
                    }
                    return
                }
                
                // Alle Bedingungen erfüllt - Präsentiere das Ad
                print("✅ Präsentiere Interstitial Ad jetzt...")
                print("   - topViewController: \(topViewController)")
                print("   - view.window: \(window)")
                print("   - isKeyWindow: \(window.isKeyWindow)")
                print("   - isViewLoaded: \(topViewController.isViewLoaded)")
                print("   - view.isHidden: \(topViewController.view.isHidden)")
                print("   - view.alpha: \(topViewController.view.alpha)")
                
                // Präsentiere das Ad direkt (wir sind bereits auf Main Thread)
                adToPresent.present(from: topViewController)
                print("✅ interstitialAd.present() aufgerufen")
                
                // Firebase Analytics: Interstitial Ad angezeigt
                FirebaseManager.shared.logAdClick(adType: "interstitial", adUnitID: self.interstitialAdUnitID)
                
                // Erhöhe Display Count
                self.interstitialDisplayCount += 1
                print("✅ Interstitial Ad Präsentation gestartet - Display Count: \(self.interstitialDisplayCount)")
                
                // Lade nächstes Ad vor
                self.loadInterstitialAd()
                
                completion?()
            }
        }
        
        // Starte Präsentation
        presentAdWhenReady()
    }
    
    // MARK: - Rewarded Ad
    func loadRewardedAd() {
        guard adsEnabled else {
            print("⚠️ loadRewardedAd: adsEnabled = false (lokale Einstellung)")
            return
        }
        
        // WICHTIG: Prüfe Firebase Remote Config IMMER (auch im Simulator)
        // Wenn ads_enabled in Firebase auf false gesetzt ist, sollen KEINE Ads geladen werden
        guard isAdMobInitialized else {
            print("⚠️ loadRewardedAd: AdMob nicht initialisiert - verwende Default")
            return
        }
        
        guard adsEnabledRemote else {
            print("❌ loadRewardedAd: ads_enabled in Firebase ist false - Rewarded Ad wird NICHT geladen")
            return
        }
        
        guard rewardedEnabled else {
            print("❌ loadRewardedAd: rewarded_enabled in Firebase ist false - Rewarded Ad wird NICHT geladen")
            return
        }
        
        // Prüfe Consent (im Simulator automatisch erteilt)
        #if targetEnvironment(simulator)
        // Im Simulator: Immer erlauben (für Testing)
        print("✅ Simulator: Consent-Prüfung übersprungen für Rewarded Ad Loading")
        #else
        guard consentManager.canShowAds() else {
            print("⚠️ Rewarded Ad: Consent nicht erteilt")
            return
        }
        #endif
        
        print("🔍 Rewarded Ad Debug:")
        print("   - rewardedAdUnitID: \(rewardedAdUnitID)")
        print("   - isSimulator: \(isSimulator)")
        print("   - adsEnabled: \(adsEnabled)")
        print("   - adsEnabledRemote: \(adsEnabledRemote)")
        
        let request = Request()
        RewardedAd.load(with: rewardedAdUnitID, request: request) { [weak self] ad, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Rewarded Ad Fehler: \(error.localizedDescription)")
                FirebaseManager.shared.logAdError(adType: "rewarded", error: error.localizedDescription)
                self.isRewardedReady = false
                return
            }
            
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.isRewardedReady = true
            print("✅ Rewarded Ad geladen")
            
            // Firebase Analytics: Rewarded Ad geladen
            FirebaseManager.shared.logAdImpression(adType: "rewarded", adUnitID: self.rewardedAdUnitID)
        }
    }
    
    func showRewardedAd(completion: @escaping (Bool) -> Void) {
        // WICHTIG: Prüfe Firebase Remote Config IMMER
        guard adsEnabled else {
            print("❌ showRewardedAd: adsEnabled = false (lokale Einstellung)")
            completion(false)
            return
        }
        
        guard isAdMobInitialized else {
            print("❌ showRewardedAd: AdMob nicht initialisiert")
            completion(false)
            return
        }
        
        guard adsEnabledRemote else {
            print("❌ showRewardedAd: ads_enabled in Firebase ist false - Rewarded Ad wird NICHT angezeigt")
            completion(false)
            return
        }
        
        guard rewardedEnabled else {
            print("❌ showRewardedAd: rewarded_enabled in Firebase ist false - Rewarded Ad wird NICHT angezeigt")
            completion(false)
            return
        }
        
        guard let rewardedAd = rewardedAd else {
            print("⚠️ Rewarded Ad nicht bereit")
            loadRewardedAd() // Lade nächstes Ad
            completion(false)
            return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            completion(false)
            return
        }
        
        rewardedAd.present(from: rootViewController, userDidEarnRewardHandler: {
            // Reward vergeben
            let reward = rewardedAd.adReward
            print("🎁 Reward erhalten: \(reward.amount) \(reward.type)")
            
            // Firebase Analytics: Reward erhalten
            FirebaseManager.shared.logAdRewardEarned(
                adType: "rewarded",
                rewardType: reward.type,
                rewardAmount: reward.amount.intValue
            )
            
            completion(true)
        })
        
        // Firebase Analytics: Rewarded Ad angezeigt
        FirebaseManager.shared.logAdClick(adType: "rewarded", adUnitID: rewardedAdUnitID)
        
        self.rewardedAd = nil
        self.isRewardedReady = false
        
        // Lade nächstes Ad vor
        loadRewardedAd()
    }
    
    // MARK: - Ad Placement Strategy
    // Zähler für Chat-Nachrichten
    private var chatMessageCount = 0
    
    func shouldShowInterstitial() -> Bool {
        // Diese Methode wird nicht mehr für Button-Klicks verwendet
        // showInterstitialAfterAction() verwendet jetzt direkt den Button-Klick-Zähler
        guard adsEnabled && adsEnabledRemote && interstitialEnabled && isInterstitialReady else {
            return false
        }
        return true
    }
    
    // Für Chat-Nachrichten: Zeige Rewarded Ad bei 3., 4., 5. Nachricht, dann alle 5 Nachrichten
    // KEIN Interstitial nach Chat-Nachrichten - nur nach Aktionen (Eingaben/Speichern)
    func incrementChatMessageCount() {
        chatMessageCount += 1
        print("📊 Chat-Nachrichten: \(chatMessageCount)")
        
        // Bei Nachricht 3, 4, 5: Zeige Rewarded Ad
        if chatMessageCount == 3 || chatMessageCount == 4 || chatMessageCount == 5 {
            print("🎁 Chat-Nachricht \(chatMessageCount) erreicht - Zeige Rewarded Ad")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showRewardedAd { success in
                    if success {
                        print("✅ Rewarded Ad erfolgreich angesehen - Belohnung erhalten")
                    } else {
                        print("⚠️ Rewarded Ad nicht verfügbar")
                        // KEIN Fallback zu Interstitial - nur Rewarded Ad
                    }
                }
            }
        } else if chatMessageCount > 5 && chatMessageCount % 5 == 0 {
            // Nach der 5. Nachricht: Alle 5 Nachrichten ein Rewarded Ad (10, 15, 20, 25, etc.)
            print("🎁 Chat-Nachricht \(chatMessageCount) erreicht (alle 5 Nachrichten) - Zeige Rewarded Ad")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showRewardedAd { success in
                    if success {
                        print("✅ Rewarded Ad erfolgreich angesehen - Belohnung erhalten")
                    } else {
                        print("⚠️ Rewarded Ad nicht verfügbar")
                        // KEIN Fallback zu Interstitial - nur Rewarded Ad
                    }
                }
            }
        } else {
            // Bei anderen Chat-Nachrichten: KEIN Ad
            // Interstitial erscheint NUR nach Aktionen (Medikament, Termin, Impfung, Symptom-Eingabe)
            print("💬 Chat-Nachricht \(chatMessageCount): Kein Ad (Rewarded bei 3,4,5 und dann alle 5)")
        }
    }
    
    // Helper: Zeige Interstitial nach wichtiger Aktion (Medikament, Termin, Impfung, Symptom-Eingabe)
    // WICHTIG: Wird NACH der Aktion aufgerufen (nach Eingabe/Speichern)
    // Interstitial erscheint bei JEDER Aktion, wenn Timing-Bedingung erfüllt ist (von Firebase gesteuert)
    // MARK: - Interstitial Ad nach Aktion (AdMob Best Practice)
    // Diese Methode folgt AdMob Best Practices:
    // 1. Ads werden beim App-Start geladen (bereit für sofortige Anzeige)
    // 2. Frequenz wird über Firebase Remote Config gesteuert
    // 3. Privacy Policy wurde bereits auf Landing Page akzeptiert
    // 4. Ads werden nur angezeigt wenn bereit (verhindert Fehler)
    func showInterstitialAfterAction() {
        // Erhöhe Button-Klick-Zähler ZUERST
        actionButtonClickCount += 1
        let currentClick = actionButtonClickCount
        
        print("🔍 ========== showInterstitialAfterAction() - Klick #\(currentClick) ==========")
        print("   📊 Status:")
        print("      - adsEnabled: \(adsEnabled)")
        print("      - adsEnabledRemote: \(adsEnabledRemote)")
        print("      - interstitialEnabled: \(interstitialEnabled)")
        print("      - isInterstitialReady: \(isInterstitialReady)")
        print("      - interstitialFrequency: \(interstitialFrequency)")
        print("      - interstitialAd vorhanden: \(interstitialAd != nil)")
        
        // Prüfe Basis-Bedingungen (AdMob Best Practice: Settings)
        guard adsEnabled else {
            print("❌ FEHLER: adsEnabled = false")
            return
        }
        
        guard adsEnabledRemote else {
            print("❌ FEHLER: adsEnabledRemote = false (von Firebase)")
            return
        }
        
        guard interstitialEnabled else {
            print("❌ FEHLER: interstitialEnabled = false (von Firebase)")
            return
        }
        
        // Privacy Policy wurde bereits auf Landing Page akzeptiert
        // Prüfe ob User Privacy Policy auf Landing Page akzeptiert hat
        let hasAcceptedPrivacy = UserDefaults.standard.bool(forKey: "hasAcceptedPrivacy")
        if !hasAcceptedPrivacy {
            print("⚠️ FEHLER: Privacy Policy nicht auf Landing Page akzeptiert")
            print("   - hasAcceptedPrivacy: \(hasAcceptedPrivacy)")
            return
        }
        print("✅ Privacy Policy akzeptiert")
        
        // Im Simulator: Immer erlauben (für Testing)
        #if !targetEnvironment(simulator)
        // Prüfe AdMob Consent (UMP SDK) nur wenn erforderlich
        if !consentManager.canShowAds() {
            print("⚠️ FEHLER: AdMob Consent nicht erteilt")
            print("   - Consent Status: \(consentManager.consentStatus)")
            print("   - canShowAds(): \(consentManager.canShowAds())")
            return
        }
        print("✅ AdMob Consent erteilt")
        #else
        print("✅ Simulator: Consent-Prüfung übersprungen")
        #endif
        
        // Berechne Frequenz (von Firebase Remote Config)
        let frequency = max(interstitialFrequency, 1) // Mindestens 1
        
        // Logik: Alle X Klicks → Interstitial
        // Bei frequency=3: Klick 3, 6, 9, 12, 15, 18...
        // Formel: Klick muss durch frequency teilbar sein
        let shouldShow = currentClick > 0 && currentClick % frequency == 0
        
        print("🔍 Frequenz-Prüfung:")
        print("   - Klick: \(currentClick)")
        print("   - Frequency: \(frequency)")
        print("   - Berechnung: \(currentClick) % \(frequency) = \(currentClick % frequency)")
        print("   - Soll zeigen: \(shouldShow)")
        
        if !shouldShow {
            // Berechne nächsten Klick wo Ad erscheinen soll
            let remainder = currentClick % frequency
            let nextShowAt = remainder == 0 ? currentClick + frequency : currentClick + (frequency - remainder)
            print("⏳ Kein Interstitial - Nächster bei Klick #\(nextShowAt)")
            print("🔍 ========== ENDE showInterstitialAfterAction() ==========")
            return
        }
        
        // AdMob Best Practice: Zeige Ad nur wenn bereit
        guard isInterstitialReady else {
            print("⚠️ FEHLER: Interstitial Ad nicht bereit")
            print("   - isInterstitialReady: \(isInterstitialReady)")
            print("   - interstitialAd vorhanden: \(interstitialAd != nil)")
            print("   - Lade neues Ad...")
            // Lade Ad für nächsten Versuch
            loadInterstitialAd()
            print("🔍 ========== ENDE showInterstitialAfterAction() ==========")
            return
        }
        
        // Ad ist bereit - zeige es jetzt
        print("✅ ALLE BEDINGUNGEN ERFÜLLT - Zeige Interstitial Ad bei Klick #\(currentClick)")
        print("🔍 ========== ENDE showInterstitialAfterAction() ==========")
        showInterstitialAd()
        
        // Lade nächstes Ad vor (AdMob Best Practice: Pre-loading)
        loadInterstitialAd()
    }
}

// MARK: - FullScreenContentDelegate
#if !canImport(GoogleMobileAds)
extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("📱 Ad geschlossen")
        
        // WICHTIG: Setze Ad auf nil NACH dem Schließen
        if ad is InterstitialAd {
            print("📱 Interstitial Ad geschlossen - Setze auf nil und lade neues Ad")
            self.interstitialAd = nil
            self.isInterstitialReady = false
            loadInterstitialAd()
        } else if ad is RewardedAd {
            print("📱 Rewarded Ad geschlossen - Setze auf nil und lade neues Ad")
            self.rewardedAd = nil
            self.isRewardedReady = false
            loadRewardedAd()
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Ad Präsentation fehlgeschlagen: \(error.localizedDescription)")
        let adType = ad is InterstitialAd ? "interstitial" : "rewarded"
        FirebaseManager.shared.logAdError(adType: adType, error: error.localizedDescription)
        
        // Setze Ad auf nil bei Fehler
        if ad is InterstitialAd {
            self.interstitialAd = nil
            self.isInterstitialReady = false
            loadInterstitialAd()
        } else if ad is RewardedAd {
            self.rewardedAd = nil
            self.isRewardedReady = false
            loadRewardedAd()
        }
    }
}
#else
extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("📱 Ad geschlossen")
        
        // WICHTIG: Setze Ad auf nil NACH dem Schließen
        if ad is InterstitialAd {
            print("📱 Interstitial Ad geschlossen - Setze auf nil und lade neues Ad")
            self.interstitialAd = nil
            self.isInterstitialReady = false
            loadInterstitialAd()
        } else if ad is RewardedAd {
            print("📱 Rewarded Ad geschlossen - Setze auf nil und lade neues Ad")
            self.rewardedAd = nil
            self.isRewardedReady = false
            loadRewardedAd()
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Ad Präsentation fehlgeschlagen: \(error.localizedDescription)")
        let adType = ad is InterstitialAd ? "interstitial" : "rewarded"
        FirebaseManager.shared.logAdError(adType: adType, error: error.localizedDescription)
        
        // Setze Ad auf nil bei Fehler
        if ad is InterstitialAd {
            self.interstitialAd = nil
            self.isInterstitialReady = false
            loadInterstitialAd()
        } else if ad is RewardedAd {
            self.rewardedAd = nil
            self.isRewardedReady = false
            loadRewardedAd()
        }
    }
}
#endif

// MARK: - Banner Ad View (SwiftUI Wrapper)
struct BannerAdView: View {
    @StateObject private var adManager = AdManager.shared
    @State private var showDebugInfo = false
    
    var body: some View {
        #if !canImport(GoogleMobileAds)
        // Test-Banner wenn Framework nicht verfügbar
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.8), Color.red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
                Text("TEST AD - GoogleMobileAds Framework fehlt")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 50)
        .onTapGesture {
            print("ℹ️ Test-Banner geklickt - Füge GoogleMobileAds Framework hinzu für echte Ads")
            showDebugInfo.toggle()
        }
        .onAppear {
            print("🔍 BannerAdView: Test-Banner angezeigt (GoogleMobileAds nicht verfügbar)")
            print("   - shouldShowAds: \(adManager.shouldShowAds)")
            print("   - adsEnabled: \(adManager.adsEnabled)")
        }
        #else
        Group {
            BannerAdViewRepresentable()
                .onAppear {
                    print("🔍 BannerAdView: Echte Ad wird geladen")
                    print("   - shouldShowAds: \(adManager.shouldShowAds)")
                    print("   - adsEnabled: \(adManager.adsEnabled)")
                    print("   - isAdMobInitialized: \(adManager.isAdMobInitialized)")
                }
            
            // Debug-Overlay im Simulator
            #if targetEnvironment(simulator)
            if showDebugInfo {
                VStack(alignment: .leading, spacing: 4) {
                    Text("DEBUG INFO")
                        .font(.caption2)
                        .bold()
                    Text("shouldShowAds: \(adManager.shouldShowAds ? "YES" : "NO")")
                        .font(.caption2)
                    Text("adsEnabled: \(adManager.adsEnabled ? "YES" : "NO")")
                        .font(.caption2)
                }
                .padding(8)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(4)
                .padding(.top, 4)
            }
            #endif
        }
        .onTapGesture(count: 3) {
            // Triple-tap für Debug-Info
            showDebugInfo.toggle()
        }
        #endif
    }
}

#if canImport(GoogleMobileAds)
struct BannerAdViewRepresentable: UIViewRepresentable {
    @StateObject private var adManager = AdManager.shared
    
    func makeUIView(context: Context) -> BannerView {
        let banner = AdManager.shared.createBannerAd()
        
        // Debug: Prüfe ob Banner-Ad geladen wird
        print("🔍 BannerAdViewRepresentable: Banner erstellt")
        print("   - adUnitID: \(banner.adUnitID)")
        print("   - rootViewController: \(banner.rootViewController != nil ? "gesetzt" : "nil")")
        
        // Setze Delegate für Ad-Loading-Events
        banner.delegate = context.coordinator
        
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        // Update wenn nötig - prüfe ob Ad geladen wurde
        if uiView.adUnitID?.isEmpty ?? true {
            print("⚠️ Banner-Ad Unit ID ist leer!")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, BannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("✅ Banner-Ad erfolgreich geladen!")
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ Banner-Ad Fehler: \(error.localizedDescription)")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
            print("📊 Banner-Ad Impression aufgezeichnet")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            print("📱 Banner-Ad wird präsentiert")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
            print("📱 Banner-Ad wird geschlossen")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            print("📱 Banner-Ad wurde geschlossen")
        }
    }
}
#endif

