# 📍 Ad-Platzierung in der App - Übersicht

## ✅ Aktuell implementiert:

### 1. **Banner Ads** (Am unteren Rand)
**Ort:** `ChatView.swift` - Zeile 255-262
- **Position:** Am unteren Rand der ChatView, über der Navigation Bar
- **Sichtbarkeit:** Immer sichtbar (wenn Ads aktiviert)
- **Höhe:** 50px
- **Status:** ✅ Implementiert

**Code:**
```swift
.overlay(alignment: .bottom) {
    if adManager.adsEnabled && !adManager.premiumUser {
        BannerAdView()
            .frame(height: 50)
            .padding(.bottom, 49) // Über der Navigation Bar
    }
}
```

### 2. **Rewarded Ads** (Für zusätzliche AI-Nachrichten)
**Ort:** `ChatView.swift` - Zeile 238-249
- **Wann:** Wenn das tägliche Limit (10 Nachrichten) erreicht ist
- **Belohnung:** +5 zusätzliche AI-Nachrichten
- **Status:** ✅ Implementiert

**Code:**
```swift
.alert("Limit erreicht", isPresented: $showRewardedAdAlert) {
    Button("Video ansehen (+5 Nachrichten)") {
        adManager.showRewardedAd { success in
            if success {
                adHelper.addRewardedBonus()
            }
        }
    }
}
```

### 3. **Interstitial Ads** (Nach wichtigen Aktionen)
**Status:** ⚠️ Noch nicht in Views integriert

**Geplante Orte:**
- Nach Medikament hinzufügen (`MedicationsView.swift`)
- Nach Termin erstellen (`AppointmentsView.swift`)
- Nach Impfung hinzufügen (`VaccinationsView.swift`)
- Nach Symptom eingeben (`SymptomInputView.swift`)

## 📋 Wo sollten Ads noch hinzugefügt werden:

### **HomeView** (Hauptbildschirm)
- **Banner Ad:** Am unteren Rand (optional)
- **Interstitial:** Nach Tierprofil erstellen

### **MedicationsView** (Medikamente)
- **Interstitial:** Nach erfolgreichem Hinzufügen eines Medikaments
- **Code hinzufügen:** Nach `healthRecordManager.addMedication(...)`

### **AppointmentsView** (Termine)
- **Interstitial:** Nach erfolgreichem Erstellen eines Termins
- **Code hinzufügen:** Nach `healthRecordManager.addAppointment(...)`

### **VaccinationsView** (Impfungen)
- **Interstitial:** Nach erfolgreichem Hinzufügen einer Impfung
- **Code hinzufügen:** Nach `healthRecordManager.addVaccination(...)`

### **SymptomInputView** (Symptome)
- **Interstitial:** Nach erfolgreichem Eingeben von Symptomen

### **PetProfileView** (Tierprofil)
- **Banner Ad:** Am unteren Rand (optional)

## 🔧 So fügst du Interstitial Ads hinzu:

### Beispiel für MedicationsView:

```swift
// Nach erfolgreichem Speichern:
healthRecordManager.addMedication(newMedication)

// Interstitial Ad zeigen (alle 3-5 Aktionen)
AdManager.shared.showInterstitialAfterAction()
```

### Beispiel für AppointmentsView:

```swift
// Nach erfolgreichem Speichern:
healthRecordManager.addAppointment(newAppointment)

// Interstitial Ad zeigen
AdManager.shared.showInterstitialAfterAction()
```

## 📊 Ad-Strategie:

### Banner Ads:
- **Wo:** ChatView (unten)
- **Einnahmen:** Niedrig, aber konstant
- **UX:** Nicht störend

### Interstitial Ads:
- **Wo:** Nach wichtigen Aktionen
- **Häufigkeit:** Alle 3-5 Aktionen (nicht zu häufig)
- **Einnahmen:** Hoch
- **UX:** Akzeptabel, da nach Aktion

### Rewarded Ads:
- **Wo:** Bei Limit-Erreichung
- **Belohnung:** +5 Nachrichten
- **Einnahmen:** Sehr hoch
- **UX:** Freiwillig, User entscheidet

## 🎯 Aktuelle Ad-Plätze in der App:

1. ✅ **ChatView** - Banner Ad (unten)
2. ✅ **ChatView** - Rewarded Ad (bei Limit)
3. ⚠️ **MedicationsView** - Interstitial (noch nicht hinzugefügt)
4. ⚠️ **AppointmentsView** - Interstitial (noch nicht hinzugefügt)
5. ⚠️ **VaccinationsView** - Interstitial (noch nicht hinzugefügt)
6. ⚠️ **SymptomInputView** - Interstitial (noch nicht hinzugefügt)

## 💡 Empfehlung:

Füge Interstitial Ads zu den wichtigsten Aktionen hinzu:
1. Medikament hinzufügen
2. Termin erstellen
3. Impfung hinzufügen
4. Symptom eingeben

Das maximiert die Einnahmen ohne die UX zu beeinträchtigen.


