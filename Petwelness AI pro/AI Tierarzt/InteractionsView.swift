//
//  InteractionsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct InteractionsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddInteraction = false
    @State private var selectedInteraction: Interaction? = nil
    @State private var showEditInteraction = false
    
    var interactions: [Interaction] {
        healthRecordManager.getInteractions(for: pet.id)
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
                        Text("interactions.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Button(action: { showAddInteraction = true }) {
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
                            if interactions.isEmpty {
                                emptyStateView.padding(.top, Spacing.xxxl)
                            } else {
                                interactionsListView.padding(.top, Spacing.lg)
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddInteraction) {
                AddInteractionView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditInteraction) {
                if let interaction = selectedInteraction {
                    EditInteractionView(healthRecordManager: healthRecordManager, interaction: interaction)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var interactionsListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(interactions) { interaction in
                InteractionCard(
                    interaction: interaction,
                    onTap: {
                        selectedInteraction = interaction
                        showEditInteraction = true
                    },
                    onDelete: {
                        healthRecordManager.deleteInteraction(interaction)
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            Text("interactions.noEntries".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            Text("interactions.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct InteractionCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let interaction: Interaction
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var severityColor: Color {
        let severity = interaction.severity.lowercased()
        if severity.contains("severe") || severity.contains("schwer") || severity.contains("grave") {
            return .accentRed
        } else if severity.contains("medium") || severity.contains("mittel") || severity.contains("moyen") {
            return .accentOrange
        } else {
            return .accentGreen
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(severityColor.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(severityColor)
                }
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(interaction.substance)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    Text("\(interaction.type) • \(interaction.severity)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Text(interaction.dateDiscovered, format: .dateTime.day().month().year())
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

struct AddInteractionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var type = "interactions.type.allergy"
    @State private var substance = ""
    @State private var reaction = ""
    @State private var severity = "interactions.severity.light"
    @State private var dateDiscovered = Date()
    @State private var notes = ""
    
    var types: [String] {
        ["interactions.type.allergy", "interactions.type.intolerance", "interactions.type.interaction"]
    }
    var severities: [String] {
        ["interactions.severity.light", "interactions.severity.medium", "interactions.severity.severe"]
    }
    
    private var typeField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.type".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            Picker("interactions.type".localized, selection: $type) {
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
    }
    
    private var substanceField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.substance".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("interactions.substancePlaceholder".localized, text: $substance)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var reactionField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.reaction".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("interactions.reactionPlaceholder".localized, text: $reaction)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var severityField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.severity".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            Picker("interactions.severity".localized, selection: $severity) {
                ForEach(severities, id: \.self) { s in
                    Text(s.localized)
                        .id(localizationManager.currentLanguage)
                        .tag(s)
                }
            }
            .pickerStyle(.menu)
            .padding(Spacing.md)
            .background(Color.backgroundTertiary)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var dateDiscoveredField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.dateDiscovered".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            DatePicker("", selection: $dateDiscovered, displayedComponents: .date)
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
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Typ")
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                Picker("Typ", selection: $type) {
                                    ForEach(types, id: \.self) { t in
                                        Text(t).tag(t)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Substanz")
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                TextField("z.B. Pollen, Medikament", text: $substance)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Reaktion")
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                TextField("Beschreibung der Reaktion", text: $reaction)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Schweregrad")
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                Picker("Schweregrad", selection: $severity) {
                                    ForEach(severities, id: \.self) { s in
                                        Text(s).tag(s)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Entdeckt am")
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                DatePicker("", selection: $dateDiscovered, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("Notizen")
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
                        
                        PrimaryButton("interactions.add".localized, icon: "checkmark") {
                            if !substance.isEmpty && !reaction.isEmpty {
                                let interaction = Interaction(
                                    petId: pet.id,
                                    type: type.localized,
                                    substance: substance,
                                    reaction: reaction,
                                    severity: severity.localized,
                                    dateDiscovered: dateDiscovered,
                                    notes: notes
                                )
                                healthRecordManager.addInteraction(interaction)
                                
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
            .navigationTitle("interactions.addTitle".localized)
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

struct EditInteractionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let interaction: Interaction
    
    @State private var type: String
    @State private var substance: String
    @State private var reaction: String
    @State private var severity: String
    @State private var dateDiscovered: Date
    @State private var notes: String
    
    var types: [String] {
        ["interactions.type.allergy", "interactions.type.intolerance", "interactions.type.interaction"]
    }
    var severities: [String] {
        ["interactions.severity.light", "interactions.severity.medium", "interactions.severity.severe"]
    }
    
    static func getTypeKey(from storedType: String) -> String {
        let typeMap: [String: String] = [
            "Allergie": "interactions.type.allergy",
            "Allergy": "interactions.type.allergy",
            "Unverträglichkeit": "interactions.type.intolerance",
            "Intolerance": "interactions.type.intolerance",
            "Wechselwirkung": "interactions.type.interaction",
            "Interaction": "interactions.type.interaction"
        ]
        return typeMap[storedType] ?? "interactions.type.allergy"
    }
    
    static func getSeverityKey(from storedSeverity: String) -> String {
        let severityMap: [String: String] = [
            "Leicht": "interactions.severity.light",
            "Light": "interactions.severity.light",
            "Mittel": "interactions.severity.medium",
            "Medium": "interactions.severity.medium",
            "Schwer": "interactions.severity.severe",
            "Severe": "interactions.severity.severe"
        ]
        return severityMap[storedSeverity] ?? "interactions.severity.light"
    }
    
    init(healthRecordManager: HealthRecordManager, interaction: Interaction) {
        self.healthRecordManager = healthRecordManager
        self.interaction = interaction
        let typeKey = Self.getTypeKey(from: interaction.type)
        _type = State(initialValue: typeKey)
        _substance = State(initialValue: interaction.substance)
        _reaction = State(initialValue: interaction.reaction)
        let severityKey = Self.getSeverityKey(from: interaction.severity)
        _severity = State(initialValue: severityKey)
        _dateDiscovered = State(initialValue: interaction.dateDiscovered)
        _notes = State(initialValue: interaction.notes)
    }
    
    private var typeField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.type".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            Picker("interactions.type".localized, selection: $type) {
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
    }
    
    private var substanceField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.substance".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("interactions.substancePlaceholder".localized, text: $substance)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var reactionField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.reaction".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            TextField("interactions.reactionPlaceholder".localized, text: $reaction)
                .id(localizationManager.currentLanguage)
                .textFieldStyle(AppTextFieldStyle())
        }
    }
    
    private var severityField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.severity".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            Picker("interactions.severity".localized, selection: $severity) {
                ForEach(severities, id: \.self) { s in
                    Text(s.localized)
                        .id(localizationManager.currentLanguage)
                        .tag(s)
                }
            }
            .pickerStyle(.menu)
            .padding(Spacing.md)
            .background(Color.backgroundTertiary)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    private var dateDiscoveredField: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("interactions.dateDiscovered".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textPrimary)
            DatePicker("", selection: $dateDiscovered, displayedComponents: .date)
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
                            typeField
                            substanceField
                            reactionField
                            severityField
                            dateDiscoveredField
                            notesField
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark") {
                            if !substance.isEmpty && !reaction.isEmpty {
                                var updated = interaction
                                updated.type = type.localized
                                updated.substance = substance
                                updated.reaction = reaction
                                updated.severity = severity.localized
                                updated.dateDiscovered = dateDiscovered
                                updated.notes = notes
                                healthRecordManager.updateInteraction(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("interactions.editTitle".localized)
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

