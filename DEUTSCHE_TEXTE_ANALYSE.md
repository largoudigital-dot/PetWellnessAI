# Analyse aller hartcodierten deutschen Texte in der App

## 📋 Übersicht
Diese Datei enthält alle gefundenen hartcodierten deutschen Texte, die lokalisiert werden müssen.

---

## 🏷️ **1. TEXT-KOMPONENTEN (Text Views)**

### **PetProfileView.swift**
- Zeile 167: `"Möchten Sie \(pet.name) wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden."`

### **VaccinationsView.swift**
- Zeile 205: `"Fällig"`
- Zeile 213: `"Abgeschlossen"`
- Zeile 228: `"Nächste Impfung: \(nextDue, format: ...)"`
- Zeile 293: `"Datum"`
- Zeile 322: `"Tierarzt"`
- Zeile 331: `"Notizen"`

### **AppointmentsView.swift**
- Zeile 278: `"Titel"`
- Zeile 299: `"Tierarzt"`
- Zeile 308: `"Ort"`
- Zeile 317: `"Notizen"`

### **DocumentsView.swift**
- Zeile 263: `"Titel"`
- Zeile 272: `"Kategorie"`
- Zeile 288: `"Datum"`
- Zeile 300: `"Notizen"`

### **JournalView.swift**
- Zeile 96: `"Tagebucheinträge"`
- Zeile 141: `"Keine Tagebucheinträge"`
- Zeile 145: `"Fügen Sie Tagebucheinträge hinzu, um tägliche Notizen zu dokumentieren"`
- Zeile 231: `"Titel"`
- Zeile 252: `"Datum"`

### **BathroomView.swift**
- Zeile 96: `"Einträge"`
- Zeile 141: `"Keine Einträge"`
- Zeile 145: `"Fügen Sie Einträge hinzu, um Kot- und Urinprotokolle zu führen"`
- Zeile 232: `"Typ"`
- Zeile 248: `"Konsistenz"`
- Zeile 276: `"Notizen"`

### **ExerciseView.swift**
- Zeile 96: `"Trainingseinheiten"`
- Zeile 108: `"Gesamt: \(totalDuration) Minuten"`
- Zeile 146: `"Keine Trainingseinheiten"`
- Zeile 150: `"Fügen Sie Trainingseinheiten hinzu, um Sport und Bewegung zu verfolgen"`
- Zeile 244: `"Übungstyp"`
- Zeile 280: `"Datum"`
- Zeile 292: `"Notizen"`

### **FeedingView.swift**
- Zeile 96: `"Fütterungen"`
- Zeile 109: `"Heute: \(todayRecords.count) Fütterung\(todayRecords.count == 1 ? "" : "en")"`
- Zeile 148: `"Keine Fütterungen"`
- Zeile 152: `"Fügen Sie Fütterungen hinzu, um den Futterplan zu verwalten"`
- Zeile 266: `"Futtertyp"`
- Zeile 294: `"Notizen"`

### **WeightView.swift**
- Zeile 100: `"Aktuelles Gewicht"`
- Zeile 115: `"Veränderung: \(changeText) kg"`
- Zeile 154: `"Keine Gewichtseinträge"`
- Zeile 158: `"Fügen Sie Gewichtseinträge hinzu, um den Gewichtsverlauf zu verfolgen"`
- Zeile 253: `"kg"`
- Zeile 259: `"Datum"`
- Zeile 271: `"Notizen"`

### **ExpensesView.swift**
- Zeile 100: `"Gesamtausgaben"`
- Zeile 111: `"\(expenses.count) Ausgabe\(expenses.count == 1 ? "" : "n")"`
- Zeile 149: `"Keine Ausgaben"`
- Zeile 153: `"Fügen Sie Ausgaben hinzu, um Kosten zu verfolgen"`
- Zeile 250: `"Kategorie"`
- Zeile 276: `"Datum"`

