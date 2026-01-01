//
//  ShareManager.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI
import PDFKit

class ShareManager {
    static let shared = ShareManager()
    
    func generatePDFReport(pet: Pet, healthRecordManager: HealthRecordManager) -> URL? {
        print("📄 Erstelle PDF-Bericht für \(pet.name)...")
        let pdfMetaData = [
            kCGPDFContextCreator: "AI Tierarzt",
            kCGPDFContextAuthor: pet.name,
            kCGPDFContextTitle: "Health Report - \(pet.name)"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let fileName = "Health_Report_\(pet.name)_\(Date().timeIntervalSince1970).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try renderer.writePDF(to: tempURL) { context in
                context.beginPage()
                
                let title = "Health Report - \(pet.name)"
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 24),
                    .foregroundColor: UIColor.label
                ]
                title.draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttributes)
                
                var yPosition: CGFloat = 100
                
                // Pet Information
                let petInfo = """
                Name: \(pet.name)
                Type: \(pet.type)
                Breed: \(pet.breed)
                Age: \(pet.age) years
                Health Status: \(pet.healthStatus)
                """
                
                let petInfoAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.label
                ]
                
                petInfo.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: petInfoAttributes)
                yPosition += 100
                
                // Medications
                let medications = healthRecordManager.medications.filter { $0.petId == pet.id }
                if !medications.isEmpty {
                    "Medications:".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: titleAttributes)
                    yPosition += 30
                    
                    for medication in medications {
                        let medText = "• \(medication.name) - \(medication.dosage) - \(medication.frequency)"
                        medText.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: petInfoAttributes)
                        yPosition += 20
                    }
                    yPosition += 20
                }
                
                // Vaccinations
                let vaccinations = healthRecordManager.vaccinations.filter { $0.petId == pet.id }
                if !vaccinations.isEmpty {
                    "Vaccinations:".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: titleAttributes)
                    yPosition += 30
                    
                    for vaccination in vaccinations {
                        let vacText = "• \(vaccination.name) - \(formatDate(vaccination.date))"
                        vacText.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: petInfoAttributes)
                        yPosition += 20
                    }
                    yPosition += 20
                }
                
                // Symptoms
                let symptoms = healthRecordManager.symptoms.filter { $0.petId == pet.id }
                if !symptoms.isEmpty {
                    if yPosition > pageHeight - 100 { context.beginPage(); yPosition = 50 }
                    let sectionAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.label]
                    "Symptoms:".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: sectionAttr)
                    yPosition += 30
                    
                    for symptom in symptoms {
                        let symText = "• \(symptom.symptom) - \(formatDate(symptom.date)) - Severity: \(symptom.severity)/5"
                        symText.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: petInfoAttributes)
                        yPosition += 20
                        if yPosition > pageHeight - 50 { context.beginPage(); yPosition = 50 }
                    }
                    yPosition += 20
                }
                
                // Weight History
                let weights = healthRecordManager.getWeightRecords(for: pet.id)
                if !weights.isEmpty {
                    if yPosition > pageHeight - 100 { context.beginPage(); yPosition = 50 }
                    let sectionAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.label]
                    "Weight History:".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: sectionAttr)
                    yPosition += 30
                    
                    for weight in weights.prefix(5) {
                        let weightText = "• \(formatDate(weight.date)): \(String(format: "%.1f", weight.weight)) kg"
                        weightText.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: petInfoAttributes)
                        yPosition += 20
                        if yPosition > pageHeight - 50 { context.beginPage(); yPosition = 50 }
                    }
                }
            }
            
            return tempURL
        } catch {
            return nil
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func sharePDF(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            var topVC = window.rootViewController
            while let presentedVC = topVC?.presentedViewController {
                topVC = presentedVC
            }
            topVC?.present(activityVC, animated: true)
        }
    }
}





