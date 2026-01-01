//
//  ChatView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var messages: [ChatMessage] = []
    @State private var isLoading = false
    @State private var isTyping = false
    @State private var selectedImage: UIImage? = nil
    @State private var showSuggestedQuestions = false
    @State private var isKeyboardVisible = false
    @State private var showDeleteConfirmation = false
    @State private var errorMessage: String? = nil
    @State private var showError = false
    @StateObject private var chatViewModel = ChatViewModel()
    
    var initialSymptoms: [String] = []
    var additionalNotes: String = ""
    var photoImage: UIImage? = nil
    var isPresentedAsSheet: Bool = false
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    // Berechnung für Bottom Padding (Eingabefeld + Navigation Bar + Banner Ad nur wenn Tastatur nicht sichtbar)
    private var bottomPadding: CGFloat {
        let inputHeight = isIPad ? 80.0 : 70.0
        // Wenn Tastatur sichtbar ist, nur Eingabefeld-Höhe, sonst + Navigation Bar + Banner Ad
        if isKeyboardVisible {
            return inputHeight
        } else {
            let navBarHeight = isIPad ? 91.0 : 37.0
            let bannerAdHeight = AdManager.shared.shouldShowAds ? 50.0 : 0.0
            return inputHeight + navBarHeight + bannerAdHeight
        }
    }
    
    init(initialSymptoms: [String] = [], additionalNotes: String = "", photoImage: UIImage? = nil, isPresentedAsSheet: Bool = false) {
        self.initialSymptoms = initialSymptoms
        self.additionalNotes = additionalNotes
        self.photoImage = photoImage
        self.isPresentedAsSheet = isPresentedAsSheet
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack(spacing: Spacing.sm) {
                    if isPresentedAsSheet {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16))
                                .foregroundColor(.brandPrimary)
                        }
                        .frame(width: 32, height: 32)
                    } else {
                        Color.clear
                            .frame(width: 16)
                    }
                    
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.2, green: 0.8, blue: 0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                        
                        Text("AI")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("chat.aiVet".localized)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.accentGreen)
                                .frame(width: 6, height: 6)
                            Text("chat.online".localized)
                                .font(.system(size: 11))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Lösch-Icon
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 18))
                            .foregroundColor(.textSecondary)
                    }
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(height: 50)
                .padding(.horizontal, Spacing.md)
                .background(Color.backgroundSecondary)
                
                Divider()
                    .frame(height: 0.5)
                
                // Disclaimer Banner - Immer sichtbar oben im Chat
                disclaimerBanner
                
                // Messages Area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: Spacing.sm) {
                            if messages.isEmpty {
                                VStack(spacing: Spacing.xl) {
                                    welcomeMessage
                                    suggestedQuestionsView
                                }
                                .padding(.top, Spacing.xl)
                            }
                            
                            ForEach(messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                                    .transition(.asymmetric(
                                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }
                            
                            if isTyping {
                                TypingIndicator()
                                    .id("typing")
                                    .padding(.leading, Spacing.lg)
                                    .padding(.top, 6)
                                    .padding(.bottom, 6)
                            }
                            
                            if isLoading {
                                HStack(alignment: .top) {
                                    ProgressView()
                                        .padding(.trailing, Spacing.sm)
                                    Text("KI denkt nach...")
                                        .font(.bodyText)
                                        .foregroundColor(.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, Spacing.lg)
                                .padding(.top, 6)
                                .padding(.bottom, 6)
                            }
                        }
                        .padding(.top, Spacing.lg)
                        .padding(.bottom, bottomPadding)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastMessage = messages.last {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    .onChange(of: isTyping) { _ in
                        if isTyping {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    proxy.scrollTo("typing", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            // Eingabebereich (direkt auf Tastatur wenn sichtbar, sonst über Navigation Bar)
            VStack(spacing: 0) {
                ChatInputBarView(
                    inputText: $appState.chatInputText,
                    chatViewModel: chatViewModel,
                    onSend: { text in
                        let trimmedText = text.trimmingCharacters(in: .whitespaces)
                        guard !trimmedText.isEmpty else { return }
                        sendMessage(text: trimmedText)
                        appState.chatInputText = ""
                    },
                    onImagePicker: {
                        appState.showChatImagePicker = true
                    }
                )
                .frame(height: (horizontalSizeClass == .regular && verticalSizeClass == .regular) ? 80 : 70)
                .background(Color.backgroundSecondary)
                
                // Banner Ad über Navigation Bar (nur wenn Tastatur NICHT sichtbar ist)
                if !isKeyboardVisible && AdManager.shared.shouldShowBannerAds {
                    BannerAdView()
                        .frame(height: 50)
                        .background(Color.backgroundPrimary)
                }
                
                // Padding nur wenn Tastatur NICHT sichtbar ist (für Navigation Bar)
                if !isKeyboardVisible {
                    let navBarHeight = (horizontalSizeClass == .regular && verticalSizeClass == .regular) ? 91.0 : 37.0
                    Color.clear
                        .frame(height: navBarHeight)
                }
            }
        }
        .onAppear {
            loadChatHistory()
            
            // Navigation Bar in ContentView anzeigen (ist jetzt in ContentView)
            withAnimation(.easeInOut(duration: 0.2)) {
                appState.isTabBarVisible = true
            }
            
            let symptoms = appState.chatSymptoms.isEmpty ? initialSymptoms : appState.chatSymptoms
            let notes = appState.chatNotes.isEmpty ? additionalNotes : appState.chatNotes
            let photo = appState.chatPhoto ?? photoImage
            
            if !symptoms.isEmpty || !notes.isEmpty {
                // Lokalisiere Symptome für professionelle Anzeige
                let localizedSymptoms = symptoms.map { symptom in
                    // Prüfe ob es ein Localization-Key ist
                    if symptom.hasPrefix("symptoms.") {
                        return symptom.localized
                    }
                    return symptom
                }
                
                let symptomText = "chat.symptoms".localized + ": " + localizedSymptoms.joined(separator: ", ")
                let notesText = notes.isEmpty ? "" : "\n" + "chat.additionalInfo".localized + ": \(notes)"
                sendInitialMessage("\(symptomText)\(notesText)")
                appState.clearChatData()
            } else if photo != nil {
                sendInitialMessage("chat.photoUploaded".localized)
                appState.clearChatData()
            }
        }
        .onDisappear {
            // Tastatur ausblenden, wenn zu einer anderen View gewechselt wird
            hideKeyboard()
        }
        .sheet(isPresented: $appState.showChatImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ChatMessageSent"))) { notification in
            if let text = notification.userInfo?["text"] as? String {
                sendMessage(text: text)
            }
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                // WICHTIG: sendMessage fügt die Nachricht bereits zu messages hinzu
                // Deshalb hier NICHT nochmal hinzufügen, sonst erscheint die Nachricht doppelt
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Verwende lokalisierte Nachricht
                    let message = "chat.photoUploaded".localized
                    sendMessage(text: message, image: image)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            withAnimation {
                isKeyboardVisible = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation {
                isKeyboardVisible = false
            }
        }
        .alert("chat.deleteChat".localized, isPresented: $showDeleteConfirmation) {
            Button("common.cancel".localized, role: .cancel) { }
            Button("common.delete".localized, role: .destructive) {
                deleteChat()
            }
        } message: {
            Text("chat.deleteChatMessage".localized)
        }
        .alert("Fehler", isPresented: $showError) {
            Button("OK", role: .cancel) {
                errorMessage = nil
            }
        } message: {
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        }
        .navigationBarHidden(true)
    }
    
    private var disclaimerBanner: some View {
        let disclaimerText = "chat.disclaimer".localized
        let components = disclaimerText.components(separatedBy: ":")
        
        return VStack(spacing: 2) {
            if let firstPart = components.first {
                // IMPORTANT Text mit Icon - kleiner
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.accentOrange)
                    
                    Text(firstPart)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .textCase(.uppercase)
                }
                
                // Rest des Textes
                if components.count > 1 {
                    Text(components.dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespaces))
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(.textPrimary.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineSpacing(1)
                }
            } else {
                Text(disclaimerText)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, 6)
        .background(Color.accentOrange.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.accentOrange.opacity(0.3), lineWidth: 0.5)
        )
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, 4)
    }
    
    private var welcomeMessage: some View {
        VStack(spacing: Spacing.xl) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.15),
                                Color(red: 0.2, green: 0.8, blue: 0.8).opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "message.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
            }
            
            VStack(spacing: Spacing.sm) {
                Text("chat.askFirstQuestion".localized)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text("chat.helpDescription".localized)
                    .font(.system(size: 15))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxl)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
    }
    
    private var suggestedQuestionsView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("chat.suggestedQuestions".localized)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.lg)
            
            VStack(spacing: Spacing.sm) {
                SuggestedQuestionButton(
                    question: "chat.question1".localized,
                    icon: "dog.fill"
                ) {
                    appState.chatInputText = "chat.question1".localized
                }
                
                SuggestedQuestionButton(
                    question: "chat.question2".localized,
                    icon: "cat.fill"
                ) {
                    appState.chatInputText = "chat.question2".localized
                }
                
                SuggestedQuestionButton(
                    question: "chat.question3".localized,
                    icon: "pawprint.fill"
                ) {
                    appState.chatInputText = "chat.question3".localized
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
        .padding(.top, Spacing.lg)
    }
    
    private func sendInitialMessage(_ text: String) {
        // WICHTIG: sendMessage fügt die Nachricht bereits zu messages hinzu
        // Deshalb hier NICHT nochmal hinzufügen, sonst erscheint die Nachricht doppelt
        let imageToSend = appState.chatPhoto ?? photoImage
        sendMessage(text: text, image: imageToSend)
    }
    
    private func sendMessage(text: String, image: UIImage? = nil) {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        guard !trimmedText.isEmpty || image != nil else { return }
        
        let userMessage = ChatMessage(text: trimmedText, isUser: true, image: image)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            messages.append(userMessage)
        }
        
        saveChatHistory()
        
        // Prüfe ob API Key vorhanden ist
        guard ClaudeAPIService.shared.hasValidAPIKey() else {
            errorMessage = "API Key fehlt. Bitte in ClaudeAPIService.swift eintragen."
            showError = true
            return
        }
        
        // Zeige Typing-Indikator
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isTyping = true
        }
        
        // Sende Nachricht an Claude API
        Task {
            do {
                // Konvertiere Bild zu Data, falls vorhanden
                // WICHTIG: Claude API hat ein Maximum von 5 MB für Bilder
                var imageData: Data? = nil
                if let image = image ?? selectedImage {
                    imageData = compressImage(image, maxSizeMB: 5)
                    if let imageData = imageData {
                        let sizeMB = Double(imageData.count) / 1024.0 / 1024.0
                        print("📸 Bild komprimiert: \(String(format: "%.2f", sizeMB)) MB")
                    }
                }
                
                // Hole aktuelle Sprache
                let language = localizationManager.currentLanguage
                
                // Sende Nachricht an Claude
                let response = try await ClaudeAPIService.shared.sendMessage(
                    trimmedText,
                    imageData: imageData,
                    conversationHistory: messages,
                    language: language
                )
                
                // Update UI auf Main Thread
                await MainActor.run {
                    isTyping = false
                    isLoading = false
                    let aiResponse = ChatMessage(
                        text: response,
                        isUser: false
                    )
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        messages.append(aiResponse)
                    }
                    saveChatHistory()
                    selectedImage = nil // Bild nach Verwendung löschen
                    
                    // Zeige Interstitial Ad nach 2-3 Nachrichten (maximaler Profit)
                    AdManager.shared.incrementChatMessageCount()
                }
            } catch {
                await MainActor.run {
                    isTyping = false
                    isLoading = false
                    
                    // Error-Handling
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .missingAPIKey:
                            errorMessage = "API Key fehlt. Bitte in ClaudeAPIService.swift eintragen."
                        case .limitReached:
                            errorMessage = "Tageslimit erreicht. Bitte versuchen Sie es morgen erneut."
                        case .httpError(let code):
                            errorMessage = "HTTP Fehler: \(code). Bitte versuchen Sie es später erneut."
                        case .apiError(let message):
                            errorMessage = "API Fehler: \(message)"
                        default:
                            errorMessage = "Ein Fehler ist aufgetreten. Bitte versuchen Sie es später erneut."
                        }
                    } else {
                        errorMessage = "Ein Fehler ist aufgetreten: \(error.localizedDescription)"
                    }
                    showError = true
                }
            }
        }
    }
    
    private func saveChatHistory() {
        if let encoded = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encoded, forKey: "chat_history")
        }
    }
    
    private func loadChatHistory() {
        if let data = UserDefaults.standard.data(forKey: "chat_history"),
           let decoded = try? JSONDecoder().decode([ChatMessage].self, from: data) {
            messages = decoded
        }
    }
    
    private func deleteChat() {
        withAnimation {
            messages = []
        }
        UserDefaults.standard.removeObject(forKey: "chat_history")
        appState.chatInputText = ""
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: - Image Compression
    /// Komprimiert ein Bild, bis es unter der maximalen Größe ist (für Claude API: 5 MB)
    private func compressImage(_ image: UIImage, maxSizeMB: Double) -> Data? {
        let maxSizeBytes = Int(maxSizeMB * 1024 * 1024) // Konvertiere MB zu Bytes
        var compressionQuality: CGFloat = 0.8
        var imageData = image.jpegData(compressionQuality: compressionQuality)
        
        // Wenn Bild bereits klein genug ist, verwende es direkt
        if let data = imageData, data.count <= maxSizeBytes {
            return data
        }
        
        // Reduziere Bildgröße schrittweise
        var currentSize = image.size
        let maxDimension: CGFloat = 2048 // Maximale Dimension für Claude API
        
        // Wenn Bild zu groß ist, verkleinere es zuerst
        if currentSize.width > maxDimension || currentSize.height > maxDimension {
            let scale = min(maxDimension / currentSize.width, maxDimension / currentSize.height)
            let newSize = CGSize(width: currentSize.width * scale, height: currentSize.height * scale)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                imageData = resizedImage.jpegData(compressionQuality: compressionQuality)
            } else {
                UIGraphicsEndImageContext()
            }
        }
        
        // Wenn Bild immer noch zu groß ist, reduziere Komprimierungsqualität
        if let data = imageData, data.count > maxSizeBytes {
            compressionQuality = 0.5
            imageData = image.jpegData(compressionQuality: compressionQuality)
            
            // Wenn immer noch zu groß, reduziere weiter
            if let data = imageData, data.count > maxSizeBytes {
                compressionQuality = 0.3
                imageData = image.jpegData(compressionQuality: compressionQuality)
                
                // Letzter Versuch mit sehr niedriger Qualität
                if let data = imageData, data.count > maxSizeBytes {
                    compressionQuality = 0.1
                    imageData = image.jpegData(compressionQuality: compressionQuality)
                }
            }
        }
        
        // Prüfe finale Größe
        if let data = imageData {
            if data.count > maxSizeBytes {
                print("⚠️ Bild konnte nicht unter \(maxSizeMB) MB komprimiert werden. Aktuelle Größe: \(Double(data.count) / 1024.0 / 1024.0) MB")
                // Versuche nochmal mit kleinerer Dimension
                let smallerDimension: CGFloat = 1024
                let scale = min(smallerDimension / image.size.width, smallerDimension / image.size.height)
                let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
                
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0.5)
                image.draw(in: CGRect(origin: .zero, size: newSize))
                if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    imageData = resizedImage.jpegData(compressionQuality: 0.5)
                } else {
                    UIGraphicsEndImageContext()
                }
            }
        }
        
        return imageData
    }
}

