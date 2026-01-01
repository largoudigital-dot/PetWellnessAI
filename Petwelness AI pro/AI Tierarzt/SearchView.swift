//
//  SearchView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var petManager: PetManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    
    @State private var searchText = ""
    @State private var debouncedSearchText = ""
    @State private var selectedCategory: SearchCategory = .all
    @State private var selectedPet: Pet?
    @State private var dateFilter: DateFilter = .all
    
    private let debouncer = Debouncer(delay: 0.3)
    
    var filteredResults: [SearchResult] {
        var results: [SearchResult] = []
        
        // Performance: Verwende debounced Text für Suche
        if debouncedSearchText.isEmpty {
            return []
        }
        
        let searchLower = debouncedSearchText.lowercased()
        
        // Search pets
        if selectedCategory == .all || selectedCategory == .pets {
            for pet in petManager.pets {
                if pet.name.lowercased().contains(searchLower) ||
                   pet.breed.lowercased().contains(searchLower) ||
                   pet.type.lowercased().contains(searchLower) {
                    if selectedPet == nil || selectedPet?.id == pet.id {
                        results.append(.pet(pet))
                    }
                }
            }
        }
        
        // Search medications
        if selectedCategory == .all || selectedCategory == .medications {
            for medication in healthRecordManager.medications {
                if medication.name.lowercased().contains(searchLower) ||
                   medication.notes.lowercased().contains(searchLower) {
                    if let pet = petManager.pets.first(where: { $0.id == medication.petId }) {
                        if selectedPet == nil || selectedPet?.id == pet.id {
                            if matchesDateFilter(medication.startDate) {
                                results.append(.medication(medication, pet))
                            }
                        }
                    }
                }
            }
        }
        
        // Search vaccinations
        if selectedCategory == .all || selectedCategory == .vaccinations {
            for vaccination in healthRecordManager.vaccinations {
                if vaccination.name.lowercased().contains(searchLower) ||
                   vaccination.notes.lowercased().contains(searchLower) {
                    if let pet = petManager.pets.first(where: { $0.id == vaccination.petId }) {
                        if selectedPet == nil || selectedPet?.id == pet.id {
                            if matchesDateFilter(vaccination.date) {
                                results.append(.vaccination(vaccination, pet))
                            }
                        }
                    }
                }
            }
        }
        
        // Search appointments
        if selectedCategory == .all || selectedCategory == .appointments {
            for appointment in healthRecordManager.appointments {
                if appointment.title.lowercased().contains(searchLower) ||
                   appointment.notes.lowercased().contains(searchLower) {
                    if let pet = petManager.pets.first(where: { $0.id == appointment.petId }) {
                        if selectedPet == nil || selectedPet?.id == pet.id {
                            if matchesDateFilter(appointment.date) {
                                results.append(.appointment(appointment, pet))
                            }
                        }
                    }
                }
            }
        }
        
        // Search symptoms
        if selectedCategory == .all || selectedCategory == .symptoms {
            for symptom in healthRecordManager.symptoms {
                if symptom.symptom.lowercased().contains(searchLower) ||
                   symptom.notes.lowercased().contains(searchLower) {
                    if let pet = petManager.pets.first(where: { $0.id == symptom.petId }) {
                        if selectedPet == nil || selectedPet?.id == pet.id {
                            if matchesDateFilter(symptom.date) {
                                results.append(.symptom(symptom, pet))
                            }
                        }
                    }
                }
            }
        }
        
        return results
    }
    
    private func matchesDateFilter(_ date: Date) -> Bool {
        switch dateFilter {
        case .all:
            return true
        case .today:
            return Calendar.current.isDateInToday(date)
        case .thisWeek:
            return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
        case .thisMonth:
            return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
        case .thisYear:
            return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    searchBarView
                    
                    // Filters
                    filtersView
                    
                    // Results
                    resultsView
                }
            }
            .navigationTitle("search.title".localized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
            
            TextField("search.placeholder".localized, text: $searchText)
                .id(localizationManager.currentLanguage)
                .onChange(of: searchText) { oldValue, newValue in
                    // Debounce: Warte 300ms bevor Suche ausgeführt wird
                    debouncer.debounce {
                        debouncedSearchText = newValue
                    }
                }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.medium)
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var filtersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                // Category Filter
                Picker("", selection: $selectedCategory) {
                    ForEach(SearchCategory.allCases, id: \.self) { category in
                        Text(category.localized)
                            .id(localizationManager.currentLanguage)
                            .tag(category)
                    }
                }
                .pickerStyle(.menu)
                
                // Pet Filter
                if !petManager.pets.isEmpty {
                    Picker("", selection: $selectedPet) {
                        Text("search.allPets".localized)
                            .id(localizationManager.currentLanguage)
                            .tag(nil as Pet?)
                        ForEach(petManager.pets) { pet in
                            Text(pet.name)
                                .tag(pet as Pet?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Date Filter
                Picker("", selection: $dateFilter) {
                    ForEach(DateFilter.allCases, id: \.self) { filter in
                        Text(filter.localized)
                            .id(localizationManager.currentLanguage)
                            .tag(filter)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.horizontal)
            .padding(.vertical, Spacing.sm)
        }
    }
    
    private var resultsView: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.sm) {
                if filteredResults.isEmpty && !debouncedSearchText.isEmpty {
                    Text("search.noResults".localized)
                        .id(localizationManager.currentLanguage)
                        .foregroundColor(.textSecondary)
                        .padding()
                } else if debouncedSearchText.isEmpty {
                    Text("search.startTyping".localized)
                        .id(localizationManager.currentLanguage)
                        .foregroundColor(.textSecondary)
                        .padding()
                } else {
                    ForEach(filteredResults, id: \.id) { result in
                        SearchResultCard(result: result)
                    }
                }
            }
            .padding()
        }
    }
}

