# App Privacy Details - Manuell hinzufügen im Info Tab

## 📍 Wo: Info Tab → Custom iOS Target Properties

Du bist bereits im richtigen Tab! Jetzt musst du die Privacy Keys manuell hinzufügen.

## ✅ Schritt-für-Schritt Anleitung:

### Schritt 1: "+" Button finden
1. Im "Info" Tab, in der Tabelle "Custom iOS Target Properties"
2. Klicke auf den **"+"** Button (rechts oben in der Tabelle)
3. Oder: Rechtsklick in die Tabelle → "Add Row"

### Schritt 2: Ersten Key hinzufügen - NSPrivacyCollectedDataTypes

1. Klicke auf **"+"** Button
2. In der neuen Zeile:
   - **Key:** Tippe: `Privacy - Collected Data Types`
   - **Type:** Wähle: `Dictionary` (oder `Array`)
   - **Value:** Klicke auf den Pfeil `>` um zu erweitern

3. Klicke auf **"+"** innerhalb des Dictionary/Array
4. Füge die Datentypen hinzu:

#### Datentyp 1: Health & Fitness
- Klicke auf "+" im Array
- **Key:** (leer lassen oder automatisch)
- **Type:** `Dictionary`
- **Value:** Erweitern `>`
- Innerhalb des Dictionary:
  - **Key:** `NSPrivacyCollectedDataType`
  - **Type:** `String`
  - **Value:** `NSPrivacyCollectedDataTypeHealthAndFitness`
  - **Key:** `NSPrivacyCollectedDataTypeLinked`
  - **Type:** `Boolean`
  - **Value:** `NO`
  - **Key:** `NSPrivacyCollectedDataTypeTracking`
  - **Type:** `Boolean`
  - **Value:** `NO`
  - **Key:** `NSPrivacyCollectedDataTypePurposes`
  - **Type:** `Array`
  - **Value:** Erweitern `>`
    - Klicke auf "+" im Array
    - **Value:** `NSPrivacyCollectedDataTypePurposeAppFunctionality`

#### Datentyp 2: Photos
- Wiederhole den Prozess mit:
  - `NSPrivacyCollectedDataTypePhotosOrVideos`
  - `NSPrivacyCollectedDataTypeLinked`: `NO`
  - `NSPrivacyCollectedDataTypeTracking`: `NO`
  - `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeAppFunctionality`

#### Datentyp 3: User Content
- `NSPrivacyCollectedDataTypeUserContent`
- `NSPrivacyCollectedDataTypeLinked`: `NO`
- `NSPrivacyCollectedDataTypeTracking`: `NO`
- `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeAppFunctionality`

#### Datentyp 4: Device ID
- `NSPrivacyCollectedDataTypeDeviceID`
- `NSPrivacyCollectedDataTypeLinked`: `NO`
- `NSPrivacyCollectedDataTypeTracking`: `YES`
- `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeThirdPartyAdvertising`

#### Datentyp 5: Advertising Data
- `NSPrivacyCollectedDataTypeAdvertisingData`
- `NSPrivacyCollectedDataTypeLinked`: `NO`
- `NSPrivacyCollectedDataTypeTracking`: `YES`
- `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeThirdPartyAdvertising`

---

## ⚠️ WICHTIG: Das ist sehr komplex!

**Empfehlung:** Da das manuelle Hinzufügen sehr aufwendig ist, empfehle ich dir:

### ✅ Besserer Weg: Über App Store Connect

1. **Erstelle einen ersten Build:**
   - Product → Archive
   - Distribute App → App Store Connect
   - Upload durchführen

2. **In App Store Connect konfigurieren:**
   - Gehe zu [App Store Connect](https://appstoreconnect.apple.com)
   - Wähle deine App
   - Klicke auf **"App Privacy"** (linke Seitenleiste)
   - Klicke auf **"Get Started"** oder **"Edit"**
   - Füge die Datentypen visuell hinzu (viel einfacher!)

**Vorteile:**
- ✅ Visuell einfacher
- ✅ Weniger Fehleranfällig
- ✅ Kannst du später anpassen
- ✅ Wird automatisch synchronisiert

---

## 🎯 Was du JETZT tun kannst:

### Option A: Manuell hinzufügen (Komplex)
- Folge der Anleitung oben
- Sehr zeitaufwendig (30-60 Minuten)
- Fehleranfällig

### Option B: Über App Store Connect (Empfohlen)
1. Erstelle Screenshots
2. Bereite App Store Connect vor
3. Lade ersten Build hoch
4. Konfiguriere Privacy Details in App Store Connect (5-10 Minuten)

---

## ✅ Meine Empfehlung:

**Mach erstmal:**
1. ✅ Screenshots erstellen
2. ✅ App Store Connect Setup
3. ✅ Ersten Build hochladen
4. ✅ Privacy Details in App Store Connect konfigurieren

**Das ist viel einfacher und schneller!** 🚀