### **VeterinariansView.swift**
- Zeile 39: `"Tierärzte"`
- Zeile 95: `"Gespeicherte Tierärzte"`
- Zeile 140: `"Keine Tierärzte"`
- Zeile 144: `"Fügen Sie Tierärzte hinzu, um Kontaktinformationen zu speichern"`
- Zeile 288: `"Notizen"`

### **ConsultationsView.swift**
- Zeile 150: `"Fügen Sie Konsultationen hinzu, um den Behandlungsverlauf zu dokumentieren"`
- Zeile 263: `"Datum"`
- Zeile 275: `"Tierarzt"`
- Zeile 321: `"Notizen"`

### **ActivitiesView.swift**
- Zeile 40: `"Aktivität"`
- Zeile 96: `"Aktivitäten"`
- Zeile 146: `"Keine Aktivitäten"`
- Zeile 150: `"Fügen Sie Aktivitäten hinzu, um die Bewegung zu verfolgen"`
- Zeile 254: `"Aktivitätstyp"`
- Zeile 273: `"Intensität"`
- Zeile 289: `"Datum"`
- Zeile 301: `"Notizen"`

### **StatisticsView.swift**
- Zeile 73: `"Statistiken"`
- Zeile 110: `"Keine Daten verfügbar"`
- Zeile 114: `"Fügen Sie Tiere hinzu, um Statistiken zu sehen"`
- Zeile 130: `"Tiere"`
- Zeile 132: `"Tier"` / `"Tiere"`
- Zeile 138: `"Medikamente"`
- Zeile 140: `"aktiv"`
- Zeile 146: `"Impfungen"`
- Zeile 148: `"gesamt"`
- Zeile 154: `"Termine"`
- Zeile 156: `"bevorstehend"`
- Zeile 163: `"Tiere nach Art"`
- Zeile 203: `"Gesundheitsstatistiken"`
- Zeile 211: `"Gesunde Tiere"`
- Zeile 213: `"von \(totalPets)"`
- Zeile 219: `"Aktive Medikamente"`
- Zeile 221: `"werden verabreicht"`
- Zeile 227: `"Impfungen"`
- Zeile 229: `"insgesamt"`
- Zeile 240: `"Ausgaben"`
- Zeile 251: `"Gesamtausgaben"`

### **SettingsView.swift**
- Zeile 296: `"Daten zwischen Geräten synchronisieren"`
- Zeile 317: `"Benachrichtigungen"`
- Zeile 335: `"Erinnerungen"`
- Zeile 339: `"Benachrichtigungen für Medikamente und Impfungen"`
- Zeile 514: `"Diese Aktion kann nicht rückgängig gemacht werden. Alle Tiere und Gesundheitsdaten werden permanent gelöscht."`
- Zeile 607: `"Datenschutzerklärung"`
- Zeile 713: `"Allgemeine Geschäftsbedingungen"`

### **SymptomInputView.swift**
- Zeile 62: `"Häufige Symptome"`

### **SymptomsView.swift**
- Zeile 99: `"Fügen Sie Symptome hinzu, um den Gesundheitsverlauf zu dokumentieren"`
- Zeile 215: `"Datum"`
- Zeile 234: `"Notizen"`

### **PhotosView.swift**
- Zeile 95: `"Fügen Sie Fotos hinzu, um den Gesundheitsverlauf zu dokumentieren"`
- Zeile 169: `"Foto auswählen"`
- Zeile 181: `"Titel"`
- Zeile 189: `"Datum"`
- Zeile 200: `"Notizen"`

### **InteractionsView.swift**
- Zeile 99: `"Fügen Sie Allergien und Unverträglichkeiten hinzu"`
- Zeile 184: `"Typ"`
- Zeile 215: `"Schweregrad"`
- Zeile 241: `"Notizen"`

### **WaterIntakeView.swift**
- Zeile 130: `"Keine Wassereinträge"`
- Zeile 133: `"Fügen Sie Wassereinträge hinzu, um die Wasseraufnahme zu verfolgen"`
- Zeile 227: `"Notizen"`

