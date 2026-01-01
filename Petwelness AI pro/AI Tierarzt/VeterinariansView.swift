//
//  VeterinariansView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct VeterinariansView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    
    @State private var showAddVeterinarian = false
    @State private var selectedVeterinarian: Veterinarian? = nil
    @State private var showEditVeterinarian = false
    
    var veterinarians: [Veterinarian] {
        healthRecordManager.veterinarians
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                        }
                        
                        Spacer()
                        
                        Text("veterinarians.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddVeterinarian = true }) {
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
                            // Summary Card
                            if !veterinarians.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Veterinarians List
                            if veterinarians.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                veterinariansListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddVeterinarian) {
                AddVeterinarianView(healthRecordManager: healthRecordManager)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditVeterinarian) {
                if let veterinarian = selectedVeterinarian {
                    EditVeterinarianView(healthRecordManager: healthRecordManager, veterinarian: veterinarian)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentBlue)
                
                Text("veterinarians.savedVeterinarians".localized)
                    .id(localizationManager.currentLanguage)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(veterinarians.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentBlue)
            }
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.accentBlue.opacity(0.1), Color.accentBlue.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var veterinariansListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(veterinarians) { veterinarian in
                VeterinarianCard(
                    veterinarian: veterinarian,
                    onTap: {
                        selectedVeterinarian = veterinarian
                        showEditVeterinarian = true
                    },
                    onDelete: {
                        healthRecordManager.deleteVeterinarian(veterinarian)
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("veterinarians.noEntries".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("veterinarians.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct VeterinarianCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let veterinarian: Veterinarian
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentBlue.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentBlue)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(veterinarian.name)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    if !veterinarian.clinic.isEmpty {
                        Text(veterinarian.clinic)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack(spacing: Spacing.sm) {
                        if !veterinarian.phone.isEmpty {
                            Label(veterinarian.phone, systemImage: "phone.fill")
                                .font(.smallCaption)
                                .foregroundColor(.textTertiary)
                        }
                        
                        if !veterinarian.email.isEmpty {
                            Label(veterinarian.email, systemImage: "envelope.fill")
                                .font(.smallCaption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.lg)
            .background(Color.backgroundSecondary)
            .cornerRadius(CornerRadius.large)
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

// MARK: - Add Veterinarian View
struct AddVeterinarianView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    
    @State private var name = ""
    @State private var clinic = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var address = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Form
                        VStack(spacing: Spacing.lg) {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.name".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.namePlaceholder".localized, text: $name)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.clinic".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.clinicPlaceholder".localized, text: $clinic)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.phone".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.phonePlaceholder".localized, text: $phone)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.phonePad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.email".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.emailPlaceholder".localized, text: $email)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.emailAddress)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.address".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.addressPlaceholder".localized, text: $address)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
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
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("veterinarians.addVeterinarian".localized, icon: "checkmark") {
                            if !name.isEmpty {
                                let veterinarian = Veterinarian(
                                    name: name,
                                    clinic: clinic,
                                    phone: phone,
                                    email: email,
                                    address: address,
                                    notes: notes
                                )
                                healthRecordManager.addVeterinarian(veterinarian)
                                
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
            .navigationTitle("veterinarians.addVeterinarian".localized)
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

// MARK: - Edit Veterinarian View
struct EditVeterinarianView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let veterinarian: Veterinarian
    
    @State private var name: String
    @State private var clinic: String
    @State private var phone: String
    @State private var email: String
    @State private var address: String
    @State private var notes: String
    
    init(healthRecordManager: HealthRecordManager, veterinarian: Veterinarian) {
        self.healthRecordManager = healthRecordManager
        self.veterinarian = veterinarian
        _name = State(initialValue: veterinarian.name)
        _clinic = State(initialValue: veterinarian.clinic)
        _phone = State(initialValue: veterinarian.phone)
        _email = State(initialValue: veterinarian.email)
        _address = State(initialValue: veterinarian.address)
        _notes = State(initialValue: veterinarian.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // Form (same as Add)
                        VStack(spacing: Spacing.lg) {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.name".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.namePlaceholder".localized, text: $name)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.clinic".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.clinicPlaceholder".localized, text: $clinic)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.phone".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.phonePlaceholder".localized, text: $phone)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.phonePad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.email".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.emailPlaceholder".localized, text: $email)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.emailAddress)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("veterinarians.address".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("veterinarians.addressPlaceholder".localized, text: $address)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
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
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark") {
                            if !name.isEmpty {
                                var updated = veterinarian
                                updated.name = name
                                updated.clinic = clinic
                                updated.phone = phone
                                updated.email = email
                                updated.address = address
                                updated.notes = notes
                                healthRecordManager.updateVeterinarian(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("veterinarians.editVeterinarian".localized)
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
