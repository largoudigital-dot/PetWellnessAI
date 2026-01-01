//
//  BathroomView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct BathroomView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddBathroom = false
    @State private var selectedRecord: BathroomRecord? = nil
    @State private var showEditBathroom = false
    
    var bathroomRecords: [BathroomRecord] {
        healthRecordManager.getBathroomRecords(for: pet.id)
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
                        
                        Text("petProfile.bathroom".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddBathroom = true }) {
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
                            if !bathroomRecords.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Records List
                            if bathroomRecords.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                bathroomRecordsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddBathroom) {
                AddBathroomView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditBathroom) {
                if let record = selectedRecord {
                    EditBathroomView(healthRecordManager: healthRecordManager, record: record)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "toilet.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.brown)
                
                Text("common.entries".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(bathroomRecords.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.brown)
            }
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.brown.opacity(0.1), Color.brown.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var bathroomRecordsListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(bathroomRecords) { record in
                BathroomRecordCard(
                    record: record,
                    onTap: {
                        selectedRecord = record
                        showEditBathroom = true
                    },
                    onDelete: {
                        healthRecordManager.deleteBathroomRecord(record)
                    }
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "toilet.fill")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("bathroom.noEntries".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("bathroom.emptyDescription".localized)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct BathroomRecordCard: View {
    let record: BathroomRecord
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.brown.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "toilet.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.brown)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(record.type)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text("Konsistenz: \(record.consistency)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(record.date, format: .dateTime.day().month().year().hour().minute())
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

// MARK: - Add Bathroom View
struct AddBathroomView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var type = "bathroom.type.urine"
    @State private var consistency = "bathroom.consistency.normal"
    @State private var date = Date()
    @State private var notes = ""
    
    var types: [String] {
        ["bathroom.type.urine", "bathroom.type.stool"]
    }
    
    var consistencies: [String] {
        ["bathroom.consistency.normal", "bathroom.consistency.soft", "bathroom.consistency.firm", "bathroom.consistency.liquid"]
    }
    
    static func getStoredType(from key: String) -> String {
        let typeMap: [String: String] = [
            "bathroom.type.urine": "Urin",
            "bathroom.type.stool": "Kot",
            "Urin": "bathroom.type.urine",
            "Kot": "bathroom.type.stool"
        ]
        return typeMap[key] ?? key
    }
    
    static func getStoredConsistency(from key: String) -> String {
        let consistencyMap: [String: String] = [
            "bathroom.consistency.normal": "Normal",
            "bathroom.consistency.soft": "Weich",
            "bathroom.consistency.firm": "Fest",
            "bathroom.consistency.liquid": "Flüssig",
            "Normal": "bathroom.consistency.normal",
            "Weich": "bathroom.consistency.soft",
            "Fest": "bathroom.consistency.firm",
            "Flüssig": "bathroom.consistency.liquid"
        ]
        return consistencyMap[key] ?? key
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
                                Text("common.type".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("common.type".localized, selection: $type) {
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
                                Text("common.consistency".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("common.consistency".localized, selection: $consistency) {
                                    ForEach(consistencies, id: \.self) { c in
                                        Text(c.localized).tag(c)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("appointments.dateTime".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
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
                        PrimaryButton("bathroom.addEntry".localized, icon: "checkmark") {
                            let record = BathroomRecord(
                                petId: pet.id,
                                type: Self.getStoredType(from: type),
                                consistency: Self.getStoredConsistency(from: consistency),
                                date: date,
                                notes: notes
                            )
                            healthRecordManager.addBathroomRecord(record)
                            
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
            .navigationTitle("bathroom.addEntry".localized)
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

// MARK: - Edit Bathroom View
struct EditBathroomView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let record: BathroomRecord
    
    @State private var type: String
    @State private var consistency: String
    @State private var date: Date
    @State private var notes: String
    
    var types: [String] {
        ["bathroom.type.urine", "bathroom.type.stool"]
    }
    
    var consistencies: [String] {
        ["bathroom.consistency.normal", "bathroom.consistency.soft", "bathroom.consistency.firm", "bathroom.consistency.liquid"]
    }
    
    static func getTypeKey(from storedType: String) -> String {
        let typeMap: [String: String] = [
            "Urin": "bathroom.type.urine",
            "Kot": "bathroom.type.stool"
        ]
        return typeMap[storedType] ?? "bathroom.type.urine"
    }
    
    static func getConsistencyKey(from storedConsistency: String) -> String {
        let consistencyMap: [String: String] = [
            "Normal": "bathroom.consistency.normal",
            "Weich": "bathroom.consistency.soft",
            "Fest": "bathroom.consistency.firm",
            "Flüssig": "bathroom.consistency.liquid"
        ]
        return consistencyMap[storedConsistency] ?? "bathroom.consistency.normal"
    }
    
    static func getStoredType(from key: String) -> String {
        let typeMap: [String: String] = [
            "bathroom.type.urine": "Urin",
            "bathroom.type.stool": "Kot"
        ]
        return typeMap[key] ?? "Urin"
    }
    
    static func getStoredConsistency(from key: String) -> String {
        let consistencyMap: [String: String] = [
            "bathroom.consistency.normal": "Normal",
            "bathroom.consistency.soft": "Weich",
            "bathroom.consistency.firm": "Fest",
            "bathroom.consistency.liquid": "Flüssig"
        ]
        return consistencyMap[key] ?? "Normal"
    }
    
    init(healthRecordManager: HealthRecordManager, record: BathroomRecord) {
        self.healthRecordManager = healthRecordManager
        self.record = record
        _type = State(initialValue: Self.getTypeKey(from: record.type))
        _consistency = State(initialValue: Self.getConsistencyKey(from: record.consistency))
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
                        formView
                        saveButtonView
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("bathroom.editEntry".localized)
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
    
    private var formView: some View {
        VStack(spacing: Spacing.lg) {
            typePickerView
            consistencyPickerView
            dateTimePickerView
            notesEditorView
        }
        .padding(Spacing.xl)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
        .padding(.top, Spacing.lg)
    }
    
    private var typePickerView: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.type".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            
            Picker("common.type".localized, selection: $type) {
                ForEach(types, id: \.self) { t in
                    Text(t.localized).tag(t)
                }
            }
            .pickerStyle(.menu)
            .padding(Spacing.md)
            .background(Color.backgroundTertiary)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var consistencyPickerView: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("common.consistency".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            
            Picker("common.consistency".localized, selection: $consistency) {
                ForEach(consistencies, id: \.self) { c in
                    Text(c.localized).tag(c)
                }
            }
            .pickerStyle(.menu)
            .padding(Spacing.md)
            .background(Color.backgroundTertiary)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var dateTimePickerView: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("appointments.dateTime".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            
            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact)
                .padding(Spacing.md)
                .background(Color.backgroundTertiary)
                .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var notesEditorView: some View {
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
    
    private var saveButtonView: some View {
        PrimaryButton("medications.saveChanges".localized, icon: "checkmark") {
            var updated = record
            updated.type = Self.getStoredType(from: type)
            updated.consistency = Self.getStoredConsistency(from: consistency)
            updated.date = date
            updated.notes = notes
            healthRecordManager.updateBathroomRecord(updated)
            dismiss()
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.bottom, Spacing.xl)
    }
}

