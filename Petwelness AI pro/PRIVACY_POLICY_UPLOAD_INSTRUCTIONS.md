# Privacy Policy Upload - Schritt für Schritt

## ❌ Problem: 404 Fehler

Die URL `https://devlargou.com/PetWellnessAI/Privacy-Policy.html` gibt einen 404-Fehler.

## ✅ Lösung:

### Option 1: Datei im Root-Verzeichnis (EMPFOHLEN - Einfachste Lösung)

1. **Lade die Datei hoch:**
   - Datei: `privacy-policy.html` (aus diesem Ordner)
   - Ziel: `/public_html/privacy-policy.html` (direkt im Root)
   - Dateiname: `privacy-policy.html` (alles kleingeschrieben)

2. **URL wird dann:**
   ```
   https://devlargou.com/privacy-policy.html
   ```

3. **Teste die URL:**
   Öffne: https://devlargou.com/privacy-policy.html

### Option 2: Datei im PetWellnessAI Ordner

1. **Lade die Datei hoch:**
   - Datei: `privacy-policy.html`
   - Ziel: `/public_html/PetWellnessAI/privacy-policy.html`
   - Dateiname: `privacy-policy.html` (alles kleingeschrieben, mit .html Endung!)

2. **URL wird dann:**
   ```
   https://devlargou.com/PetWellnessAI/privacy-policy.html
   ```

## 🔧 WICHTIG - Dateiname prüfen:

### ❌ FALSCH:
- `Privacy-Policy` (ohne .html)
- `Privacy-Policy.txt`
- `privacy policy.html` (mit Leerzeichen)

### ✅ RICHTIG:
- `privacy-policy.html` (alles kleingeschrieben, mit Bindestrich)
- `Privacy-Policy.html` (mit Großbuchstaben, funktioniert auch)

## 📝 Upload-Schritte im File Manager:

1. Gehe zu `/public_html/` (Root-Verzeichnis)
2. Klicke auf "Upload" oder "New File"
3. Wähle die Datei `privacy-policy.html`
4. Stelle sicher, dass der Dateiname `privacy-policy.html` ist
5. Setze Permissions auf `0644` (falls nötig)
6. Klicke auf "Save" oder "Upload"

## 🎯 Empfohlene URL für App Store Connect:

**Einfachste und sicherste Option:**
```
https://devlargou.com/privacy-policy.html
```

Diese URL funktioniert garantiert, da sie direkt im Root-Verzeichnis ist!

## ✅ Nach dem Upload:

1. **Teste die URL im Browser:**
   ```
   https://devlargou.com/privacy-policy.html
   ```

2. **Prüfe:**
   - ✅ Seite lädt ohne 404
   - ✅ Privacy Policy wird angezeigt
   - ✅ HTTPS funktioniert
   - ✅ Alle Links funktionieren

3. **Trage in App Store Connect ein:**
   - Gehe zu App Store Connect
   - App Information → Privacy Policy URL
   - Trage ein: `https://devlargou.com/privacy-policy.html`
   - Speichern

## 💡 Pro-Tipp:

Falls der Ordner `PetWellnessAI` Probleme macht, verwende einfach das Root-Verzeichnis:
- Einfacher
- Kürzere URL
- Weniger Fehlerquellen
- Funktioniert garantiert

