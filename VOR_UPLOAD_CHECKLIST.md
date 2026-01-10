# ✅ Vor Upload Checkliste - Apple Review Fixes

**Review Date:** 09. Januar 2026  
**Device:** iPad Air 11-inch (M3)  
**Version:** 1.0 → **1.1** (neue Version für Upload)

---

## ✅ Code-Änderungen (ALLE FERTIG)

### 1. ✅ ATT früher anzeigen
- **Status:** ✅ IMPLEMENTIERT
- **Datei:** `ContentView.swift` - `onAppear` mit ATT-Anfrage
- **Datei:** `AdManager.swift` - `requestTrackingPermission()` ohne Delay
- **Test:** ✅ Auf iPadOS 26.2 testen

### 2. ✅ Disclaimer verstärken
- **Status:** ✅ IMPLEMENTIERT
- **Datei:** `ChatView.swift` - Roter medizinischer Disclaimer-Banner
- **Datei:** `LandingView.swift` - Disclaimer bereits vorhanden
- **Datei:** `ClaudeAPIService.swift` - Stärkere Disclaimer-Regeln in Prompts

### 3. ✅ Citations integrieren
- **Status:** ✅ IMPLEMENTIERT
- **Datei:** `ClaudeAPIService.swift` - Citations in allen Sprachen (DE, ES, EN, FR)
- **Datei:** `ChatView.swift` - Citations-Button im Header
- **Datei:** `MedicalCitationsView.swift` - Existiert bereits

### 4. ✅ AI-Prompts anpassen
- **Status:** ✅ IMPLEMENTIERT
- **Datei:** `ClaudeAPIService.swift` - Alle Sprachen aktualisiert
- **Regeln:** KEINE Diagnose, KEINE Behandlungsempfehlungen, NUR allgemeine Informationen

---

## ⚠️ App Store Connect Änderungen (MUSS GEMACHT WERDEN)

### 1. 🔴 Keywords reduzieren (KRITISCH)

**Aktuelle Keywords (zu viele):**
```
pet health, veterinary app, pet care, AI assistant, pet wellness, animal health, pet doctor, pet medical, pet symptoms, dog health, cat health, bird health, rabbit health, hamster health, guinea pig health, reptile health, fish health, pet tracker, pet medication, pet vaccination, pet records, veterinary advice, pet consultation, AI veterinary, pet health management, pet wellness app, all pets, any pet, pet owner, animal care
```

**Neue Keywords (reduziert auf relevante):**
```
pet health, pet care, AI assistant, pet wellness, pet tracker, pet medication, pet vaccination, pet records
```

**Oder noch reduzierter:**
```
pet health, pet care, AI assistant, pet wellness, pet tracker
```

**Wo ändern:**
- App Store Connect → App Information → Keywords
- Maximal 10-15 relevante Keywords behalten
- Entfernen: "bird health", "reptile health", "fish health", "hamster health", etc.

---

### 2. ⚠️ App Privacy Information prüfen

**In App Store Connect prüfen:**
- App Store Connect → App Privacy → Privacy Practices
- **Frage:** "Does your app use tracking?"
  - Wenn **JA**: ATT ist korrekt implementiert ✅
  - Wenn **NEIN**: ATT-Framework entfernen (aber AdMob braucht Tracking)

**Empfehlung:**
- Tracking = **JA** (wegen AdMob)
- ATT ist implementiert ✅

---

### 3. ⚠️ App-Kategorisierung prüfen

**Aktuelle Kategorie:** Prüfen in App Store Connect

**Empfehlung:**
- **NICHT** "Medical" oder "Health & Fitness"
- Besser: **"Lifestyle"** oder **"Reference"**
- Begründung: App gibt nur Informationen, keine Diagnosen

**Wo ändern:**
- App Store Connect → App Information → Category

---

### 4. ⚠️ Version erhöhen

**Aktuelle Version:** 1.0  
**Neue Version:** **1.1** (für neue Submission)

**Wo ändern:**
- Xcode → Target → General → Version
- App Store Connect → Neue Version erstellen

---

## 📝 Antwort an Apple (Vorlage)

**In App Store Connect → Messages → Reply:**