### **PhotoAnalysisView.swift**
- Zeile 69: `"Tipps für beste Ergebnisse"`

### **MedicationsView.swift**
- Zeile 307: `"Häufigkeit"`

### **GroomingView.swift**
- Zeile 273: `"Datum"`
- Zeile 311: `"Notizen"`

---

## 🔘 **2. BUTTONS**

### **HomeView.swift**
- Zeile 681: `"Fertig"`

### **SettingsView.swift**
- Zeile 509: `"Abbrechen"`
- Zeile 510: `"Löschen"`

### **EmergencyView.swift**
- Zeile 113: `"Notfall-Check mit AI starten"`

### **JournalView.swift**
- Zeile 287: `"Eintrag hinzufügen"`
- Zeile 409: `"Änderungen speichern"`

### **BathroomView.swift**
- Zeile 293: `"Eintrag hinzufügen"`
- Zeile 419: `"Änderungen speichern"`

### **ExerciseView.swift**
- Zeile 309: `"Trainingseinheit hinzufügen"`
- Zeile 443: `"Änderungen speichern"`

### **FeedingView.swift**
- Zeile 311: `"Fütterung hinzufügen"`
- Zeile 443: `"Änderungen speichern"`

### **WeightView.swift**
- Zeile 288: `"Gewicht hinzufügen"`
- Zeile 393: `"Änderungen speichern"`

### **ExpensesView.swift**
- Zeile 302: `"Ausgabe hinzufügen"`
- Zeile 420: `"Änderungen speichern"`

### **VeterinariansView.swift**
- Zeile 305: `"Tierarzt hinzufügen"`
- Zeile 438: `"Änderungen speichern"`

### **ConsultationsView.swift**
- Zeile 338: `"Konsultation hinzufügen"`
- Zeile 484: `"Änderungen speichern"`

### **ActivitiesView.swift**
- Zeile 318: `"Aktivität hinzufügen"`
- Zeile 451: `"Änderungen speichern"`

### **PhotoAnalysisView.swift**
- Zeile 49: `"Kamera"`
- Zeile 96: `"Foto analysieren"`

### **SymptomInputView.swift**
- Zeile 108: `"Analyse starten"`

### **SymptomsView.swift**
- Zeile 249: `"Symptom hinzufügen"`
- Zeile 374: `"Änderungen speichern"`

### **PhotosView.swift**
- Zeile 215: `"Foto hinzufügen"`
- Zeile 318: `"Änderungen speichern"`

### **InteractionsView.swift**
- Zeile 256: `"Wechselwirkung hinzufügen"`
- Zeile 397: `"Änderungen speichern"`

### **WaterIntakeView.swift**
- Zeile 242: `"Wassereintrag hinzufügen"`
- Zeile 334: `"Änderungen speichern"`

---

## 🏷️ **3. LABELS**

### **MedicationsView.swift**
- Zeile 218: `Label("Löschen", systemImage: "trash")`

### **JournalView.swift**
- Zeile 201: `Label("Löschen", systemImage: "trash")`

### **BathroomView.swift**
- Zeile 201: `Label("Löschen", systemImage: "trash")`

### **ExerciseView.swift**
- Zeile 214: `Label("Löschen", systemImage: "trash")`

### **FeedingView.swift**
- Zeile 217: `Label("Löschen", systemImage: "trash")`

### **WeightView.swift**
- Zeile 217: `Label("Löschen", systemImage: "trash")`

### **ExpensesView.swift**
- Zeile 220: `Label("Löschen", systemImage: "trash")`

### **VeterinariansView.swift**
- Zeile 212: `Label("Löschen", systemImage: "trash")`

### **ConsultationsView.swift**
- Zeile 232: `Label("Löschen", systemImage: "trash")`

### **ActivitiesView.swift**
- Zeile 223: `Label("Löschen", systemImage: "trash")`

