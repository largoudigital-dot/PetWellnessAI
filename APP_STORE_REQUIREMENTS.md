# App Store Veröffentlichung - Anforderungen für Europa & USA

## 📋 Übersicht der benötigten Dokumente und Assets

### ✅ Bereits implementiert:
- ✅ Privacy Policy View (PrivacyPolicyView.swift)
- ✅ Terms of Service View (TermsOfServiceView.swift)
- ✅ Medical Disclaimer (in ChatView und LandingView)
- ✅ Logo in Assets

---

## 🇪🇺 Europa (App Store Connect - EU)

### 1. **Rechtliche Dokumente (Pflicht)**

#### Privacy Policy (Datenschutzerklärung)
- ✅ **Implementiert**: `PrivacyPolicyView.swift`
- ⚠️ **Benötigt**: URL zur Online-Version
- **Inhalt muss enthalten**:
  - Welche Daten werden gesammelt (Haustierdaten, Symptome, Fotos)
  - Wie werden Daten gespeichert (lokal in UserDefaults)
  - Werden Daten geteilt? (Nein, außer Groq API für Chat)
  - Nutzerrechte (DSGVO-konform)
  - Kontaktinformationen

#### Terms of Service (Nutzungsbedingungen)
- ✅ **Implementiert**: `TermsOfServiceView.swift`
- ⚠️ **Benötigt**: URL zur Online-Version
- **Inhalt muss enthalten**:
  - Medizinischer Disclaimer (KEINE Diagnose)
  - Haftungsausschluss
  - Nutzungsbedingungen
  - Änderungsvorbehalt

#### Datenschutzerklärung (DSGVO-konform)
- ✅ **Implementiert**: In PrivacyPolicyView
- **Wichtig für DSGVO**:
  - Recht auf Auskunft
  - Recht auf Löschung
  - Recht auf Datenübertragbarkeit
  - Widerspruchsrecht

### 2. **App Store Connect Einstellungen**

#### App Information
- App Name: "AI Tierarzt" (oder "Veterinario IA")
- Subtitle: Professionelle Gesundheitsberatung für Ihr Haustier
- Category: Medical / Health & Fitness
- Age Rating: 4+ (oder höher, je nach Inhalt)

#### Privacy Policy URL
- **Benötigt**: HTTPS-URL zu Ihrer Privacy Policy
- Beispiel: `https://ihre-domain.com/privacy-policy`
- Muss öffentlich zugänglich sein

#### Support URL
- **Benötigt**: HTTPS-URL zu Support/Kontakt
- Beispiel: `https://ihre-domain.com/support`

#### Marketing URL (optional)
- Website der App

### 3. **App Privacy Details (App Store Connect)**

#### Datentypen, die gesammelt werden:
1. **Haustierdaten** (Name, Alter, Rasse)
   - Zweck: App-Funktionalität
   - Verknüpft mit Benutzer: Nein
   - Verwendet für Tracking: Nein

2. **Gesundheitsdaten** (Symptome, Medikamente, Termine)
   - Zweck: App-Funktionalität
   - Verknüpft mit Benutzer: Nein
   - Verwendet für Tracking: Nein

3. **Fotos** (Haustier-Fotos)
   - Zweck: App-Funktionalität
   - Verknüpft mit Benutzer: Nein
   - Verwendet für Tracking: Nein

4. **Chat-Nachrichten** (an Groq API)
   - Zweck: AI-Chat-Funktionalität
   - Verknüpft mit Benutzer: Nein
   - Verwendet für Tracking: Nein
   - **WICHTIG**: Groq API Privacy Policy beachten

#### Tracking
- **Wird Tracking verwendet?**: Nein
- Keine Analytics, keine Werbung, keine Third-Party-Tracking

### 4. **Berechtigungen (Permissions)**

#### Kamera (optional)
- Zweck: Foto-Analyse
- Privacy Description: "Wir benötigen Zugriff auf Ihre Kamera, um Fotos Ihres Haustieres für die Analyse aufzunehmen."

#### Foto-Bibliothek (optional)
- Zweck: Foto-Analyse
- Privacy Description: "Wir benötigen Zugriff auf Ihre Foto-Bibliothek, um Fotos Ihres Haustieres für die Analyse auszuwählen."

#### Benachrichtigungen
- Zweck: Erinnerungen für Medikamente, Termine, Impfungen
- Privacy Description: "Wir senden Ihnen Erinnerungen für Medikamente, Tierarzt-Termine und Impfungen."

---

## 🇺🇸 USA (App Store Connect - USA)

### 1. **Rechtliche Dokumente (Pflicht)**

#### Privacy Policy
- ✅ **Implementiert**: `PrivacyPolicyView.swift`
- ⚠️ **Benötigt**: URL zur Online-Version
- **Muss enthalten** (CCPA-konform):
  - Welche Daten werden gesammelt
  - Wie werden Daten verwendet
  - Werden Daten verkauft? (Nein)
  - Nutzerrechte (Kalifornien CCPA)

