# Function `track_80_event`

## Zweck
- Nimmt 80%-Tracking-Events aus der App entgegen.
- Aggregiert in:
  - `audio_daily_aggregate`
  - `slot_daily_aggregate`
  - `audio_participant_daily_aggregate` (pseudonym, pro Person/Tag/Audio)
- Speichert keine personenbezogenen Felder.

## Erwarteter Request-Body

```json
{
  "audio_id": "697d0fc80030febb4db5",
  "audio_title": "Body-Scan standard",
  "participant_ref": "user_abc123",
  "heard_seconds": 612,
  "total_seconds": 720,
  "event_timestamp_utc": "2026-04-17T18:13:24.000Z"
}
```

## Validierung
- `heard_seconds` darf nicht deutlich groesser als `total_seconds` sein (Puffer 5 s)
- Pflichtfelder muessen gesetzt sein
- Zeitstempel muss gueltiges ISO-UTC sein
- `participant_ref` wird serverseitig mit Salt zu `participant_hash` gehasht

## ENV-Variablen
- `APPWRITE_ENDPOINT`
- `APPWRITE_PROJECT_ID`
- `APPWRITE_API_KEY`
- `APPWRITE_DATABASE_ID` (default: `mbsr_database`)
- `APPWRITE_AUDIO_DAILY_TABLE_ID` (default: `audio_daily_aggregate`)
- `APPWRITE_SLOT_DAILY_TABLE_ID` (default: `slot_daily_aggregate`)
- `APPWRITE_AUDIO_PARTICIPANT_DAILY_TABLE_ID` (default: `audio_participant_daily_aggregate`)
- `APP_TRACKING_TIMEZONE` (default: `Europe/Berlin`)
- `APP_TRACKING_HASH_SALT` (required, random secret)

## Slot-Regeln
- `vormittag`: 05:00-11:59
- `nachmittag`: 12:00-17:59
- `abend`: 18:00-04:59

## Stabilitaet
- Retries bei Konflikten/Parallelzugriffen (begrenzt).
- Bei Fehlern liefert Function 5xx, App darf dadurch nicht blockieren.
