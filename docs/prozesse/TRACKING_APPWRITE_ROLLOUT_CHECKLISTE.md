# Rollout-Checkliste: Appwrite-Tracking stabil aktivieren

Stand: April 2026

## 0) Ziel
Remote-Tracking nur als Zusatz aktivieren, ohne Playback- oder UI-Risiko.

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

## 2) Feature-Flag (standardmaessig AUS)
In der App laeuft Remote-Tracking nur, wenn gesetzt:

```bash
--dart-define=APP_ENABLE_REMOTE_TRACKING=true
--dart-define=APP_TRACKING_FUNCTION_ID=track_80_event
--dart-define=APP_TRACKING_TIMEZONE=Europe/Berlin
```

Ohne Flag bleibt Verhalten wie bisher lokal.

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
