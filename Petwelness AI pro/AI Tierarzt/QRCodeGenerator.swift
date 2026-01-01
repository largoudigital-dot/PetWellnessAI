//
//  QRCodeGenerator.swift
//  AI Tierarzt
//
//  Created by Largou on 04.12.25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let pet: Pet
    let vaccinations: [Vaccination]
    
    @State private var qrCodeImage: UIImage?
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Text("qr.title".localized)
                .id(localizationManager.currentLanguage)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if let qrImage = qrCodeImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(CornerRadius.large)
            } else {
                ProgressView()
            }
            
            Text("qr.description".localized)
                .id(localizationManager.currentLanguage)
                .font(.caption)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                shareQRCode()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("qr.share".localized)
                        .id(localizationManager.currentLanguage)
                }
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.brandPrimary)
                .cornerRadius(CornerRadius.medium)
            }
        }
        .padding()
        .onAppear {
            generateQRCode()
        }
    }
    
    private func generateQRCode() {
        let vaccinationData = createVaccinationJSON()
        
        let filter = CIFilter.qrCodeGenerator()
        let data = vaccinationData.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                qrCodeImage = UIImage(cgImage: cgImage)
            }
        }
    }
    
    private func createVaccinationJSON() -> String {
        let vaccinationsDict = vaccinations.map { vaccination in
            [
                "name": vaccination.name,
                "date": ISO8601DateFormatter().string(from: vaccination.date),
                "nextDueDate": vaccination.nextDueDate != nil ? ISO8601DateFormatter().string(from: vaccination.nextDueDate!) : "",
                "veterinarian": vaccination.veterinarian
            ]
        }
        
        let data: [String: Any] = [
            "pet": [
                "name": pet.name,
                "type": pet.type,
                "breed": pet.breed,
                "age": pet.age
            ],
            "vaccinations": vaccinationsDict,
            "generatedDate": ISO8601DateFormatter().string(from: Date())
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        
        return "{}"
    }
    
    private func shareQRCode() {
        guard let qrImage = qrCodeImage else { return }
        
        let activityVC = UIActivityViewController(activityItems: [qrImage], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}














