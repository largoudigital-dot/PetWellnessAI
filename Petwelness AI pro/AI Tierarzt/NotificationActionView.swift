//
//  NotificationActionView.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI

struct NotificationActionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    let medicationId: String
    let petId: String
    let medicationName: String
    let petName: String
    
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header mit Titel
            HStack {
                Text("notifications.medicationReminder".localized)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(width: 26, height: 26)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 14)
            
            Divider()
                .background(Color.gray.opacity(0.25))
            
            // Content - Kompakt
            VStack(spacing: 18) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentOrange.opacity(0.12))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "pills.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.accentOrange)
                }
                .padding(.top, 20)
                
                // Question
                Text("notifications.actionQuestion".localized)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Medication Info
                Text("\(medicationName.uppercased()) - \(petName.uppercased())")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Action Buttons - iOS Style
                VStack(spacing: 12) {
                    // Gegeben Button - Blau
                    Button(action: {
                        print("🔵 Pris Button gedrückt")
                        markAsTaken()
                    }) {
                        HStack {
                            Spacer()
                            Text("notifications.action.taken".localized)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(height: 50)
                        .background(Color.accentBlue)
                        .cornerRadius(12)
                    }
                    .disabled(isProcessing)
                    .buttonStyle(.plain)
                    
                    // Snooze Buttons - Weiß mit blauem Rahmen
                    HStack(spacing: 12) {
                        Button(action: {
                            print("🔵 15 Min Button gedrückt")
                            snooze(minutes: 15)
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 14))
                                Text("15 " + "notifications.minutes".localized)
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(.accentBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentBlue, lineWidth: 1.5)
                            )
                        }
                        .disabled(isProcessing)
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            print("🔵 30 Min Button gedrückt")
                            snooze(minutes: 30)
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 14))
                                Text("30 " + "notifications.minutes".localized)
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(.accentBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentBlue, lineWidth: 1.5)
                            )
                        }
                        .disabled(isProcessing)
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: 320)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 25, x: 0, y: 12)
        .preferredColorScheme(.light)
    }
    
    private func markAsTaken() {
        print("🔵 markAsTaken() aufgerufen für Medication: \(medicationId)")
        isProcessing = true
        
        guard let medicationUUID = UUID(uuidString: medicationId) else {
            print("❌ Ungültige Medication ID: \(medicationId)")
            isProcessing = false
            return
        }
        
        print("🔵 UUID konvertiert: \(medicationUUID)")
        
        let healthRecordManager = HealthRecordManager()
        let success = healthRecordManager.markMedicationAsTaken(medicationId: medicationUUID, time: Date())
        
        if success {
            print("✅ Medikament als 'genommen' markiert")
            // Schließe das Modal (Overlay)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                appState.showNotificationAction = false
                dismiss()
            }
        } else {
            print("❌ Fehler beim Markieren des Medikaments")
            isProcessing = false
        }
    }
    
    private func snooze(minutes: Int) {
        print("🔔 Snooze Button gedrückt: \(minutes) Minuten")
        isProcessing = true
        
        // Speichere die Daten in UserDefaults für die Snooze-Benachrichtigung
        UserDefaults.standard.set(medicationName, forKey: "medication_\(medicationId)_name")
        UserDefaults.standard.set(petName, forKey: "pet_\(petId)_name")
        
        // Plane die Snooze-Benachrichtigung
        NotificationManager.shared.scheduleSnoozeNotification(
            for: medicationId,
            petId: petId,
            originalIdentifier: "",
            minutes: minutes
        )
        
        print("✅ Snooze-Benachrichtigung geplant: Erinnere in \(minutes) Minuten erneut")
        
        // Schließe das Modal
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            appState.showNotificationAction = false
            dismiss()
        }
    }
}

