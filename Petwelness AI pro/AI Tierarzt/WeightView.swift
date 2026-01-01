//
//  WeightView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct WeightView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddWeight = false
    @State private var selectedRecord: WeightRecord? = nil
    @State private var showEditWeight = false
    
    var weightRecords: [WeightRecord] {
        healthRecordManager.getWeightRecords(for: pet.id)
    }
    
    var latestWeight: WeightRecord? {
        weightRecords.first
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
                        
                        Text("weight.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddWeight = true }) {
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
                            if let latest = latestWeight {
                                summaryCard(latest: latest)
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Weight Records List
                            if weightRecords.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                weightRecordsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddWeight) {
                AddWeightView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditWeight) {
                if let record = selectedRecord {
                    EditWeightView(healthRecordManager: healthRecordManager, record: record)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private func summaryCard(latest: WeightRecord) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentOrange)
                
                Text("weight.currentWeight".localized)
                    .id(localizationManager.currentLanguage)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text(String(format: "%.1f kg", latest.weight))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentOrange)
            }
            
            if weightRecords.count > 1 {
                let previous = weightRecords[1]
                let change = latest.weight - previous.weight
                let changeText = change > 0 ? "+\(String(format: "%.1f", change))" : String(format: "%.1f", change)
                Text("\(LocalizedStrings.get("weight.change")) \(changeText) kg")
                    .id(localizationManager.currentLanguage)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.accentOrange.opacity(0.1), Color.accentOrange.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var weightRecordsListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(weightRecords) { record in
                WeightRecordCard(
                    record: record,
                    onTap: {
                        selectedRecord = record
                        showEditWeight = true
                    },
                    onDelete: {
                        healthRecordManager.deleteWeightRecord(record)
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "scalemass")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("weight.noEntries".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("weight.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct WeightRecordCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let record: WeightRecord
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentOrange.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "scalemass.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentOrange)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(String(format: "%.1f kg", record.weight))
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text(record.date, format: .dateTime.day().month().year())
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    if !record.notes.isEmpty {
                        Text(record.notes)
                            .font(.smallCaption)
                            .foregroundColor(.textTertiary)
                            .lineLimit(1)
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

// MARK: - Add Weight View
struct AddWeightView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var weight: String = ""
    @State private var date = Date()
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
                                Text("weight.weightKg".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                HStack {
                                    TextField("0.0", text: $weight)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(AppTextFieldStyle())
                                    
                                    Text("kg")
                                        .foregroundColor(.textSecondary)
                                }
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
                        PrimaryButton("weight.add".localized, icon: "checkmark") {
                            if let weightValue = Double(weight.replacingOccurrences(of: ",", with: ".")) {
                                let record = WeightRecord(
                                    petId: pet.id,
                                    weight: weightValue,
                                    date: date,
                                    notes: notes
                                )
                                healthRecordManager.addWeightRecord(record)
                                
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
            .navigationTitle("weight.addTitle".localized)
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

// MARK: - Edit Weight View
struct EditWeightView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let record: WeightRecord
    
    @State private var weight: String
    @State private var date: Date
    @State private var notes: String
    
    init(healthRecordManager: HealthRecordManager, record: WeightRecord) {
        self.healthRecordManager = healthRecordManager
        self.record = record
        _weight = State(initialValue: String(format: "%.1f", record.weight))
        _date = State(initialValue: record.date)
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
                                Text("weight.weightKg".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                HStack {
                                    TextField("0.0", text: $weight)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(AppTextFieldStyle())
                                    
                                    Text("kg")
                                        .foregroundColor(.textSecondary)
                                }
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
                            if let weightValue = Double(weight.replacingOccurrences(of: ",", with: ".")) {
                                var updated = record
                                updated.weight = weightValue
                                updated.date = date
                                updated.notes = notes
                                healthRecordManager.updateWeightRecord(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("weight.editTitle".localized)
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
