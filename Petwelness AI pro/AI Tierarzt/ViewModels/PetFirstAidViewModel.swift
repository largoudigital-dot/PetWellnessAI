//
//  PetFirstAidViewModel.swift
//  AI Tierarzt
//
//  Created by Largou on 06.12.25.
//

import SwiftUI
import Foundation

class PetFirstAidViewModel: ObservableObject {
    @Published var categories: [PetCategory] = []
    @Published var searchText: String = ""
    
    var filteredCategories: [PetCategory] {
        if searchText.isEmpty {
            return categories
        }
        
        return categories.map { category in
            let filteredEmergencies = category.emergencies.filter { emergency in
                emergency.title.localizedCaseInsensitiveContains(searchText) ||
                emergency.symptoms.joined().localizedCaseInsensitiveContains(searchText)
            }
            return PetCategory(name: category.name, icon: category.icon, emergencies: filteredEmergencies)
        }.filter { !$0.emergencies.isEmpty }
    }
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        categories = [
            // HUND
            PetCategory(
                name: "Hund",
                icon: "pawprint.fill",
                emergencies: [
                    Emergency(
                        title: "Vergiftung",
                        severity: .critical,
                        symptoms: ["Erbrechen", "Zittern", "Krämpfe", "Speicheln", "Atemnot"],
                        steps: [
                            "Ruhe bewahren und das Tier beruhigen",
                            "NICHT zum Erbrechen bringen (kann gefährlich sein)",
                            "Sofort Tierarzt oder Tierklinik kontaktieren",
                            "Gift oder Verpackung mitnehmen",
                            "Tier warm halten und ruhig transportieren"
                        ],
                        warning: "Bei Vergiftungen zählt jede Minute! Sofort handeln!",
                        imageName: "Hund Vergiftung Erste Hilfe"
                    ),
                    Emergency(
                        title: "Giftverdacht - Symptome erkennen",
                        severity: .critical,
                        symptoms: ["Plötzliche Verhaltensänderung", "Erbrechen", "Durchfall", "Speicheln", "Zittern", "Krämpfe"],
                        steps: [
                            "Sofort Symptome dokumentieren",
                            "Mögliche Giftquelle identifizieren",
                            "Tierarzt kontaktieren und Symptome beschreiben",
                            "Gift oder Verpackung mitnehmen",
                            "Tier warm halten und beobachten"
                        ],
                        warning: "Bei Giftverdacht sofort handeln - auch bei leichten Symptomen!",
                        imageName: "1-Giftverdacht-Symptome"
                    ),
                    Emergency(
                        title: "Hitzschlag",
                        severity: .critical,
                        symptoms: ["Starkes Hecheln", "Taumeln", "Erbrechen", "Bewusstlosigkeit"],
                        steps: [
                            "Tier sofort an einen kühlen, schattigen Ort bringen",
                            "Mit lauwarmem (nicht kaltem!) Wasser kühlen",
                            "Pfoten zuerst kühlen, dann Körper",
                            "Kleines Mengen Wasser anbieten",
                            "Sofort zum Tierarzt fahren"
                        ],
                        warning: "Niemals eiskaltes Wasser verwenden - kann zu Schock führen!",
                        imageName: "Hitzschlag Erste Hilfe"
                    ),
                    Emergency(
                        title: "Schnittwunden",
                        severity: .high,
                        symptoms: ["Starke Blutung", "Sichtbare Verletzung", "Schmerzen"],
                        steps: [
                            "Mit sauberem Tuch oder Verband abdecken",
                            "Leichten Druck ausüben (nicht zu fest)",
                            "Tier ruhig halten und beruhigen",
                            "Wunde nicht säubern oder desinfizieren",
                            "Zum Tierarzt fahren"
                        ],
                        imageName: "4-Schnittwunden-Stabilisierung"
                    ),
                    Emergency(
                        title: "Erbrechen",
                        severity: .medium,
                        symptoms: ["Wiederholtes Erbrechen", "Appetitlosigkeit", "Lethargie"],
                        steps: [
                            "Tier ruhig halten",
                            "Kein Futter für 12-24 Stunden",
                            "Kleine Mengen Wasser anbieten",
                            "Bei anhaltendem Erbrechen zum Tierarzt",
                            "Hydratation überwachen"
                        ],
                        warning: "Bei blutigem Erbrechen sofort zum Tierarzt!",
                        imageName: "5-Erbrechen-Hydratation"
                    ),
                    Emergency(
                        title: "Knochenbruch",
                        severity: .high,
                        symptoms: ["Schonhaltung", "Schmerzen", "Schwellung"],
                        steps: [
                            "Tier nicht bewegen oder anfassen",
                            "Beruhigend mit dem Tier sprechen",
                            "Bruchstelle nicht berühren oder einrenken",
                            "Auf feste Unterlage legen (Decke, Brett)",
                            "Sofort zum Tierarzt transportieren"
                        ],
                        imageName: "Tier Allgemeine Notfallversorgung"
                    )
                ]
            ),
            
            // KATZE
            PetCategory(
                name: "Katze",
                icon: "cat.fill",
                emergencies: [
                    Emergency(
                        title: "Vergiftung",
                        severity: .critical,
                        symptoms: ["Speicheln", "Erbrechen", "Zittern", "Atemnot", "Krämpfe"],
                        steps: [
                            "Ruhe bewahren",
                            "NICHT zum Erbrechen bringen",
                            "Sofort Tierarzt kontaktieren",
                            "Gift mitnehmen",
                            "Tier warm halten"
                        ],
                        warning: "Katzen reagieren besonders empfindlich auf Vergiftungen!",
                        imageName: "Katze Allgemeine Erste Hilfe"
                    ),
                    Emergency(
                        title: "Chemikalienvergiftung",
                        severity: .critical,
                        symptoms: ["Speicheln", "Atemnot", "Verbrennungen", "Erbrechen", "Bewusstlosigkeit"],
                        steps: [
                            "Sofort Tierarzt kontaktieren",
                            "Chemikalie identifizieren (Verpackung mitnehmen)",
                            "NICHT zum Erbrechen bringen",
                            "Bei Hautkontakt: Mit viel Wasser spülen",
                            "Tier warm halten und ruhig transportieren"
                        ],
                        warning: "Chemikalienvergiftungen sind extrem gefährlich - sofort handeln!",
                        imageName: "Katzen-Erste-Hilfe-Chemikalien"
                    ),
                    Emergency(
                        title: "Sturz",
                        severity: .critical,
                        symptoms: ["Schock", "Atemnot", "Bewegungsunfähigkeit"],
                        steps: [
                            "Tier nicht bewegen",
                            "Atmung überprüfen",
                            "Bewusstlosigkeit: Stabile Seitenlage",
                            "Sofort zum Tierarzt",
                            "Ruhig transportieren"
                        ],
                        warning: "Nach Stürzen können innere Verletzungen auftreten!",
                        imageName: "Katze Sturz Erste Hilfe"
                    ),
                    Emergency(
                        title: "Atemnot",
                        severity: .critical,
                        symptoms: ["Maulatmung", "Blaue Schleimhäute", "Panik"],
                        steps: [
                            "Sofort Tierarzt kontaktieren",
                            "Tier ruhig halten",
                            "Halsband entfernen",
                            "Fenster öffnen für frische Luft",
                            "Bereit für Transport sein"
                        ],
                        warning: "Atemnot ist lebensbedrohlich - sofort handeln!",
                        imageName: "Katze Allgemeine Erste Hilfe"
                    )
                ]
            ),
            
            // KLEINTIERE
            PetCategory(
                name: "Kleintiere",
                icon: "hare.fill",
                emergencies: [
                    Emergency(
                        title: "Hitzschlag",
                        severity: .critical,
                        symptoms: ["Apathie", "Seitenlage", "Starke Atmung"],
                        steps: [
                            "Sofort an kühlen Ort bringen",
                            "Mit lauwarmem Wasser kühlen",
                            "Kleine Mengen Wasser anbieten",
                            "Zum Tierarzt fahren",
                            "Während Transport kühlen"
                        ],
                        warning: "Kleintiere überhitzen sehr schnell!",
                        imageName: "Hitzschlag Erste Hilfe"
                    ),
                    Emergency(
                        title: "Schock",
                        severity: .critical,
                        symptoms: ["Apathie", "Kalte Extremitäten", "Schnelle Atmung"],
                        steps: [
                            "Tier warm halten (Decke)",
                            "Ruhig halten",
                            "Sofort zum Tierarzt",
                            "Körpertemperatur überwachen",
                            "Bewusstlosigkeit: Stabile Seitenlage"
                        ],
                        warning: "Schock kann lebensbedrohlich sein!"
                    )
                ]
            )
        ]
    }
}