### **SymptomsView.swift**
- Zeile 162: `Label("Löschen", systemImage: "trash")`

### **PhotosView.swift**
- Zeile 133: `Label("Löschen", systemImage: "trash")`

### **InteractionsView.swift**
- Zeile 155: `Label("Löschen", systemImage: "trash")`

### **WaterIntakeView.swift**
- Zeile 184: `Label("Löschen", systemImage: "trash")`

---

## 📝 **4. TEXTFIELD PLACEHOLDER**

### **PhotosView.swift**
- Zeile 184: `TextField("Titel", text: $title)`
- Zeile 287: `TextField("Titel", text: $title)`

---

## 🔄 **5. TOGGLE**

### **VaccinationsView.swift**
- Zeile 305: `Toggle("Nächste Impfung festlegen", isOn: $hasNextDueDate)`

### **GroomingView.swift**
- Zeile 294: `Toggle("Professionell", isOn: $professional)`

### **ExerciseView.swift**
- Zeile 263: `Toggle("Distanz festlegen", isOn: $hasDistance)`
- Zeile 397: `Toggle("Distanz festlegen", isOn: $hasDistance)`

---

## 📅 **6. PICKER**

### **DocumentsView.swift**
- Zeile 276: `Picker("Kategorie", selection: $category)`

### **GroomingView.swift**
- Zeile 261: `Picker("Typ", selection: $type)`
- Zeile 422: `Picker("Typ", selection: $type)`

### **BathroomView.swift**
- Zeile 236: `Picker("Typ", selection: $type)`
- Zeile 252: `Picker("Konsistenz", selection: $consistency)`
- Zeile 362: `Picker("Typ", selection: $type)`
- Zeile 378: `Picker("Konsistenz", selection: $consistency)`

### **FeedingView.swift**
- Zeile 270: `Picker("Futtertyp", selection: $foodType)`
- Zeile 402: `Picker("Futtertyp", selection: $foodType)`

### **ExpensesView.swift**
- Zeile 254: `Picker("Kategorie", selection: $category)`
- Zeile 372: `Picker("Kategorie", selection: $category)`

### **ActivitiesView.swift**
- Zeile 277: `Picker("Intensität", selection: $intensity)`
- Zeile 410: `Picker("Intensität", selection: $intensity)`

### **InteractionsView.swift**
- Zeile 187: `Picker("Typ", selection: $type)`
- Zeile 218: `Picker("Schweregrad", selection: $severity)`
- Zeile 328: `Picker("Typ", selection: $type)`
- Zeile 359: `Picker("Schweregrad", selection: $severity)`

### **MedicationsView.swift**
- Zeile 312: `Picker("Häufigkeit", selection: $frequency)`
- Zeile 782: `Picker("Häufigkeit", selection: $frequency)`

---

## 📅 **7. DATEPICKER**

### **VaccinationsView.swift**
- Zeile 310: `DatePicker("Nächste Impfung", selection: Binding(...))`

---

## 🚨 **8. ALERT-MELDUNGEN**

### **SettingsView.swift**
- Zeile 508: `"Alle Daten löschen?"`
- Zeile 509: `"Abbrechen"`
- Zeile 510: `"Löschen"`
- Zeile 514: `"Diese Aktion kann nicht rückgängig gemacht werden. Alle Tiere und Gesundheitsdaten werden permanent gelöscht."`

---

## 📱 **9. NAVIGATION TITLES**

### **HomeView.swift**
- Zeile 677: `"Emoji wählen"`

### **SettingsView.swift**
- Zeile 647: `"Datenschutzerklärung"`
- Zeile 691: `"Impressum"`
- Zeile 741: `"AGB"`
- Zeile 791: `"Hilfe & Support"`

### **StatisticsView.swift**
- Zeile 73: `"Statistiken"`

### **EmergencyView.swift**
- Zeile 121: `"Notfall"`

### **JournalView.swift**
- Zeile 306: `"Tagebucheintrag hinzufügen"`
- Zeile 426: `"Tagebucheintrag bearbeiten"`

