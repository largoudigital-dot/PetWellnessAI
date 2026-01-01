# Support-Seite Upload-Anleitung

## 📄 Datei: `support.html`

Die Support-HTML-Datei wurde erstellt und ist bereit zum Upload.

## 📍 Upload-Pfad

**Ziel-URL:** `https://devlargou.com/PetWellnessAI/Support`

**Upload-Pfad auf Server:**
```
/public_html/PetWellnessAI/Support.html
```
oder
```
/public_html/PetWellnessAI/Support/index.html
```

## 📋 Upload-Schritte

### Option 1: Direkte HTML-Datei (Einfachste Methode)

1. **Datei umbenennen:**
   - `support.html` → `Support.html` (Großbuchstaben beachten)

2. **Upload:**
   - Via FTP/SFTP oder cPanel File Manager
   - Upload nach: `/public_html/PetWellnessAI/Support.html`
   - **URL wird sein:** `https://devlargou.com/PetWellnessAI/Support.html`

3. **URL-Weiterleitung einrichten (Optional):**
   - Falls du `https://devlargou.com/PetWellnessAI/Support` (ohne .html) möchtest
   - Erstelle `.htaccess` in `/public_html/PetWellnessAI/`:
   ```apache
   RewriteEngine On
   RewriteRule ^Support$ Support.html [L]
   ```

### Option 2: Als index.html in Support-Ordner (Professioneller)

1. **Ordner erstellen:**
   - Erstelle Ordner: `/public_html/PetWellnessAI/Support/`

2. **Datei umbenennen:**
   - `support.html` → `index.html`

3. **Upload:**
   - Upload nach: `/public_html/PetWellnessAI/Support/index.html`
   - **URL wird sein:** `https://devlargou.com/PetWellnessAI/Support/`

## ✅ Nach dem Upload prüfen

1. **URL testen:**
   - Öffne: `https://devlargou.com/PetWellnessAI/Support`
   - Oder: `https://devlargou.com/PetWellnessAI/Support.html`

2. **Funktionen testen:**
   - ✅ Seite lädt korrekt
   - ✅ E-Mail-Links funktionieren
   - ✅ Links zu Privacy Policy funktionieren
   - ✅ Responsive Design (auf Mobile testen)
   - ✅ Alle Buttons sind klickbar

3. **In App Store Connect eintragen:**
   - Gehe zu App Store Connect
   - App-Informationen → Support URL
   - Trage ein: `https://devlargou.com/PetWellnessAI/Support`

## 🔗 Verlinkte Seiten

Die Support-Seite verlinkt zu:
- **Privacy Policy:** `https://devlargou.com/PetWellnessAI/Privacy-Policy`
- **Terms of Service:** `https://devlargou.com/PetWellnessAI/Terms` (falls vorhanden)
- **Website:** `https://devlargou.com`

## 📧 E-Mail-Links

Die Support-Seite enthält E-Mail-Links zu:
- **Support:** `largou.digital@gmail.com`
- **Feature Request:** `largou.digital@gmail.com?subject=PetWellness AI Feature Request`
- **Bug Report:** `largou.digital@gmail.com?subject=Bug Report`

## 🎨 Design-Features

- ✅ Responsive Design (Mobile & Desktop)
- ✅ Brand-Farben (Emerald & Ocean Blue)
- ✅ Professionelles Layout
- ✅ FAQ-Sektion
- ✅ Kontakt-Informationen
- ✅ E-Mail-Buttons mit vorgefertigten Betreffzeilen

## ⚠️ Wichtig

- Stelle sicher, dass die Datei korrekt hochgeladen wurde
- Teste alle Links nach dem Upload
- Prüfe, ob die URL in App Store Connect funktioniert
- Die URL muss HTTPS sein (nicht HTTP)

## 🚀 Fertig!

Nach erfolgreichem Upload ist die Support-URL bereit für App Store Connect!

