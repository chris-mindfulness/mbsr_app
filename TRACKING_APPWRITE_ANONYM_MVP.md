# Appwrite-Tracking ohne Cache-Verlust (anonym, stabil)

## Ziel
- Tracking soll bei Browserwechsel und geloeschtem Cache nicht verloren gehen.
- Keine personenbezogenen Daten in der Tracking-Statistik.
- Bestehende App-Funktionen sollen unveraendert stabil bleiben.

## Ist-Stand (Code)
- 80%-Schwelle wird in `AudioService` ausgeloest.
- Lokale Statistik liegt in `SharedPreferences`.
- Bei Browserdaten-Loeschung ist die lokale Statistik weg.

## Konkrete Moeglichkeit (MVP)
Ein zusaetzliches, anonymes Appwrite-Tracking nur fuer 80%-Events.

### 1) Neue Appwrite-Tabelle
`audio_listen_aggregate_daily`

Felder:
- `date_key` (String, z. B. `2026-04-17`)
- `audio_id` (String)
- `audio_title` (String)
- `plays_80_count` (Integer)
- `heard_seconds_sum` (Integer)
- `updated_at` (Datetime/String)

Schluessel-Idee:
- Pro Tag + Audio genau ein Aggregat-Datensatz.
- Keine User-ID, keine E-Mail, kein Name.

### 2) Schreibweg ueber Appwrite Function
Warum Function:
- App kann nicht direkt in Aggregat schreiben (Race-Conditions).
- Function kann kontrolliert lesen+erhoehen+schreiben.
- Rechte bleiben sauber.

Function-Input (aus App):
- `audio_id`
- `audio_title`
- `heard_seconds`
- `total_seconds`
- `date_key`

Function-Logik:
1. Payload validieren.
2. Aggregat-Zeile fuer (`date_key`, `audio_id`) holen oder neu anlegen.
3. `plays_80_count += 1`
4. `heard_seconds_sum += heard_seconds`
5. speichern.

### 3) App-Integration ohne Risiko
Hook nur an bestehender Stelle:
- In `lib/audio_service.dart` in `_performTracking(...)`

Wichtig:
- Lokales Tracking bleibt unveraendert.
- Remote-Call nur "best effort" (try/catch, kurzer Timeout).
- Fehler im Remote-Tracking duerfen Audio nie blockieren.
- Aufruf nicht-blockierend (fire-and-forget).

## Warum stoert das die aktuelle App nicht
- Audio-Playback und lokale Statistik bleiben unveraendert.
- Neuer Teil ist optional und fail-safe.
- Bei Appwrite-Ausfall funktioniert die App wie heute weiter.

## Sichtbarkeit in Appwrite
Du siehst in der Tabelle direkt:
- welche Meditation (`audio_title`)
- wie oft gehoert (`plays_80_count`)
- optional pro Tag (`date_key`)

Damit bekommst du sofort eine einfache Statistik ohne Personenbezug.

## Rollout-Empfehlung
1. Funktion + Tabelle in Appwrite bereitstellen.
2. Feature-Flag in App aktivieren (zunaechst nur intern testen).
3. 3-5 Tage beobachten.
4. Dann fuer alle aktivieren.
