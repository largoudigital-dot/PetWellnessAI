//
//  DocumentsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct DocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddDocument = false
    @State private var selectedDocument: Document? = nil
    @State private var showEditDocument = false
    
    var documents: [Document] {
        healthRecordManager.getDocuments(for: pet.id)
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
                        
                        Text("petProfile.documents".localized)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddDocument = true }) {
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
                            if !documents.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Documents List
                            if documents.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                documentsListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddDocument) {
                AddDocumentView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditDocument) {
                if let document = selectedDocument {
                    EditDocumentView(healthRecordManager: healthRecordManager, document: document)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "doc.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.textSecondary)
                
                Text("documents.savedDocuments".localized)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(documents.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Color.textSecondary.opacity(0.1), Color.textSecondary.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(CornerRadius.large)
    }
    
    private var documentsListView: some View {
        VStack(spacing: Spacing.md) {
            ForEach(documents) { document in
                DocumentCard(
                    document: document,
                    onTap: {
                        selectedDocument = document
                        showEditDocument = true
                    },
                    onDelete: {
                        healthRecordManager.deleteDocument(document)
                    }
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "doc.fill")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("petProfile.noDocuments".localized)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("documents.emptyDescription".localized)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct DocumentCard: View {
    let document: Document
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var categoryColor: Color {
        // Check both localized and stored values
        let cat = document.category.lowercased()
        if cat.contains("lab") || cat == "labor" {
            return .accentBlue
        } else if cat.contains("xray") || cat.contains("röntgen") || cat.contains("x-ray") {
            return .accentPurple
        } else if cat.contains("prescription") || cat.contains("rezept") {
            return .accentOrange
        } else {
            return .textSecondary
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "doc.fill")
                        .font(.system(size: 20))
                        .foregroundColor(categoryColor)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(document.title)
                        .font(.bodyTextBold)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        Text(document.category)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Text("•")
                            .foregroundColor(.textTertiary)
                        
                        Text(document.date, format: .dateTime.day().month().year())
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    if !document.notes.isEmpty {
                        Text(document.notes)
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
            }
        }
    }
}

// MARK: - Add Document View
struct AddDocumentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var title = ""
    @State private var category = "documents.category.other"
    @State private var date = Date()
    @State private var notes = ""
    @State private var selectedDocumentData: Data? = nil
    @State private var showDocumentPicker = false
    
    var categories: [String] {
        ["documents.category.lab", "documents.category.xray", "documents.category.prescription", "documents.category.other"]
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
                                Text("common.title".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("documents.titlePlaceholder".localized, text: $title)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.category".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("common.category".localized, selection: $category) {
                                    ForEach(categories, id: \.self) { cat in
                                        Text(cat.localized)
                                            .id(localizationManager.currentLanguage)
                                            .tag(cat)
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
                        PrimaryButton("documents.add".localized, icon: "checkmark") {
                            if !title.isEmpty {
                                let document = Document(
                                    petId: pet.id,
                                    title: title,
                                    category: category.localized,
                                    date: date,
                                    notes: notes,
                                    documentData: selectedDocumentData
                                )
                                healthRecordManager.addDocument(document)
                                
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
            .navigationTitle("documents.add".localized)
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

// MARK: - Edit Document View
struct EditDocumentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let document: Document
    
    @State private var title: String
    @State private var category: String
    @State private var date: Date
    @State private var notes: String
    
    var categories: [String] {
        ["documents.category.lab", "documents.category.xray", "documents.category.prescription", "documents.category.other"]
    }
    
    static func getCategoryKey(from storedCategory: String) -> String {
        let categoryMap: [String: String] = [
            "Labor": "documents.category.lab",
            "Lab": "documents.category.lab",
            "Röntgen": "documents.category.xray",
            "X-Ray": "documents.category.xray",
            "Rezept": "documents.category.prescription",
            "Prescription": "documents.category.prescription",
            "Sonstiges": "documents.category.other",
            "Other": "documents.category.other"
        ]
        return categoryMap[storedCategory] ?? "documents.category.other"
    }
    
    init(healthRecordManager: HealthRecordManager, document: Document) {
        self.healthRecordManager = healthRecordManager
        self.document = document
        _title = State(initialValue: document.title)
        let categoryKey = Self.getCategoryKey(from: document.category)
        _category = State(initialValue: categoryKey)
        _date = State(initialValue: document.date)
        _notes = State(initialValue: document.notes)
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
                                
                                TextField("documents.titlePlaceholder".localized, text: $title)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("common.category".localized)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("common.category".localized, selection: $category) {
                                    ForEach(categories, id: \.self) { cat in
                                        Text(cat.localized).tag(cat)
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
                            if !title.isEmpty {
                                var updated = document
                                updated.title = title
                                updated.category = category.localized
                                updated.date = date
                                updated.notes = notes
                                healthRecordManager.updateDocument(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("documents.edit".localized)
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


