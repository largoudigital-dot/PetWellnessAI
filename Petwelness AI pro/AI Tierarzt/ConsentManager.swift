//
//  ConsentManager.swift
//  AI Tierarzt
//
//  Created for GDPR/CCPA Compliance
//

import Foundation
import SwiftUI
import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds
import UserMessagingPlatform
#endif

class ConsentManager: ObservableObject {
    static let shared = ConsentManager()
    
    @Published var consentStatus: ConsentStatus = .unknown
    @Published var showConsentDialog = false
    
    enum ConsentStatus {
        case unknown
        case notRequired // Nicht in EU/USA
        case required
        case obtained
        case denied
    }
    
    private let consentKey = "user_consent_status"
    private let consentDateKey = "user_consent_date"
    
    private init() {
        loadConsentStatus()
    }
    
    // MARK: - Consent Status Management
    func loadConsentStatus() {
        if let statusString = UserDefaults.standard.string(forKey: consentKey),
           let status = ConsentStatus(rawValue: statusString) {
            self.consentStatus = status
        } else {
            // Prüfe ob User in EU/USA ist
            checkIfConsentRequired()
        }
    }
    
    func saveConsentStatus(_ status: ConsentStatus) {
        self.consentStatus = status
        UserDefaults.standard.set(status.rawValue, forKey: consentKey)
        UserDefaults.standard.set(Date(), forKey: consentDateKey)
        print("✅ Consent Status gespeichert: \(status)")
    }
    
    // MARK: - Check if Consent is Required
    func checkIfConsentRequired() {
        // Prüfe ob User in EU oder USA ist
        let locale = Locale.current
        let regionCode = locale.regionCode ?? ""
        
        // EU Länder
        let euCountries = ["AT", "BE", "BG", "HR", "CY", "CZ", "DK", "EE", "FI", "FR", "DE", "GR", "HU", "IE", "IT", "LV", "LT", "LU", "MT", "NL", "PL", "PT", "RO", "SK", "SI", "ES", "SE"]
        
        // USA
        let usRegion = "US"
        
        if euCountries.contains(regionCode) || regionCode == usRegion {
            consentStatus = .required
            print("🌍 Consent erforderlich für Region: \(regionCode)")
        } else {
            consentStatus = .notRequired
            print("🌍 Consent nicht erforderlich für Region: \(regionCode)")
        }
    }
    
    // MARK: - Request Consent
    func requestConsent(completion: @escaping (Bool) -> Void) {
        #if canImport(GoogleMobileAds)
        // Verwende Google UMP SDK für Consent-Management
        let parameters = RequestParameters()
        parameters.isTaggedForUnderAgeOfConsent = false
        
        // Prüfe ob Consent erforderlich ist
        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) { [weak self] error in
            guard let self = self else {
                completion(false)
                return
            }
            
            if let error = error {
                print("❌ Consent Request Fehler: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            let status = ConsentInformation.shared.consentStatus
            
            switch status {
            case .required:
                // Zeige Consent-Formular
                DispatchQueue.main.async {
                    self.showConsentForm(completion: completion)
                }
                
            case .notRequired:
                // Consent nicht erforderlich
                self.saveConsentStatus(.notRequired)
                completion(true)
                
            case .obtained:
                // Consent bereits vorhanden
                self.saveConsentStatus(.obtained)
                completion(true)
                
            case .unknown:
                // Status unbekannt, zeige Formular
                DispatchQueue.main.async {
                    self.showConsentForm(completion: completion)
                }
                
            @unknown default:
                completion(false)
            }
        }
        #else
        // Fallback: Zeige eigenen Consent-Dialog wenn UMP nicht verfügbar
        DispatchQueue.main.async {
            self.showConsentDialog = true
        }
        // Completion wird vom Dialog aufgerufen, wenn User eine Auswahl trifft
        #endif
    }
    
    #if canImport(GoogleMobileAds)
    private func showConsentForm(completion: @escaping (Bool) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            completion(false)
            return
        }
        
        ConsentForm.load { [weak self] form, error in
            guard let self = self else {
                completion(false)
                return
            }
            
            if let error = error {
                print("❌ Consent Form Fehler: \(error.localizedDescription)")
                self.saveConsentStatus(.denied)
                completion(false)
                return
            }
            
            guard let form = form else {
                completion(false)
                return
            }
            
            form.present(from: rootViewController) { [weak self] formError in
                guard let self = self else {
                    completion(false)
                    return
                }
                
                if let formError = formError {
                    print("❌ Consent Form Präsentation Fehler: \(formError.localizedDescription)")
                    self.saveConsentStatus(.denied)
                    completion(false)
                    return
                }
                
                let status = ConsentInformation.shared.consentStatus
                
                switch status {
                case .obtained:
                    self.saveConsentStatus(.obtained)
                    completion(true)
                    
                case .notRequired:
                    self.saveConsentStatus(.notRequired)
                    completion(true)
                    
                default:
                    self.saveConsentStatus(.denied)
                    completion(false)
                }
            }
        }
    }
    #endif
    
