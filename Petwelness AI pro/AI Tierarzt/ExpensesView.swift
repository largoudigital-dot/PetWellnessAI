//
//  ExpensesView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct ExpensesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var showAddExpense = false
    @State private var selectedExpense: Expense? = nil
    @State private var showEditExpense = false
    
    var expenses: [Expense] {
        healthRecordManager.getExpenses(for: pet.id).sorted { $0.date > $1.date }
    }
    
    var totalExpenses: Double {
        healthRecordManager.getTotalExpenses(for: pet.id)
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
                        
                        Text("expenses.title".localized)
                            .id(localizationManager.currentLanguage)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: { showAddExpense = true }) {
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
                            if !expenses.isEmpty {
                                summaryCard
                                    .padding(.top, Spacing.lg)
                            }
                            
                            // Expenses List
                            if expenses.isEmpty {
                                emptyStateView
                                    .padding(.top, Spacing.xxxl)
                            } else {
                                expensesListView
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(healthRecordManager: healthRecordManager, pet: pet)
                    .environmentObject(localizationManager)
            }
            .sheet(isPresented: $showEditExpense) {
                if let expense = selectedExpense {
                    EditExpenseView(healthRecordManager: healthRecordManager, expense: expense)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "eurosign.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentGreen)
                
                Text("expenses.totalExpenses".localized)
                    .id(localizationManager.currentLanguage)
                    .font(.bodyTextBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text(String(format: "%.2f %@", totalExpenses, LocalizedStrings.currencySymbol()))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.accentGreen)
            }
            
            Text("\(expenses.count) \(expenses.count == 1 ? "expenses.singular".localized : "expenses.plural".localized)")
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textSecondary)
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
    
    private var expensesListView: some View {
        // Performance: Verwende LazyVStack für bessere Performance bei vielen Ausgaben
        LazyVStack(spacing: Spacing.md) {
            ForEach(expenses) { expense in
                ExpenseCard(
                    expense: expense,
                    onTap: {
                        selectedExpense = expense
                        showEditExpense = true
                    },
                    onDelete: {
                        healthRecordManager.deleteExpense(expense)
                    }
                )
                .environmentObject(localizationManager)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "eurosign.circle")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("expenses.noEntries".localized)
                .id(localizationManager.currentLanguage)
                .font(.bodyTextBold)
                .foregroundColor(.textSecondary)
            
            Text("expenses.emptyDescription".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xxl)
        }
    }
}

