//
//  GroomingView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct GroomingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddGrooming = false
    @State private var selectedRecord: GroomingRecord? = nil
    @State private var showEditGrooming = false
    
    var groomingRecords: [GroomingRecord] {
        healthRecordManager.getGroomingRecords(for: pet.id)
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
                        
                        Text("grooming.title".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddGrooming = true }) {
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
                            if !groomingRecords.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Grooming Records List
                            if groomingRecords.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                groomingRecordsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddGrooming) {
                AddGroomingView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditGrooming) {
                if let record = selectedRecord {
                    EditGroomingView(healthRecordManager: healthRecordManager, record: record)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "scissors")
                    .font(.system(size: 24))
                    .foregroundColor(.accentPurple)
                
                Text("grooming.entries".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(groomingRecords.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentPurple)
            }
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.accentPurple.opacity(0.1), Color.accentPurple.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var groomingRecordsListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(groomingRecords) { record in
                GroomingRecordCard(
                    record: record,
                    onTap: {
                        selectedRecord = record
                        showEditGrooming = true
                    },
                    onDelete: {
                        healthRecordManager.deleteGroomingRecord(record)
                    }
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "scissors")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("grooming.noEntries".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("grooming.addEntriesDescription".localized)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct GroomingRecordCard: View {
    let record: GroomingRecord
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentPurple.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "scissors")
                        .font(.system(size: 20))
                        .foregroundColor(.accentPurple)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(record.type)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        if record.duration > 0 {
                            Text("\(record.duration) Min")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        if record.professional {
                            Text("common.professional".localized)
                                .font(.smallCaption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.brandPrimary)
                                .cornerRadius(6)
                        }
                        
                        if record.cost > 0 {
                            Text(String(format: "%.2f %@", record.cost, LocalizedStrings.currencySymbol()))
                                .font(.smallCaption)
                                .foregroundColor(.accentGreen)
                        }
                    }
                    
                    Text(record.date, format: .dateTime.day().month().year())
                        .font(.smallCaption)
                        .foregroundColor(.textTertiary)
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
            }
        }
    }
}

// MARK: - Add Grooming View
struct AddGroomingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var type = "grooming.type.bathing"
    @State private var date = Date()
    @State private var duration: String = ""
    @State private var professional = false
    @State private var cost: String = ""
    @State private var notes = ""
    
    var types: [String] {
        ["grooming.type.bathing", "grooming.type.brushing", "grooming.type.nails", "grooming.type.ears"]
    }
    
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
                                Text("grooming.careType".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("grooming.careType".localized, selection: $type) {
                                    ForEach(types, id: \.self) { t in
                                        Text(t.localized)
                                            .id(localizationManager.currentLanguage)
                                            .tag(t)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
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
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.durationMinutes".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("common.durationPlaceholder".localized, text: $duration)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            Toggle("common.professional".localized, isOn: $professional)
                                .id(localizationManager.currentLanguage)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                            
                            if professional {
                                VStack(alignment: .leading, spacing: Spacing.sm) {
                                    Text("common.cost".localized)
                                        .id(localizationManager.currentLanguage)
                                        .font(.bodyTextBold)
                                        .foregroundColor(.textPrimary)
                                    
                                    TextField("0.00", text: $cost)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(AppTextFieldStyle())
                                }
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
                        PrimaryButton("grooming.addEntry".localized, icon: "checkmark") {
                            let record = GroomingRecord(
                                petId: pet.id,
                                type: type.localized,
                                date: date,
                                duration: Int(duration) ?? 0,
                                professional: professional,
                                cost: Double(cost.replacingOccurrences(of: ",", with: ".")) ?? 0,
                                notes: notes
                            )
                            healthRecordManager.addGroomingRecord(record)
                            
                            // Zeige Interstitial Ad nach Aktion
                            AdManager.shared.showInterstitialAfterAction()
                            
                            dismiss()
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("grooming.addEntry".localized)
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

// MARK: - Edit Grooming View
struct EditGroomingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let record: GroomingRecord
    
    @State private var type: String
    @State private var date: Date
    @State private var duration: String
    @State private var professional: Bool
    @State private var cost: String
    @State private var notes: String
    
    var types: [String] {
        ["grooming.type.bathing", "grooming.type.brushing", "grooming.type.nails", "grooming.type.ears"]
    }
    
    static func getTypeKey(from storedType: String) -> String {
        // Map stored localized strings back to keys
        let typeMap: [String: String] = [
            "Baden": "grooming.type.bathing",
            "Bathing": "grooming.type.bathing",
            "Bürsten": "grooming.type.brushing",
            "Brushing": "grooming.type.brushing",
            "Krallen": "grooming.type.nails",
            "Nails": "grooming.type.nails",
            "Ohren": "grooming.type.ears",
            "Ears": "grooming.type.ears"
        ]
        return typeMap[storedType] ?? "grooming.type.bathing"
    }
    
    init(healthRecordManager: HealthRecordManager, record: GroomingRecord) {
        self.healthRecordManager = healthRecordManager
        self.record = record
        // Convert stored type back to key if needed, or keep as is
        let typeKey = Self.getTypeKey(from: record.type)
        _type = State(initialValue: typeKey)
        _date = State(initialValue: record.date)
        _duration = State(initialValue: "\(record.duration)")
        _professional = State(initialValue: record.professional)
        _cost = State(initialValue: String(format: "%.2f", record.cost))
        _notes = State(initialValue: record.notes)
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
                                Text("grooming.careType".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("Typ", selection: $type) {
                                    ForEach(types, id: \.self) { t in
                                        Text(t.localized).tag(t)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.date".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.durationMinutes".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("common.durationPlaceholder".localized, text: $duration)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            Toggle("common.professional".localized, isOn: $professional)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                            
                            if professional {
                                VStack(alignment: .leading, spacing: Spacing.sm) {
                                    Text("common.cost".localized)
                                        .font(.bodyTextBold)
                                        .foregroundColor(.textPrimary)
                                    
                                    TextField("0.00", text: $cost)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(AppTextFieldStyle())
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.notes".localized)
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
                            var updated = record
                            updated.type = type.localized
                            updated.date = date
                            updated.duration = Int(duration) ?? 0
                            updated.professional = professional
                            updated.cost = Double(cost.replacingOccurrences(of: ",", with: ".")) ?? 0
                            updated.notes = notes
                            healthRecordManager.updateGroomingRecord(updated)
                            dismiss()
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("grooming.editEntry".localized)
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


