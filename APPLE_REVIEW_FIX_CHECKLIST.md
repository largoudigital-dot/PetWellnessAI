# 🚨 Apple Review Fix Checklist

## ❌ **WICHTIG: NOCH NICHT HOCHLADEN!**

Alle folgenden Probleme müssen BEVOR dem Upload behoben werden:

---

## 1. ✅ Guideline 2.1 - ATT Permission Request (iPadOS 26.2)

**Problem:** Apple kann die ATT-Anfrage auf iPadOS 26.2 nicht finden.

**Status:** ⚠️ Muss verbessert werden

**Lösung:**
- ✅ ATT ist bereits implementiert
- ⚠️ Muss früher im App-Lifecycle aufgerufen werden
- ⚠️ Muss auch ohne Consent-Dialog angezeigt werden
- ⚠️ Muss auf iPadOS 26.2 getestet werden

**Aktion:**
- [ ] ATT-Anfrage direkt beim App-Start (vor Consent-Dialog)
- [ ] Test auf iPadOS 26.2
- [ ] Antwort an Apple: "Die ATT-Anfrage erscheint direkt beim App-Start, bevor Daten gesammelt werden"

---

## 2. ❌ Guideline 1.4.1 - Regulatory Clearance

**Problem:** App benötigt regulatorische Genehmigungen für medizinische Informationen.

**Status:** ❌ KRITISCH - Kann nicht behoben werden ohne Dokumentation

**Lösung:**
- ⚠️ **Du musst regulatorische Genehmigungen haben ODER**
- ⚠️ **Die App muss als "Informations-App" deklariert werden (keine Diagnosen/Treatments)**

**Aktion:**
- [ ] Entscheiden: Hat die App regulatorische Genehmigungen?
  - **JA:** Dokumentation in App Store Connect hochladen
  - **NEIN:** App muss als reine Informations-App deklariert werden
- [ ] AI-Prompts anpassen: KEINE Diagnosen, KEINE Behandlungsempfehlungen
- [ ] Disclaimers verstärken: "Nur für Informationszwecke"
- [ ] Antwort an Apple: Entweder Dokumentation hochladen ODER erklären, dass es eine Informations-App ist

---

## 3. ⚠️ Guideline 1.4.1 - Citations

**Problem:** Citations sind nicht prominent genug oder Apple hat sie nicht gefunden.

**Status:** ⚠️ Muss verbessert werden

**Lösung:**
- ✅ MedicalCitationsView existiert bereits
- ✅ Citations-Button in ChatView vorhanden
- ⚠️ Muss prominenter gemacht werden
- ⚠️ AI muss in JEDER Antwort Citations erwähnen

**Aktion:**
- [ ] Citations-Button prominenter machen (größer, besser sichtbar)
- [ ] AI-Prompts anpassen: JEDE Antwort muss mit "Sources: [Link]" enden
- [ ] Citations auch in EmergencyDetailView prominenter platzieren
- [ ] Antwort an Apple: "Citations sind über den Citations-Button in der ChatView und EmergencyDetailView erreichbar"

---

## 4. ✅ Guideline 2.3 - Keywords

**Problem:** Zu viele Keywords in App Store Connect.

**Status:** ✅ Kann behoben werden (App Store Connect)

**Lösung:**
- Reduziere Keywords auf 10-15 relevante Begriffe

**Aktion:**
- [ ] In App Store Connect: Keywords reduzieren auf:
  - "pet health"
  - "pet care"
  - "AI assistant"
  - "pet wellness"
  - "veterinary information"
  - "pet symptoms"
  - "pet tracker"
  - "pet records"
- [ ] Entferne: "all pets", "any pet", "pet owner", "animal care", spezifische Tierarten

---

## 📋 VOR DEM UPLOAD:

1. ✅ ATT früher aufrufen
2. ✅ Citations prominenter machen
3. ✅ AI-Prompts anpassen (keine Diagnosen, immer Citations)
4. ✅ Keywords reduzieren (App Store Connect)
5. ✅ Antwort an Apple vorbereiten
6. ✅ Version auf 1.1 erhöhen
7. ✅ Test auf iPadOS 26.2 (falls möglich)

---

## 📝 ANTWORT AN APPLE (Vorlage):

```
Hello Apple Review Team,

Thank you for your feedback. I have addressed all issues:

1. ATT Permission Request (Guideline 2.1):
   - The ATT permission request appears immediately upon app launch, before any data collection.
   - It is called in ContentView.onAppear with a 0.5 second delay to ensure UI is loaded.
   - The request appears on all iOS versions including iPadOS 26.2.

2. Regulatory Clearance (Guideline 1.4.1):
   - This app is an informational app only and does not provide diagnoses or treatment advice.
   - All AI responses include disclaimers stating that professional veterinary consultation is required.
   - The app provides general information only and always recommends consulting a licensed veterinarian.

3. Citations (Guideline 1.4.1):
   - Citations are easily accessible via the "Citations" button (book icon) in the chat header.
   - Citations are also available in the Emergency Detail View.
   - All AI responses include source citations at the end.
   - The MedicalCitationsView displays 5 trusted veterinary sources with links.

4. Keywords (Guideline 2.3):
   - Keywords have been reduced to 10-15 relevant terms.
   - Removed irrelevant keywords as requested.

Thank you for your review.

Best regards,
[Your Name]
```

---

## ⚠️ WICHTIG:

**Die App kann NICHT hochgeladen werden, bis:**
1. ✅ ATT früher aufgerufen wird
2. ✅ Citations prominenter sind
3. ✅ AI-Prompts angepasst sind (keine Diagnosen)
4. ✅ Keywords reduziert sind
5. ✅ Antwort an Apple vorbereitet ist

**Regulatorische Genehmigungen:**
- Wenn du KEINE hast: App muss als reine Informations-App deklariert werden
- AI darf KEINE Diagnosen stellen
- AI darf KEINE Behandlungsempfehlungen geben
- Nur allgemeine Informationen + "Konsultiere einen Tierarzt"

