//
//  PerformanceCache.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation

// MARK: - Performance Cache
class PerformanceCache {
    static let shared = PerformanceCache()
    
    private var medicationsCache: [UUID: [Medication]] = [:]
    private var vaccinationsCache: [UUID: [Vaccination]] = [:]
    private var appointmentsCache: [UUID: [Appointment]] = [:]
    private var cacheTimestamp: Date = Date()
    private let cacheValidityDuration: TimeInterval = 60 // 1 Minute
    
    private init() {}
    
    // MARK: - Cache Management
    func invalidateCache() {
        medicationsCache.removeAll()
        vaccinationsCache.removeAll()
        appointmentsCache.removeAll()
        cacheTimestamp = Date()
    }
    
    func isCacheValid() -> Bool {
        Date().timeIntervalSince(cacheTimestamp) < cacheValidityDuration
    }
    
    // MARK: - Medications Cache
    func getMedications(for petId: UUID, from source: [Medication]) -> [Medication] {
        if isCacheValid(), let cached = medicationsCache[petId] {
            return cached
        }
        let filtered = source.filter { $0.petId == petId }
        medicationsCache[petId] = filtered
        return filtered
    }
    
    // MARK: - Vaccinations Cache
    func getVaccinations(for petId: UUID, from source: [Vaccination]) -> [Vaccination] {
        if isCacheValid(), let cached = vaccinationsCache[petId] {
            return cached
        }
        let filtered = source.filter { $0.petId == petId }
        vaccinationsCache[petId] = filtered
        return filtered
    }
    
    // MARK: - Appointments Cache
    func getAppointments(for petId: UUID, from source: [Appointment]) -> [Appointment] {
        if isCacheValid(), let cached = appointmentsCache[petId] {
            return cached
        }
        let filtered = source.filter { $0.petId == petId }
        appointmentsCache[petId] = filtered
        return filtered
    }
}

// MARK: - Debouncer
class Debouncer {
    private var workItem: DispatchWorkItem?
    private let delay: TimeInterval
    
    init(delay: TimeInterval = 0.5) {
        self.delay = delay
    }
    
    func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}



