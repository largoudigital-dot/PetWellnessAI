//
//  ContentView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var petManager = PetManager()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.scenePhase) private var scenePhase
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        ZStack {
            // Main Content - Kein TabView, damit kein Swipen möglich ist
            Group {
                switch appState.selectedTab {
                case 0:
                    HomeView()
                case 1:
                    PetFirstAidHomeView()
                case 2:
                    MoreView()
                        .environmentObject(LocalizationManager.shared)
                case 3:
                    SettingsView()
                        .environmentObject(LocalizationManager.shared)
                case 4:
                    ChatView()
                        .environmentObject(LocalizationManager.shared)
                        .environmentObject(appState)
                default:
                    HomeView()
                }
            }
            .onChange(of: appState.selectedTab) { newTab in
                // Tastatur ausblenden, wenn zu einem anderen Tab gewechselt wird
                if newTab != 4 {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            .onAppear {
                // ATT SOFORT anzeigen - VOR jeder Datensammlung (Apple Requirement)
                // Wichtig: Nach minimaler Verzögerung, damit UI geladen ist
                // Muss VOR Consent-Dialog erscheinen
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if #available(iOS 14.5, *) {
                        AdManager.shared.requestTrackingPermission()
                    }
                }
            }
            .onChange(of: scenePhase) { newPhase in
                // Lade Remote Config neu wenn App wieder aktiv wird
                if newPhase == .active {
                    print("🔄 App ist aktiv - lade Remote Config sofort neu...")
                    FirebaseManager.shared.fetchRemoteConfig { success in
                        if success {
                            print("✅ Remote Config neu geladen - Änderungen sind jetzt aktiv")
                            // Informiere AdManager über Änderungen
                            AdManager.shared.refreshAdSettings()
                        }
                    }
                }
            }
            
            // Navigation Bar (ohne Banner Ad - Banner Ads sind jetzt in den einzelnen Views)
            if appState.isTabBarVisible {
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Navigation Bar
                    BottomNavigationBar(selectedTab: $appState.selectedTab)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .allowsHitTesting(true)
                .zIndex(1000)
            }
        }
        .overlay {
            if appState.showNotificationAction,
               let medicationId = appState.notificationMedicationId,
               let petId = appState.notificationPetId,
               let medicationName = appState.notificationMedicationName,
               let petName = appState.notificationPetName {
                ZStack {
                    // Transparenter Hintergrund - Homepage bleibt sichtbar
                    // Nur außerhalb des Modals tappable
                    Color.black.opacity(0.05)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            appState.showNotificationAction = false
                        }
                    
                    // Modal in der Mitte - muss über dem Hintergrund sein
                    NotificationActionView(
                        medicationId: medicationId,
                        petId: petId,
                        medicationName: medicationName,
                        petName: petName
                    )
                    .environmentObject(appState)
                }
            }
        }
    }
}

// MARK: - Chat ViewModel
class ChatViewModel: ObservableObject {
    @Published var isLoading = false
    
    func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }
        NotificationCenter.default.post(name: NSNotification.Name("ChatMessageSent"), object: nil, userInfo: ["text": text])
    }
}

// MARK: - Bottom Navigation Bar
struct BottomNavigationBar: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var appState: AppState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Items (immer angezeigt) - Genau 37px (iPhone) / 91px (iPad) ohne Safe Area
            HStack(spacing: 0) {
                NavBarItem(icon: "house.fill", title: "nav.home".localized, tag: 0, selectedTab: $selectedTab)
                    .id(localizationManager.currentLanguage)
                NavBarItem(icon: "cross.case.fill", title: "nav.firstAid".localized, tag: 1, selectedTab: $selectedTab)
                    .id(localizationManager.currentLanguage)
                ChatNavItem(selectedTab: $selectedTab)
                NavBarItem(icon: "square.grid.2x2.fill", title: "nav.more".localized, tag: 2, selectedTab: $selectedTab)
                    .id(localizationManager.currentLanguage)
                NavBarItem(icon: "gearshape.fill", title: "nav.settings".localized, tag: 3, selectedTab: $selectedTab)
                    .id(localizationManager.currentLanguage)
            }
            .frame(height: isIPad ? 91 : 37)
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundSecondary)
        .allowsHitTesting(true)
    }
}

// MARK: - Nav Bar Item
struct NavBarItem: View {
    let icon: String
    let title: String
    let tag: Int
    @Binding var selectedTab: Int
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var isSelected: Bool {
        selectedTab == tag
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedTab = tag
            }
        }) {
            VStack(spacing: isIPad ? 4 : 2) { // Etwas mehr Spacing auf iPad
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 22 : 18, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .brandPrimary : .textTertiary)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
                
                Text(title)
                    .font(.system(size: isIPad ? 12 : 10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? .brandPrimary : .textTertiary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: isIPad ? 91 : 37)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Chat Navigation Item (Blauer Button ohne Text)
struct ChatNavItem: View {
    @Binding var selectedTab: Int
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var isSelected: Bool {
        selectedTab == 4
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedTab = 4
            }
        }) {
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: isIPad ? 12 : 10)
                        .fill(Color(red: 0.0, green: 0.5, blue: 1.0)) // Blau
                        .frame(width: isIPad ? 50 : 44, height: isIPad ? 50 : 44)
                    
                    Image(systemName: "message.fill")
                        .font(.system(size: isIPad ? 22 : 18, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: isIPad ? 91 : 37)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Placeholder Views
struct SymptomListView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var showSymptomInput = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.lg) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 80))
                    .foregroundColor(.brandPrimary)
                
                Text("symptomList.title".localized)
                    .font(.appSubtitle)
                    .foregroundColor(.textPrimary)
                    .id(localizationManager.currentLanguage)
                
                PrimaryButton("symptomList.enter".localized, icon: "plus") {
                    showSymptomInput = true
                }
                .padding(.horizontal, Spacing.xxl)
                .padding(.top, Spacing.xl)
                .id(localizationManager.currentLanguage)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $showSymptomInput) {
            SymptomInputView()
        }
    }
}

struct ProfileView: View {
    @Binding var selectedTab: Int
    @ObservedObject var petManager: PetManager
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.xl) {
                // Paw Print Icons
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.textTertiary)
                        .offset(x: -5)
                    
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.textTertiary)
                        .offset(x: 5)
                }
                
                // Text
                Text("profile.noPetSelected".localized)
                    .font(.bodyText)
                    .foregroundColor(.textTertiary)
                    .id(localizationManager.currentLanguage)
                
                // Button
                PrimaryButton("profile.backToHome".localized, icon: "house.fill") {
                        withAnimation {
                        selectedTab = 0
                    }
                }
                .padding(.horizontal, Spacing.xxl)
                .id(localizationManager.currentLanguage)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