#### Terms of Service
- ✅ **Implementiert**: `TermsOfServiceView.swift`
- ⚠️ **Benötigt**: URL zur Online-Version
- **Muss enthalten**:
  - Medizinischer Disclaimer (HIPAA beachten)
  - Haftungsausschluss
  - Nutzungsbedingungen

### 2. **App Store Connect Einstellungen**

#### App Information
- App Name: "AI Veterinarian" (oder "Veterinario IA")
- Subtitle: Professional health consultation for your pet
- Category: Medical / Health & Fitness
- Age Rating: 4+ (oder höher)

#### Privacy Policy URL
- **Benötigt**: HTTPS-URL
- Muss öffentlich zugänglich sein

#### Support URL
- **Benötigt**: HTTPS-URL

### 3. **App Privacy Details**

#### Datentypen (wie oben)
- Gleiche Angaben wie für Europa

#### Tracking
- **Wird Tracking verwendet?**: Nein

### 4. **Berechtigungen (Permissions)**
- Gleiche wie für Europa

---

## 📝 Checkliste für Veröffentlichung

### Vor der Einreichung:

- [ ] **Privacy Policy online veröffentlichen**
  - URL erstellen (z.B. auf Ihrer Website)
  - In App Store Connect eintragen
  - In App verlinken (SettingsView)

- [ ] **Terms of Service online veröffentlichen**
  - URL erstellen
  - In App Store Connect eintragen
  - In App verlinken (SettingsView)

- [ ] **App Store Connect konfigurieren**
  - App Information ausfüllen
  - Privacy Policy URL eintragen
  - Support URL eintragen
  - App Privacy Details ausfüllen
  - Screenshots erstellen (verschiedene Geräte)
  - App Icon (1024x1024px)

- [ ] **App Assets**
  - [x] Logo in Assets vorhanden
  - [ ] App Icon (1024x1024px)
  - [ ] Screenshots für verschiedene Geräte
  - [ ] App Preview Video (optional)

- [ ] **Testen**
  - App auf verschiedenen Geräten testen
  - Privacy Policy und Terms in App testen
  - Alle Features testen

- [ ] **Developer Account**
  - Apple Developer Account (99$/Jahr)
  - App Store Connect Zugang

---

## 🔗 Integration in SettingsView

Die Privacy Policy und Terms of Service sollten in SettingsView verlinkt werden:

```swift
// In SettingsView.swift
Section("legal.title".localized) {
    NavigationLink(destination: PrivacyPolicyView()) {
        Label("legal.privacy".localized, systemImage: "hand.raised.fill")
    }
    
    NavigationLink(destination: TermsOfServiceView()) {
        Label("legal.terms".localized, systemImage: "doc.text.fill")
    }
}
```

---

## ⚠️ Wichtige Hinweise

### Medizinischer Disclaimer
- ✅ Bereits implementiert in ChatView und LandingView
- ⚠️ Muss auch in Terms of Service prominent sein
- ⚠️ App Store kann Apps mit medizinischem Inhalt strenger prüfen

### Groq API
- ⚠️ Privacy Policy von Groq beachten
- ⚠️ In Ihrer Privacy Policy erwähnen, dass Chat-Nachrichten an Groq API gesendet werden
- ⚠️ Groq API Terms of Service beachten

### DSGVO (Europa)
- ✅ Recht auf Auskunft implementiert (PrivacyPolicyView)
- ✅ Recht auf Löschung (Daten werden lokal gespeichert, können gelöscht werden)
- ⚠️ Kontakt-E-Mail für Datenschutzanfragen bereitstellen

### CCPA (Kalifornien, USA)
- ✅ Ähnliche Rechte wie DSGVO
- ⚠️ "Do Not Sell My Data" Option (nicht nötig, da keine Daten verkauft werden)

---

## 📧 Kontakt für Datenschutz

In Privacy Policy muss eine Kontakt-E-Mail angegeben werden:
- Beispiel: `privacy@ihre-domain.com`
- Oder: `datenschutz@ihre-domain.com`

---

## 🚀 Nächste Schritte

1. **Privacy Policy & Terms online veröffentlichen**
   - Website erstellen oder bestehende nutzen
   - Dokumente als HTML/PDF veröffentlichen
   - HTTPS-URLs erstellen

2. **SettingsView erweitern**
   - Links zu Privacy Policy und Terms hinzufügen
   - LocalizedStrings hinzufügen

3. **App Store Connect vorbereiten**
   - Alle Informationen sammeln
   - Screenshots erstellen
   - App Icon vorbereiten

4. **Testen**
   - App gründlich testen
   - Privacy Policy und Terms in App testen

5. **Einreichen**
   - App in App Store Connect hochladen
   - Review-Prozess durchlaufen


