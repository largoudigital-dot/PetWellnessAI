//
//  CalendarView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var healthRecordManager: HealthRecordManager
    let pet: Pet?
    
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: Spacing.lg) {
                    // Month Header
                    monthHeaderView
                    
                    // Calendar Grid
                    calendarGridView
                    
                    // Events for selected date
                    eventsForSelectedDateView
                    
                    Spacer()
                }
                .padding(.horizontal, Spacing.lg)
            }
            .safeAreaInset(edge: .bottom) {
                // Banner Ad am unteren Rand (über Safe Area)
                if AdManager.shared.shouldShowBannerAds {
                    BannerAdView()
                        .frame(height: 50)
                        .background(Color.backgroundPrimary)
                }
            }
            .navigationTitle("calendar.title".localized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var monthHeaderView: some View {
        HStack {
            Button(action: { changeMonth(-1) }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.brandPrimary)
            }
            
            Spacer()
            
            Text(monthYearString)
                .id(localizationManager.currentLanguage)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button(action: { changeMonth(1) }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.brandPrimary)
            }
        }
        .padding(.vertical, Spacing.md)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 0) {
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { day in
                    Text(day)
                        .id(localizationManager.currentLanguage)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, Spacing.sm)
            
            // Calendar days
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: Spacing.xs) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        isToday: Calendar.current.isDate(date, inSameDayAs: Date()),
                        hasEvents: hasEvents(on: date),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.large)
    }
    
    private var eventsForSelectedDateView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("calendar.eventsFor".localized + " \(formattedDate(selectedDate))")
                .id(localizationManager.currentLanguage)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            let events = getEvents(for: selectedDate)
            
            if events.isEmpty {
                Text("calendar.noEvents".localized)
                    .id(localizationManager.currentLanguage)
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: Spacing.sm) {
                        ForEach(events, id: \.id) { event in
                            EventCardView(event: event)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 300)
    }
    
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localizationManager.currentLanguage)
        return formatter.shortWeekdaySymbols
    }
    
    private var calendarDays: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        
        var days: [Date] = []
        
        // Add days from previous month
        let daysToAdd = (firstWeekday - calendar.firstWeekday + 7) % 7
        if daysToAdd > 0 {
            for i in (1...daysToAdd).reversed() {
                if let date = calendar.date(byAdding: .day, value: -i, to: startOfMonth) {
                    days.append(date)
                }
            }
        }
        
        // Add days of current month
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        // Add days from next month to fill grid
        let totalDays = days.count
        let remainingDays = 42 - totalDays // 6 rows * 7 days
        if remainingDays > 0, let lastDay = days.last {
            for day in 1...remainingDays {
                if let date = calendar.date(byAdding: .day, value: day, to: lastDay) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
    
    private func changeMonth(_ direction: Int) {
        currentMonth = Calendar.current.date(byAdding: .month, value: direction, to: currentMonth) ?? currentMonth
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localizationManager.currentLanguage)
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localizationManager.currentLanguage)
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func hasEvents(on date: Date) -> Bool {
        !getEvents(for: date).isEmpty
    }
    
    private func getEvents(for date: Date) -> [CalendarEvent] {
        var events: [CalendarEvent] = []
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Appointments
        if let pet = pet {
            let appointments = healthRecordManager.appointments.filter { appointment in
                appointment.petId == pet.id &&
                appointment.date >= startOfDay &&
                appointment.date < endOfDay
            }
            events.append(contentsOf: appointments.map { CalendarEvent.appointment($0) })
        } else {
            let appointments = healthRecordManager.appointments.filter { appointment in
                appointment.date >= startOfDay &&
                appointment.date < endOfDay
            }
            events.append(contentsOf: appointments.map { CalendarEvent.appointment($0) })
        }
        
        // Vaccinations - zeige sowohl durchgeführte als auch anstehende Impfungen
        if let pet = pet {
            let vaccinations = healthRecordManager.vaccinations.filter { vaccination in
                guard vaccination.petId == pet.id else { return false }
                // Zeige durchgeführte Impfungen
                if calendar.isDate(vaccination.date, inSameDayAs: date) {
                    return true
                }
                // Zeige anstehende Impfungen (nextDueDate)
                if let nextDueDate = vaccination.nextDueDate,
                   calendar.isDate(nextDueDate, inSameDayAs: date) {
                    return true
                }
                return false
            }
            events.append(contentsOf: vaccinations.map { CalendarEvent.vaccination($0) })
        } else {
            let vaccinations = healthRecordManager.vaccinations.filter { vaccination in
                // Zeige durchgeführte Impfungen
                if calendar.isDate(vaccination.date, inSameDayAs: date) {
                    return true
                }
                // Zeige anstehende Impfungen (nextDueDate)
                if let nextDueDate = vaccination.nextDueDate,
                   calendar.isDate(nextDueDate, inSameDayAs: date) {
                    return true
                }
                return false
            }
            events.append(contentsOf: vaccinations.map { CalendarEvent.vaccination($0) })
        }
        
        // Consultations
        if let pet = pet {
            let consultations = healthRecordManager.consultations.filter { consultation in
                consultation.petId == pet.id &&
                calendar.isDate(consultation.date, inSameDayAs: date)
            }
            events.append(contentsOf: consultations.map { CalendarEvent.consultation($0) })
        } else {
            let consultations = healthRecordManager.consultations.filter { consultation in
                calendar.isDate(consultation.date, inSameDayAs: date)
            }
            events.append(contentsOf: consultations.map { CalendarEvent.consultation($0) })
        }
        
        // Medications (start dates)
        if let pet = pet {
            let medications = healthRecordManager.medications.filter { medication in
                medication.petId == pet.id &&
                medication.isActive &&
                calendar.isDate(medication.startDate, inSameDayAs: date)
            }
            events.append(contentsOf: medications.map { CalendarEvent.medication($0) })
        } else {
            let medications = healthRecordManager.medications.filter { medication in
                medication.isActive &&
                calendar.isDate(medication.startDate, inSameDayAs: date)
            }
            events.append(contentsOf: medications.map { CalendarEvent.medication($0) })
        }
        
        return events.sorted { $0.date < $1.date }
    }
}

