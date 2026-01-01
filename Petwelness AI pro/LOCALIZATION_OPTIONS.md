# Mehrsprachen-System - Optionen & Implementierung

## 🌍 Unterstützte Sprachen (18 Sprachen)

1. 🇬🇧 **English** (en) - **STANDARD/FALLBACK**
2. 🇩🇪 Deutsch (de)
3. 🇪🇸 Español (es)
4. 🇫🇷 Français (fr)
5. 🇮🇹 Italiano (it)
6. 🇵🇹 Português (pt)
7. 🇧🇷 Português (Brasil) (pt-BR)
8. 🇳🇱 Nederlands (nl)
9. 🇵🇱 Polski (pl)
10. 🇷🇺 Русский (ru)
11. 🇹🇷 Türkçe (tr)
12. 🇯🇵 日本語 (ja)
13. 🇨🇳 中文 (简体) (zh-Hans)
14. 🇹🇼 中文 (繁體) (zh-Hant)
15. 🇰🇷 한국어 (ko)
16. 🇦🇪 العربية (ar)
17. 🇮🇳 हिन्दी (hi)

## 📋 Verfügbare Optionen

### ✅ Option 1: Native iOS Lokalisierung (EMPFOHLEN)

**Vorteile:**
- ✅ Native iOS-Integration
- ✅ Automatische Sprach-Erkennung
- ✅ Englisch als automatischer Fallback
- ✅ System-Integration (App Store Lokalisierung)
- ✅ Keine zusätzlichen Dependencies
- ✅ Unterstützt String Catalogs (Xcode 15+)

**Nachteile:**
- ⚠️ Benötigt Xcode-Konfiguration
- ⚠️ Lokalisierungsdateien müssen erstellt werden

**Implementierung:**
- `.lproj` Ordner für jede Sprache
- `Localizable.strings` Dateien
- Oder String Catalogs (moderne Methode)

---

### Option 2: Custom LocalizationManager (Bereits implementiert)

**Vorteile:**
- ✅ Volle Kontrolle
- ✅ Dynamische Sprachumschaltung ohne App-Neustart
- ✅ Einfache Verwaltung

**Nachteile:**
- ⚠️ Keine System-Integration
- ⚠️ Mehr Code zu pflegen

**Status:** ✅ Bereits implementiert in `LocalizationManager.swift`

---

## 🚀 Implementierung (Option 1 - Native iOS)

### Schritt 1: Lokalisierungsdateien erstellen

In Xcode:
1. Projekt auswählen → Project Settings
2. "Info" Tab → "Localizations"
3. "+" klicken → Sprachen hinzufügen
4. "English" als Development Language setzen

### Schritt 2: String Keys definieren

Erstelle `Localizable.strings` Dateien für jede Sprache:

**en.lproj/Localizable.strings:**
```strings
/* Navigation */
"nav.home" = "Home";
"nav.symptoms" = "Symptoms";
"nav.chat" = "Chat";
"nav.profile" = "Profile";

/* Common */
"common.save" = "Save";
"common.cancel" = "Cancel";
"common.delete" = "Delete";
```

**de.lproj/Localizable.strings:**
```strings
/* Navigation */
"nav.home" = "Home";
"nav.symptoms" = "Symptome";
"nav.chat" = "Chat";
"nav.profile" = "Profil";

/* Common */
"common.save" = "Speichern";
"common.cancel" = "Abbrechen";
"common.delete" = "Löschen";
```

### Schritt 3: In Code verwenden

```swift
// Einfache Verwendung
Text("nav.home".localized)

// Mit LocalizationManager
Text(LocalizedStrings.home)
```

---

## 🎯 Aktuelle Implementierung

### ✅ Bereits implementiert:

1. **LocalizationManager.swift**
   - Sprach-Erkennung
   - Englisch als Standard
   - 18 Sprachen unterstützt
   - Dynamische Sprachumschaltung

2. **SettingsView**
   - Zeigt alle Sprachen in einem Container
   - Englisch zuerst
   - Checkmark für aktuelle Sprache

3. **App-Integration**
   - Automatische Sprach-Erkennung beim Start
   - Fallback zu Englisch

---

## 📝 Nächste Schritte

### Um vollständige Lokalisierung zu aktivieren:

1. **Lokalisierungsdateien erstellen:**
   - In Xcode: Projekt → Info → Localizations
   - Sprachen hinzufügen
   - `Localizable.strings` für jede Sprache erstellen

2. **Alle Texte lokalisieren:**
   - Hardcodierte Strings durch `"key".localized` ersetzen
   - Beispiel: `Text("Home")` → `Text("nav.home".localized)`

3. **String Keys definieren:**
   - Alle Texte in `en.lproj/Localizable.strings` (Master)
   - Übersetzungen in anderen `.lproj` Ordnern

---

## 🔧 Verwendung im Code

### Aktuell (Custom Manager):
```swift
Text("nav.home".localized)  // Funktioniert sofort
```

### Mit Native iOS (nach Setup):
```swift
Text("nav.home", comment: "Navigation home")  // Native Methode
// Oder
Text(LocalizedStringKey("nav.home"))  // Automatisch lokalisiert
```

---

## ⚙️ Konfiguration

### Englisch als Standard setzen:

1. **Xcode Project Settings:**
   - Development Language: `English`
   - Base Localization: `English`

2. **Info.plist:**
   ```xml
   <key>CFBundleDevelopmentRegion</key>
   <string>en</string>
   ```

3. **LocalizationManager:**
   - Standard: `currentLanguage = "en"`
   - Fallback: Englisch wenn Sprache nicht unterstützt

---

## 📊 Vergleich der Optionen

| Feature | Native iOS | Custom Manager |
|---------|-----------|---------------|
| System-Integration | ✅ | ❌ |
| App Store Lokalisierung | ✅ | ❌ |
| Dynamische Umschaltung | ⚠️ (mit Code) | ✅ |
| Einfache Setup | ⚠️ | ✅ |
| Fallback zu Englisch | ✅ | ✅ |
| Sprach-Erkennung | ✅ | ✅ |

---

## 💡 Empfehlung

**Für Produktions-App:** Native iOS Lokalisierung (Option 1)
- Beste Integration
- App Store Support
- Professionell

**Für schnelle Entwicklung:** Custom Manager (Option 2) - ✅ Bereits implementiert
- Funktioniert sofort
- Volle Kontrolle
- Einfach zu erweitern

**Kombination:** Beide verwenden
- Custom Manager für dynamische Umschaltung
- Native iOS für App Store Lokalisierung
