enum SearchCategory: String, CaseIterable {
    case all
    case pets
    case medications
    case vaccinations
    case appointments
    case symptoms
    
    var localized: String {
        switch self {
        case .all:
            return "search.category.all".localized
        case .pets:
            return "search.category.pets".localized
        case .medications:
            return "search.category.medications".localized
        case .vaccinations:
            return "search.category.vaccinations".localized
        case .appointments:
            return "search.category.appointments".localized
        case .symptoms:
            return "search.category.symptoms".localized
        }
    }
}

enum DateFilter: String, CaseIterable {
    case all
    case today
    case thisWeek
    case thisMonth
    case thisYear
    
    var localized: String {
        switch self {
        case .all:
            return "search.dateFilter.all".localized
        case .today:
            return "search.dateFilter.today".localized
        case .thisWeek:
            return "search.dateFilter.thisWeek".localized
        case .thisMonth:
            return "search.dateFilter.thisMonth".localized
        case .thisYear:
            return "search.dateFilter.thisYear".localized
        }
    }
}

enum SearchResult: Identifiable {
    case pet(Pet)
    case medication(Medication, Pet)
    case vaccination(Vaccination, Pet)
    case appointment(Appointment, Pet)
    case symptom(Symptom, Pet)
    
    var id: UUID {
        switch self {
        case .pet(let pet):
            return pet.id
        case .medication(let medication, _):
            return medication.id
        case .vaccination(let vaccination, _):
            return vaccination.id
        case .appointment(let appointment, _):
            return appointment.id
        case .symptom(let symptom, _):
            return symptom.id
        }
    }
}

struct SearchResultCard: View {
    let result: SearchResult
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .id(localizationManager.currentLanguage)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.medium)
    }
    
    private var iconName: String {
        switch result {
        case .pet:
            return "pawprint.fill"
        case .medication:
            return "pills.fill"
        case .vaccination:
            return "syringe.fill"
        case .appointment:
            return "calendar"
        case .symptom:
            return "stethoscope"
        }
    }
    
    private var iconColor: Color {
        switch result {
        case .pet:
            return .brandPrimary
        case .medication:
            return .accentBlue
        case .vaccination:
            return .accentGreen
        case .appointment:
            return .accentPurple
        case .symptom:
            return .accentRed
        }
    }
    
    private var title: String {
        switch result {
        case .pet(let pet):
            return pet.name
        case .medication(let medication, _):
            return medication.name
        case .vaccination(let vaccination, _):
            return vaccination.name
        case .appointment(let appointment, _):
            return appointment.title
        case .symptom(let symptom, _):
            return symptom.symptom
        }
    }
    
    private var subtitle: String {
        switch result {
        case .pet(let pet):
            return "\(pet.type) • \(pet.breed)"
        case .medication(_, let pet):
            return "search.medicationFor".localized + " \(pet.name)"
        case .vaccination(_, let pet):
            return "search.vaccinationFor".localized + " \(pet.name)"
        case .appointment(_, let pet):
            return "search.appointmentFor".localized + " \(pet.name)"
        case .symptom(_, let pet):
            return "search.symptomFor".localized + " \(pet.name)"
        }
    }
}




