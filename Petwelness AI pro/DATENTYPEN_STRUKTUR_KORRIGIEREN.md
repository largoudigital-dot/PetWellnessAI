# Datentypen-Struktur korrigieren

## ⚠️ Problem: Falsche Struktur!

Du hast die Datentypen als separate Einträge hinzugefügt:
- "Health & Fitness" (Type: String)
- "Photos" (Type: String)
- etc.

**Das ist falsch!** Sie müssen **innerhalb** von "Privacy - Collected Data Types" sein!

---

## ✅ Korrekte Struktur:

```
Privacy - Collected Data Types (Type: Array)
└── Item 0 (Type: Dictionary)
    ├── NSPrivacyCollectedDataType → String → NSPrivacyCollectedDataTypeHealthAndFitness
    ├── NSPrivacyCollectedDataTypeLinked → Boolean → NO
    ├── NSPrivacyCollectedDataTypeTracking → Boolean → NO
    └── NSPrivacyCollectedDataTypePurposes → Array
        └── Item 0 → String → NSPrivacyCollectedDataTypePurposeAppFunctionality
```

---

## 🔧 Lösung: Falsche Einträge löschen und neu hinzufügen

### Schritt 1: Falsche Einträge löschen
1. Wähle "Health & Fitness" aus
2. Klicke auf das **"-"** Zeichen (Minus-Button)
3. Wiederhole für:
   - "Photos"
   - "User Content"
   - "Device ID"
   - "Advertising Data"

### Schritt 2: "Privacy - Collected Data Types" erweitern
1. Klicke auf den **Pfeil `>`** links von "Privacy - Collected Data Types"
2. Das Array/Dictionary öffnet sich
3. Du siehst jetzt: "(0 items)" wird zu einer leeren Liste

### Schritt 3: Type auf "Array" ändern (falls nötig)
1. Falls Type "Dictionary" ist, ändere es zu **"Array"**
2. Wähle "Array" aus dem Dropdown

### Schritt 4: Ersten Datentyp hinzufügen
1. Klicke auf **"+"** innerhalb des Arrays (nicht außerhalb!)
2. Eine neue Zeile erscheint **innerhalb** des Arrays
3. Type: Wähle **`Dictionary`**
4. Value: `(0 items)`

### Schritt 5: Dictionary konfigurieren
1. Klicke auf den **Pfeil `>`** um das Dictionary zu erweitern
2. Klicke auf **"+"** innerhalb des Dictionary
3. Füge diese 4 Keys hinzu:

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

### Schritt 6: Weitere 4 Datentypen hinzufügen
Wiederhole Schritt 4-5 für:
- Photos → `NSPrivacyCollectedDataTypePhotosOrVideos`
- User Content → `NSPrivacyCollectedDataTypeUserContent`
- Device ID → `NSPrivacyCollectedDataTypeDeviceID` (Tracking: YES, Purpose: ThirdPartyAdvertising)
- Advertising Data → `NSPrivacyCollectedDataTypeAdvertisingData` (Tracking: YES, Purpose: ThirdPartyAdvertising)

---

## ⚠️ WICHTIG: Struktur prüfen

Nach dem Hinzufügen sollte es so aussehen:

```
Privacy - Collected Data Types (Array)
├── Item 0 (Dictionary) → Health & Fitness
├── Item 1 (Dictionary) → Photos
├── Item 2 (Dictionary) → User Content
├── Item 3 (Dictionary) → Device ID
└── Item 4 (Dictionary) → Advertising Data
```

**NICHT** so:
```
Privacy - Collected Data Types (Dictionary)
Health & Fitness (String) ← FALSCH!
Photos (String) ← FALSCH!
```

---

## ✅ Nach der Korrektur:

Du solltest sehen:
- "Privacy - Collected Data Types"
- Type: **"Array"** (nicht Dictionary!)
- Value: **(5 items)** ← 5 Datentypen innerhalb des Arrays!

---

## 🎯 Schnell-Lösung:

1. ✅ Lösche alle falschen Einträge ("Health & Fitness", "Photos", etc.)
2. ✅ Erweitere "Privacy - Collected Data Types" (Pfeil `>`)
3. ✅ Ändere Type zu "Array" (falls nötig)
4. ✅ Klicke auf "+" **innerhalb** des Arrays
5. ✅ Füge Dictionary mit 4 Keys hinzu (siehe oben)
6. ✅ Wiederhole für alle 5 Datentypen

**Viel Erfolg!** 🚀

