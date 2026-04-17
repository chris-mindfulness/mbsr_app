# Rollout-Checkliste: Appwrite-Tracking stabil aktivieren

Stand: April 2026

## 0) Ziel
Remote-Tracking nur als Zusatz aktivieren, ohne Playback- oder UI-Risiko.

## 0b) Symptom: In Appwrite „Execution test“ geht, aus der Web-App kommt nichts

Typische Ursachen (in dieser Reihenfolge pruefen):

1. **Function → Settings / Ausfuehrung:** Eingeloggte Nutzer duerfen die Function starten (je nach Appwrite-Version z. B. **Execute access: Users** oder **any** mit Session — nicht nur Server/Console). Der Test in der Konsole nutzt oft **Admin/API-Kontext**, die App nutzt die **Teilnehmer-Session**.
2. **Function-ID in der App:** `APP_TRACKING_FUNCTION_ID` muss die **$id** der Function in Appwrite sein (nicht zwingend der Anzeigename). Stimmt die ID mit dem Eintrag unter Functions ueberein?
3. **Web-Build:** Remote-Tracking nur aktiv mit `APP_ENABLE_REMOTE_TRACKING=true` (siehe Abschnitt 2 / CI-Deploy). Ohne Flag sendet die App **gar nichts**.
4. **Executions-Liste** in Appwrite filtern nach **Trigger** aus der App (nicht nur manuelle Tests): tauchen **fehlgeschlagene** Laeufe auf? Logs oeffnen.

Die App nutzt **synchrone** Function-Ausfuehrung (`xasync: false`), damit Fehler und Response in der Antwort stehen (bei rein async war die App „stumm“).

## 1) Vorbereitung (Backend zuerst)
- Tabellen und Rechte gem. `docs/prozesse/TRACKING_APPWRITE_SCHEMA_UND_RECHTE.md` anlegen.
- Function `track_80_event` deployen:
  - Code: `appwrite_functions/track_80_event/index.js`
  - ENV setzen:
    - `APPWRITE_ENDPOINT`
    - `APPWRITE_PROJECT_ID`
    - `APPWRITE_API_KEY`
    - `APPWRITE_DATABASE_ID`
    - `APPWRITE_AUDIO_DAILY_TABLE_ID`
    - `APPWRITE_SLOT_DAILY_TABLE_ID`
    - `APPWRITE_AUDIO_PARTICIPANT_DAILY_TABLE_ID`
    - `APP_TRACKING_TIMEZONE`
    - `APP_TRACKING_HASH_SALT`
- Retention-Function deployen:
  - Code: `appwrite_functions/tracking_retention_cleanup/index.js`
  - zuerst Dry-Run (`APP_TRACKING_RETENTION_DRY_RUN=true`)

## 2) Feature-Flag (Release vs. lokal)

**Release-Web-Build** (`flutter build web --release`): Wenn `APP_ENABLE_REMOTE_TRACKING`
**nicht** gesetzt ist, ist Remote-Tracking **standard AN** (damit z. B. Cloudflare-Pages-
Direktbuilds ohne `--dart-define` trotzdem Events senden).

**Lokal / Debug / Tests:** Ohne Define ist Tracking **AUS**.

**Explizit ausschalten** (auch im Release):

```bash
--dart-define=APP_ENABLE_REMOTE_TRACKING=false
```

**Empfohlen** weiterhin explizit setzen (CI / Dokumentation):

```bash
--dart-define=APP_ENABLE_REMOTE_TRACKING=true
--dart-define=APP_TRACKING_FUNCTION_ID=track_80_event
--dart-define=APP_TRACKING_TIMEZONE=Europe/Berlin
```

## 3) Pflichtchecks vor Aktivierung
- `flutter analyze --no-pub`
- `flutter test --no-pub`
- Lokaler Funktionstest:
  - Audio bis >=80% hoeren.
  - Erwartung: lokale Statistik bleibt unveraendert.
  - Erwartung: zusaetzlicher Aggregat-Eintrag in Appwrite.

## 4) Smoke-Test (24-48h)
- Flag nur intern aktivieren.
- Beobachten:
  - Audio startet/stoppt normal.
  - Keine neuen Playback-Haenger.
  - Function-Error-Rate niedrig.
  - Aggregatwerte plausibel (kein sprunghaftes Fehlverhalten).

## 5) Rollback-Kriterien (sofort)
Flag wieder AUS, wenn:
- Playback-Fehler sichtbar zunehmen.
- Audio-Flow verzoegert/haengt.
- Tracking-Function regelmaessig fehlschlaegt.

Rollback ist nur Konfigurationsaenderung:
- `APP_ENABLE_REMOTE_TRACKING=false`

## 6) Freigabe fuer alle
- Erst nach stabilem Smoke-Test.
- Danach Flag global aktivieren.
- Erste 7 Tage taeglich Logs + Aggregatdaten pruefen.

## 7) CSV-Export nur aggregiert
Export-Skript:

```bash
dart run tool/export_tracking_aggregates.dart --from 2026-01-01 --to 2026-12-31
```

Wichtig:
- Kein Export von Rohdaten pro Person.
- Nur Aggregat-CSV-Dateien nutzen.
