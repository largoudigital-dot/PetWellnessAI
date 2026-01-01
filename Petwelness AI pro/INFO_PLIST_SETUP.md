# Info.plist Privacy Details Setup

## ✅ Was wurde implementiert:

1. **NSUserTrackingUsageDescription** - ✅ Hinzugefügt in project.pbxproj (Debug & Release)
2. **ATT Framework Integration** - ✅ Implementiert in AdManager.swift
3. **ATT Request Logic** - ✅ Automatisch nach Consent

## ⚠️ WICHTIG: Privacy Details müssen in Xcode hinzugefügt werden

Da `GENERATE_INFOPLIST_FILE = YES` aktiv ist, werden die Privacy Details automatisch generiert, aber die komplexen Privacy Details müssen manuell in Xcode hinzugefügt werden:

### Schritt 1: Info.plist in Xcode öffnen

1. Öffne das Projekt in Xcode
2. Wähle das Target "AI Tierarzt"
3. Gehe zu "Info" Tab
4. Oder öffne `AI Tierarzt/Info.plist` direkt

### Schritt 2: Privacy Details hinzufügen

Füge folgende Keys hinzu:

#### NSPrivacyCollectedDataTypes

```xml
<key>NSPrivacyCollectedDataTypes</key>
<array>
    <!-- Health & Fitness Data -->
    <dict>
        <key>NSPrivacyCollectedDataType</key>
        <string>NSPrivacyCollectedDataTypeHealthAndFitness</string>
        <key>NSPrivacyCollectedDataTypeLinked</key>
        <false/>
        <key>NSPrivacyCollectedDataTypeTracking</key>
        <false/>
        <key>NSPrivacyCollectedDataTypePurposes</key>
        <array>
            <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
        </array>
    </dict>
    <!-- Photos -->
    <dict>
        <key>NSPrivacyCollectedDataType</key>
        <string>NSPrivacyCollectedDataTypePhotosOrVideos</string>
        <key>NSPrivacyCollectedDataTypeLinked</key>
        <false/>
        <key>NSPrivacyCollectedDataTypeTracking</key>
        <false/>
        <key>NSPrivacyCollectedDataTypePurposes</key>
        <array>
            <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
        </array>
    </dict>
    <!-- User Content -->
    <dict>
        <key>NSPrivacyCollectedDataType</key>
        <string>NSPrivacyCollectedDataTypeUserContent</string>
        <key>NSPrivacyCollectedDataTypeLinked</key>
        <false/>
        <key>NSPrivacyCollectedDataTypeTracking</key>
        <false/>
        <key>NSPrivacyCollectedDataTypePurposes</key>
        <array>
            <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
        </array>
    </dict>
</array>
```

#### NSPrivacyAccessedAPITypes

```xml
<key>NSPrivacyAccessedAPITypes</key>
<array>
    <!-- User Defaults -->
    <dict>
        <key>NSPrivacyAccessedAPIType</key>
        <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
        <key>NSPrivacyAccessedAPITypeReasons</key>
        <array>
            <string>CA92.1</string>
        </array>
    </dict>
    <!-- File Timestamp -->
    <dict>
        <key>NSPrivacyAccessedAPIType</key>
        <string>NSPrivacyAccessedAPICategoryFileTimestamp</string>
        <key>NSPrivacyAccessedAPITypeReasons</key>
        <array>
            <string>C617.1</string>
        </array>
    </dict>
    <!-- System Boot Time -->
    <dict>
        <key>NSPrivacyAccessedAPIType</key>
        <string>NSPrivacyAccessedAPICategorySystemBootTime</string>
        <key>NSPrivacyAccessedAPITypeReasons</key>
        <array>
            <string>35F9.1</string>
        </array>
    </dict>
    <!-- Disk Space -->
    <dict>
        <key>NSPrivacyAccessedAPIType</key>
        <string>NSPrivacyAccessedAPICategoryDiskSpace</string>
        <key>NSPrivacyAccessedAPITypeReasons</key>
        <array>
            <string>E174.1</string>
        </array>
    </dict>
    <!-- Active Keyboards -->
    <dict>
        <key>NSPrivacyAccessedAPIType</key>
        <string>NSPrivacyAccessedAPICategoryActiveKeyboards</string>
        <key>NSPrivacyAccessedAPITypeReasons</key>
        <array>
            <string>54BD.1</string>
        </array>
    </dict>
</array>
```

#### NSPrivacyTrackingDomains

```xml
<key>NSPrivacyTrackingDomains</key>
<array>
    <string>googleads.g.doubleclick.net</string>
    <string>googlesyndication.com</string>
    <string>googleadservices.com</string>
    <string>google-analytics.com</string>
</array>
```

#### NSPrivacyTracking

```xml
<key>NSPrivacyTracking</key>
<true/>
```

## 📝 Schritt-für-Schritt Anleitung:

### Option 1: In Xcode Target Settings (Empfohlen)

1. Öffne Xcode
2. Wähle das Projekt "AI Tierarzt" im Navigator
3. Wähle das Target "AI Tierarzt"
4. Gehe zum Tab "Info"
5. Klicke auf "+" um neue Keys hinzuzufügen
6. Füge die Keys aus der Liste unten hinzu

### Option 2: Info.plist als Source File

Falls du eine manuelle Info.plist verwenden möchtest:

1. Setze `GENERATE_INFOPLIST_FILE = NO` in Build Settings
2. Erstelle eine Info.plist Datei im "AI Tierarzt" Ordner
3. Setze `INFOPLIST_FILE = "AI Tierarzt/Info.plist"` in Build Settings
4. Verwende die Privacy Details aus der Vorlage unten

## ✅ Was funktioniert bereits:

- ✅ NSUserTrackingUsageDescription ist in project.pbxproj
- ✅ ATT Framework ist in AdManager.swift implementiert
- ✅ ATT wird automatisch nach Consent angefordert
- ✅ Info.plist Vorlage wurde erstellt

## 📝 Nächste Schritte:

1. Öffne Xcode
2. Füge die Privacy Details manuell in Info.plist hinzu (siehe oben)
3. Oder verwende die erstellte Info.plist Datei (siehe Alternative)

## ⚠️ WICHTIG:

- Die Privacy Details MÜSSEN in Info.plist vorhanden sein, sonst wird die App von App Store Connect abgelehnt
- ATT wird automatisch angefordert, wenn Consent erteilt wurde
- Die Privacy Details müssen genau mit den tatsächlich gesammelten Daten übereinstimmen

