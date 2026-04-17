# Function `tracking_retention_cleanup`

## Zweck
- Loescht alte Aggregatdaten gemaess Retention-Regel.
- Standard: 12 Monate.
- Unterstuetzt Dry-Run fuer sichere Vorpruefung.

## ENV
- `APPWRITE_ENDPOINT`
- `APPWRITE_PROJECT_ID`
- `APPWRITE_API_KEY`
- `APPWRITE_DATABASE_ID` (default: `mbsr_database`)
- `APPWRITE_AUDIO_DAILY_TABLE_ID` (default: `audio_daily_aggregate`)
- `APPWRITE_SLOT_DAILY_TABLE_ID` (default: `slot_daily_aggregate`)
- `APPWRITE_WEEKLY_DISTRIBUTION_TABLE_ID` (default: `weekly_distribution_aggregate`)
- `APP_TRACKING_RETENTION_MONTHS` (default: `12`)
- `APP_TRACKING_RETENTION_DRY_RUN` (default: `false`)

## Ablauf
1. Cutoff-Datum und Cutoff-Woche berechnen.
2. Alte Zeilen in allen Aggregat-Tabellen suchen.
3. Bei Dry-Run nur zaehlen.
4. Sonst alte Zeilen loeschen.

## Rueckgabe
- JSON mit Match- und Delete-Zahlen pro Tabelle.

## Scheduling
- Empfohlen taeglich nachts (z. B. 03:10 Uhr).
- Zuerst 1-2 Tage im Dry-Run laufen lassen.
