# App Privacy Details - Schritt-für-Schritt Anleitung

## 📋 Was sind App Privacy Details?

App Privacy Details sind detaillierte Angaben darüber, welche Daten deine App sammelt und wie sie verwendet werden. **Apple verlangt diese Angaben seit iOS 14** und sie sind **Pflicht für die App Store Veröffentlichung**.

## 🎯 Warum ist das wichtig?

- ✅ **App Store Connect verlangt es** - Ohne diese Angaben kannst du die App nicht einreichen
- ✅ **Transparenz für Nutzer** - Nutzer sehen vor dem Download, welche Daten gesammelt werden
- ✅ **DSGVO/GDPR Compliance** - Erfüllt Datenschutzanforderungen

---

## 📱 Schritt-für-Schritt Anleitung in Xcode

### Schritt 1: Xcode öffnen
1. Öffne dein Projekt: `AI Tierarzt.xcodeproj`
2. Wähle das **Target "AI Tierarzt"** in der linken Seitenleiste

### Schritt 2: App Privacy öffnen
1. Klicke oben auf den Tab **"Signing & Capabilities"**
2. Scrolle nach unten zu **"App Privacy"**
3. Klicke auf **"Add Privacy Type"** oder **"+"** Button

### Schritt 3: Datentypen hinzufügen

Für **PetWellness AI** musst du folgende Datentypen hinzufügen:

#### 1. **Health & Fitness** (Pet Health Records)
- **Warum**: Die App speichert Gesundheitsdaten von Haustieren
- **Einstellungen**:
  - ✅ **Collected**: Ja
  - ✅ **Used for App Functionality**: Ja
  - ✅ **Linked to User**: Nein (lokal gespeichert)
  - ✅ **Used for Tracking**: Nein
  - ✅ **Collected in App**: Ja

#### 2. **Photos** (Pet Photos)
- **Warum**: Die App speichert und analysiert Fotos von Haustieren
- **Einstellungen**:
  - ✅ **Collected**: Ja
  - ✅ **Used for App Functionality**: Ja
  - ✅ **Linked to User**: Nein
  - ✅ **Used for Tracking**: Nein
  - ✅ **Collected in App**: Ja

#### 3. **User Content** (Chat Messages)
- **Warum**: Die App verarbeitet Chat-Nachrichten für AI-Beratung
- **Einstellungen**:
  - ✅ **Collected**: Ja
  - ✅ **Used for App Functionality**: Ja
  - ✅ **Linked to User**: Nein
  - ✅ **Used for Tracking**: Nein
  - ✅ **Collected in App**: Ja

#### 4. **Device ID** (für AdMob)
- **Warum**: AdMob verwendet Device ID für Werbung
- **Einstellungen**:
  - ✅ **Collected**: Ja
  - ✅ **Used for Third-Party Advertising**: Ja
  - ✅ **Linked to User**: Nein
  - ✅ **Used for Tracking**: Ja (wenn User zustimmt)
  - ✅ **Collected in App**: Ja

#### 5. **Advertising Data** (für AdMob)
- **Warum**: AdMob sammelt Werbedaten
- **Einstellungen**:
  - ✅ **Collected**: Ja
  - ✅ **Used for Third-Party Advertising**: Ja
  - ✅ **Linked to User**: Nein
  - ✅ **Used for Tracking**: Ja (wenn User zustimmt)
  - ✅ **Collected in App**: Ja

#### 6. **Product Interaction** (Optional - für Analytics)
- **Warum**: Falls du später Analytics hinzufügst
- **Einstellungen**:
  - ✅ **Collected**: Ja (optional)
  - ✅ **Used for App Functionality**: Ja
  - ✅ **Linked to User**: Nein
  - ✅ **Used for Tracking**: Nein
  - ✅ **Collected in App**: Ja

---

## 🔍 Detaillierte Konfiguration pro Datentyp

### Für jeden Datentyp musst du angeben:

1. **Collected** (Wird gesammelt?)
   - ✅ **Ja** - Die App sammelt diesen Datentyp
   - ❌ **Nein** - Die App sammelt diesen Datentyp nicht

2. **Purposes** (Zwecke)
   - ✅ **App Functionality** - Für App-Funktionalität
   - ✅ **Analytics** - Für Analyse (falls verwendet)
   - ✅ **Third-Party Advertising** - Für Werbung (AdMob)
   - ✅ **Developer's Advertising or Marketing** - Für eigene Werbung
   - ✅ **Product Personalization** - Für Personalisierung

3. **Linked to User** (Mit Nutzer verknüpft?)
   - ❌ **Nein** - Daten sind nicht mit Nutzer verknüpft (lokal gespeichert)
   - ✅ **Ja** - Daten sind mit Nutzer verknüpft

