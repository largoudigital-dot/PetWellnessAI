# Datentypen-Keys korrekt hinzufügen

## ✅ Status: Datentypen sind im Array!

Gut! Die Struktur ist jetzt:
```
Privacy - Collected Data Types (Array)
├── Item 0 (Dictionary) → "Health & Fitness" (String) ← FALSCH!
├── Item 1 (Dictionary) → "Photos" (String) ← FALSCH!
etc.
```

**ABER:** Die String-Einträge müssen durch die korrekten Keys ersetzt werden!

---

## 🔧 Lösung: String-Einträge durch Keys ersetzen

### Schritt 1: "Health & Fitness" Dictionary öffnen
1. Klicke auf den **Pfeil `>`** bei "Item 0" (Health & Fitness)
2. Du siehst: "Health & Fitness" (Type: String)

### Schritt 2: String-Eintrag löschen
1. Wähle "Health & Fitness" aus
2. Klicke auf das **"-"** Zeichen (Minus-Button)
3. Das Dictionary ist jetzt leer: "(0 items)"

### Schritt 3: Korrekte Keys hinzufügen
Klicke auf **"+"** innerhalb des Dictionary und füge diese 4 Keys hinzu:

#### Key 1: NSPrivacyCollectedDataType
1. Klicke auf **"+"** im Dictionary
2. **Key:** `NSPrivacyCollectedDataType`
3. **Type:** `String`
4. **Value:** `NSPrivacyCollectedDataTypeHealthAndFitness`

#### Key 2: NSPrivacyCollectedDataTypeLinked
1. Klicke auf **"+"** im Dictionary
2. **Key:** `NSPrivacyCollectedDataTypeLinked`
3. **Type:** `Boolean`
4. **Value:** `NO`

#### Key 3: NSPrivacyCollectedDataTypeTracking
1. Klicke auf **"+"** im Dictionary
2. **Key:** `NSPrivacyCollectedDataTypeTracking`
3. **Type:** `Boolean`
4. **Value:** `NO`

#### Key 4: NSPrivacyCollectedDataTypePurposes
1. Klicke auf **"+"** im Dictionary
2. **Key:** `NSPrivacyCollectedDataTypePurposes`
3. **Type:** `Array`
4. **Value:** Erweitern `>` (Pfeil klicken)
5. Klicke auf **"+"** im Array
6. **Value:** `NSPrivacyCollectedDataTypePurposeAppFunctionality`

---

## 📋 Für alle 5 Datentypen:

### 1. Health & Fitness (Item 0)
- Lösche: "Health & Fitness" (String)
- Füge hinzu:
  - `NSPrivacyCollectedDataType` → `NSPrivacyCollectedDataTypeHealthAndFitness`
  - `NSPrivacyCollectedDataTypeLinked` → `NO`
  - `NSPrivacyCollectedDataTypeTracking` → `NO`
  - `NSPrivacyCollectedDataTypePurposes` → Array → `NSPrivacyCollectedDataTypePurposeAppFunctionality`

### 2. Photos (Item 1)
- Lösche: "Photos" (String)
- Füge hinzu:
  - `NSPrivacyCollectedDataType` → `NSPrivacyCollectedDataTypePhotosOrVideos`
  - `NSPrivacyCollectedDataTypeLinked` → `NO`
  - `NSPrivacyCollectedDataTypeTracking` → `NO`
  - `NSPrivacyCollectedDataTypePurposes` → Array → `NSPrivacyCollectedDataTypePurposeAppFunctionality`

### 3. User Content (Item 2)
- Lösche: "User Content" (String)
- Füge hinzu:
  - `NSPrivacyCollectedDataType` → `NSPrivacyCollectedDataTypeUserContent`
  - `NSPrivacyCollectedDataTypeLinked` → `NO`
  - `NSPrivacyCollectedDataTypeTracking` → `NO`
  - `NSPrivacyCollectedDataTypePurposes` → Array → `NSPrivacyCollectedDataTypePurposeAppFunctionality`

### 4. Device ID (Item 3)
- Lösche: "Device ID" (String)
- Füge hinzu:
  - `NSPrivacyCollectedDataType` → `NSPrivacyCollectedDataTypeDeviceID`
  - `NSPrivacyCollectedDataTypeLinked` → `NO`
  - `NSPrivacyCollectedDataTypeTracking` → `YES` ⚠️ (WICHTIG!)
  - `NSPrivacyCollectedDataTypePurposes` → Array → `NSPrivacyCollectedDataTypePurposeThirdPartyAdvertising`

### 5. Advertising Data (Item 4)
- Lösche: "Advertising Data" (String)
- Füge hinzu:
  - `NSPrivacyCollectedDataType` → `NSPrivacyCollectedDataTypeAdvertisingData`
  - `NSPrivacyCollectedDataTypeLinked` → `NO`
  - `NSPrivacyCollectedDataTypeTracking` → `YES` ⚠️ (WICHTIG!)
  - `NSPrivacyCollectedDataTypePurposes` → Array → `NSPrivacyCollectedDataTypePurposeThirdPartyAdvertising`

---

## ✅ Korrekte Struktur nach dem Hinzufügen:

```
Privacy - Collected Data Types (Array)
├── Item 0 (Dictionary) → 4 items
│   ├── NSPrivacyCollectedDataType → NSPrivacyCollectedDataTypeHealthAndFitness
│   ├── NSPrivacyCollectedDataTypeLinked → NO
│   ├── NSPrivacyCollectedDataTypeTracking → NO
│   └── NSPrivacyCollectedDataTypePurposes → Array → NSPrivacyCollectedDataTypePurposeAppFunctionality
├── Item 1 (Dictionary) → 4 items
│   └── (Photos - gleiche Struktur)
├── Item 2 (Dictionary) → 4 items
│   └── (User Content - gleiche Struktur)
├── Item 3 (Dictionary) → 4 items
│   └── (Device ID - Tracking: YES, Purpose: ThirdPartyAdvertising)
└── Item 4 (Dictionary) → 4 items
    └── (Advertising Data - Tracking: YES, Purpose: ThirdPartyAdvertising)
```

---

## ⚠️ WICHTIG:

- **Tracking:** Nur bei Device ID und Advertising Data auf `YES`
- **Linked:** Bei allen auf `NO`
- **Purposes:** 
  - Health, Photos, User Content → `AppFunctionality`
  - Device ID, Advertising Data → `ThirdPartyAdvertising`

---

## 🎯 Schritt-für-Schritt für Item 0 (Health & Fitness):

1. ✅ Öffne Item 0 (Pfeil `>`)
2. ✅ Lösche "Health & Fitness" (String) mit "-"
3. ✅ Klicke auf "+" im Dictionary
4. ✅ Füge 4 Keys hinzu (siehe oben)
5. ✅ Wiederhole für alle 5 Items

**Viel Erfolg!** 🚀

