# Tracking in Appwrite: Schema und Rechte

Stand: April 2026

## Ziel
- Nur aggregierte Trackingdaten speichern.
- Keine personenbezogenen Felder speichern.
- Schreibzugriffe nur ueber Function.

## Tabellen

### 1) `audio_daily_aggregate`
Pro Tag und Audio genau ein Datensatz.

Felder:
- `date_key` (String, Format `YYYY-MM-DD`)
- `audio_id` (String, Appwrite File-ID)
- `audio_title` (String, fuer Lesbarkeit in Auswertung)
- `plays_80_count` (Integer, Anzahl 80%-Events)
- `heard_seconds_sum` (Integer, Summe real gehoerter Sekunden)
- `updated_at` (Datetime)

Empfohlene Keys/Indizes:
- Komposit-Key: `date_key + audio_id` (eindeutig)
- Sekundaerindex: `date_key`

### 2) `slot_daily_aggregate`
Pro Tag und Slot genau ein Datensatz.

Felder:
- `date_key` (String, Format `YYYY-MM-DD`)
- `slot_key` (String, `vormittag` | `nachmittag` | `abend`)
- `plays_80_count` (Integer)
- `heard_seconds_sum` (Integer)
- `updated_at` (Datetime)

Empfohlene Keys/Indizes:
- Komposit-Key: `date_key + slot_key` (eindeutig)
- Sekundaerindex: `date_key`

### 3) `weekly_distribution_aggregate`
Nur Verteilungs-Buckets, keine Einzelprofile.

Felder:
- `week_key` (String, z. B. `2026-W16`)
- `bucket_key` (String, z. B. `0-20`, `21-60`, `61-120`, `121+`)
- `participant_count` (Integer)
- `updated_at` (Datetime)

Empfohlene Keys/Indizes:
- Komposit-Key: `week_key + bucket_key` (eindeutig)

### 4) `audio_participant_daily_aggregate`
Pro Tag, Audio und pseudonymisierter Person genau ein Datensatz.

Felder:
- `date_key` (String, Format `YYYY-MM-DD`)
- `audio_id` (String, Appwrite File-ID)
- `audio_title` (String)
- `participant_hash` (String, SHA-256 aus `participant_ref + salt`)
- `plays_80_count` (Integer)
- `heard_seconds_sum` (Integer)
- `updated_at` (Datetime)

Empfohlene Keys/Indizes:
- Komposit-Key: `date_key + audio_id + participant_hash` (eindeutig)
- Sekundaerindex: `date_key`

## Zeitslots (fix)
- `vormittag`: 05:00-11:59
- `nachmittag`: 12:00-17:59
- `abend`: 18:00-04:59

Zeitzone:
- Standard `Europe/Berlin`
- wird als Konfiguration an Function uebergeben (`APP_TRACKING_TIMEZONE`).

## Berechtigungen
- App-User:
  - kein direktes Schreiben in Aggregat-Tabellen
  - kein direktes Lesen der Aggregat-Tabellen
- Function-Service:
  - darf lesen/schreiben in allen vier Aggregat-Tabellen
- Admin-Rolle (nur Kursleitung):
  - read-only Zugriff auf Aggregat-Tabellen

## Datenschutzgrenzen
- Keine E-Mail, keine User-ID, kein Name in Aggregat-Tabellen.
- `participant_ref` wird nie gespeichert; nur `participant_hash`.
- CSV-Export nur aus Aggregaten.
- Keine Rohdaten pro Pseudonym im Export.

## Stabilitaet
- Aggregat-Schreiben nie direkt aus der App.
- App sendet nur Event an Function.
- Wenn Function fehlschlaegt, bleibt lokales Tracking unveraendert aktiv.
