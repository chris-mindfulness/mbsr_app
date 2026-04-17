# Checkliste: Appwrite-Tracking / keine Executions

Fuer morgen: der Reihe nach abhaken. Kurze Saetze.

---

## A) Was im Projekt schon angepasst wurde (Referenz)

- [ ] GitHub **deploy** / **quality**: `flutter build web` mit `--dart-define` (Remote-Tracking, Function-ID, Zeitzone).
- [ ] **Function-ID** in der App: Appwrite-**$id** (z. B. `69e238000035a8d4295f`), **nicht** nur der Name `track_80_event`.
- [ ] **Release ohne Define**: Remote-Tracking ist im **Release-Build** standard **an** (lokal/Debug aus).
- [ ] **TrackingRemoteService**: synchrone Ausfuehrung (`xasync: false`), Timeout **20 s**.
- [ ] Function **index.js**: alte starre `heard/total >= 0.8`-Validierung entfernt (sonst viele Events mit 400 abgelehnt).
- [ ] **AudioService**: Ende der Wiedergabe `completed` -> Status **paused** (Play-Symbol).

---

## B) Appwrite (Backend) – manuell pruefen

- [ ] Function **track_80_event** existiert, **aktives Deployment**.
- [ ] **Execute access**: mindestens eine Rolle, die **eingeloggte Nutzer** erlaubt (z. B. **`users`**). Nicht leer lassen.
- [ ] **Settings → Function ID** (`$id`) = dieselbe ID wie in der **gebauten App** (`APP_TRACKING_FUNCTION_ID` / Default in `lib/core/app_config.dart`).
- [ ] **Variablen (ENV)** der Function gesetzt: `APPWRITE_ENDPOINT`, `APPWRITE_PROJECT_ID`, `APPWRITE_API_KEY`, `APPWRITE_DATABASE_ID`, Tabellen-IDs, `APP_TRACKING_TIMEZONE`, **`APP_TRACKING_HASH_SALT`** (Pflicht).
- [ ] Aggregate-**Tabellen** existieren, Rechte wie in `docs/prozesse/TRACKING_APPWRITE_SCHEMA_UND_RECHTE.md`.

---

## C) Live-Web-App (Cloudflare / Build)

- [ ] Letzter **Deploy** ist **nach** den letzten Git-Aenderungen (GitHub Actions gruen, oder Cloudflare „Last deployment“ Datum).
- [ ] **Gleiche Quelle**: Wird die Seite wirklich aus **diesem** Build geliefert (nicht alter Zweig / manuelles Upload ohne CI)?
- [ ] Im Browser: **hart neu laden** (Cache leeren / Shift-Reload), ggf. anderes Fenster **Inkognito**.

---

## D) Test aus der App

- [ ] **Eingeloggt** (normale Teilnehmer-Session).
- [ ] Audio mit **echter** `appwrite_id` (nicht leer / nicht „pending“).
- [ ] Mindestens bis ca. **80 %** der Laufzeit hoeren (oder komplett bis Ende).

---

## E) Wenn weiterhin keine Executions

1. [ ] **Browser → Entwicklertools → Netzwerk** (waehrend des Hoerens / danach):
   - Gibt es einen Request auf  
     `.../v1/functions/<DEINE_FUNCTION_ID>/executions`?
   - **Nein** → App sendet nicht (alter Build, kein 80 %-Trigger, oder `appwrite_id` leer).
   - **Ja** → **HTTP-Status** notieren (401, 404, 500?) und **Antwort-Text** (kurz kopieren).

2. [ ] **Appwrite → Functions → track_80_event → Executions**:
   - **Gar keine** neuen Zeilen → meist kein Request aus der App (siehe E1 + Abschnitt C).
   - **Nur „failed“** → eine Execution oeffnen, **Logs / Response** lesen; haengt oft an ENV, Rechten auf Tabellen oder Salt.

3. [ ] **Function-ID** nochmal vergleichen: Appwrite Settings vs. gebaute App (bei neuer Function aendert sich die `$id`).

---

## F) Kurz-Dokumentation im Repo

- [ ] `docs/prozesse/TRACKING_APPWRITE_ROLLOUT_CHECKLISTE.md` (Rollout, Flag, Symptom „Console geht, App nicht“).
- [ ] `docs/prozesse/TRACKING_APPWRITE_SCHEMA_UND_RECHTE.md` (Tabellen, Rechte).

---

*Stand: Checkliste fuer Debugging „keine Executions“; Inhalt aus Projekt-Chat zusammengestellt.*