// MARK: - Chat Input Bar View (direkt in ChatView integriert)
struct ChatInputBarView: View {
    @Binding var inputText: String
    @ObservedObject var chatViewModel: ChatViewModel
    var onSend: (String) -> Void
    var onImagePicker: () -> Void
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isTextFieldFocused: Bool
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var textFieldBackgroundColor: Color {
        colorScheme == .dark 
            ? Color(red: 0.2, green: 0.2, blue: 0.25)
            : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Kamera Button (Teal wie im Screenshot)
            Button(action: onImagePicker) {
                Image(systemName: "camera.fill")
                    .font(.system(size: isIPad ? 20 : 18))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color(red: 0.2, green: 0.8, blue: 0.8)) // Teal
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            
            // Textfeld
            TextField("chat.messagePlaceholder".localized, text: $inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(textFieldBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .lineLimit(1...4)
                .submitLabel(.send)
                .autocorrectionDisabled(false)
                .textInputAutocapitalization(.sentences)
                .focused($isTextFieldFocused)
                .onSubmit {
                    if !inputText.trimmingCharacters(in: .whitespaces).isEmpty {
                        onSend(inputText)
                        inputText = ""
                        isTextFieldFocused = false
                    }
                }
                .onTapGesture {
                    isTextFieldFocused = true
                }
            
            // Senden Button (Farbe ändert sich wenn Text vorhanden)
            Button(action: {
                let trimmedText = inputText.trimmingCharacters(in: .whitespaces)
                guard !trimmedText.isEmpty else { return }
                onSend(trimmedText)
                inputText = ""
                isTextFieldFocused = false
            }) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        inputText.trimmingCharacters(in: .whitespaces).isEmpty
                            ? Color(red: 0.7, green: 0.7, blue: 0.7) // Hellgrau wenn leer
                            : Color.brandPrimary // Brand-Farbe wenn Text vorhanden
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary)
    }
}

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let text: String
    let isUser: Bool
    let timestamp: Date
    let imageData: Data?
    
