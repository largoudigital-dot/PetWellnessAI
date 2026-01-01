# GoogleMobileAds Framework hinzufügen - Schritt für Schritt

## ⚠️ WICHTIG: Aktueller Status

Der Code kompiliert jetzt mit Dummy-Klassen, aber **Ads funktionieren nicht**, bis du das Framework hinzufügst!

## 🚀 Lösung: Framework hinzufügen

### Methode 1: Swift Package Manager (EMPFOHLEN)

1. **Öffne dein Xcode-Projekt**
   - Öffne `AI Tierarzt.xcodeproj` in Xcode

2. **Gehe zu Package Dependencies**
   - Klicke auf dein Projekt in der linken Seitenleiste (ganz oben, blaues Icon)
   - Wähle das **"AI Tierarzt"** Target
   - Gehe zum Tab **"Package Dependencies"**

3. **Füge Package hinzu**
   - Klicke auf das **"+"** Symbol
   - Füge diese URL ein:
     ```
     https://github.com/googleads/swift-package-manager-google-mobile-ads.git
     ```
   - Klicke auf **"Add Package"**
   - Wähle Version: **"Up to Next Major Version"** mit **10.0.0**
   - Klicke auf **"Add Package"**
   - Stelle sicher, dass **"GoogleMobileAds"** ausgewählt ist
   - Klicke auf **"Add Package"**

4. **Warte auf Download**
   - Xcode lädt das Framework herunter (kann einige Minuten dauern)

5. **Entferne Dummy-Klassen**
   - Öffne `AdManager.swift`
   - Entferne die Zeilen zwischen `#if !canImport(GoogleMobileAds)` und `#else`
   - Entferne auch die `#if`, `#else` und `#endif` Zeilen
   - Behalte nur `import GoogleMobileAds`

### Methode 2: CocoaPods (Alternative)

Falls Swift Package Manager nicht funktioniert:

1. **Installiere CocoaPods** (falls noch nicht installiert):
   ```bash
   sudo gem install cocoapods
   ```

2. **Erstelle Podfile**:
   ```bash
   cd "/Users/blargou/Desktop/Apps swift/AI Tierarzt"
   pod init
   ```

3. **Bearbeite Podfile**:
   Öffne `Podfile` und füge hinzu:
   ```ruby
   platform :ios, '14.0'
   
   target 'AI Tierarzt' do
     use_frameworks!
     pod 'Google-Mobile-Ads-SDK'
   end
   ```

4. **Installiere Pods**:
   ```bash
   pod install
   ```

5. **Öffne Workspace**:
   - Schließe Xcode
   - Öffne `AI Tierarzt.xcworkspace` (nicht .xcodeproj!)

## ✅ Verifizierung

Nach dem Hinzufügen des Frameworks:

1. **Build das Projekt** (⌘+B)
2. **Prüfe, ob Fehler weg sind**
3. **Teste die App** - Ads sollten jetzt funktionieren

## 🔧 Troubleshooting

### Fehler: "No such module 'GoogleMobileAds'"
- ✅ Stelle sicher, dass das Framework in Package Dependencies hinzugefügt wurde
- ✅ Clean Build Folder (⌘+Shift+K) und neu bauen
- ✅ Prüfe, ob das Framework im "Frameworks, Libraries, and Embedded Content" Bereich ist

### Fehler: "Multiple commands produce..."
- ✅ Clean Build Folder (⌘+Shift+K)
- ✅ Lösche Derived Data: `~/Library/Developer/Xcode/DerivedData`

### Framework wird nicht gefunden
- ✅ Prüfe, ob die richtige Version ausgewählt ist (10.0.0+)
- ✅ Stelle sicher, dass das Target "AI Tierarzt" ausgewählt ist
- ✅ Restart Xcode

## 📝 Nach dem Setup

1. **Entferne Dummy-Klassen** aus `AdManager.swift`
2. **Füge deine echten Ad Unit IDs** hinzu (siehe `ADMOB_SETUP.md`)
3. **Teste mit Test-IDs** bevor du echte IDs verwendest

## 🆘 Hilfe

- GoogleMobileAds Dokumentation: https://developers.google.com/admob/ios/quick-start
- Swift Package Manager Guide: https://developers.google.com/admob/ios/swift-package-manager


