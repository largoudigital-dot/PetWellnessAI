//
//  PhotosView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct PhotosView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddPhoto = false
    @State private var selectedPhoto: PetPhoto? = nil
    @State private var showEditPhoto = false
    
    var photos: [PetPhoto] {
        healthRecordManager.getPhotos(for: pet.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                        }
                        Spacer()
                        Text("Foto-Galerie")
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Button(action: { showAddPhoto = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                        }
                    }
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.md)
                    .background(Color.white)
                    
                    ScrollView {
                        VStack(spacing: Spacing.xl) {
                            if photos.isEmpty {
                                emptyStateView.padding(.top, Spacing.xxxl)
                            } else {
                                photosGridView.padding(.top, Spacing.lg)
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddPhoto) {
                AddPhotoView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditPhoto) {
                if let photo = selectedPhoto {
                    EditPhotoView(healthRecordManager: healthRecordManager, photo: photo)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var photosGridView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
            ForEach(photos) { photo in
                PhotoThumbnail(photo: photo, onTap: {
                    selectedPhoto = photo
                    showEditPhoto = true
                }, onDelete: {
                    healthRecordManager.deletePhoto(photo)
                })
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            Text("photos.noPhotos".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            Text("photos.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct PhotoThumbnail: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let photo: PetPhoto
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Color.backgroundSecondary)
                    .frame(height: 120)
                
                if let imageData = photo.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(CornerRadius.medium)
                } else {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(role: .destructive, action: onDelete) {
                Label("common.delete".localized, systemImage: "trash")
                    .id(localizationManager.currentLanguage)
            }
        }
    }
}

struct AddPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var title = ""
    @State private var date = Date()
    @State private var notes = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isAddPhotoFormValid: Bool {
        selectedImage != nil
    }
    
    private var titleField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.title".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("common.title".localized, text: $title)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var dateField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.date".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(Spacing.md)
                .background(Color.backgroundTertiary)
                .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var notesField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.notes".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextEditor(text: $notes)
                .frame(minHeight: 100)
                .padding(Spacing.sm)
                .background(Color.backgroundTertiary)
                .cornerRadius(CornerRadius.medium)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        VStack(spacing: Spacing.lg) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 300)
                                    .cornerRadius(CornerRadius.large)
                            } else {
                                Button(action: { showImagePicker = true }) {
                                    VStack(spacing: Spacing.md) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(.brandPrimary)
                                        Text("photos.selectPhoto".localized)
                                            .id(localizationManager.currentLanguage)
                                            .font(.bodyTextBold)
                                            .foregroundColor(.brandPrimary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(CornerRadius.large)
                                }
                            }
                            
                            titleField
                            dateField
                            notesField
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        PrimaryButton("photos.add".localized, icon: "checkmark", isDisabled: !isAddPhotoFormValid) {
                            if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                                let photo = PetPhoto(
                                    petId: pet.id,
                                    date: date,
                                    title: title,
                                    notes: notes,
                                    imageData: imageData
                                )
                                healthRecordManager.addPhoto(photo)
                                
                                // Zeige Interstitial Ad nach Aktion
                                AdManager.shared.showInterstitialAfterAction()
                                
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("photos.addTitle".localized)
                .id(localizationManager.currentLanguage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
        }
    }
}

struct EditPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let photo: PetPhoto
    
    @State private var title: String
    @State private var date: Date
    @State private var notes: String
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isEditPhotoFormValid: Bool {
        true // Keine Pflichtfelder für EditPhotoView
    }
    
    private var titleField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.title".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("common.title".localized, text: $title)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var dateField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.date".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(Spacing.md)
                .background(Color.backgroundTertiary)
                .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var notesField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.notes".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextEditor(text: $notes)
                .frame(minHeight: 100)
                .padding(Spacing.sm)
                .background(Color.backgroundTertiary)
                .cornerRadius(CornerRadius.medium)
        }
    }
    
    init(healthRecordManager: HealthRecordManager, photo: PetPhoto) {
        self.healthRecordManager = healthRecordManager
        self.photo = photo
        _title = State(initialValue: photo.title)
        _date = State(initialValue: photo.date)
        _notes = State(initialValue: photo.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        if let imageData = photo.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .cornerRadius(CornerRadius.large)
                        }
                        
                        VStack(spacing: Spacing.lg) {
                            titleField
                            dateField
                            notesField
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        PrimaryButton("common.saveChanges".localized, icon: "checkmark") {
                            var updated = photo
                            updated.title = title
                            updated.date = date
                            updated.notes = notes
                            healthRecordManager.updatePhoto(updated)
                            dismiss()
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("photos.editTitle".localized)
                .id(localizationManager.currentLanguage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }
}

