# App Privacy Details - Xcode Schritt-für-Schritt

## 📍 Wo findest du "App Privacy"?

### Schritt 1: Tab wechseln
1. Du bist gerade im **"General"** Tab (siehe oben)
2. Klicke auf den Tab **"Signing & Capabilities"** (direkt rechts neben "General")
3. Dieser Tab ist der 2. Tab in der oberen Leiste

### Schritt 2: Nach unten scrollen
1. Im "Signing & Capabilities" Tab siehst du:
   - **Signing** (oben)
   - **Capabilities** (Mitte)
   - **App Privacy** (unten) ← **HIER!**

2. Scrolle nach unten bis du **"App Privacy"** siehst

### Schritt 3: App Privacy öffnen
1. Unter "App Privacy" siehst du entweder:
   - Eine Liste mit bereits hinzugefügten Datentypen, ODER
   - Den Text "No privacy types configured" mit einem **"+"** Button

2. Klicke auf **"+"** oder **"Add Privacy Type"**

---

## 🎯 Genauer Pfad in Xcode:

```
Xcode Fenster
└── Obere Tabs (General | Signing & Capabilities | Resource Tags | Info | ...)
    └── Klicke auf: "Signing & Capabilities" ← HIER!
        └── Scroll nach unten
            └── "App Privacy" Sektion
                └── "+" Button klicken
                    └── Datentypen auswählen
```

---

## 📸 Was du sehen solltest:

Nach dem Klick auf "Signing & Capabilities" Tab:

```
┌─────────────────────────────────────────┐
│ Signing & Capabilities Tab               │
├─────────────────────────────────────────┤
│                                          │
│ Signing                                  │
│ ├── Team: [Dein Team]                   │
│ ├── Bundle Identifier: devlargou...     │
│ └── ...                                 │
│                                          │
│ Capabilities                             │
│ ├── [Verschiedene Capabilities]         │
│ └── ...                                 │
│                                          │
│ App Privacy                               │ ← HIER!
│ ├── [Liste der Datentypen]              │
│ └── "+" Button                          │
│                                          │
└─────────────────────────────────────────┘
```

---

## ✅ Schnell-Anleitung:

1. **Klicke auf "Signing & Capabilities"** (2. Tab oben)
2. **Scrolle nach unten** zu "App Privacy"
3. **Klicke auf "+"** (Add Privacy Type)
4. **Wähle Datentypen** aus der Liste:
   - Health & Fitness
   - Photos
   - User Content
   - Device ID
   - Advertising Data
5. **Konfiguriere jeden Datentyp** (siehe Anleitung unten)

---

## 🔍 Falls du "App Privacy" nicht siehst:

### Problem 1: Tab nicht sichtbar
- **Lösung**: Stelle sicher, dass das Target "AI Tierarzt" ausgewählt ist (linke Seitenleiste)

### Problem 2: "App Privacy" Sektion fehlt
- **Lösung**: 
  - Xcode Version prüfen (muss 12+ sein)
  - Projekt neu öffnen
  - Xcode neu starten

### Problem 3: "+" Button fehlt
- **Lösung**: 
  - Stelle sicher, dass du im "Signing & Capabilities" Tab bist
  - Scrolle ganz nach unten
  - Falls leer: Klicke auf "App Privacy" Sektion, um sie zu erweitern

---

## 📋 Nach dem Klick auf "+":

Du siehst eine Liste mit Datentypen. Wähle diese aus:

1. ✅ **Health & Fitness**
2. ✅ **Photos** (oder "Photos or Videos")
3. ✅ **User Content**
4. ✅ **Device ID**
5. ✅ **Advertising Data**

Nach der Auswahl erscheinen sie in der Liste und du kannst sie konfigurieren.

---

## 🎯 Zusammenfassung:

**Wo:** 
- Tab: **"Signing & Capabilities"** (2. Tab oben)
- Sektion: **"App Privacy"** (ganz unten)
- Button: **"+"** (Add Privacy Type)

**Zeitaufwand:** 2 Minuten zum Finden, 10 Minuten zum Konfigurieren

**Priorität:** 🔴 HÖCHSTE

