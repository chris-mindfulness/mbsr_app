# Plan Tracking-Migration Sommer 2026

## Zweck
Dieser Plan bleibt bis Kursende unverändert liegen.  
Er wird erst nach dem laufenden Kurs umgesetzt, um kein Risiko für die Stabilität einzugehen.

## Ausgangslage
- Tracking liegt aktuell lokal in `SharedPreferences`.
- Bei Browserwechsel oder gelöschten Browserdaten gehen persönliche Statistiken verloren.
- Ziel ist: geräteübergreifender Erhalt der eigenen Statistik bei guter Privatsphäre.

## Zielbild (Hybrid)
- Persönliche Statistik wird pro Account serverseitig gesichert.
- Standard bleibt privat: Teilnehmende sehen ihre Daten, nicht die Kursleitung.
- Kursleitung sieht nur pseudonyme Einzelverläufe und/oder aggregierte Gruppenwerte.
- Keine Klarnamen in Tracking-Datensätzen.

## Umsetzungsphasen
### Phase 0: Freeze bis Kursende
- Keine Tracking-Änderungen im laufenden Kurs.
- Nur Notfall-Fixes bei echten Problemen.

### Phase 1: Entscheidungen finalisieren
- Datenschutz-Standard festlegen: Default privat, optionaler Opt-in für Auswertung.
- Definieren, welche Kennzahlen in Admin-Ansicht erlaubt sind (z. B. Wochenminuten, Streak, Sessions).

### Phase 2: Appwrite-Datenmodell und Rechte
- Tabellen für persönliche Tages-/Wochenaggregate anlegen.
- Optional separate Aggregationstabelle für Gruppenmetriken.
- Rechte strikt setzen:
  - User: nur eigene Tracking-Daten lesen/schreiben.
  - Admin: nur freigegebene Auswertungsdaten lesen.

### Phase 3: Technische Umsetzung (schrittweise)
- Tracking-Repository einführen (lokal + remote).
- Bestehende Tracking-Aufrufe auf Repository umstellen.
- Lokalen Fallback beibehalten, damit die App bei Serverproblemen weiter stabil läuft.
- Konfliktregel definieren (z. B. letzte Aktualisierung gewinnt).

### Phase 4: Migration und Rollout
- Soft-Launch per Feature-Flag (Testgruppe -> stufenweise alle).
- Optional einmalige Übernahme lokaler Bestandsdaten.
- Fail-safe: bei Remote-Fehlern weiterhin lokale Anzeige.

### Phase 5: Kommunikation
- In-App-Text klar aktualisieren:
  - was gespeichert wird,
  - wer was sieht,
  - wie Opt-in/Opt-out funktioniert.
- Kurze Teilnehmer-Info und FAQ ergänzen.

### Phase 6: Qualitätssicherung vor Go-Live
- `flutter analyze --no-pub`
- `flutter test --no-pub`
- Manuelle Tests: Browserwechsel, Browserdaten löschen, Gerätewechsel, Login/Logout, Offline/Online.
- Go-Live-Kriterium: keine Datenverluste bei normaler Nutzung.

## Reaktivieren im Sommer
1. Diese Datei öffnen: `PLAN_TRACKING_SOMMER_2026.md`.
2. Phase 1 final entscheiden (Datenschutz und Admin-Kennzahlen).
3. Erst danach technische Umsetzung starten.
4. Rollout nur stufenweise mit Feature-Flag.

## Risiko-Einschätzung
- Mit stufenweiser Einführung: gering bis mittel.
- Höchstes Risiko wäre ein Big-Bang-Umbau ohne Übergangsphase.
