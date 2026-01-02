# 🔍 Interstitial Ads Debugging - Problem lösen

## ❌ Problem:
Interstitial Ads funktionieren nicht, aber Banner Ads und Rewarded Ads funktionieren.

## ✅ Was funktioniert:
- ✅ Banner Ads funktionieren → AdMob ist initialisiert
- ✅ Rewarded Ads funktionieren → Firebase Remote Config funktioniert
- ✅ Consent funktioniert

## 🔍 Mögliche Ursachen:

### 1. **Firebase Remote Config: `interstitial_enabled` ist `false`**
**Prüfung:**
- Gehe zu Firebase Console → Remote Config
- Prüfe ob `interstitial_enabled` auf `true` gesetzt ist

**Lösung:**
```
Key: interstitial_enabled
Value: true
Type: Boolean
```

### 2. **Firebase Remote Config: `interstitial_ad_unit_id` fehlt oder ist leer**
**Prüfung:**
- Gehe zu Firebase Console → Remote Config
- Prüfe ob `interstitial_ad_unit_id` gesetzt ist

**Lösung:**
```
Key: interstitial_ad_unit_id
Value: ca-app-pub-3840959679571598/xxxxx (deine AdMob Interstitial Ad Unit ID)
Type: String
```

### 3. **Firebase Remote Config: `interstitial_frequency` ist zu hoch**
**Prüfung:**
- Gehe zu Firebase Console → Remote Config
- Prüfe den Wert von `interstitial_frequency`

**Problem:**
- Wenn `interstitial_frequency = 10`, dann erscheint Interstitial erst nach 10 Klicks!
- Standard sollte `3` sein (alle 3 Klicks)

**Lösung:**
```
Key: interstitial_frequency
Value: 3
Type: Number
```

### 4. **Interstitial Ad wird nicht geladen**
**Prüfung:**
- Öffne Xcode Console
- Suche nach: `"🔄 Lade Interstitial Ad..."` oder `"❌ Interstitial Ad"`
- Prüfe ob Fehler-Meldungen erscheinen

**Mögliche Fehler:**
- `❌ Interstitial Ad: Ad Unit ID ist leer`
- `❌ loadInterstitialAd: interstitial_enabled in Firebase ist false`
- `❌ Interstitial Ad Fehler: ...`

### 5. **Interstitial Ad ist nicht bereit (`isInterstitialReady = false`)**
**Prüfung:**
- Öffne Xcode Console
- Suche nach: `"✅ Interstitial Ad bereit - isInterstitialReady = true"`
- Wenn diese Meldung fehlt, wurde das Ad nicht erfolgreich geladen

---

## 🔧 Schritt-für-Schritt Lösung:

### Schritt 1: Firebase Remote Config prüfen

Gehe zu Firebase Console → Remote Config und prüfe folgende Keys:

#### ✅ MUSS vorhanden sein:
1. **`ads_enabled`** = `true` ✅ (funktioniert, da Banner funktioniert)
2. **`interstitial_enabled`** = `true` ⚠️ **PRÜFEN**
3. **`interstitial_ad_unit_id`** = `ca-app-pub-xxxxx/xxxxx` ⚠️ **PRÜFEN**
4. **`interstitial_frequency`** = `3` ⚠️ **PRÜFEN** (oder niedriger)

#### Optional:
5. **`interstitial_min_interval`** = `60` (Sekunden zwischen Ads)

### Schritt 2: Xcode Console prüfen

1. Öffne Xcode
2. Starte die App im Simulator oder auf einem echten Gerät
3. Öffne die Console (⌘ + Shift + Y)
4. Suche nach folgenden Meldungen:

#### ✅ Erfolgreich geladen:
```
✅ Interstitial Ad erfolgreich geladen
✅ Interstitial Ad bereit - isInterstitialReady = true
```

#### ❌ Fehler-Meldungen:
```
❌ Interstitial Ad: Ad Unit ID ist leer
❌ loadInterstitialAd: interstitial_enabled in Firebase ist false
❌ Interstitial Ad Fehler: ...
⚠️ FEHLER: Interstitial Ad nicht bereit
```

### Schritt 3: Test-Interstitial manuell auslösen

Füge einen Test-Button hinzu, um Interstitial manuell zu testen:

```swift
// In einer View (z.B. SettingsView oder HomeView):
Button("Test Interstitial") {
    print("🔍 Test Interstitial Button geklickt")
    print("   - isInterstitialReady: \(AdManager.shared.isInterstitialReady)")
    print("   - interstitialEnabled: \(AdManager.shared.interstitialEnabled)")
    
    if AdManager.shared.isInterstitialReady {
        AdManager.shared.showInterstitialAd()
    } else {
        print("⚠️ Interstitial nicht bereit - lade Ad...")
        AdManager.shared.loadInterstitialAd()
    }
}
```

