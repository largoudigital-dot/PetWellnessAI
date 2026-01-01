//
//  JournalView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddEntry = false
    @State private var selectedEntry: JournalEntry? = nil
    @State private var showEditEntry = false
    
    var journalEntries: [JournalEntry] {
        healthRecordManager.getJournalEntries(for: pet.id)
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
                        
                        Text("petProfile.journal".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddEntry = true }) {
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
                            if !journalEntries.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Journal Entries List
                            if journalEntries.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                journalEntriesListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddEntry) {
                AddJournalEntryView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditEntry) {
                if let entry = selectedEntry {
                    EditJournalEntryView(healthRecordManager: healthRecordManager, entry: entry)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "book.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentBlue)
                
                Text("common.journalEntries".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(journalEntries.count)")
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
    
    private var journalEntriesListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(journalEntries) { entry in
                JournalEntryCard(
                    entry: entry,
                    onTap: {
                        selectedEntry = entry
                        showEditEntry = true
                    },
                    onDelete: {
                        healthRecordManager.deleteJournalEntry(entry)
                    }
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "book.fill")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("journal.noEntries".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("journal.emptyDescription".localized)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
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
                    
                    Text(entry.mood)
                        .font(.system(size: 24))
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(entry.title)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    Text(entry.content)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                    
                    Text(entry.date, format: .dateTime.day().month().year())
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

// MARK: - Add Journal Entry View
struct AddJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var title = ""
    @State private var content = ""
    @State private var date = Date()
    @State private var mood = "😊"
    
    let moods = ["😊", "😐", "😢", "😷", "🎉"]
    
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
                                Text("common.title".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("journal.titlePlaceholder".localized, text: $title)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("journal.content".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextEditor(text: $content)
                                    .frame(minHeight: 150)
                                    .padding(Spacing.sm)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.date".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("journal.mood".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: Spacing.md) {
                                    ForEach(moods, id: \.self) { m in
                                        Button(action: { mood = m }) {
                                            Text(m)
                                                .font(.system(size: 30))
                                                .frame(width: 50, height: 50)
                                                .background(mood == m ? Color.brandPrimary.opacity(0.2) : Color.backgroundTertiary)
                                                .cornerRadius(CornerRadius.medium)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("journal.addEntryButton".localized, icon: "checkmark") {
                            if !title.isEmpty && !content.isEmpty {
                                let entry = JournalEntry(
                                    petId: pet.id,
                                    title: title,
                                    content: content,
                                    date: date,
                                    mood: mood
                                )
                                healthRecordManager.addJournalEntry(entry)
                                
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
            .navigationTitle("journal.addEntry".localized)
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

// MARK: - Edit Journal Entry View
struct EditJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let entry: JournalEntry
    
    @State private var title: String
    @State private var content: String
    @State private var date: Date
    @State private var mood: String
    
    let moods = ["😊", "😐", "😢", "😷", "🎉"]
    
    init(healthRecordManager: HealthRecordManager, entry: JournalEntry) {
        self.healthRecordManager = healthRecordManager
        self.entry = entry
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
        _date = State(initialValue: entry.date)
        _mood = State(initialValue: entry.mood)
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
                                Text("common.title".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("journal.titlePlaceholder".localized, text: $title)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("journal.content".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextEditor(text: $content)
                                    .frame(minHeight: 150)
                                    .padding(Spacing.sm)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.date".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .padding(Spacing.md)
                                    .background(Color.backgroundTertiary)
                                    .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("journal.mood".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: Spacing.md) {
                                    ForEach(moods, id: \.self) { m in
                                        Button(action: { mood = m }) {
                                            Text(m)
                                                .font(.system(size: 30))
                                                .frame(width: 50, height: 50)
                                                .background(mood == m ? Color.brandPrimary.opacity(0.2) : Color.backgroundTertiary)
                                                .cornerRadius(CornerRadius.medium)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark") {
                            if !title.isEmpty && !content.isEmpty {
                                var updated = entry
                                updated.title = title
                                updated.content = content
                                updated.date = date
                                updated.mood = mood
                                healthRecordManager.updateJournalEntry(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("journal.editEntry".localized)
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

