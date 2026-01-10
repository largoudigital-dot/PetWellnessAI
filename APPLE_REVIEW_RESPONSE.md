# Antwort für Apple Review Team

## Submission ID: d417da25-bdc0-4b39-b9e8-b3b571ee83fa
## Review Date: January 09, 2026
## Review Device: iPad Air 11-inch (M3)

---

## Problem 1: App Tracking Transparency (ATT)

### Antwort:
Die App Tracking Transparency-Anfrage wird beim ersten App-Start angezeigt, bevor Tracking-Daten gesammelt werden.

**Wo finden Sie die ATT-Anfrage:**
1. Installieren Sie die App zum ersten Mal auf einem iPad Air 11-inch (M3) mit iPadOS 26.2
2. Starten Sie die App
3. Die ATT-Anfrage sollte innerhalb der ersten 1-2 Sekunden nach dem App-Start erscheinen
4. Die Anfrage erscheint VOR jedem Consent-Dialog oder anderen Dialogen

**Technische Details:**
- Die ATT-Anfrage wird in `AdManager.swift` implementiert
- Sie wird beim App-Start in `AI_TierarztApp.swift` initialisiert
- Die Implementierung prüft explizit, ob ein Window vorhanden ist (wichtig für iPadOS)
- Die Anfrage wird nur angezeigt, wenn der Status `.notDetermined` ist

**Wenn die Anfrage nicht erscheint:**
- Der Status wurde möglicherweise bereits gesetzt (z.B. bei vorherigen Tests)
- Um zu testen: App löschen → Gerät neu starten → App neu installieren → App starten

**Alternative Lösung:**
Falls die App kein Tracking verwendet, können wir die App Privacy-Einstellungen in App Store Connect aktualisieren, um Tracking zu deaktivieren.

---

## Problem 2 & 3: Medizinische Informationen - Zitate und Regulatorische Genehmigung

### Antwort:
Wir haben umfassende Disclaimers und Quellenangaben hinzugefügt.

**Wo finden Sie die Disclaimers und Zitate:**

1. **First Aid Home View (PetFirstAidHomeView):**
   - Öffnen Sie die App → Navigieren Sie zu "First Aid" Tab
   - Am oberen Rand der Seite sehen Sie einen großen orangefarbenen Disclaimer-Box mit dem Text:
     "⚠️ WICHTIGER HINWEIS: Diese Erste-Hilfe-Informationen dienen NUR zu Informationszwecken und ersetzen KEINE tierärztliche Behandlung..."

2. **Emergency Detail View (EmergencyDetailView):**
   - Navigieren Sie zu: First Aid → Wählen Sie eine Kategorie (z.B. "Hund") → Wählen Sie einen Notfall (z.B. "Vergiftung", "Hitzschlag", "Knochenbruch")
   - Am oberen Rand jeder Emergency-Detail-Seite sehen Sie:
     - Einen großen orangefarbenen Disclaimer-Box mit dem Text: "⚠️ WICHTIGER HINWEIS: Diese Informationen dienen NUR zu Informationszwecken..."
     - Einen Button "Quellenangaben anzeigen" direkt im Disclaimer

3. **Chat View:**
   - Öffnen Sie die Chat-Funktion (AI Chat)
   - Im Welcome-Message sehen Sie einen Disclaimer
   - Im Header der ChatView gibt es ein Buch-Icon (📖) - klicken Sie darauf für Quellenangaben

4. **Citations View (Quellenangaben):**
   - Erreichbar über:
     - ChatView → Buch-Icon im Header
     - EmergencyDetailView → "Quellenangaben anzeigen" Button im Disclaimer
   - Die Citations-View zeigt 5 etablierte veterinärmedizinische Quellen:
     1. Merck Veterinary Manual
     2. Veterinary Practice News
     3. American Veterinary Medical Association (AVMA)
     4. University of Wisconsin School of Veterinary Medicine
     5. Veterinary Medicine Resources
   - Jede Quelle hat einen klickbaren Link zur Originalquelle

**Regulatorische Genehmigung:**
Die App stellt KEINE medizinische Diagnose oder Behandlung bereit. Alle Informationen dienen nur zu Informationszwecken. Die App:
- Ersetzt KEINE tierärztliche Behandlung
- Stellt KEINE Diagnose bereit
- Stellt KEINE Behandlung bereit
- Empfiehlt IMMER, einen lizenzierten Tierarzt zu konsultieren

Die Disclaimers sind in allen relevanten Views prominent platziert und machen dies klar.

---

## Problem 4: Keywords

### Antwort:
Wir werden die Keywords in App Store Connect anpassen und nur relevante Keywords beibehalten, die direkt mit der App-Funktionalität zusammenhängen.

**Geplante Änderungen:**
- Entfernen aller nicht relevanten Keywords
- Beibehaltung nur der Keywords, die direkt mit der App-Funktionalität zusammenhängen
- Maximale Länge: 100 Zeichen

**Neue Keywords (Vorschlag):**
```
pet, veterinary, AI, health, wellness, information, consultation
```

Diese Keywords sind direkt relevant für die App-Funktionalität als Informations-App für Haustiergesundheit.

---

## Zusammenfassung der Änderungen

### Implementiert:
1. ✅ ATT-Anfrage wird beim App-Start angezeigt (iPadOS-kompatibel)
2. ✅ Disclaimers in allen First Aid Views hinzugefügt
3. ✅ Citations-View erstellt und in allen relevanten Views eingebunden
4. ✅ Klare Kennzeichnung, dass die App keine Diagnose oder Behandlung bereitstellt

### In App Store Connect zu ändern:
1. ⚠️ Keywords anpassen (nur relevante Keywords behalten)
2. ⚠️ App Privacy-Einstellungen prüfen (Tracking deaktivieren, falls nicht verwendet)

---

## Test-Anleitung für Reviewer

### ATT-Anfrage testen:
1. App löschen (falls bereits installiert)
2. iPad neu starten (optional, aber empfohlen)
3. App neu installieren
4. App starten
5. ATT-Anfrage sollte innerhalb von 1-2 Sekunden erscheinen

### Disclaimers und Citations testen:
1. App starten
2. Navigieren Sie zu "First Aid" Tab (untere Navigation)
3. Sie sehen sofort einen Disclaimer am oberen Rand
4. Wählen Sie eine Kategorie (z.B. "Hund")
5. Wählen Sie einen Notfall (z.B. "Vergiftung")
6. Sie sehen einen Disclaimer am oberen Rand der Detail-Seite
7. Klicken Sie auf "Quellenangaben anzeigen" für Citations

### Chat Citations testen:
1. Navigieren Sie zu "AI Chat" (großer blauer Button oder Tab)
2. Im Header sehen Sie ein Buch-Icon (📖)
3. Klicken Sie darauf für Citations

---

## Kontakt

Falls Sie weitere Fragen haben oder Probleme beim Testen auftreten, kontaktieren Sie uns bitte über App Store Connect.

Vielen Dank für Ihr Verständnis und Ihre Geduld.