    init(id: UUID = UUID(), text: String, isUser: Bool, timestamp: Date = Date(), image: UIImage? = nil) {
        self.id = id
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
        self.imageData = image?.jpegData(compressionQuality: 0.8)
    }
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            if message.isUser {
                Spacer(minLength: isIPad ? 100 : 60)
            } else {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.2, green: 0.8, blue: 0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isIPad ? 40 : 32, height: isIPad ? 40 : 32)
                    
                    Text("AI")
                        .font(.system(size: isIPad ? 14 : 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.leading, isIPad ? Spacing.xl : Spacing.lg)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                // Bild-Vorschau wenn vorhanden
                if let image = message.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: isIPad ? 200 : 150, height: isIPad ? 200 : 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(message.isUser ? Color.white.opacity(0.3) : Color.clear, lineWidth: 1)
                        )
                        .padding(.bottom, message.text.isEmpty ? 0 : 8)
                }
                
                // Text-Nachricht
                if !message.text.isEmpty {
                    Text(message.text)
                        .font(.system(size: isIPad ? 19 : 17))
                        .foregroundColor(message.isUser ? .white : .textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, isIPad ? 22 : 18)
                        .padding(.vertical, isIPad ? 16 : 14)
                        .background(
                            Group {
                                if message.isUser {
                                    LinearGradient(
                                        colors: [Color.brandPrimary, Color.brandPrimary.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                } else {
                                    Color.backgroundSecondary
                                }
                            }
                        )
                        .cornerRadius(24)
                        .shadow(
                            color: message.isUser ? Color.brandPrimary.opacity(0.2) : Color.black.opacity(0.05),
                            radius: message.isUser ? 8 : 4,
                            y: 2
                        )
                        .frame(maxWidth: isIPad ? 600 : UIScreen.main.bounds.width * 0.72, alignment: message.isUser ? .trailing : .leading)
                }
            }
            
            if message.isUser {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.2))
                        .frame(width: isIPad ? 40 : 32, height: isIPad ? 40 : 32)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: isIPad ? 16 : 14))
                        .foregroundColor(.brandPrimary)
                }
                .padding(.trailing, isIPad ? Spacing.xl : Spacing.lg)
            } else {
                Spacer(minLength: isIPad ? 100 : 60)
            }
        }
        .padding(.vertical, isIPad ? 10 : 8)
    }
}
