# 🎁 Rewarded Ads - Übersicht

## ✅ Wo Rewarded Ads angezeigt werden:

### 1. **ChatView.swift** - Automatisch nach bestimmten Chat-Nachrichten
- **Funktion**: `AdManager.shared.incrementChatMessageCount()`
- **Wann**: Nach jeder gesendeten Chat-Nachricht
- **Logik**: 
  - Zeigt Rewarded Ad automatisch nach bestimmten Nachrichten (konfigurierbar über Firebase)
  - Standard: Nach Nachricht 3, 4, 5 (erste Shows)
  - Danach: Alle X Nachrichten (konfigurierbar über Firebase)

### 2. **ChatView.swift** - Bei Limit-Erreichung
- **Funktion**: `AdHelper.shared.checkAndOfferRewardedAd()`
- **Wann**: 
  - Wenn nur noch 2 Nachrichten übrig sind → Zeigt Angebot
  - Wenn Limit erreicht ist (0 Nachrichten) → Zeigt Alert
- **Belohnung**: +5 zusätzliche AI-Nachrichten
- **Status**: ✅ Implementiert

---

## 🔧 Wie funktioniert es?

### Funktion: `incrementChatMessageCount()`
- **Ort**: `AdManager.swift` (Zeile 1104)
- **Funktion**: 
  - Zählt alle Chat-Nachrichten
  - Zeigt Rewarded Ad automatisch nach bestimmten Nachrichten
  - Belohnung: +5 Nachrichten werden automatisch hinzugefügt

### Funktion: `showRewardedAd()`
- **Ort**: `AdManager.swift` (Zeile 1025)
- **Funktion**: 
  - Zeigt Rewarded Ad Video
  - Nach erfolgreichem Ansehen: Belohnung wird vergeben
  - Belohnung: +5 zusätzliche Nachrichten

### Funktion: `addRewardedBonus()`
- **Ort**: `AdHelper.swift` (Zeile 52)
- **Funktion**: 
  - Fügt +5 Nachrichten zum täglichen Limit hinzu
  - Wird automatisch aufgerufen nach erfolgreichem Ansehen des Rewarded Ads

---

## 📊 Firebase Remote Config Einstellungen:

### Rewarded Ad Konfiguration:
- **`rewarded_enabled`**: Aktiviert/deaktiviert Rewarded Ads
- **`rewarded_ad_unit_id`**: AdMob Ad Unit ID für Rewarded Ads
- **`rewarded_ad_frequency`**: Nach wie vielen Nachrichten soll Ad erscheinen (z.B. 5 = alle 5 Nachrichten)
- **`rewarded_ad_first_shows`**: Komma-getrennte Liste der ersten Nachrichten, bei denen Ad erscheinen soll (z.B. "3,4,5")

### Beispiel-Konfiguration:
```
rewarded_enabled: true
rewarded_ad_unit_id: ca-app-pub-xxxxx/xxxxx
rewarded_ad_frequency: 5
rewarded_ad_first_shows: "3,4,5"
```

### Beispiel-Verhalten:
```
Nachricht 1: Kein Ad
Nachricht 2: Kein Ad
Nachricht 3: ✅ Rewarded Ad wird automatisch angezeigt → +5 Nachrichten
Nachricht 4: ✅ Rewarded Ad wird automatisch angezeigt → +5 Nachrichten
Nachricht 5: ✅ Rewarded Ad wird automatisch angezeigt → +5 Nachrichten
Nachricht 6: Kein Ad
Nachricht 7: Kein Ad
Nachricht 8: Kein Ad
Nachricht 9: Kein Ad
Nachricht 10: ✅ Rewarded Ad wird automatisch angezeigt (alle 5) → +5 Nachrichten
```

---

## 🎯 Limit-Management:

### Tägliches Limit:
- **Kostenlose Nachrichten**: 10 pro Tag
- **Rewarded Bonus**: +5 Nachrichten pro Rewarded Ad
- **Gesamt**: 10 + (Anzahl Rewarded Ads × 5)

### AdHelper Funktionen:
- **`getRemainingFreeMessages()`**: Gibt verbleibende Nachrichten zurück
- **`canSendMessage()`**: Prüft ob noch Nachrichten verfügbar sind
- **`incrementMessageCount()`**: Erhöht Zähler nach gesendeter Nachricht
- **`addRewardedBonus()`**: Fügt +5 Nachrichten hinzu
- **`checkAndOfferRewardedAd()`**: Prüft ob Rewarded Ad Angebot gezeigt werden soll

---

## 📍 Implementierungs-Details:

### ChatView.swift:
```swift
// Nach jeder gesendeten Nachricht:
AdManager.shared.incrementChatMessageCount()

// Prüft Limit und zeigt Angebot:
AdHelper.shared.checkAndOfferRewardedAd()

// Zeigt Rewarded Ad bei Limit:
.alert("Limit erreicht", isPresented: $showLimitReachedAlert) {
    Button("Video ansehen (+5 Nachrichten)") {
        AdManager.shared.showRewardedAd { success in
            if success {
                AdHelper.shared.addRewardedBonus()
            }
        }
    }
}
```

### AdManager.swift:
```swift
// Automatisch nach bestimmten Nachrichten:
func incrementChatMessageCount() {
    chatMessageCount += 1
    
    // Prüfe ob in "erste Shows" Liste
    if rewardedAdFirstShows.contains(chatMessageCount) {
        showRewardedAd { success in
            if success {
                // Belohnung wird automatisch vergeben
            }
        }
    }
    
    // Prüfe ob Frequenz erreicht ist
    if chatMessageCount % rewardedAdFrequency == 0 {
        showRewardedAd { success in
            if success {
                // Belohnung wird automatisch vergeben
            }
        }
    }
}
```

---

## ✅ Status:

### ✅ Implementiert:
- Rewarded Ads werden automatisch nach bestimmten Chat-Nachrichten angezeigt
- Rewarded Ads werden beim App-Start geladen
- Belohnung (+5 Nachrichten) wird automatisch vergeben
- Limit-Management funktioniert korrekt
- Frequenz wird über Firebase Remote Config gesteuert

### ⚠️ Zu prüfen:
- Firebase Remote Config: `rewarded_enabled` muss `true` sein
- Firebase Remote Config: `rewarded_ad_unit_id` muss gesetzt sein
- Firebase Remote Config: `rewarded_ad_frequency` sollte gesetzt sein (Standard: 5)
- Firebase Remote Config: `rewarded_ad_first_shows` sollte gesetzt sein (Standard: "3,4,5")

---

## 🎯 Zusammenfassung:

**Rewarded Ads sind vollständig implementiert** und funktionieren auf zwei Arten:

1. **Automatisch**: Nach bestimmten Chat-Nachrichten (konfigurierbar über Firebase)
2. **Bei Limit**: Wenn das tägliche Limit erreicht ist (10 Nachrichten)

**Belohnung**: +5 zusätzliche AI-Nachrichten pro Rewarded Ad

Die Häufigkeit wird über Firebase Remote Config gesteuert, sodass du die Frequenz jederzeit anpassen kannst, ohne die App zu aktualisieren.


