# Wo ist das "+" Zeichen im Info Tab?

## 📍 Das "+" Zeichen finden:

### Methode 1: Rechtsklick (Einfachste)
1. **Rechtsklick** irgendwo in die Tabelle "Custom iOS Target Properties"
2. Im Kontextmenü: **"Add Row"** oder **"Add Item"** wählen
3. Neue Zeile erscheint

### Methode 2: "+" Button oben rechts
1. Schaue **oben rechts** in der Tabelle
2. Es gibt einen **"+"** Button (manchmal auch als Icon)
3. Klicke darauf

### Methode 3: Tastatur-Shortcut
1. Wähle eine Zeile in der Tabelle aus
2. Drücke **Enter** oder **Return**
3. Neue Zeile wird erstellt

---

## 🎯 Schritt-für-Schritt:

### Schritt 1: Rechtsklick
1. **Rechtsklick** auf eine beliebige Zeile in der Tabelle
   - Zum Beispiel: Rechtsklick auf "Bundle name"
2. Im Menü erscheint: **"Add Row"** oder **"Add Item"**
3. Klicke darauf

### Schritt 2: Neue Zeile
1. Eine neue Zeile erscheint
2. In der Spalte **"Key"** tippe: `Privacy - Collected Data Types`
3. In der Spalte **"Type"** wähle: `Dictionary` (aus dem Dropdown)
4. Die Spalte **"Value"** zeigt dann `(0 items)` oder `(empty)`

### Schritt 3: Dictionary erweitern
1. Klicke auf den **Pfeil `>`** in der "Value" Spalte
2. Das Dictionary öffnet sich
3. Klicke auf **"+"** innerhalb des Dictionary
4. Füge die Datentypen hinzu

---

## ⚠️ WICHTIG: Das ist sehr komplex!

**Empfehlung:** Da das manuelle Hinzufügen sehr aufwendig und fehleranfällig ist, empfehle ich dir:

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

### Option A: Rechtsklick → Add Row (Komplex)
- Rechtsklick in die Tabelle
- "Add Row" wählen
- Privacy Keys manuell hinzufügen (30-60 Minuten, fehleranfällig)

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