4. **Used for Tracking** (Für Tracking verwendet?)
   - ✅ **Ja** - Für Device ID und Advertising Data (wenn User zustimmt)
   - ❌ **Nein** - Für Health, Photos, User Content

5. **Collected in App** (In App gesammelt?)
   - ✅ **Ja** - Alle Daten werden in der App gesammelt

---

## 📸 Screenshots der Konfiguration

### Beispiel-Konfiguration für "Health & Fitness":

```
┌─────────────────────────────────────┐
│ Health & Fitness                    │
├─────────────────────────────────────┤
│ Collected: ✅ Yes                    │
│                                     │
│ Purposes:                           │
│ ✅ App Functionality               │
│                                     │
│ Linked to User: ❌ No               │
│ Used for Tracking: ❌ No            │
│ Collected in App: ✅ Yes            │
└─────────────────────────────────────┘
```

### Beispiel-Konfiguration für "Device ID":

```
┌─────────────────────────────────────┐
│ Device ID                           │
├─────────────────────────────────────┤
│ Collected: ✅ Yes                    │
│                                     │
│ Purposes:                           │
│ ✅ Third-Party Advertising         │
│                                     │
│ Linked to User: ❌ No               │
│ Used for Tracking: ✅ Yes          │
│ Collected in App: ✅ Yes            │
└─────────────────────────────────────┘
```

---

## ⚠️ Wichtige Hinweise

### 1. **Tracking nur mit Zustimmung**
- Device ID und Advertising Data werden nur für Tracking verwendet, **wenn der User zustimmt**
- Die Zustimmung wird über den Consent Dialog (UMP) eingeholt
- Wenn User ablehnt → Kein Tracking

### 2. **Lokale Speicherung**
- Health, Photos, User Content werden **nur lokal** gespeichert
- **Nicht** auf Servern gespeichert
- **Nicht** mit Nutzer verknüpft (anonym)

### 3. **Dritte Anbieter**
- **Claude API** und **Google Gemini** verarbeiten Chat-Nachrichten und Fotos
- Diese werden in den Privacy Details als "Third-Party Data Processing" erwähnt
- Details stehen in der Privacy Policy

---

## ✅ Checkliste

Nach der Konfiguration solltest du haben:

- [ ] Health & Fitness hinzugefügt
- [ ] Photos hinzugefügt
- [ ] User Content hinzugefügt
- [ ] Device ID hinzugefügt
- [ ] Advertising Data hinzugefügt
- [ ] Alle Datentypen korrekt konfiguriert
- [ ] "Used for Tracking" nur bei Device ID und Advertising Data
- [ ] "Linked to User" bei allen auf "No" (lokal gespeichert)

---

## 🔍 Prüfung

### Nach der Konfiguration prüfen:

1. **In Xcode:**
   - Gehe zu Target → Signing & Capabilities → App Privacy
   - Alle Datentypen sollten sichtbar sein
   - Konfiguration sollte korrekt sein

2. **In App Store Connect:**
   - Nach dem ersten Upload siehst du die Privacy Details
   - Sie sollten automatisch aus Xcode übernommen werden
   - Prüfe, ob alle Angaben korrekt sind

---

## 🚨 Häufige Fehler vermeiden

### ❌ Falsch:
- "Used for Tracking" bei Health/Photos/User Content auf "Yes" → **FALSCH**
- "Linked to User" auf "Yes" → **FALSCH** (Daten sind lokal)
- Datentypen fehlen → **App wird abgelehnt**

### ✅ Richtig:
- "Used for Tracking" nur bei Device ID/Advertising Data
- "Linked to User" auf "No" (außer bei Tracking-Daten)
- Alle verwendeten Datentypen sind aufgelistet

---

## 📞 Hilfe

Falls du Probleme hast:

1. **Xcode zeigt keine "App Privacy" Option:**
   - Stelle sicher, dass du Xcode 12+ verwendest
   - Prüfe, ob das Target korrekt ausgewählt ist

2. **Datentypen werden nicht gespeichert:**
   - Stelle sicher, dass du auf "Save" klickst
   - Prüfe, ob die Projektdatei schreibbar ist

3. **App Store Connect zeigt andere Angaben:**
   - Warte nach dem Upload 5-10 Minuten
   - Prüfe, ob der Build korrekt hochgeladen wurde

---

## 🎯 Zusammenfassung

**Was du tun musst:**

1. ✅ Xcode öffnen → Target → Signing & Capabilities
2. ✅ "App Privacy" öffnen
3. ✅ 5-6 Datentypen hinzufügen (siehe oben)
4. ✅ Jeden Datentyp korrekt konfigurieren
5. ✅ Speichern und prüfen

**Zeitaufwand:** 10-15 Minuten

**Priorität:** 🔴 HÖCHSTE (Pflicht für App Store)

---

**Viel Erfolg! 🚀**