### **BathroomView.swift**
- Zeile 310: `"Eintrag hinzufügen"`
- Zeile 434: `"Eintrag bearbeiten"`

### **ExerciseView.swift**
- Zeile 329: `"Trainingseinheit hinzufügen"`
- Zeile 461: `"Trainingseinheit bearbeiten"`

### **FeedingView.swift**
- Zeile 331: `"Fütterung hinzufügen"`
- Zeile 461: `"Fütterung bearbeiten"`

### **WeightView.swift**
- Zeile 306: `"Gewicht hinzufügen"`
- Zeile 409: `"Gewicht bearbeiten"`

### **ExpensesView.swift**
- Zeile 321: `"Ausgabe hinzufügen"`
- Zeile 437: `"Ausgabe bearbeiten"`

### **VeterinariansView.swift**
- Zeile 325: `"Tierarzt hinzufügen"`
- Zeile 457: `"Tierarzt bearbeiten"`

### **ConsultationsView.swift**
- Zeile 358: `"Konsultation hinzufügen"`
- Zeile 502: `"Konsultation bearbeiten"`

### **ActivitiesView.swift**
- Zeile 338: `"Aktivität hinzufügen"`
- Zeile 469: `"Aktivität bearbeiten"`

### **PhotoAnalysisView.swift**
- Zeile 107: `"Foto-Analyse"`

### **SymptomsView.swift**
- Zeile 269: `"Symptom hinzufügen"`
- Zeile 392: `"Symptom bearbeiten"`

### **PhotosView.swift**
- Zeile 234: `"Foto hinzufügen"`
- Zeile 332: `"Foto bearbeiten"`

### **InteractionsView.swift**
- Zeile 277: `"Wechselwirkung hinzufügen"`
- Zeile 416: `"Wechselwirkung bearbeiten"`

### **WaterIntakeView.swift**
- Zeile 260: `"Wassereintrag hinzufügen"`
- Zeile 350: `"Wassereintrag bearbeiten"`

---

## 🖨️ **10. CONSOLE LOGS / PRINT STATEMENTS**

### **SettingsView.swift**
- Zeile 562: `print("Fehler beim Export: \(error)")`

---

## 📊 **ZUSAMMENFASSUNG**

### **Nach Kategorien:**
- **Text Views**: ~150+ Instanzen
- **Buttons**: ~30+ Instanzen
- **Labels**: ~15 Instanzen
- **TextFields**: ~2 Instanzen
- **Toggles**: ~4 Instanzen
- **Pickers**: ~20+ Instanzen
- **DatePickers**: ~1 Instanz
- **Alerts**: ~4 Instanzen
- **Navigation Titles**: ~30+ Instanzen
- **Console Logs**: ~1 Instanz

### **Nach Dateien (Top 10):**
1. **StatisticsView.swift** - ~25 deutsche Texte
2. **ActivitiesView.swift** - ~15 deutsche Texte
3. **ExerciseView.swift** - ~12 deutsche Texte
4. **FeedingView.swift** - ~10 deutsche Texte
5. **WeightView.swift** - ~10 deutsche Texte
6. **ExpensesView.swift** - ~10 deutsche Texte
7. **InteractionsView.swift** - ~10 deutsche Texte
8. **BathroomView.swift** - ~10 deutsche Texte
9. **JournalView.swift** - ~8 deutsche Texte
10. **SettingsView.swift** - ~8 deutsche Texte

---

## ✅ **NÄCHSTE SCHRITTE**

1. Alle gefundenen Texte zu `LocalizedStrings.swift` hinzufügen
2. Alle Views aktualisieren, um `.localized` zu verwenden
3. Alle Buttons, Labels, Placeholder, etc. lokalisieren
4. Alle Navigation Titles lokalisieren
5. Alle Alert-Meldungen lokalisieren
6. Console Logs entfernen oder lokalisieren