    // MARK: - Check if Ads can be shown
    func canShowAds() -> Bool {
        // Im Simulator: Immer erlauben (für Testing)
        #if targetEnvironment(simulator)
        return true
        #endif
        
        switch consentStatus {
        case .obtained, .notRequired:
            return true
        case .required, .unknown, .denied:
            return false
        }
    }
    
    // MARK: - Reset Consent (für Testing)
    func resetConsent() {
        UserDefaults.standard.removeObject(forKey: consentKey)
        UserDefaults.standard.removeObject(forKey: consentDateKey)
        #if canImport(GoogleMobileAds)
        ConsentInformation.shared.reset()
        #endif
        consentStatus = .unknown
        checkIfConsentRequired()
    }
}

// MARK: - ConsentStatus RawValue
extension ConsentManager.ConsentStatus: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case "unknown":
            self = .unknown
        case "notRequired":
            self = .notRequired
        case "required":
            self = .required
        case "obtained":
            self = .obtained
        case "denied":
            self = .denied
        default:
            return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .unknown:
            return "unknown"
        case .notRequired:
            return "notRequired"
        case .required:
            return "required"
        case .obtained:
            return "obtained"
        case .denied:
            return "denied"
        }
    }
}

// MARK: - Custom Consent Dialog View (Fallback)
struct ConsentDialogView: View {
    @ObservedObject var consentManager = ConsentManager.shared
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    @State private var personalizedAds = false
    @State private var deviceStorage = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: Spacing.md) {
                    Text("consent.title".localized)
                        .id(localizationManager.currentLanguage)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("consent.description".localized)
                        .id(localizationManager.currentLanguage)
                        .font(.bodyText)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(Spacing.xl)
                .background(Color.backgroundSecondary)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Personalized Ads
                        ConsentOptionView(
                            icon: "person.crop.circle.badge.gearshape",
                            title: "consent.personalizedAds.title".localized,
                            description: "consent.personalizedAds.description".localized,
                            isEnabled: $personalizedAds
                        )
                        .id(localizationManager.currentLanguage)
                        
                        // Device Storage
                        ConsentOptionView(
                            icon: "externaldrive.badge.icloud",
                            title: "consent.deviceStorage.title".localized,
                            description: "consent.deviceStorage.description".localized,
                            isEnabled: $deviceStorage
                        )
                        .id(localizationManager.currentLanguage)
                        
                        // More Information
                        DisclosureGroup {
                            Text("consent.moreInfo".localized)
                                .id(localizationManager.currentLanguage)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                                .padding(.top, Spacing.sm)
                        } label: {
                            HStack {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12))
                                Text("consent.moreInfoTitle".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyText)
                            }
                            .foregroundColor(.brandPrimary)
                        }
                        .padding(.top, Spacing.md)
                    }
                    .padding(Spacing.xl)
                }
                .background(Color.backgroundPrimary)
                
                // Buttons
                VStack(spacing: Spacing.md) {
                    // Agree Button
                    Button(action: {
                        consentManager.saveConsentStatus(.obtained)
                        consentManager.showConsentDialog = false
                        dismiss()
                    }) {
                        Text("consent.agree".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(Spacing.md)
                            .background(LinearGradient.brand)
                            .cornerRadius(CornerRadius.medium)
                    }
                    
                    // Disagree Button
                    Button(action: {
                        consentManager.saveConsentStatus(.denied)
                        consentManager.showConsentDialog = false
                        dismiss()
                    }) {
                        Text("consent.disagree".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(Spacing.md)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(CornerRadius.medium)
                    }
                    
                    // Manage Options
                    Button(action: {
                        // Zeige erweiterte Optionen
                    }) {
                        Text("consent.manageOptions".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyText)
                            .foregroundColor(.brandPrimary)
                    }
                }
                .padding(Spacing.xl)
                .background(Color.backgroundSecondary)
            }
            .background(Color.backgroundPrimary)
            .cornerRadius(CornerRadius.large)
            .padding(Spacing.xl)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.85)
        }
    }
}

struct ConsentOptionView: View {
    let icon: String
    let title: String
    let description: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
        }
        .padding(Spacing.md)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.medium)
    }
}

