# AdMob Integration Anleitung

## 📋 Übersicht

Diese App verwendet Google AdMob für:
- **Banner Ads**: Am unteren Rand der ChatView
- **Interstitial Ads**: Nach wichtigen Aktionen (Medikament hinzufügen, Termin erstellen, etc.)
- **Rewarded Ads**: Für zusätzliche AI-Nachrichten (5 Bonus-Nachrichten pro Video)

## 🚀 Setup-Schritte

### 1. AdMob Account erstellen
1. Gehe zu https://admob.google.com/
2. Erstelle ein Google AdMob Konto
3. Füge deine App hinzu (iOS App)

### 2. Ad Unit IDs erstellen
1. In AdMob Dashboard: **Apps** → **Ad Units**
2. Erstelle 3 Ad Units:
   - **Banner Ad**: Name z.B. "Banner - Chat"
   - **Interstitial Ad**: Name z.B. "Interstitial - Actions"
   - **Rewarded Ad**: Name z.B. "Rewarded - AI Messages"

### 3. Ad Unit IDs in App einfügen
Öffne `AdManager.swift` und ersetze die Test-IDs:

```swift
private let bannerAdUnitID = "ca-app-pub-XXXXXXXXXX/XXXXXXXXXX" // Deine echte ID
private let interstitialAdUnitID = "ca-app-pub-XXXXXXXXXX/XXXXXXXXXX" // Deine echte ID
private let rewardedAdUnitID = "ca-app-pub-XXXXXXXXXX/XXXXXXXXXX" // Deine echte ID
```

### 4. GoogleMobileAds Framework hinzufügen
1. Öffne dein Xcode-Projekt
2. Gehe zu **File** → **Add Packages...**
3. Füge hinzu: `https://github.com/googleads/swift-package-manager-google-mobile-ads.git`
4. Wähle Version: **Latest** oder **10.0.0+**

### 5. Info.plist aktualisieren
Füge deine AdMob App ID hinzu:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXX~XXXXXXXXXX</string>
```

Die App ID findest du in AdMob Dashboard unter **Apps** → **App Settings**

### 6. Interstitial Ads nach Aktionen hinzufügen

In `MedicationsView.swift`, `AppointmentsView.swift`, `VaccinationsView.swift`:

Nach erfolgreichem Hinzufügen:
```swift
// Nach dem Speichern
if AdManager.shared.shouldShowInterstitial() {
    AdManager.shared.showInterstitialAd()
}
```

## 💰 Monetarisierungs-Strategie

### Banner Ads
- **Platzierung**: Am unteren Rand der ChatView
- **Einnahmen**: Niedrig, aber konstant
- **UX**: Nicht störend

### Interstitial Ads
- **Platzierung**: Nach wichtigen Aktionen
  - Medikament hinzufügen
  - Termin erstellen
  - Impfung hinzufügen
  - Symptom eingeben
- **Häufigkeit**: Alle 3-5 Aktionen (nicht zu aufdringlich)
- **Einnahmen**: Hoch
- **UX**: Akzeptabel, da nach Aktion

### Rewarded Ads
- **Platzierung**: Wenn Limit erreicht
- **Belohnung**: +5 zusätzliche AI-Nachrichten
- **Einnahmen**: Sehr hoch
- **UX**: Freiwillig, User entscheidet

## 📊 Best Practices

### AdMob Richtlinien beachten:
1. ✅ **Nicht zu viele Ads**: Maximal 1 Interstitial pro Minute
2. ✅ **Nicht beim App-Start**: Schlechte UX
3. ✅ **Nicht in kritischen Flows**: Nicht während Eingabe
4. ✅ **Klare Trennung**: Ads klar als Werbung markiert
5. ✅ **User-Kontrolle**: Rewarded Ads sind freiwillig

### Optimale Platzierung:
- ✅ Nach erfolgreichen Aktionen (User ist zufrieden)
- ✅ Zwischen Screens (natürliche Pause)
- ✅ Bei Limit-Erreichung (Rewarded Ads)
- ❌ Nicht beim App-Start
- ❌ Nicht während Eingabe
- ❌ Nicht zu häufig (max. 1/Minute)

## 🎯 Erwartete Einnahmen

### Pro 1000 User (täglich):
- **Banner Ads**: ~$2-5/Tag
- **Interstitial Ads**: ~$10-20/Tag
- **Rewarded Ads**: ~$5-15/Tag
- **Gesamt**: ~$17-40/Tag = ~$500-1200/Monat

*Hinweis: Einnahmen variieren stark je nach:
- User-Engagement
- Geografische Lage
- Ad-Fill-Rate
- Ad-Format*

## 🔧 Testing

### Test Ads verwenden:
Die App verwendet standardmäßig Test-IDs, die automatisch Test-Anzeigen zeigen.

### Echte Ads testen:
1. Erstelle Test-Geräte in AdMob Dashboard
2. Füge deine Geräte-ID hinzu
3. Teste mit echten Ads (aber keine Einnahmen)

## 📱 Premium-Option (Optional)

Du kannst eine Premium-Version ohne Ads anbieten:
- Setze `AdManager.shared.premiumUser = true`
- Oder in Settings: Toggle für "Ads deaktivieren"

## ⚠️ Wichtige Hinweise

1. **AdMob Account**: Muss mindestens 18 Jahre alt sein
2. **App Store**: Apps mit Ads müssen in App Store Guidelines erfüllen
3. **Datenschutz**: AdMob benötigt Privacy Policy
4. **Testen**: Immer mit Test-IDs testen, bevor echte IDs verwendet werden

## 🆘 Support

- AdMob Support: https://support.google.com/admob
- AdMob Forum: https://groups.google.com/forum/#!forum/admob-ads-sdk
- Dokumentation: https://developers.google.com/admob/ios


