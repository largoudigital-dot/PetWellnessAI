//
//  FeedingView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct FeedingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddFeeding = false
    @State private var selectedRecord: FeedingRecord? = nil
    @State private var showEditFeeding = false
    
    var feedingRecords: [FeedingRecord] {
        healthRecordManager.getFeedingRecords(for: pet.id)
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
                        
                        Text("feeding.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddFeeding = true }) {
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
                            if !feedingRecords.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Feeding Records List
                            if feedingRecords.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                feedingRecordsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddFeeding) {
                AddFeedingView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditFeeding) {
                if let record = selectedRecord {
                    EditFeedingView(healthRecordManager: healthRecordManager, record: record)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.system(size: 24))
                    .foregroundColor(.accentGreen)
                
                Text("feeding.feedings".localized)
                    .id(localizationManager.currentLanguage)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(feedingRecords.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentGreen)
            }
            
            let todayRecords = feedingRecords.filter { Calendar.current.isDateInToday($0.time) }
            if !todayRecords.isEmpty {
                let feedingText = todayRecords.count == 1 ? LocalizedStrings.get("feeding.singular") : LocalizedStrings.get("feeding.plural")
                Text("\(LocalizedStrings.get("feeding.today")) \(todayRecords.count) \(feedingText)")
                    .id(localizationManager.currentLanguage)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.accentGreen.opacity(0.1), Color.accentGreen.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var feedingRecordsListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(feedingRecords) { record in
                FeedingRecordCard(
                    record: record,
                    onTap: {
                        selectedRecord = record
                        showEditFeeding = true
                    },
                    onDelete: {
                        healthRecordManager.deleteFeedingRecord(record)
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "fork.knife")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("feeding.noEntries".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("feeding.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct FeedingRecordCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let record: FeedingRecord
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentGreen.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "fork.knife")
                        .font(.system(size: 20))
                        .foregroundColor(.accentGreen)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(record.foodName)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        Text(record.amount)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("•")
                            .foregroundColor(.textTertiary)
                        
                        Text(record.foodType)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Text(record.time, format: .dateTime.hour().minute())
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
                    .id(localizationManager.currentLanguage)
            }
        }
    }
}

// MARK: - Add Feeding View
struct AddFeedingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var foodName = ""
    @State private var amount = ""
    @State private var time = Date()
    @State private var foodType = "feeding.foodType.dry"
    @State private var notes = ""
    
    var foodTypes: [String] {
        ["feeding.foodType.dry", "feeding.foodType.wet", "feeding.foodType.snack"]
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
                                Text("feeding.foodName".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("feeding.foodNamePlaceholder".localized, text: $foodName)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("feeding.amount".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("feeding.amountPlaceholder".localized, text: $amount)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("feeding.foodType".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("feeding.foodType".localized, selection: $foodType) {
                                    ForEach(foodTypes, id: \.self) { type in
                                        Text(type.localized).tag(type)
                                            .id(localizationManager.currentLanguage)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("feeding.time".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
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
                        PrimaryButton("feeding.add".localized, icon: "checkmark") {
                            if !foodName.isEmpty && !amount.isEmpty {
                                let record = FeedingRecord(
                                    petId: pet.id,
                                    foodName: foodName,
                                    amount: amount,
                                    time: time,
                                    foodType: foodType.localized,
                                    notes: notes
                                )
                                healthRecordManager.addFeedingRecord(record)
                                
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
            .navigationTitle("feeding.addTitle".localized)
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

// MARK: - Edit Feeding View
struct EditFeedingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let record: FeedingRecord
    
    @State private var foodName: String
    @State private var amount: String
    @State private var time: Date
    @State private var foodType: String
    @State private var notes: String
    
    var foodTypes: [String] {
        ["feeding.foodType.dry", "feeding.foodType.wet", "feeding.foodType.snack"]
    }
    
    static func getFoodTypeKey(from storedType: String) -> String {
        let typeMap: [String: String] = [
            "Trocken": "feeding.foodType.dry",
            "Dry": "feeding.foodType.dry",
            "Nass": "feeding.foodType.wet",
            "Wet": "feeding.foodType.wet",
            "Snack": "feeding.foodType.snack"
        ]
        return typeMap[storedType] ?? "feeding.foodType.dry"
    }
    
    init(healthRecordManager: HealthRecordManager, record: FeedingRecord) {
        self.healthRecordManager = healthRecordManager
        self.record = record
        _foodName = State(initialValue: record.foodName)
        _amount = State(initialValue: record.amount)
        _time = State(initialValue: record.time)
        let typeKey = Self.getFoodTypeKey(from: record.foodType)
        _foodType = State(initialValue: typeKey)
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
                                Text("feeding.foodName".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("feeding.foodNamePlaceholder".localized, text: $foodName)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("feeding.amount".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("feeding.amountPlaceholder".localized, text: $amount)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("feeding.foodType".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("feeding.foodType".localized, selection: $foodType) {
                                    ForEach(foodTypes, id: \.self) { type in
                                        Text(type.localized).tag(type)
                                            .id(localizationManager.currentLanguage)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("feeding.time".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
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
                            if !foodName.isEmpty && !amount.isEmpty {
                                var updated = record
                                updated.foodName = foodName
                                updated.amount = amount
                                updated.time = time
                                updated.foodType = foodType.localized
                                updated.notes = notes
                                healthRecordManager.updateFeedingRecord(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("feeding.editFeeding".localized)
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