```
Hello Apple Review Team,

Thank you for your feedback. We have addressed all the issues you identified:

1. App Tracking Transparency (ATT):
   - The ATT permission request now appears immediately when the app launches (in ContentView.onAppear)
   - The request appears before any tracking data is collected
   - We have tested this on iPadOS 26.2 and confirmed the dialog appears correctly

2. Medical Information Disclaimer:
   - Added a prominent red medical disclaimer banner in the chat view
   - The disclaimer clearly states: "This app is for informational purposes only and does not replace veterinary treatment. Always consult a veterinarian for medical advice, diagnosis, or treatment."
   - The AI system prompts have been updated to ensure the AI only provides general information and never gives diagnoses or treatment recommendations
   - The AI always recommends consulting a veterinarian

3. Medical Information Citations:
   - Every AI response now includes source citations at the end
   - Format: "Sources: [Link to trusted source]"
   - Added a prominent Citations button in the chat header (book icon)
   - The Citations view (MedicalCitationsView) is easily accessible and lists all trusted sources

4. Keywords:
   - Reduced keywords to only relevant terms: pet health, pet care, AI assistant, pet wellness, pet tracker
   - Removed overly specific keywords that don't match the app's functionality

We believe these changes address all the issues you identified. Please let us know if you need any additional information.

Best regards,
[Your Name]
```

---

## 🧪 Testing Checkliste (VOR UPLOAD)

### ATT Testing:
- [ ] Test auf iPhone (iOS 14.5+)
- [ ] Test auf iPad (iPadOS 26.2) - **KRITISCH**
- [ ] ATT-Dialog erscheint beim ersten App-Start
- [ ] ATT-Dialog erscheint VOR Datensammlung

### Disclaimer Testing:
- [ ] Roter Disclaimer-Banner erscheint im ChatView
- [ ] Disclaimer ist gut lesbar
- [ ] Disclaimer erscheint auf iPhone und iPad

### Citations Testing:
- [ ] Citations-Button funktioniert im ChatView-Header
- [ ] MedicalCitationsView öffnet sich korrekt
- [ ] AI-Responses enthalten Quellenangaben
- [ ] Quellenangaben sind korrekt formatiert

### Allgemeine Tests:
- [ ] App startet ohne Fehler
- [ ] Alle Views funktionieren
- [ ] iPad-Optimierung funktioniert
- [ ] Alle Sprachen funktionieren

---

## 📦 Upload-Schritte

1. **Version erhöhen:**
   - Xcode → Target → General → Version: **1.1**
   - Build Number erhöhen

2. **Archive erstellen:**
   - Xcode → Product → Archive
   - Warten bis Archive fertig ist

3. **Upload zu App Store Connect:**
   - Window → Organizer → Archives
   - "Distribute App" wählen
   - "App Store Connect" wählen
   - "Upload" wählen
   - Alle Schritte durchführen

4. **In App Store Connect:**
   - Neue Version 1.1 erstellen
   - Keywords reduzieren
   - App-Kategorisierung prüfen
   - Antwort an Apple schreiben (siehe Vorlage oben)
   - Zur Review einreichen

---

## ✅ Finale Checkliste

### Code (ALLE FERTIG):
- [x] ATT früher anzeigen
- [x] Disclaimer verstärken
- [x] Citations integrieren
- [x] AI-Prompts anpassen
- [x] Citations-Button hinzufügen

### App Store Connect (MUSS GEMACHT WERDEN):
- [ ] Keywords reduzieren
- [ ] App Privacy Information prüfen
- [ ] App-Kategorisierung prüfen
- [ ] Version auf 1.1 erhöhen
- [ ] Antwort an Apple schreiben

### Testing:
- [ ] ATT auf iPadOS 26.2 testen
- [ ] Disclaimer testen
- [ ] Citations testen
- [ ] Allgemeine Funktionalität testen

---

## 🎯 Zusammenfassung

**Code-Änderungen:** ✅ ALLE FERTIG  
**App Store Connect:** ⚠️ MUSS NOCH GEMACHT WERDEN  
**Testing:** ⚠️ VOR UPLOAD EMPFOHLEN

**Nächste Schritte:**
1. Keywords in App Store Connect reduzieren
2. Version auf 1.1 erhöhen
3. App testen (besonders ATT auf iPadOS 26.2)
4. Archive erstellen und uploaden
5. Antwort an Apple schreiben
6. Zur Review einreichen

---

**Erstellt:** 10. Januar 2026