enum CalendarEvent: Identifiable {
    case appointment(Appointment)
    case vaccination(Vaccination)
    case consultation(Consultation)
    case medication(Medication)
    
    var id: UUID {
        switch self {
        case .appointment(let appointment):
            return appointment.id
        case .vaccination(let vaccination):
            return vaccination.id
        case .consultation(let consultation):
            return consultation.id
        case .medication(let medication):
            return medication.id
        }
    }
    
    var date: Date {
        switch self {
        case .appointment(let appointment):
            return appointment.date
        case .vaccination(let vaccination):
            // Für anstehende Impfungen verwende nextDueDate, sonst das Impfdatum
            return vaccination.nextDueDate ?? vaccination.date
        case .consultation(let consultation):
            return consultation.date
        case .medication(let medication):
            return medication.startDate
        }
    }
    
    var title: String {
        switch self {
        case .appointment(let appointment):
            return appointment.title
        case .vaccination(let vaccination):
            return vaccination.name
        case .consultation(let consultation):
            return consultation.reason
        case .medication(let medication):
            return medication.name
        }
    }
    
    var type: String {
        switch self {
        case .appointment:
            return "appointment"
        case .vaccination:
            return "vaccination"
        case .consultation:
            return "consultation"
        case .medication:
            return "medication"
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvents: Bool
    let isCurrentMonth: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                    .foregroundColor(
                        isSelected ? .white :
                        isToday ? .brandPrimary :
                        isCurrentMonth ? .textPrimary : .textSecondary
                    )
                
                if hasEvents {
                    Circle()
                        .fill(isSelected ? .white : .brandPrimary)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(width: 40, height: 40)
            .background(
                isSelected ? Color.brandPrimary :
                isToday ? Color.brandPrimary.opacity(0.2) :
                Color.clear
            )
            .cornerRadius(8)
        }
    }
}

struct EventCardView: View {
    let event: CalendarEvent
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        HStack {
            Circle()
                .fill(colorForEventType(event.type))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                
                Text(typeLabel(for: event.type))
                    .id(localizationManager.currentLanguage)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text(timeString(from: event.date))
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.medium)
    }
    
    private func colorForEventType(_ type: String) -> Color {
        switch type {
        case "appointment":
            return .accentBlue
        case "vaccination":
            return .accentGreen
        case "consultation":
            return .accentPurple
        case "medication":
            return .accentOrange
        default:
            return .textSecondary
        }
    }
    
    private func typeLabel(for type: String) -> String {
        switch type {
        case "appointment":
            return "calendar.appointment".localized
        case "vaccination":
            return "calendar.vaccination".localized
        case "consultation":
            return "calendar.consultation".localized
        case "medication":
            return "calendar.medication".localized
        default:
            return ""
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localizationManager.currentLanguage)
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

