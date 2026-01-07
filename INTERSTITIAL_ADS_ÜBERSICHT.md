# 📍 Interstitial Ads - Übersicht

## ✅ Wo Interstitial Ads angezeigt werden:

Interstitial Ads werden nach wichtigen Benutzer-Aktionen angezeigt. Die Funktion `AdManager.shared.showInterstitialAfterAction()` wird in folgenden Views aufgerufen:

### 1. **HomeView.swift** (Zeile 887)
- **Wann**: Nach dem Erstellen eines neuen Tierprofils
- **Aktion**: Neues Haustier hinzufügen

### 2. **MedicationsView.swift** (Zeile 567)
- **Wann**: Nach dem Hinzufügen eines Medikaments
- **Aktion**: Medikament speichern

### 3. **AppointmentsView.swift** (Zeile 404)
- **Wann**: Nach dem Erstellen eines Termins
- **Aktion**: Tierarzt-Termin speichern

### 4. **VaccinationsView.swift** (Zeile 412)
- **Wann**: Nach dem Hinzufügen einer Impfung
- **Aktion**: Impfung speichern

### 5. **SymptomInputView.swift** (Zeile 146)
- **Wann**: Nach dem Eingeben von Symptomen
- **Aktion**: Symptome speichern

### 6. **PhotoAnalysisView.swift** (Zeile 90)
- **Wann**: Nach dem Analysieren eines Fotos
- **Aktion**: Foto-Analyse starten

### 7. **PetProfileView.swift** (Zeile 234)
- **Wann**: Nach dem Aktualisieren des Tierprofils
- **Aktion**: Profil-Daten speichern

### 8. **BathroomView.swift** (Zeile 337)
- **Wann**: Nach dem Speichern von Toilettengängen
- **Aktion**: Toilettengang speichern

### 9. **PhotosView.swift** (Zeile 255)
- **Wann**: Nach dem Hinzufügen eines Fotos
- **Aktion**: Foto speichern

### 10. **VeterinariansView.swift** (Zeile 340)
- **Wann**: Nach dem Hinzufügen eines Tierarztes
- **Aktion**: Tierarzt-Kontakt speichern

### 11. **SymptomsView.swift** (Zeile 318)
- **Wann**: Nach dem Speichern von Symptomen
- **Aktion**: Symptom-Eintrag speichern

### 12. **InteractionsView.swift** (Zeile 379)
- **Wann**: Nach dem Speichern von Interaktionen
- **Aktion**: Interaktion speichern

### 13. **WaterIntakeView.swift** (Zeile 268)
- **Wann**: Nach dem Speichern der Wasseraufnahme
- **Aktion**: Wasseraufnahme speichern

### 14. **ExpensesView.swift** (Zeile 353)
- **Wann**: Nach dem Hinzufügen einer Ausgabe
- **Aktion**: Ausgabe speichern

### 15. **ConsultationsView.swift** (Zeile 381)
- **Wann**: Nach dem Hinzufügen einer Konsultation
- **Aktion**: Konsultation speichern

### 16. **DocumentsView.swift** (Zeile 339)
- **Wann**: Nach dem Hinzufügen eines Dokuments
- **Aktion**: Dokument speichern

### 17. **JournalView.swift** (Zeile 303)
- **Wann**: Nach dem Erstellen eines Tagebucheintrags
- **Aktion**: Tagebucheintrag speichern

### 18. **GroomingView.swift** (Zeile 352)
- **Wann**: Nach dem Speichern von Pflegemaßnahmen
- **Aktion**: Pflegemaßnahme speichern

### 19. **ExerciseView.swift** (Zeile 341)
- **Wann**: Nach dem Speichern von Bewegung
- **Aktion**: Bewegung speichern

### 20. **FeedingView.swift** (Zeile 347)
- **Wann**: Nach dem Speichern von Fütterungen
- **Aktion**: Fütterung speichern

### 21. **ActivitiesView.swift** (Zeile 357)
- **Wann**: Nach dem Speichern von Aktivitäten
- **Aktion**: Aktivität speichern

### 22. **WeightView.swift** (Zeile 314)
- **Wann**: Nach dem Speichern des Gewichts
- **Aktion**: Gewicht speichern

---

## 🔧 Wie funktioniert es?

### Funktion: `showInterstitialAfterAction()`
- **Ort**: `AdManager.swift` (Zeile 1174)
- **Funktion**: 
  - Zählt alle Button-Klicks (über alle Aktionen hinweg)
  - Zeigt Interstitial Ad basierend auf Frequenz aus Firebase Remote Config
  - Standard-Frequenz: Alle 3 Klicks (konfigurierbar über Firebase)

### Firebase Remote Config Einstellungen:
- **`interstitial_enabled`**: Aktiviert/deaktiviert Interstitial Ads
- **`interstitial_frequency`**: Nach wie vielen Klicks soll Ad erscheinen (z.B. 3 = alle 3 Klicks)
- **`interstitial_min_interval`**: Mindest-Abstand zwischen Ads in Sekunden

### Beispiel:
```
Klick 1: Kein Ad
Klick 2: Kein Ad
Klick 3: ✅ Interstitial Ad wird angezeigt
Klick 4: Kein Ad
Klick 5: Kein Ad
Klick 6: ✅ Interstitial Ad wird angezeigt
```

---

## 📊 Status:

### ✅ Implementiert:
- Alle 22 Views haben `showInterstitialAfterAction()` implementiert
- Interstitial Ads werden beim App-Start geladen
- Frequenz wird über Firebase Remote Config gesteuert
- Ads werden automatisch neu geladen nach Anzeige

### ⚠️ Zu prüfen:
- Firebase Remote Config: `interstitial_enabled` muss `true` sein
- Firebase Remote Config: `interstitial_ad_unit_id` muss gesetzt sein
- Firebase Remote Config: `interstitial_frequency` sollte gesetzt sein (Standard: 3)

---

## 🎯 Zusammenfassung:

**Interstitial Ads sind in 22 verschiedenen Views implementiert** und erscheinen nach wichtigen Benutzer-Aktionen wie:
- Medikamente hinzufügen
- Termine erstellen
- Impfungen hinzufügen
- Symptome eingeben
- Fotos hochladen
- Und viele weitere Aktionen...

Die Häufigkeit wird über Firebase Remote Config gesteuert, sodass du die Frequenz jederzeit anpassen kannst, ohne die App zu aktualisieren.


