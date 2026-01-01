//
//  NotificationDelegate.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    override init() {
        super.init()
        setupNotificationCategories()
    }
    
    // MARK: - Setup Notification Categories
    
    private func setupNotificationCategories() {
        // Action: "Genommen" (Medikament wurde eingenommen)
        let takenAction = UNNotificationAction(
            identifier: "TAKEN_ACTION",
            title: "notifications.action.taken".localized,
            options: []
        )
        
        // Action: "Später" (Snooze - 10 Minuten später erinnern)
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_ACTION",
            title: "notifications.action.snooze".localized,
            options: []
        )
        
        // Action: "Überspringen" (Diese Erinnerung überspringen)
        let skipAction = UNNotificationAction(
            identifier: "SKIP_ACTION",
            title: "common.skip".localized,
            options: []
        )
        
        // Category für Medikamenten-Erinnerungen
        let medicationCategory = UNNotificationCategory(
            identifier: "MEDICATION_REMINDER",
            actions: [takenAction, snoozeAction, skipAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        // Category für Impfungen
        let vaccinationCategory = UNNotificationCategory(
            identifier: "VACCINATION_REMINDER",
            actions: [takenAction, snoozeAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        // Category für Termine
        let appointmentCategory = UNNotificationCategory(
            identifier: "APPOINTMENT_REMINDER",
            actions: [takenAction, snoozeAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        // Category für Test-Benachrichtigungen (ohne Actions)
        let testCategory = UNNotificationCategory(
            identifier: "TEST_NOTIFICATION",
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        // Alle Categories registrieren
        UNUserNotificationCenter.current().setNotificationCategories([
            medicationCategory,
            vaccinationCategory,
            appointmentCategory,
            testCategory
        ])
        
        print("✅ Notification Categories registriert:")
        print("   - MEDICATION_REMINDER (Actions: Genommen, Später, Überspringen)")
        print("   - VACCINATION_REMINDER (Actions: Genommen, Später)")
        print("   - APPOINTMENT_REMINDER (Actions: Genommen, Später)")
        print("   - TEST_NOTIFICATION (keine Actions)")
    }
    
    // MARK: - Handle Notification Actions
    
    /// Wird aufgerufen, wenn User auf eine Notification-Action klickt
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let actionIdentifier = response.actionIdentifier
        let notificationIdentifier = response.notification.request.identifier
        
        print("📱 ========== Notification Action ==========")
        print("📱 Action: \(actionIdentifier)")
        print("📱 Notification ID: \(notificationIdentifier)")
        print("📱 Category: \(response.notification.request.content.categoryIdentifier)")
        print("📱 UserInfo: \(userInfo)")
        
        let formatter = ISO8601DateFormatter()
        
        // Prüfe welche Art von Notification (Medikament, Impfung, Termin)
        if let medicationId = userInfo["medicationId"] as? String,
           let petId = userInfo["petId"] as? String,
           let scheduledTimeString = userInfo["scheduledTime"] as? String,
           let scheduledTime = formatter.date(from: scheduledTimeString) {
            
            // MEDIKAMENT
            print("📱 Medikament-Notification erkannt")
            let medicationName = userInfo["medicationName"] as? String ?? "Medikament"
            let petName = userInfo["petName"] as? String ?? "Tier"
            
            switch actionIdentifier {
            case "TAKEN_ACTION":
                handleTakenAction(medicationId: medicationId, petId: petId, time: scheduledTime)
                
            case "SNOOZE_ACTION":
                handleSnoozeAction(medicationId: medicationId, petId: petId, notificationIdentifier: notificationIdentifier)
                
            case "SKIP_ACTION":
                handleSkipAction(medicationId: medicationId)
                
            case UNNotificationDefaultActionIdentifier:
                print("📱 User hat auf Medikament-Notification geklickt")
                handleNotificationTap(medicationId: medicationId, petId: petId, medicationName: medicationName, petName: petName)
                
            default:
                print("📱 Unbekannte Action: \(actionIdentifier)")
            }
            
        } else if let appointmentId = userInfo["appointmentId"] as? String,
                  let petId = userInfo["petId"] as? String,
                  let scheduledTimeString = userInfo["scheduledTime"] as? String,
                  let scheduledTime = formatter.date(from: scheduledTimeString) {
            
            // TERMIN
            print("📱 Termin-Notification erkannt")
            switch actionIdentifier {
            case "TAKEN_ACTION":
                handleAppointmentTakenAction(appointmentId: appointmentId, petId: petId, time: scheduledTime)
                
            case "SNOOZE_ACTION":
                handleAppointmentSnoozeAction(appointmentId: appointmentId, petId: petId, notificationIdentifier: notificationIdentifier)
                
            case UNNotificationDefaultActionIdentifier:
                print("📱 User hat auf Termin-Notification geklickt")
                handleAppointmentTap(appointmentId: appointmentId, petId: petId)
                
            default:
                print("📱 Unbekannte Action: \(actionIdentifier)")
            }
            
        } else if let vaccinationId = userInfo["vaccinationId"] as? String,
                  let petId = userInfo["petId"] as? String,
                  let scheduledTimeString = userInfo["scheduledTime"] as? String,
                  let scheduledTime = formatter.date(from: scheduledTimeString) {
            
            // IMPFUNG
            print("📱 Impfung-Notification erkannt")
            switch actionIdentifier {
            case "TAKEN_ACTION":
                handleVaccinationTakenAction(vaccinationId: vaccinationId, petId: petId, time: scheduledTime)
                
            case "SNOOZE_ACTION":
                handleVaccinationSnoozeAction(vaccinationId: vaccinationId, petId: petId, notificationIdentifier: notificationIdentifier)
                
            case UNNotificationDefaultActionIdentifier:
                print("📱 User hat auf Impfung-Notification geklickt")
                handleVaccinationTap(vaccinationId: vaccinationId, petId: petId)
                
            default:
                print("📱 Unbekannte Action: \(actionIdentifier)")
            }
        } else {
            print("⚠️ Unbekannte Notification-Art oder fehlende UserInfo")
        }
        
        completionHandler()
    }
    
    // MARK: - Handle Foreground Notifications
    
    /// Wird aufgerufen, wenn Notification erscheint (auch wenn App offen ist)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Zeige Notification auch im Vordergrund (Banner, Sound, Badge)
        print("📱 Foreground Notification: \(notification.request.content.title)")
        completionHandler([.banner, .sound, .badge])
    }
    
    // MARK: - Action Handlers
    
    private func handleTakenAction(medicationId: String, petId: String, time: Date) {
        print("✅ Medikament als 'genommen' markiert: \(medicationId) um \(time)")
        
        // Datenbank aktualisieren
        guard let medicationUUID = UUID(uuidString: medicationId) else {
            print("❌ Ungültige Medication ID: \(medicationId)")
            return
        }
        
        let healthRecordManager = HealthRecordManager()
        if healthRecordManager.markMedicationAsTaken(medicationId: medicationUUID, time: time) {
            showConfirmationNotification(title: "✅ " + "notifications.confirmation.done".localized, body: "💊 " + "notifications.confirmation.medicationMarked".localized)
        } else {
            showConfirmationNotification(title: "❌ " + "notifications.confirmation.error".localized, body: "💊 " + "notifications.confirmation.medicationError".localized)
        }
    }
    
    private func handleSnoozeAction(medicationId: String, petId: String, notificationIdentifier: String) {
        print("⏰ Snooze: Erinnere in 10 Minuten erneut")
        
        // Snooze-Benachrichtigung planen (10 Minuten später)
        NotificationManager.shared.scheduleSnoozeNotification(
            for: medicationId,
            petId: petId,
            originalIdentifier: notificationIdentifier
        )
    }
    
    private func handleSkipAction(medicationId: String) {
        print("⏭️ Erinnerung übersprungen für: \(medicationId)")
        
        // Optional: Bestätigung zeigen
        showConfirmationNotification(title: "⏭️ " + "notifications.confirmation.skipped".localized, body: "💊 " + "notifications.confirmation.reminderSkipped".localized)
    }
    
    private func handleNotificationTap(medicationId: String, petId: String, medicationName: String, petName: String) {
        print("👆 User hat auf Notification getippt - zeige Action View")
        
        // Zeige Notification Action View
        DispatchQueue.main.async {
            AppState.shared.notificationMedicationId = medicationId
            AppState.shared.notificationPetId = petId
            AppState.shared.notificationMedicationName = medicationName
            AppState.shared.notificationPetName = petName
            AppState.shared.showNotificationAction = true
        }
    }
    
    // MARK: - Appointment Action Handlers
    
    private func handleAppointmentTakenAction(appointmentId: String, petId: String, time: Date) {
        print("✅ Termin als 'erledigt' markiert: \(appointmentId) um \(time)")
        
        // Datenbank aktualisieren
        guard let appointmentUUID = UUID(uuidString: appointmentId) else {
            print("❌ Ungültige Appointment ID: \(appointmentId)")
            return
        }
        
        let healthRecordManager = HealthRecordManager()
        if healthRecordManager.markAppointmentAsCompleted(appointmentId: appointmentUUID) {
            showConfirmationNotification(title: "✅ " + "notifications.confirmation.done".localized, body: "📅 " + "notifications.confirmation.appointmentMarked".localized)
        } else {
            showConfirmationNotification(title: "❌ " + "notifications.confirmation.error".localized, body: "📅 " + "notifications.confirmation.appointmentError".localized)
        }
    }
    
    private func handleAppointmentSnoozeAction(appointmentId: String, petId: String, notificationIdentifier: String) {
        print("⏰ Snooze: Erinnere in 10 Minuten erneut (Termin)")
        
        // Snooze-Benachrichtigung planen (10 Minuten später)
        NotificationManager.shared.scheduleSnoozeNotification(
            for: appointmentId,
            petId: petId,
            originalIdentifier: notificationIdentifier
        )
    }
    
    private func handleAppointmentTap(appointmentId: String, petId: String) {
        print("👆 User hat auf Termin-Notification getippt - öffne Termin-View")
        
        NotificationCenter.default.post(
            name: NSNotification.Name("OpenAppointment"),
            object: nil,
            userInfo: ["appointmentId": appointmentId, "petId": petId]
        )
    }
    
    // MARK: - Vaccination Action Handlers
    
    private func handleVaccinationTakenAction(vaccinationId: String, petId: String, time: Date) {
        print("✅ Impfung als 'erledigt' markiert: \(vaccinationId) um \(time)")
        
        // Datenbank aktualisieren
        guard let vaccinationUUID = UUID(uuidString: vaccinationId) else {
            print("❌ Ungültige Vaccination ID: \(vaccinationId)")
            return
        }
        
        let healthRecordManager = HealthRecordManager()
        if healthRecordManager.markVaccinationAsCompleted(vaccinationId: vaccinationUUID) {
            showConfirmationNotification(title: "✅ " + "notifications.confirmation.done".localized, body: "💉 " + "notifications.confirmation.vaccinationMarked".localized)
        } else {
            showConfirmationNotification(title: "❌ " + "notifications.confirmation.error".localized, body: "💉 " + "notifications.confirmation.vaccinationError".localized)
        }
    }
    
    private func handleVaccinationSnoozeAction(vaccinationId: String, petId: String, notificationIdentifier: String) {
        print("⏰ Snooze: Erinnere in 10 Minuten erneut (Impfung)")
        
        // Snooze-Benachrichtigung planen (10 Minuten später)
        NotificationManager.shared.scheduleSnoozeNotification(
            for: vaccinationId,
            petId: petId,
            originalIdentifier: notificationIdentifier
        )
    }
    
    private func handleVaccinationTap(vaccinationId: String, petId: String) {
        print("👆 User hat auf Impfung-Notification getippt - öffne Impfung-View")
        
        NotificationCenter.default.post(
            name: NSNotification.Name("OpenVaccination"),
            object: nil,
            userInfo: ["vaccinationId": vaccinationId, "petId": petId]
        )
    }
    
    // MARK: - Helper Functions
    
    private func showConfirmationNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(
            identifier: "confirmation_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}


