//
//  SuggestedQuestionManager.swift
//  AI Tierarzt
//
//  Created by Assistant on 21.01.26.
//

import Foundation

struct SuggestedQuestion: Identifiable {
    let id = UUID()
    let text: String
    let icon: String
}

class SuggestedQuestionManager {
    static let shared = SuggestedQuestionManager()
    
    private init() {}
    
    private let categories: [String] = [
        "Preventive", "Nutrition", "Behavior", "Symptoms", 
        "Senior", "Dental", "Emergency", "Seasonal"
    ]
    
    private let categoryIcons: [String: String] = [
        "Preventive": "shield.cross.fill",
        "Nutrition": "leaf.fill",
        "Behavior": "brain.head.profile",
        "Symptoms": "stethoscope",
        "Senior": "clock.fill",
        "Dental": "sparkles",
        "Emergency": "exclamationmark.triangle.fill",
        "Seasonal": "sun.max.fill"
    ]
    
    private let questionBank: [String: [String]] = [
        "Preventive": [
            "Welche Impfungen braucht mein Welpe im ersten Jahr?",
            "Wie oft sollte ich mein Haustier entwurmen?",
            "Wann ist der beste Zeitpunkt für eine Kastration?",
            "Braucht meine Wohnungskatze auch Impfungen?",
            "Wie schütze ich mein Tier am besten vor Zecken?",
            "Ist ein Mikrochip für mein Haustier Pflicht?",
            "Wie oft sollte ich mit meinem Tier zum Check-up?"
        ],
        "Nutrition": [
            "Ist mein Haustier übergewichtig? Wie erkenne ich das?",
            "Was darf mein Hund auf keinen Fall fressen?",
            "Wie stelle ich das Futter am besten um?",
            "Braucht mein älteres Tier spezielles Futter?",
            "Dürfen Katzen auch Hundefutter fressen?",
            "Ist Barfen für meinen Hund sinnvoll?",
            "Wie viel Wasser sollte mein Tier täglich trinken?"
        ],
        "Behavior": [
            "Wie gewöhne ich meinen Welpen an das Alleinsein?",
            "Warum kratzt meine Katze an Möbeln?",
            "Mein Hund bellt, wenn es klingelt. Was tun?",
            "Wie bekomme ich meine Katze stubenrein?",
            "Warum frisst mein Hund Gras?",
            "Wie führe ich Hund und Katze zusammen?",
            "Warum leckt mein Hund ständig seine Pfoten?"
        ],
        "Symptoms": [
            "Wann sollte ich bei Erbrechen zum Tierarzt?",
            "Mein Tier trinkt sehr viel. Ist das normal?",
            "Woran erkenne ich, dass mein Tier Schmerzen hat?",
            "Mein Hund humpelt nach dem Aufstehen. Grund zur Sorge?",
            "Die Augen meiner Katze tränen. Was kann ich tun?",
            "Mein Tier hat Durchfall. Was hilft sofort?",
            "Ist eine trockene Hundenase immer ein schlechtes Zeichen?"
        ],
        "Senior": [
            "Wie erkenne ich Demenz bei meinem alten Hund?",
            "Welche Vorsorgeuntersuchungen sind für Senioren wichtig?",
            "Mein altes Tier schläft sehr viel. Ist das okay?",
            "Wie kann ich meinem arthritischen Tier helfen?",
            "Ab wann gilt mein Haustier eigentlich als Senior?",
            "Sollte ich meinem alten Tier Nahrungsergänzungsmittel geben?",
            "Wie halte ich meinen Senior geistig fit?"
        ],
        "Dental": [
            "Wie oft sollte ich die Zähne meiner Katze putzen?",
            "Wie schneide ich die Krallen richtig?",
            "Mein Hund riecht aus dem Maul. Was hilft?",
            "Wie oft muss ich meinen Hund baden?",
            "Wie pflege ich das Fell meiner Langhaarkatze?",
            "Was tun gegen Zahnstein beim Hund?",
            "Wie reinige ich die Ohren meines Tieres richtig?"
        ],
        "Emergency": [
            "Was sind Anzeichen für eine Magendrehung?",
            "Mein Tier hat Schokolade gefressen. Was jetzt?",
            "Woran erkenne ich einen Hitzschlag?",
            "Mein Tier hat Atemnot. Was ist zu tun?",
            "Wie leiste ich Erste Hilfe bei einer Pfotenverletzung?",
            "Was gehört in die Notfallapotheke für Haustiere?",
            "Verdacht auf Vergiftung - was ist der erste Schritt?"
        ],
        "Seasonal": [
            "Wie schütze ich mein Tier vor Streusalz im Winter?",
            "Was muss ich bei Hitze im Sommer beachten?",
            "Wie beruhige ich mein Tier an Silvester?",
            "Gefahr durch Grannen im Sommer - worauf achten?",
            "Zeckensaison: Was ist jetzt besonders wichtig?",
            "Blaualgen im Sommer: Wo lauern die Gefahren?",
            "Braucht mein Hund im Winter einen Mantel?"
        ]
    ]
    
    /// Returns 3 random unique questions from 3 different categories
    func getRandomQuestions() -> [SuggestedQuestion] {
        // 1. Pick 3 random unique categories
        let shuffledCategories = categories.shuffled()
        let selectedCategories = Array(shuffledCategories.prefix(3))
        
        var selectedQuestions: [SuggestedQuestion] = []
        
        // 2. Pick 1 random question from each selected category
        for category in selectedCategories {
            if let questions = questionBank[category], let randomQuestion = questions.randomElement() {
                let icon = categoryIcons[category] ?? "questionmark.circle.fill"
                selectedQuestions.append(SuggestedQuestion(text: randomQuestion, icon: icon))
            }
        }
        
        return selectedQuestions
    }
}
