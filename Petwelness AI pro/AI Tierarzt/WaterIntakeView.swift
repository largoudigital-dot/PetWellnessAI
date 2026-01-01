//
//  WaterIntakeView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct WaterIntakeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddWaterIntake = false
    @State private var selectedIntake: WaterIntake? = nil
    @State private var showEditWaterIntake = false
    
    var waterIntakes: [WaterIntake] {
        healthRecordManager.getWaterIntakes(for: pet.id)
    }
    
    var todayWater: Double {
        healthRecordManager.getTodayWaterIntake(for: pet.id)
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
                        Text("water.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Button(action: { showAddWaterIntake = true }) {
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
                            if todayWater > 0 {
                                summaryCard.padding(.top, Spacing.lg)
                            }
                            
                            if waterIntakes.isEmpty {
                                emptyStateView.padding(.top, Spacing.xxxl)
                            } else {
                                waterIntakesListView.padding(.top, Spacing.lg)
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddWaterIntake) {
                AddWaterIntakeView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditWaterIntake) {
                if let intake = selectedIntake {
                    EditWaterIntakeView(healthRecordManager: healthRecordManager, intake: intake)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentBlue)
                Text("water.todayDrunk".localized)
                    .id(localizationManager.currentLanguage)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text(String(format: "%.0f ml", todayWater))
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
    
    private var waterIntakesListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(waterIntakes) { intake in
                WaterIntakeCard(
                    intake: intake,
                    onTap: {
                        selectedIntake = intake
                        showEditWaterIntake = true
                    },
                    onDelete: {
                        healthRecordManager.deleteWaterIntake(intake)
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "drop.fill")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            Text("water.noEntries".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            Text("water.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct WaterIntakeCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let intake: WaterIntake
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.accentBlue.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Image(systemName: "drop.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentBlue)
                }
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(String(format: "%.0f ml", intake.amount))
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    Text(intake.date, format: .dateTime.day().month().year().hour().minute())
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    if !intake.notes.isEmpty {
                        Text(intake.notes)
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

struct AddWaterIntakeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var amount: String = ""
    @State private var date = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        VStack(spacing: Spacing.lg) {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("water.amountMl".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                TextField("water.amountPlaceholder".localized, text: $amount)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("water.dateTime".localized)
                                    .id(localizationManager.currentLanguage)
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
                        
                        PrimaryButton("water.addWaterIntake".localized, icon: "checkmark") {
                            if let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) {
                                let intake = WaterIntake(
                                    petId: pet.id,
                                    amount: amountValue,
                                    date: date,
                                    notes: notes
                                )
                                healthRecordManager.addWaterIntake(intake)
                                
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
            .navigationTitle("waterIntake.addTitle".localized)
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

struct EditWaterIntakeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let intake: WaterIntake
    
    @State private var amount: String
    @State private var date: Date
    @State private var notes: String
    
    init(healthRecordManager: HealthRecordManager, intake: WaterIntake) {
        self.healthRecordManager = healthRecordManager
        self.intake = intake
        _amount = State(initialValue: String(format: "%.0f", intake.amount))
        _date = State(initialValue: intake.date)
        _notes = State(initialValue: intake.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        VStack(spacing: Spacing.lg) {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("water.amountMl".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                TextField("water.amountPlaceholder".localized, text: $amount)
                                    .id(localizationManager.currentLanguage)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("water.dateTime".localized)
                                    .id(localizationManager.currentLanguage)
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
                        
                        PrimaryButton("common.saveChanges".localized, icon: "checkmark") {
                            if let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) {
                                var updated = intake
                                updated.amount = amountValue
                                updated.date = date
                                updated.notes = notes
                                healthRecordManager.updateWaterIntake(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("waterIntake.editTitle".localized)
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