### Schritt 4: Firebase Remote Config neu laden

Die App lädt Remote Config automatisch beim App-Start. Falls du Änderungen gemacht hast:

1. **App neu starten** (vollständig schließen und neu öffnen)
2. Oder: App in den Hintergrund bringen und wieder aktivieren (lädt Remote Config neu)

### Schritt 5: Häufigkeit prüfen

Interstitial erscheint nur alle X Klicks (basierend auf `interstitial_frequency`):

- **Frequency = 3**: Nach Klick 3, 6, 9, 12...
- **Frequency = 1**: Nach jedem Klick
- **Frequency = 10**: Erst nach 10 Klicks!

**Test:** Führe mehrere Aktionen aus (Medikament hinzufügen, Termin erstellen, etc.) und zähle die Klicks.

---

## 📋 Checkliste:

- [ ] Firebase Remote Config: `interstitial_enabled` = `true`
- [ ] Firebase Remote Config: `interstitial_ad_unit_id` ist gesetzt (nicht leer)
- [ ] Firebase Remote Config: `interstitial_frequency` = `3` (oder niedriger)
- [ ] Xcode Console zeigt: `✅ Interstitial Ad erfolgreich geladen`
- [ ] Xcode Console zeigt: `✅ Interstitial Ad bereit - isInterstitialReady = true`
- [ ] Mindestens 3 Aktionen ausgeführt (Medikament hinzufügen, Termin erstellen, etc.)
- [ ] App wurde nach Firebase-Änderungen neu gestartet

---

## 🎯 Schnelltest:

### Test 1: Prüfe Firebase Remote Config
```
1. Öffne Firebase Console
2. Gehe zu Remote Config
3. Prüfe diese 3 Keys:
   - interstitial_enabled = true ✅
   - interstitial_ad_unit_id = ca-app-pub-xxxxx/xxxxx ✅
   - interstitial_frequency = 3 ✅
```

### Test 2: Prüfe Xcode Console
```
1. Öffne Xcode Console
2. Starte die App
3. Suche nach:
   - "✅ Interstitial Ad erfolgreich geladen" ✅
   - Oder: "❌ Interstitial Ad..." ❌
```

### Test 3: Teste manuell
```
1. Führe 3 Aktionen aus:
   - Medikament hinzufügen
   - Termin erstellen
   - Impfung hinzufügen
2. Nach der 3. Aktion sollte Interstitial erscheinen
```

---

## 💡 Häufigste Probleme:

### Problem 1: `interstitial_enabled` ist `false`
**Symptom:** Banner funktioniert, Interstitial nicht
**Lösung:** Setze `interstitial_enabled` auf `true` in Firebase

### Problem 2: `interstitial_ad_unit_id` ist leer
**Symptom:** Console zeigt: `❌ Interstitial Ad: Ad Unit ID ist leer`
**Lösung:** Füge `interstitial_ad_unit_id` in Firebase Remote Config hinzu

### Problem 3: `interstitial_frequency` ist zu hoch
**Symptom:** Interstitial erscheint nicht nach 3 Klicks
**Lösung:** Setze `interstitial_frequency` auf `3` oder `1` in Firebase

### Problem 4: Ad wird nicht geladen
**Symptom:** Console zeigt Fehler beim Laden
**Lösung:** Prüfe AdMob Dashboard → Ad Unit ID ist korrekt

---

## 🔧 Debug-Code hinzufügen:

Füge diesen Code in `AdManager.swift` ein, um mehr Debug-Informationen zu sehen:

```swift
func printInterstitialDebugInfo() {
    print("🔍 ========== INTERSTITIAL DEBUG INFO ==========")
    print("   - adsEnabled: \(adsEnabled)")
    print("   - adsEnabledRemote: \(adsEnabledRemote)")
    print("   - interstitialEnabled: \(interstitialEnabled)")
    print("   - interstitialAdUnitID: \(interstitialAdUnitID)")
    print("   - interstitialFrequency: \(interstitialFrequency)")
    print("   - isInterstitialReady: \(isInterstitialReady)")
    print("   - interstitialAd vorhanden: \(interstitialAd != nil)")
    print("   - actionButtonClickCount: \(actionButtonClickCount)")
    print("   - consentManager.canShowAds(): \(consentManager.canShowAds())")
    print("🔍 ============================================")
}
```

Rufe diese Funktion auf, um den Status zu prüfen:
```swift
AdManager.shared.printInterstitialDebugInfo()
```

---

## ✅ Wenn alles korrekt ist:

Wenn alle Firebase Remote Config Keys korrekt gesetzt sind und die Console keine Fehler zeigt, sollte Interstitial nach der 3. Aktion erscheinen.

**Test:** Führe 3 Aktionen aus (z.B. Medikament hinzufügen, Termin erstellen, Impfung hinzufügen) und prüfe ob Interstitial nach der 3. Aktion erscheint.