struct ExpenseCard: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let expense: Expense
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
                    
                    Image(systemName: "eurosign.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentGreen)
                }
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text(expense.category)
                            .font(.bodyTextBold)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f %@", expense.amount, LocalizedStrings.currencySymbol()))
                            .font(.bodyTextBold)
                            .foregroundColor(.accentGreen)
                    }
                    
                    Text(expense.date, format: .dateTime.day().month().year())
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    if !expense.description.isEmpty {
                        Text(expense.description)
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

// MARK: - Add Expense View
struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet
    
    @State private var category = "expenses.category.medications"
    @State private var amount: String = ""
    @State private var date = Date()
    @State private var description = ""
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isAddExpenseFormValid: Bool {
        !amount.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(amount.replacingOccurrences(of: ",", with: ".")) != nil &&
        Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0 > 0
    }
    
    var categories: [String] {
        ["expenses.category.medications", "expenses.category.vaccination", "expenses.category.consultation", "expenses.category.surgery", "expenses.category.feeding", "expenses.category.grooming", "expenses.category.other"]
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
                                Text("expenses.category".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("expenses.category".localized, selection: $category) {
                                    ForEach(categories, id: \.self) { cat in
                                        Text(cat.localized).tag(cat)
                                            .id(localizationManager.currentLanguage)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("expenses.amount".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("0.00", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(AppTextFieldStyle())
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
                                Text("expenses.description".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("expenses.descriptionPlaceholder".localized, text: $description)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("expenses.add".localized, icon: "checkmark", isDisabled: !isAddExpenseFormValid) {
                            // Validierung
                            guard let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) else {
                                ErrorHandler.shared.handle(.validationFailed("Ungültiger Betrag. Bitte geben Sie eine gültige Zahl ein."))
                                return
                            }
                            
                            let amountValidation = InputValidator.shared.validateNumber(amountValue, fieldName: "Betrag", min: 0)
                            if !amountValidation.isValid {
                                ErrorHandler.shared.handle(.validationFailed(amountValidation.errorMessage ?? "Ungültiger Betrag"))
                                return
                            }
                            
                            let expense = Expense(
                                petId: pet.id,
                                category: category.localized,
                                amount: amountValue,
                                date: date,
                                description: description.trimmingCharacters(in: .whitespaces)
                            )
                            healthRecordManager.addExpense(expense)
                            
                            // Zeige Interstitial Ad nach Aktion
                            AdManager.shared.showInterstitialAfterAction()
                            
                            dismiss()
                        }
                        .disabled(amount.isEmpty || Double(amount.replacingOccurrences(of: ",", with: ".")) == nil)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("expenses.addTitle".localized)
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

// MARK: - Edit Expense View
struct EditExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let expense: Expense
    
    @State private var category: String
    @State private var amount: String
    @State private var date: Date
    @State private var description: String
    
    // Validierung: Prüft ob alle Pflichtfelder ausgefüllt sind
    private var isEditExpenseFormValid: Bool {
        !amount.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(amount.replacingOccurrences(of: ",", with: ".")) != nil &&
        Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0 > 0
    }
    
    var categories: [String] {
        ["expenses.category.medications", "expenses.category.vaccination", "expenses.category.consultation", "expenses.category.surgery", "expenses.category.feeding", "expenses.category.grooming", "expenses.category.other"]
    }
    
    static func getCategoryKey(from storedCategory: String) -> String {
        let categoryMap: [String: String] = [
            "Medikamente": "expenses.category.medications",
            "Medications": "expenses.category.medications",
            "Impfung": "expenses.category.vaccination",
            "Vaccination": "expenses.category.vaccination",
            "Konsultation": "expenses.category.consultation",
            "Consultation": "expenses.category.consultation",
            "Operation": "expenses.category.surgery",
            "Surgery": "expenses.category.surgery",
            "Futter": "expenses.category.feeding",
            "Feeding": "expenses.category.feeding",
            "Pflege": "expenses.category.grooming",
            "Grooming": "expenses.category.grooming",
            "Sonstiges": "expenses.category.other",
            "Other": "expenses.category.other"
        ]
        return categoryMap[storedCategory] ?? "expenses.category.other"
    }
    
    init(healthRecordManager: HealthRecordManager, expense: Expense) {
        self.healthRecordManager = healthRecordManager
        self.expense = expense
        let categoryKey = Self.getCategoryKey(from: expense.category)
        _category = State(initialValue: categoryKey)
        _amount = State(initialValue: String(format: "%.2f", expense.amount))
        _date = State(initialValue: expense.date)
        _description = State(initialValue: expense.description)
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
                                Text("expenses.category".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                Picker("expenses.category".localized, selection: $category) {
                                    ForEach(categories, id: \.self) { cat in
                                        Text(cat.localized).tag(cat)
                                            .id(localizationManager.currentLanguage)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(Spacing.md)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(CornerRadius.medium)
                            }
                            
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                Text("expenses.amount".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("0.00", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(AppTextFieldStyle())
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
                                Text("expenses.description".localized)
                                    .id(localizationManager.currentLanguage)
                                    .font(.bodyTextBold)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("expenses.description".localized, text: $description)
                                    .id(localizationManager.currentLanguage)
                                    .textFieldStyle(AppTextFieldStyle())
                            }
                        }
                        .padding(Spacing.xl)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(CornerRadius.large)
                        .padding(.top, Spacing.lg)
                        
                        // Save Button
                        PrimaryButton("medications.saveChanges".localized, icon: "checkmark", isDisabled: !isEditExpenseFormValid) {
                            if let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) {
                                var updated = expense
                                updated.category = category.localized
                                updated.amount = amountValue
                                updated.date = date
                                updated.description = description
                                healthRecordManager.updateExpense(updated)
                                dismiss()
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.bottom, Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .navigationTitle("expenses.editExpense".localized)
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
