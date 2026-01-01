//
//  NotificationManager.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    init() {
        checkAuthorizationStatus()
    }
    
    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if let error = error {
                    print("❌ Fehler bei Benachrichtigungsberechtigung: \(error.localizedDescription)")
                    // Bei Fehler: notificationsEnabled auf false setzen
                    UserDefaults.standard.set(false, forKey: "notificationsEnabled")
                    completion?(false)
                } else if granted {
                    // WICHTIG: Wenn Berechtigung erteilt wird, aktiviere automatisch Benachrichtigungen
                    // Das macht UX-Sinn: Wenn der Benutzer die Berechtigung erteilt, will er auch Benachrichtigungen erhalten
                    UserDefaults.standard.set(true, forKey: "notificationsEnabled")
                    print("✅ Benachrichtigungsberechtigung erteilt und Benachrichtigungen automatisch aktiviert")
                    completion?(true)
                } else {
                    print("⚠️ Benachrichtigungsberechtigung verweigert")
                    // Bei Verweigerung: notificationsEnabled auf false setzen
                    UserDefaults.standard.set(false, forKey: "notificationsEnabled")
                    completion?(false)
                }
            }
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let wasAuthorized = self.isAuthorized
                self.isAuthorized = settings.authorizationStatus == .authorized
                
                // WICHTIG: Behebe Inkonsistenz für bestehende User
                // Wenn Berechtigung erteilt ist, aber notificationsEnabled noch false ist,
                // setze es automatisch auf true (behebt Problem für bestehende User)
                if self.isAuthorized {
                    let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                    if !notificationsEnabled {
                        UserDefaults.standard.set(true, forKey: "notificationsEnabled")
                        print("🔧 Auto-Fix: notificationsEnabled wurde auf true gesetzt (Berechtigung vorhanden)")
                    }
                }
                
                if wasAuthorized != self.isAuthorized {
                    print("📱 Benachrichtigungsstatus geändert: \(self.isAuthorized ? "Autorisiert" : "Nicht autorisiert")")
                }
            }
        }
    }
    
    func checkAuthorizationStatusSync() -> Bool {
        var isAuthorized = false
        let semaphore = DispatchSemaphore(value: 0)
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            isAuthorized = settings.authorizationStatus == .authorized
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .now() + 1.0)
        return isAuthorized
    }
    
    // MARK: - Medication Reminders
    func scheduleMedicationReminder(medication: Medication, petName: String) {
        // DEBUG: Prüfe alle relevanten Einstellungen
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        let authorized = checkAuthorizationStatusSync()
        
        print("🔍 ========== DEBUG: scheduleMedicationReminder() ==========")
        print("🔍 Medikament: \(medication.name)")
        print("🔍 notificationsEnabled (UserDefaults): \(notificationsEnabled)")
        print("🔍 isAuthorized (checkAuthorizationStatusSync): \(authorized)")
        print("🔍 medication.isActive: \(medication.isActive)")
        if let endDate = medication.endDate {
            print("🔍 medication.endDate: \(endDate)")
        } else {
            print("🔍 medication.endDate: nil (kein Enddatum)")
        }
        
        // Prüfe Berechtigung synchron
        guard authorized else {
            print("⚠️ Medikamenten-Benachrichtigung nicht geplant: Berechtigung fehlt (Medikament: \(medication.name))")
            print("🔍 ==========================================================")
            return
        }
        
        // Prüfe ob Benachrichtigungen aktiviert sind
        guard notificationsEnabled else {
            print("⚠️ Medikamenten-Benachrichtigung nicht geplant: notificationsEnabled = false (Medikament: \(medication.name))")
            print("🔍 ==========================================================")
            return
        }
        
        // Prüfe ob Medikament aktiv ist
        guard medication.isActive else {
            print("⚠️ Medikament \(medication.name) ist nicht aktiv, keine Benachrichtigung geplant")
            return
        }
        
        // Prüfe ob Enddatum in der Zukunft liegt oder nicht gesetzt ist
        if let endDate = medication.endDate, endDate < Date() {
            print("⚠️ Medikament \(medication.name) ist abgelaufen (Enddatum: \(endDate)), keine Benachrichtigung geplant")
            return
        }
        
        print("📅 Plane Medikamenten-Benachrichtigung: \(medication.name) für \(petName)")
        
        // Lösche alte Benachrichtigungen für dieses Medikament
        cancelMedicationReminder(medication: medication)
        
        let content = UNMutableNotificationContent()
        content.title = "💊 \("notifications.medicationReminder".localized)"
        // Nur ein Emoji im Title, Body ohne Emoji, Namen groß schreiben
        let medicationNameUpper = medication.name.uppercased()
        let petNameUpper = petName.uppercased()
        content.body = String(format: "notifications.medicationBody".localized, medicationNameUpper, petNameUpper)
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "MEDICATION_REMINDER"
        
        // UserInfo für Action-Handling hinzufügen
        let formatter = ISO8601DateFormatter()
        content.userInfo = [
            "medicationId": medication.id.uuidString,
            "petId": medication.petId.uuidString,
            "medicationName": medication.name,
            "petName": petName,
            "scheduledTime": formatter.string(from: Date())
        ]
        
        // Speichere Namen für Notification Tap
        UserDefaults.standard.set(medication.name, forKey: "medication_\(medication.id.uuidString)_name")
        UserDefaults.standard.set(petName, forKey: "pet_\(medication.petId.uuidString)_name")
        
        // WICHTIG: Extrahiere Zeiten aus notes (falls vorhanden), sonst verwende parseMedicationFrequency
        print("  🔍 Prüfe Notes für Zeiten: \(medication.notes.prefix(100))")
        let times: [Date]
        if let extractedTimes = extractTimesFromNotes(medication.notes), !extractedTimes.isEmpty {
            print("  ✅ Verwende eingegebene Zeiten aus Notes: \(extractedTimes.map { formatTime($0) }.joined(separator: ", "))")
            times = extractedTimes
        } else {
            print("  ⚠️ Keine Zeiten in Notes gefunden, verwende Standard-Zeiten basierend auf Häufigkeit")
            print("  📝 Notes-Inhalt: '\(medication.notes)'")
            times = parseMedicationFrequency(medication.frequency)
        }
        
        guard !times.isEmpty else {
            print("❌ Keine Zeiten für Medikament \(medication.name) gefunden")
            return
        }
        
        for (index, time) in times.enumerated() {
            let components = Calendar.current.dateComponents([.hour, .minute], from: time)
            var dateComponents = DateComponents()
            dateComponents.hour = components.hour
            dateComponents.minute = components.minute
            
            guard let hour = components.hour, let minute = components.minute else {
                print("❌ Ungültige Zeitkomponenten für Benachrichtigung")
                continue
            }
            
            // DEBUG: Zeige genaue Zeit der geplanten Notification
            let timeString = String(format: "%02d:%02d", hour, minute)
            print("🔍 ✅ WIRD GEPLANT: Benachrichtigung \(index + 1)/\(times.count) um \(timeString) Uhr (täglich wiederkehrend)")
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let identifier = "medication_\(medication.id.uuidString)_\(index)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            print("  📌 Plane Benachrichtigung \(index + 1)/\(times.count) um \(hour):\(String(format: "%02d", minute)) Uhr")
            
            UNUserNotificationCenter.current().add(request) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Fehler beim Planen der Benachrichtigung \(identifier): \(error.localizedDescription)")
                        print("🔍 ==========================================================")
                    } else {
                        print("✅ Benachrichtigung erfolgreich geplant: \(identifier) um \(hour):\(String(format: "%02d", minute)) Uhr")
                        if index == times.count - 1 {
                            print("🔍 ==========================================================")
                        }
                    }
                }
            }
        }
    }
    
    func cancelMedicationReminder(medication: Medication) {
        let identifiers = (0..<10).map { "medication_\(medication.id.uuidString)_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: - Vaccination Reminders
    func scheduleVaccinationReminder(vaccination: Vaccination, petName: String, daysBefore: Int = 7) {
        // DEBUG: Prüfe alle relevanten Einstellungen
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        let authorized = checkAuthorizationStatusSync()
        
        print("🔍 ========== DEBUG: scheduleVaccinationReminder() ==========")
        print("🔍 Impfung: \(vaccination.name)")
        print("🔍 notificationsEnabled (UserDefaults): \(notificationsEnabled)")
        print("🔍 isAuthorized (checkAuthorizationStatusSync): \(authorized)")
        
        guard authorized else {
            print("⚠️ Impfung-Benachrichtigung nicht geplant: Berechtigung fehlt")
            print("🔍 ==========================================================")
            return
        }
        
        guard notificationsEnabled else {
            print("⚠️ Impfung-Benachrichtigung nicht geplant: notificationsEnabled = false")
            print("🔍 ==========================================================")
            return
        }
        
        guard let dueDate = vaccination.nextDueDate else {
            print("⚠️ Impfung-Benachrichtigung nicht geplant: Kein Fälligkeitsdatum (Impfung: \(vaccination.name))")
            print("🔍 ==========================================================")
            return
        }
        
        print("📅 Plane Impfung-Benachrichtigung: \(vaccination.name) für \(petName)")
        
        let reminderDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: dueDate) ?? dueDate
        
        // Nur planen, wenn das Datum in der Zukunft liegt
        guard reminderDate > Date() else {
            print("⚠️ Impfung-Benachrichtigung nicht geplant: Datum liegt in der Vergangenheit")
            print("🔍 ==========================================================")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "💉 \("notifications.vaccinationReminder".localized)"
        // Nur ein Emoji im Title, Body ohne Emoji, Namen groß schreiben
        let vaccinationNameUpper = vaccination.name.uppercased()
        let petNameUpper = petName.uppercased()
        content.body = String(format: "notifications.vaccinationBody".localized, vaccinationNameUpper, petNameUpper, daysBefore)
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "VACCINATION_REMINDER"
        
        // UserInfo für Action-Handling hinzufügen
        let formatter = ISO8601DateFormatter()
        content.userInfo = [
            "vaccinationId": vaccination.id.uuidString,
            "petId": vaccination.petId.uuidString,
            "vaccinationName": vaccination.name,
            "petName": petName,
            "dueDate": formatter.string(from: dueDate),
            "scheduledTime": formatter.string(from: reminderDate)
        ]
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = "vaccination_\(vaccination.id.uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // DEBUG: Zeige genaue Zeit
        if let hour = components.hour, let minute = components.minute {
            let timeString = String(format: "%02d:%02d", hour, minute)
            print("🔍 ✅ WIRD GEPLANT: Impfung-Benachrichtigung am \(formatDate(reminderDate)) um \(timeString) Uhr")
        }
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Fehler beim Planen der Impfung-Benachrichtigung: \(error.localizedDescription)")
                print("🔍 ==========================================================")
            } else {
                print("✅ Impfung-Benachrichtigung geplant: \(identifier)")
                print("🔍 ==========================================================")
            }
        }
    }
    
    func cancelVaccinationReminder(vaccination: Vaccination) {
        let identifier = "vaccination_\(vaccination.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // MARK: - Appointment Reminders
    func scheduleAppointmentReminder(appointment: Appointment, petName: String, hoursBefore: Int = 24) {
        // DEBUG: Prüfe alle relevanten Einstellungen
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        let authorized = checkAuthorizationStatusSync()
        
        print("🔍 ========== DEBUG: scheduleAppointmentReminder() ==========")
        print("🔍 Termin: \(appointment.title)")
        print("🔍 notificationsEnabled (UserDefaults): \(notificationsEnabled)")
        print("🔍 isAuthorized (checkAuthorizationStatusSync): \(authorized)")
        print("🔍 Termin-Datum: \(appointment.date)")
        print("🔍 Stunden vorher: \(hoursBefore)")
        
        guard authorized else {
            print("⚠️ Termin-Benachrichtigung nicht geplant: Berechtigung fehlt")
            print("🔍 ==========================================================")
            return
        }
        
        guard notificationsEnabled else {
            print("⚠️ Termin-Benachrichtigung nicht geplant: notificationsEnabled = false")
            print("🔍 ==========================================================")
            return
        }
        
        print("📅 Plane Termin-Benachrichtigung: \(appointment.title) für \(petName)")
        
        var reminderDate = Calendar.current.date(byAdding: .hour, value: -hoursBefore, to: appointment.date) ?? appointment.date
        
        // Wenn Reminder-Datum in der Vergangenheit liegt, plane für kürzeren Zeitraum
        let now = Date()
        if reminderDate <= now {
            print("⚠️ Reminder-Datum liegt in der Vergangenheit, passe an...")
            print("   Ursprüngliches Reminder-Datum: \(reminderDate)")
            print("   Termin-Datum: \(appointment.date)")
            print("   Aktuelles Datum: \(now)")
            
            // Berechne verbleibende Zeit bis zum Termin
            let timeUntilAppointment = appointment.date.timeIntervalSince(now)
            
            if timeUntilAppointment <= 0 {
                // Termin ist bereits vorbei
                print("❌ Termin liegt bereits in der Vergangenheit, keine Benachrichtigung geplant")
                print("🔍 ==========================================================")
                return
            } else if timeUntilAppointment < 3600 {
                // Termin ist in weniger als 1 Stunde - plane für 5 Minuten vorher
                reminderDate = Calendar.current.date(byAdding: .minute, value: -5, to: appointment.date) ?? appointment.date
                print("   ⏰ Termin ist sehr bald, plane Benachrichtigung 5 Minuten vorher")
            } else if timeUntilAppointment < 86400 {
                // Termin ist in weniger als 24 Stunden - plane für 1 Stunde vorher
                reminderDate = Calendar.current.date(byAdding: .hour, value: -1, to: appointment.date) ?? appointment.date
                print("   ⏰ Termin ist heute, plane Benachrichtigung 1 Stunde vorher")
            } else {
                // Termin ist morgen oder später - plane für 1 Tag vorher
                reminderDate = Calendar.current.date(byAdding: .day, value: -1, to: appointment.date) ?? appointment.date
                print("   ⏰ Plane Benachrichtigung 1 Tag vorher")
            }
            
            // Sicherstellen, dass das neue Reminder-Datum nicht in der Vergangenheit liegt
            if reminderDate <= now {
                reminderDate = Calendar.current.date(byAdding: .minute, value: 1, to: now) ?? now
                print("   ⚠️ Reminder-Datum angepasst auf 1 Minute in der Zukunft")
            }
            
            print("   ✅ Neues Reminder-Datum: \(reminderDate)")
        }
        
        // Finale Prüfung: Nur planen, wenn das Datum in der Zukunft liegt
        guard reminderDate > now else {
            print("⚠️ Termin-Benachrichtigung nicht geplant: Reminder-Datum liegt immer noch in der Vergangenheit")
            print("   Reminder-Datum: \(reminderDate)")
            print("   Aktuelles Datum: \(now)")
            print("🔍 ==========================================================")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "📅 \("notifications.appointmentReminder".localized)"
        // Nur ein Emoji im Title, Body ohne Emoji, Namen groß schreiben
        let appointmentTitleUpper = appointment.title.uppercased()
        let petNameUpper = petName.uppercased()
        content.body = String(format: "notifications.appointmentBody".localized, appointmentTitleUpper, petNameUpper)
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "APPOINTMENT_REMINDER"
        
        // UserInfo für Action-Handling hinzufügen
        let formatter = ISO8601DateFormatter()
        content.userInfo = [
            "appointmentId": appointment.id.uuidString,
            "petId": appointment.petId.uuidString,
            "appointmentTitle": appointment.title,
            "petName": petName,
            "appointmentDate": formatter.string(from: appointment.date),
            "scheduledTime": formatter.string(from: reminderDate)
        ]
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = "appointment_\(appointment.id.uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // DEBUG: Zeige genaue Zeit
        if let hour = components.hour, let minute = components.minute {
            let timeString = String(format: "%02d:%02d", hour, minute)
            print("🔍 ✅ WIRD GEPLANT: Termin-Benachrichtigung am \(formatDate(reminderDate)) um \(timeString) Uhr")
        }
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Fehler beim Planen der Termin-Benachrichtigung: \(error.localizedDescription)")
                print("🔍 ==========================================================")
            } else {
                print("✅ Termin-Benachrichtigung geplant: \(identifier)")
                print("🔍 ==========================================================")
            }
        }
    }
    
    func cancelAppointmentReminder(appointment: Appointment) {
        let identifier = "appointment_\(appointment.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // MARK: - Helper Functions
    
    /// Extrahiert Zeiten aus den Notes (Format: "Uhrzeiten: 21:51" oder "Uhrzeiten: 21:51, 8:00")
    private func extractTimesFromNotes(_ notes: String) -> [Date]? {
        print("  🔍 extractTimesFromNotes() aufgerufen mit Notes: '\(notes)'")
        
        guard notes.contains("Uhrzeiten:") else {
            print("  ❌ 'Uhrzeiten:' nicht in Notes gefunden")
            return nil
        }
        
        let components = notes.components(separatedBy: "Uhrzeiten:")
        guard components.count > 1 else {
            print("  ❌ Kein Text nach 'Uhrzeiten:' gefunden")
            return nil
        }
        
        // Extrahiere den Teil nach "Uhrzeiten:"
        let timesString = components[1].components(separatedBy: "\n\n").first ?? components[1]
        let trimmedTimesString = timesString.trimmingCharacters(in: .whitespacesAndNewlines)
        print("  🔍 Extrahiertes Zeit-String: '\(trimmedTimesString)'")
        
        // Parse die Zeiten (Format: "21:51" oder "21:51, 8:00")
        let timeStrings = trimmedTimesString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        print("  🔍 Gefundene Zeit-Strings: \(timeStrings)")
        
        var times: [Date] = []
        let calendar = Calendar.current
        let now = Date()
        
        for timeString in timeStrings {
            print("  🔍 Parse Zeit-String: '\(timeString)'")
            
            // Versuche manuell zu parsen (Format: "21:51" oder "9:51 PM")
            let parts = timeString.split(separator: ":")
            if parts.count == 2,
               let hour = Int(parts[0]),
               let minute = Int(parts[1].trimmingCharacters(in: .whitespaces).components(separatedBy: " ").first ?? ""),
               hour >= 0 && hour < 24,
               minute >= 0 && minute < 60 {
                print("  ✅ Parse erfolgreich: \(hour):\(String(format: "%02d", minute))")
                if let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) {
                    times.append(date)
                    print("  ✅ Date erstellt: \(date)")
                } else {
                    print("  ❌ Konnte Date nicht erstellen für \(hour):\(minute)")
                }
            } else {
                // Versuche mit DateFormatter (für lokalisierte Formate wie "9:51 PM")
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.dateStyle = .none
                
                if let time = formatter.date(from: String(timeString)) {
                    let components = calendar.dateComponents([.hour, .minute], from: time)
                    if let hour = components.hour, let minute = components.minute {
                        print("  ✅ Parse mit DateFormatter erfolgreich: \(hour):\(String(format: "%02d", minute))")
                        if let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) {
                            times.append(date)
                        }
                    }
                } else {
                    print("  ❌ Konnte Zeit-String '\(timeString)' nicht parsen")
                }
            }
        }
        
        print("  🔍 Extrahiert \(times.count) Zeit(en): \(times.map { formatTime($0) })")
        return times.isEmpty ? nil : times
    }
    
    /// Formatiert eine Zeit als String (z.B. "21:51")
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    
    /// Formatiert ein Datum als String (z.B. "13.12.2025")
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func parseMedicationFrequency(_ frequency: String) -> [Date] {
        var times: [Date] = []
        let calendar = Calendar.current
        let now = Date()
        
        // Default times: 8:00, 12:00, 18:00, 20:00
        let defaultTimes = [
            calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now) ?? now,
            calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now) ?? now,
            calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now) ?? now,
            calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) ?? now
        ]
        
        // Prüfe auf verschiedene Sprachen
        let frequencyLower = frequency.lowercased()
        
        if frequencyLower.contains("täglich") || frequencyLower.contains("daily") || frequencyLower.contains("quotidien") || frequencyLower.contains("giornaliero") {
            if frequencyLower.contains("2x") || frequencyLower.contains("2") || frequencyLower.contains("zweimal") || frequencyLower.contains("twice") {
                times = [defaultTimes[0], defaultTimes[2]] // 8:00, 18:00
            } else if frequencyLower.contains("3x") || frequencyLower.contains("3") || frequencyLower.contains("dreimal") || frequencyLower.contains("three") {
                times = [defaultTimes[0], defaultTimes[1], defaultTimes[2]] // 8:00, 12:00, 18:00
            } else if frequencyLower.contains("4x") || frequencyLower.contains("4") || frequencyLower.contains("viermal") || frequencyLower.contains("four") {
                times = defaultTimes // 8:00, 12:00, 18:00, 20:00
            } else {
                times = [defaultTimes[0]] // 8:00
            }
        } else if frequencyLower.contains("wöchentlich") || frequencyLower.contains("weekly") || frequencyLower.contains("hebdomadaire") || frequencyLower.contains("settimanale") {
            times = [defaultTimes[0]] // Once a week
        } else {
            times = [defaultTimes[0]] // Default: once daily
        }
        
        print("  📊 Häufigkeit '\(frequency)' analysiert: \(times.count) Benachrichtigung(en) pro Tag")
        return times
    }
    
    // MARK: - Test Notification
    func scheduleTestNotification(inSeconds: TimeInterval = 10) {
        let authorized = checkAuthorizationStatusSync()
        guard authorized else {
            print("⚠️ Test-Benachrichtigung nicht geplant: Berechtigung fehlt")
            print("   Aktueller Status: \(getAuthorizationStatus().rawValue)")
            return
        }
        
        print("🧪 ========== TEST-BENACHRICHTIGUNG ==========")
        print("🧪 Plane Test-Benachrichtigung in \(inSeconds) Sekunden...")
        
        let content = UNMutableNotificationContent()
        content.title = "notifications.testTitle".localized
        content.body = "notifications.testBody".localized
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "TEST_NOTIFICATION"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        let identifier = "test_notification_\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ FEHLER beim Planen der Test-Benachrichtigung: \(error.localizedDescription)")
                    print("   Error Code: \((error as NSError).code)")
                    print("   Error Domain: \((error as NSError).domain)")
                } else {
                    print("✅ Test-Benachrichtigung erfolgreich geplant!")
                    print("   Identifier: \(identifier)")
                    print("   Sie sollte in \(inSeconds) Sekunden erscheinen.")
                    print("🧪 ==========================================")
                }
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🗑️ Alle Benachrichtigungen wurden gelöscht")
    }
    
    // MARK: - Debug Functions
    func listPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 Anzahl geplanter Benachrichtigungen: \(requests.count)")
            for request in requests {
                print("  - \(request.identifier): \(request.content.title)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    print("    Trigger: \(trigger.dateComponents)")
                }
            }
        }
    }
    
    func getAuthorizationStatus() -> UNAuthorizationStatus {
        var status: UNAuthorizationStatus = .notDetermined
        let semaphore = DispatchSemaphore(value: 0)
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            status = settings.authorizationStatus
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .now() + 1.0)
        return status
    }
    
    // MARK: - Test Function
    func testNotification() {
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        let isAuthorized = checkAuthorizationStatusSync()
        
        print("🔔 ========== TEST: testNotification() ==========")
        print("🔔 Test: notificationsEnabled = \(notificationsEnabled)")
        print("🔔 Test: isAuthorized = \(isAuthorized)")
        
        // Prüfe ob wir im Simulator sind
        #if targetEnvironment(simulator)
        print("⚠️ WICHTIG: Du bist im SIMULATOR!")
        print("⚠️ Benachrichtigungen funktionieren im Simulator oft NICHT zuverlässig!")
        print("⚠️ Bitte teste auf einem ECHTEN GERÄT für zuverlässige Ergebnisse.")
        print("⚠️ Im Simulator können Benachrichtigungen verzögert erscheinen oder ganz fehlen.")
        #endif
        
        guard isAuthorized else {
            print("❌ Test-Notification nicht geplant: Berechtigung fehlt")
            print("💡 Tipp: Gehe zu Einstellungen > AI Tierarzt > Benachrichtigungen")
            print("🔔 ===========================================")
            return
        }
        
        // Prüfe alle geplanten Benachrichtigungen
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 Aktuell geplante Benachrichtigungen: \(requests.count)")
        }
        
        // Prüfe Notification-Einstellungen
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("📱 Notification Settings:")
            print("   - Authorization: \(settings.authorizationStatus.rawValue)")
            print("   - Alert: \(settings.alertSetting.rawValue)")
            print("   - Sound: \(settings.soundSetting.rawValue)")
            print("   - Badge: \(settings.badgeSetting.rawValue)")
            print("   - Lock Screen: \(settings.lockScreenSetting.rawValue)")
            print("   - Notification Center: \(settings.notificationCenterSetting.rawValue)")
        }
        
        // Force eine Test-Notification in 5 Sekunden (kürzer für schnelleres Testen)
        let content = UNMutableNotificationContent()
        content.title = "🧪 " + "notifications.testTitle".localized
        content.body = "notifications.testBody".localized
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "MEDICATION_REMINDER"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "TEST_\(UUID().uuidString)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Fehler beim Planen: \(error.localizedDescription)")
                print("   Error Code: \((error as NSError).code)")
                print("   Error Domain: \((error as NSError).domain)")
            } else {
                print("✅ Test-Notification geplant! Erscheint in 5 Sekunden.")
                #if targetEnvironment(simulator)
                print("⚠️ REMINDER: Im Simulator kann die Benachrichtigung verzögert erscheinen oder fehlen!")
                print("⚠️ Für zuverlässige Tests: Verwende ein echtes iOS-Gerät.")
                #endif
            }
            print("🔔 ===========================================")
        }
    }
    
    // MARK: - Debug: Vollständiger Status-Check
    func debugNotificationStatus() {
        print("🔍 ========== VOLLSTÄNDIGER NOTIFICATION-STATUS ==========")
        
        // 1. UserDefaults
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        print("1️⃣ UserDefaults 'notificationsEnabled': \(notificationsEnabled)")
        
        // 2. Authorization Status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("2️⃣ Authorization Status: \(settings.authorizationStatus.rawValue)")
            print("   - .notDetermined = 0 (noch nicht angefragt)")
            print("   - .denied = 1 (verweigert)")
            print("   - .authorized = 2 (erlaubt) ✅")
            print("   - .provisional = 3 (provisorisch)")
            print("   - .ephemeral = 4 (temporär)")
            
            print("3️⃣ Notification Settings:")
            print("   - Alert: \(settings.alertSetting.rawValue) (0=notSupported, 1=disabled, 2=enabled)")
            print("   - Sound: \(settings.soundSetting.rawValue)")
            print("   - Badge: \(settings.badgeSetting.rawValue)")
            print("   - Lock Screen: \(settings.lockScreenSetting.rawValue)")
            print("   - Notification Center: \(settings.notificationCenterSetting.rawValue)")
            print("   - Banners: \(settings.alertStyle.rawValue) (0=unset, 1=banner, 2=alert)")
            
            // 4. Geplante Benachrichtigungen
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                print("4️⃣ Geplante Benachrichtigungen: \(requests.count)")
                if requests.isEmpty {
                    print("   ⚠️ Keine Benachrichtigungen geplant!")
                } else {
                    for (index, request) in requests.prefix(5).enumerated() {
                        print("   \(index + 1). \(request.identifier)")
                        print("      Title: \(request.content.title)")
                        if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                            print("      Trigger: Calendar (repeats: \(trigger.repeats))")
                            if let hour = trigger.dateComponents.hour,
                               let minute = trigger.dateComponents.minute {
                                print("      Zeit: \(hour):\(String(format: "%02d", minute))")
                            }
                        } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                            print("      Trigger: TimeInterval (in \(Int(trigger.timeInterval))s, repeats: \(trigger.repeats))")
                        }
                    }
                    if requests.count > 5 {
                        print("   ... und \(requests.count - 5) weitere")
                    }
                }
                
                // 5. Gelieferte Benachrichtigungen (letzte 24h)
                UNUserNotificationCenter.current().getDeliveredNotifications { delivered in
                    print("5️⃣ Gelieferte Benachrichtigungen (letzte 24h): \(delivered.count)")
                    
                    #if targetEnvironment(simulator)
                    print("\n⚠️ ========== SIMULATOR-WARNUNG ==========")
                    print("⚠️ Du testest im SIMULATOR!")
                    print("⚠️ Benachrichtigungen funktionieren im Simulator oft NICHT zuverlässig:")
                    print("   - Sie können verzögert erscheinen")
                    print("   - Sie können ganz fehlen")
                    print("   - Foreground-Benachrichtigungen funktionieren besser")
                    print("⚠️ LÖSUNG: Teste auf einem ECHTEN iOS-GERÄT!")
                    print("⚠️ ========================================")
                    #endif
                    
                    print("🔍 ================================================")
                }
            }
        }
    }
    
    // MARK: - Snooze Function
    
    /// Plant eine Snooze-Benachrichtigung (10 Minuten später erinnern)
    func scheduleSnoozeNotification(
        for medicationId: String,
        petId: String,
        originalIdentifier: String,
        minutes: Int = 10
    ) {
        let authorized = checkAuthorizationStatusSync()
        guard authorized else {
            print("⚠️ Snooze-Benachrichtigung nicht geplant: Berechtigung fehlt")
            return
        }
        
        print("⏰ Plane Snooze-Benachrichtigung in \(minutes) Minuten für: \(medicationId)")
        
        // Hole die ursprüngliche Notification, um UserInfo zu übernehmen
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let originalRequest = requests.first { $0.identifier == originalIdentifier }
            
            let content = UNMutableNotificationContent()
            
            if let original = originalRequest {
                // Verwende Titel und Body der ursprünglichen Notification
                content.title = original.content.title
                content.body = original.content.body
                content.userInfo = original.content.userInfo
            } else {
                // Fallback, falls ursprüngliche Notification nicht gefunden wird
                let medicationName = UserDefaults.standard.string(forKey: "medication_\(medicationId)_name") ?? "Medikament"
                let petName = UserDefaults.standard.string(forKey: "pet_\(petId)_name") ?? "Tier"
                let medicationNameUpper = medicationName.uppercased()
                let petNameUpper = petName.uppercased()
                
                content.title = "💊 \("notifications.medicationReminder".localized)"
                content.body = String(format: "notifications.medicationBody".localized, medicationNameUpper, petNameUpper)
                content.userInfo = [
                    "medicationId": medicationId,
                    "petId": petId,
                    "medicationName": medicationName,
                    "petName": petName,
                    "scheduledTime": ISO8601DateFormatter().string(from: Date())
                ]
            }
            
            content.sound = .default
            content.badge = 1
            content.categoryIdentifier = "MEDICATION_REMINDER"
            
            // TimeInterval-Trigger (in X Minuten)
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: TimeInterval(minutes * 60),
                repeats: false
            )
            
            let identifier = "\(medicationId)_snooze_\(UUID().uuidString)"
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Fehler beim Planen der Snooze-Benachrichtigung: \(error.localizedDescription)")
                } else {
                    print("✅ Snooze-Benachrichtigung geplant: \(identifier) (in \(minutes) Minuten)")
                }
            }
        }
    }
}

