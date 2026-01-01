//
//  AdHelper.swift
//  AI Tierarzt
//
//  Created for Ad Integration and Limits
//

import Foundation
import SwiftUI

class AdHelper: ObservableObject {
    static let shared = AdHelper()
    
    // Limits
    private let freeDailyLimit = 10 // Kostenlose Nachrichten pro Tag
    private let rewardedAdBonus = 5 // Zusätzliche Nachrichten nach Rewarded Ad
    
    @Published var showRewardedAdOffer = false
    @Published var showLimitReachedAlert = false
    
    private init() {}
    
    // MARK: - Message Limit Management
    func getRemainingFreeMessages() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = UserDefaults.standard.object(forKey: "ai_limit_date") as? Date ?? .distantPast
        
        if !Calendar.current.isDate(today, inSameDayAs: lastDate) {
            // Neuer Tag, Zähler zurücksetzen
            UserDefaults.standard.set(0, forKey: "ai_message_count")
            UserDefaults.standard.set(0, forKey: "ai_rewarded_bonus")
            UserDefaults.standard.set(today, forKey: "ai_limit_date")
            return freeDailyLimit
        }
        
        let usedMessages = UserDefaults.standard.integer(forKey: "ai_message_count")
        let rewardedBonus = UserDefaults.standard.integer(forKey: "ai_rewarded_bonus")
        let totalLimit = freeDailyLimit + rewardedBonus
        
        return max(0, totalLimit - usedMessages)
    }
    
    func canSendMessage() -> Bool {
        return getRemainingFreeMessages() > 0
    }
    
    func incrementMessageCount() {
        let count = UserDefaults.standard.integer(forKey: "ai_message_count")
        UserDefaults.standard.set(count + 1, forKey: "ai_message_count")
    }
    
    func addRewardedBonus() {
        let currentBonus = UserDefaults.standard.integer(forKey: "ai_rewarded_bonus")
        UserDefaults.standard.set(currentBonus + rewardedAdBonus, forKey: "ai_rewarded_bonus")
        print("✅ Rewarded Bonus hinzugefügt: +\(rewardedAdBonus) Nachrichten")
    }
    
    // MARK: - Ad Offers
    func checkAndOfferRewardedAd() {
        let remaining = getRemainingFreeMessages()
        
        // Zeige Rewarded Ad Angebot, wenn nur noch 2 Nachrichten übrig sind
        if remaining <= 2 && remaining > 0 {
            showRewardedAdOffer = true
        } else if remaining == 0 {
            showLimitReachedAlert = true
        }
    }
}


