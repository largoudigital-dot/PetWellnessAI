//
//  ChartsView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet?
    
    @State private var selectedChart: ChartType = .weight
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Chart Type Picker
                        chartTypePicker
                        
                        // Selected Chart
                        selectedChartView
                    }
                    .padding()
                }
            }
            .navigationTitle("charts.title".localized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var chartTypePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Button(action: { selectedChart = type }) {
                        Text(type.localized)
                            .id(localizationManager.currentLanguage)
                            .font(.body)
                            .foregroundColor(selectedChart == type ? .white : .textPrimary)
                            .padding(.horizontal, Spacing.md)
                            .padding(.vertical, Spacing.sm)
                            .background(selectedChart == type ? Color.brandPrimary : Color.backgroundSecondary)
                            .cornerRadius(CornerRadius.medium)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var selectedChartView: some View {
        switch selectedChart {
        case .weight:
            weightChartView
        case .expenses:
            expensesChartView
        case .activity:
            activityChartView
        }
    }
    
    private var weightChartView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("charts.weight.title".localized)
                .id(localizationManager.currentLanguage)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if let weightData = getWeightData(), !weightData.isEmpty {
                Chart(weightData) { data in
                    LineMark(
                        x: .value("charts.date".localized, data.date, unit: .day),
                        y: .value("charts.weight".localized, data.weight)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("charts.date".localized, data.date, unit: .day),
                        y: .value("charts.weight".localized, data.weight)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .blue.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 250)
                .padding()
                .background(Color.backgroundSecondary)
                .cornerRadius(CornerRadius.large)
            } else {
                Text("charts.noData".localized)
                    .id(localizationManager.currentLanguage)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
    
    private var expensesChartView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("charts.expenses.title".localized)
                .id(localizationManager.currentLanguage)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if let expenseData = getExpenseData(), !expenseData.isEmpty {
                #if canImport(Charts)
                Chart(expenseData) { data in
                    BarMark(
                        x: .value("charts.category".localized, data.category),
                        y: .value("charts.amount".localized, data.amount)
                    )
                    .foregroundStyle(.green)
                }
                .frame(height: 250)
                .padding()
                .background(Color.backgroundSecondary)
                .cornerRadius(CornerRadius.large)
                #else
                SimpleExpenseChart(data: expenseData)
                #endif
            } else {
                Text("charts.noData".localized)
                    .id(localizationManager.currentLanguage)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
    
    private var activityChartView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("charts.activity.title".localized)
                .id(localizationManager.currentLanguage)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if let activityData = getActivityData(), !activityData.isEmpty {
                #if canImport(Charts)
                Chart(activityData) { data in
                    BarMark(
                        x: .value("charts.date".localized, data.date, unit: .day),
                        y: .value("charts.duration".localized, data.duration)
                    )
                    .foregroundStyle(.purple)
                }
                .frame(height: 250)
                .padding()
                .background(Color.backgroundSecondary)
                .cornerRadius(CornerRadius.large)
                #else
                SimpleActivityChart(data: activityData)
                #endif
            } else {
                Text("charts.noData".localized)
                    .id(localizationManager.currentLanguage)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
    
    private func getWeightData() -> [WeightChartData]? {
        let records = pet != nil ?
            healthRecordManager.weightRecords.filter { $0.petId == pet!.id } :
            healthRecordManager.weightRecords
        
        return records.sorted { $0.date < $1.date }.map {
            WeightChartData(date: $0.date, weight: $0.weight)
        }
    }
    
    private func getExpenseData() -> [ExpenseChartData]? {
        let expenses = pet != nil ?
            healthRecordManager.expenses.filter { $0.petId == pet!.id } :
            healthRecordManager.expenses
        
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        return grouped.map { category, expenses in
            ExpenseChartData(category: category, amount: expenses.reduce(0) { $0 + $1.amount })
        }
    }
    
    private func getActivityData() -> [ActivityChartData]? {
        let activities = pet != nil ?
            healthRecordManager.activities.filter { $0.petId == pet!.id } :
            healthRecordManager.activities
        
        return activities.sorted { $0.date < $1.date }.map {
            ActivityChartData(date: $0.date, duration: $0.duration)
        }
    }
}

enum ChartType: String, CaseIterable {
    case weight
    case expenses
    case activity
    
    var localized: String {
        switch self {
        case .weight:
            return "charts.type.weight".localized
        case .expenses:
            return "charts.type.expenses".localized
        case .activity:
            return "charts.type.activity".localized
        }
    }
}

struct WeightChartData: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
}

struct ExpenseChartData: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
}

struct ActivityChartData: Identifiable {
    let id = UUID()
    let date: Date
    let duration: Int
}

// Fallback charts if Charts framework is not available
struct SimpleWeightChart: View {
    let data: [WeightChartData]
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            ForEach(data.suffix(10)) { item in
                HStack {
                    Text(item.date, format: .dateTime.day().month())
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * CGFloat(item.weight / maxWeight), height: 20)
                        }
                    }
                    .frame(height: 20)
                    
                    Text("\(item.weight, specifier: "%.1f") kg")
                        .font(.caption)
                        .foregroundColor(.textPrimary)
                        .frame(width: 60, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
    
    private var maxWeight: Double {
        data.map { $0.weight }.max() ?? 1.0
    }
}

struct SimpleExpenseChart: View {
    let data: [ExpenseChartData]
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            ForEach(data) { item in
                HStack {
                    Text(item.category)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .frame(width: 100, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.green.opacity(0.2))
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: geometry.size.width * CGFloat(item.amount / maxAmount), height: 20)
                        }
                    }
                    .frame(height: 20)
                    
                    Text("\(item.amount, specifier: "%.2f") \(LocalizedStrings.currencySymbol())")
                        .font(.caption)
                        .foregroundColor(.textPrimary)
                        .frame(width: 80, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
    
    private var maxAmount: Double {
        data.map { $0.amount }.max() ?? 1.0
    }
}

struct SimpleActivityChart: View {
    let data: [ActivityChartData]
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            ForEach(data.suffix(10)) { item in
                HStack {
                    Text(item.date, format: .dateTime.day().month())
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.purple.opacity(0.2))
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.purple)
                                .frame(width: geometry.size.width * CGFloat(Double(item.duration) / maxDuration), height: 20)
                        }
                    }
                    .frame(height: 20)
                    
                    Text("\(item.duration) min")
                        .font(.caption)
                        .foregroundColor(.textPrimary)
                        .frame(width: 60, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
    
    private var maxDuration: Double {
        Double(data.map { $0.duration }.max() ?? 1)
    }
}

