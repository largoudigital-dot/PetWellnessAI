//
//  PhotoAnalysisView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI
import PhotosUI

struct PhotoAnalysisView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var appState: AppState
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showChat = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? Spacing.xxl : Spacing.xl) {
                        // Upload Area
                        VStack(spacing: isIPad ? Spacing.xl : Spacing.lg) {
                            // Dashed Border Upload Area mit Foto-Vorschau
                            ZStack {
                                RoundedRectangle(cornerRadius: CornerRadius.large)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                    .foregroundColor(.textSecondary)
                                    .frame(height: isIPad ? 350 : 250)
                                
                                if let image = selectedImage {
                                    // Foto wird im Feld angezeigt
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: isIPad ? 346 : 246)
                                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
                                } else {
                                    // Platzhalter wenn kein Foto ausgewählt
                                    VStack(spacing: isIPad ? Spacing.lg : Spacing.md) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: isIPad ? 70 : 50))
                                            .foregroundColor(.textSecondary)
                                        
                                        Text("photoAnalysis.dragPhoto".localized)
                                            .font(.system(size: isIPad ? 20 : 17))
                                            .foregroundColor(.textPrimary)
                                    }
                                }
                            }
                            .padding(.horizontal, isIPad ? Spacing.xxl : Spacing.xl)
                            
                            VStack(spacing: isIPad ? Spacing.lg : Spacing.md) {
                                PrimaryButton("photoAnalysis.camera".localized, icon: "camera.fill") {
                                    showCamera = true
                                }
                                .padding(.horizontal, isIPad ? Spacing.xxl : Spacing.xl)
                                
                                SecondaryButton("photoAnalysis.select".localized, icon: "photo.on.rectangle") {
                                    showImagePicker = true
                                }
                                .padding(.horizontal, isIPad ? Spacing.xxl : Spacing.xl)
                                
                                // Analyse-Button nur wenn Foto ausgewählt
                                if selectedImage != nil {
                                    PrimaryButton("photoAnalysis.analyze".localized, icon: "sparkles") {
                                        // WICHTIG: Erst Aktion ausführen, dann Ad zeigen
                                        // Setze Foto im AppState und wechsle direkt zum Chat-Tab
                                        appState.chatPhoto = selectedImage
                                        dismiss() // Schließe PhotoAnalysisView
                                        // Wechsle zum Chat-Tab in Navigation Bar
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            appState.selectedTab = 4
                                        }
                                        
                                        // Zeige Interstitial Ad NACH der Aktion
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            AdManager.shared.showInterstitialAfterAction()
                                        }
                                    }
                                    .padding(.horizontal, isIPad ? Spacing.xxl : Spacing.xl)
                                    .padding(.top, isIPad ? Spacing.md : Spacing.sm)
                                }
                            }
                        }
                        .padding(.top, isIPad ? Spacing.xxl : Spacing.xl)
                        
                        // Tips Section
                        VStack(alignment: .leading, spacing: isIPad ? Spacing.lg : Spacing.md) {
                            HStack(spacing: isIPad ? Spacing.md : Spacing.sm) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: isIPad ? 28 : 20))
                                    .foregroundColor(.brandPrimary)
                                
                                Text("photoAnalysis.tipsTitle".localized)
                                    .font(.system(size: isIPad ? 20 : 17, weight: .bold))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: isIPad ? Spacing.md : Spacing.sm) {
                                TipRow(text: "photoAnalysis.tip1".localized)
                                TipRow(text: "photoAnalysis.tip2".localized)
                                TipRow(text: "photoAnalysis.tip3".localized)
                                TipRow(text: "photoAnalysis.tip4".localized)
                            }
                        }
                        .padding(isIPad ? Spacing.xl : Spacing.lg)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.horizontal, isIPad ? Spacing.xxl : Spacing.xl)
                    }
                    .padding(.bottom, isIPad ? Spacing.xxl : Spacing.xl)
                }
            }
            .navigationTitle("photoAnalysis.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.brandPrimary)
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
                    .presentationDetents(isIPad ? [.large] : [.large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
                    .presentationDetents(isIPad ? [.large] : [.large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showChat) {
                ChatView(photoImage: selectedImage, isPresentedAsSheet: true)
                    .presentationDetents(isIPad ? [.large] : [.large])
                    .presentationDragIndicator(.visible)
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Circle()
                .fill(Color.brandPrimary)
                .frame(width: 6, height: 6)
            
            Text(text)
                .font(.bodyText)
                .foregroundColor(.textPrimary)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

