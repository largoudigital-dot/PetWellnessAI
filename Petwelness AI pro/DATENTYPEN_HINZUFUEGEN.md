# Datentypen zum Array hinzufügen

## ✅ Status: "Privacy - Collected Data Types" ist hinzugefügt!

Du siehst:
- Key: "Privacy - Collected Data Types"
- Type: "Array"
- Value: "(0 items)"

Jetzt musst du die 5 Datentypen hinzufügen!

---

## 📋 Schritt-für-Schritt: Datentypen hinzufügen

### Schritt 1: Array erweitern
1. Klicke auf den **Pfeil `>`** links von "Privacy - Collected Data Types"
2. Das Array öffnet sich
3. Du siehst jetzt: "(0 items)" wird zu einer leeren Liste

### Schritt 2: Ersten Datentyp hinzufügen
1. Klicke auf das **"+"** Zeichen (rechts in der Zeile, neben den Pfeilen)
2. Eine neue Zeile erscheint im Array
3. In der neuen Zeile:
   - **Type:** Wähle `Dictionary` (aus dem Dropdown)
   - **Value:** `(0 items)` oder `(empty)`

### Schritt 3: Dictionary erweitern und konfigurieren
1. Klicke auf den **Pfeil `>`** um das Dictionary zu erweitern
2. Klicke auf **"+"** innerhalb des Dictionary
3. Füge diese Keys hinzu:

#### Key 1: NSPrivacyCollectedDataType
- **Key:** `NSPrivacyCollectedDataType`
- **Type:** `String`
- **Value:** `NSPrivacyCollectedDataTypeHealthAndFitness`

#### Key 2: NSPrivacyCollectedDataTypeLinked
- **Key:** `NSPrivacyCollectedDataTypeLinked`
- **Type:** `Boolean`
- **Value:** `NO`

#### Key 3: NSPrivacyCollectedDataTypeTracking
- **Key:** `NSPrivacyCollectedDataTypeTracking`
- **Type:** `Boolean`
- **Value:** `NO`

#### Key 4: NSPrivacyCollectedDataTypePurposes
- **Key:** `NSPrivacyCollectedDataTypePurposes`
- **Type:** `Array`
- **Value:** Erweitern `>`
  - Klicke auf **"+"** im Array
  - **Value:** `NSPrivacyCollectedDataTypePurposeAppFunctionality`

---

## 📋 Alle 5 Datentypen:

### 1. Health & Fitness
- `NSPrivacyCollectedDataType`: `NSPrivacyCollectedDataTypeHealthAndFitness`
- `NSPrivacyCollectedDataTypeLinked`: `NO`
- `NSPrivacyCollectedDataTypeTracking`: `NO`
- `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeAppFunctionality`

### 2. Photos
- `NSPrivacyCollectedDataType`: `NSPrivacyCollectedDataTypePhotosOrVideos`
- `NSPrivacyCollectedDataTypeLinked`: `NO`
- `NSPrivacyCollectedDataTypeTracking`: `NO`
- `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeAppFunctionality`

### 3. User Content
- `NSPrivacyCollectedDataType`: `NSPrivacyCollectedDataTypeUserContent`
- `NSPrivacyCollectedDataTypeLinked`: `NO`
- `NSPrivacyCollectedDataTypeTracking`: `NO`
- `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeAppFunctionality`

### 4. Device ID
- `NSPrivacyCollectedDataType`: `NSPrivacyCollectedDataTypeDeviceID`
- `NSPrivacyCollectedDataTypeLinked`: `NO`
- `NSPrivacyCollectedDataTypeTracking`: `YES` ⚠️
- `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeThirdPartyAdvertising`

### 5. Advertising Data
- `NSPrivacyCollectedDataType`: `NSPrivacyCollectedDataTypeAdvertisingData`
- `NSPrivacyCollectedDataTypeLinked`: `NO`
- `NSPrivacyCollectedDataTypeTracking`: `YES` ⚠️
- `NSPrivacyCollectedDataTypePurposes`: `NSPrivacyCollectedDataTypePurposeThirdPartyAdvertising`

---

## ⚠️ WICHTIG:

- **Tracking:** Nur bei Device ID und Advertising Data auf `YES`
- **Linked:** Bei allen auf `NO` (Daten sind lokal gespeichert)
- **Purposes:** 
  - Health, Photos, User Content → `AppFunctionality`
  - Device ID, Advertising Data → `ThirdPartyAdvertising`

---

## ✅ Nach dem Hinzufügen:

Du solltest sehen:
- "Privacy - Collected Data Types"
- Type: "Array"
- Value: "(5 items)" ← 5 Datentypen!

---

## 🎯 Nächste Schritte:

1. ✅ Array erweitern (Pfeil `>` klicken)
2. ✅ 5x auf "+" klicken (für 5 Datentypen)
3. ✅ Jeden Datentyp konfigurieren (siehe oben)
4. ✅ Speichern (Cmd+S)

**Viel Erfolg!** 🚀

