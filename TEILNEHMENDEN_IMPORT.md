# Teilnehmenden-Import (Batch)

Mit diesem Skript legst du in **einem Lauf** an:

- Auth-Account in Appwrite
- Rollenprofil in der `users`-Tabelle (`role=mbsr`)

## 1) CSV vorbereiten

Datei z. B. unter `import/teilnehmende.csv` anlegen.

Header:

`email;name;password;role`

`role` ist optional (Default ist `mbsr`).

Beispiel liegt in:

`import/teilnehmende.example.csv`

## 2) API-Zugang setzen

Das Skript braucht eine Appwrite API Key mit Rechten für:

- Users lesen/schreiben
- TablesDB Rows lesen/schreiben

Umgebungsvariablen:

```bash
export APPWRITE_ENDPOINT="https://api.mindfulpractice.de/v1"
export APPWRITE_PROJECT_ID="696befd00018180d10ff"
export APPWRITE_API_KEY="dein_appwrite_api_key"
```

Optional:

```bash
export APPWRITE_DATABASE_ID="mbsr_database"
export APPWRITE_USERS_TABLE_ID="users"
export DEFAULT_ROLE="mbsr"
```

## 3) Testlauf ohne Schreiben

```bash
dart run tool/import_participants.dart --file import/teilnehmende.csv --dry-run
```

## 4) Echter Import

```bash
dart run tool/import_participants.dart --file import/teilnehmende.csv
```

## Verhalten

- E-Mails werden normalisiert (`trim`, lowercase)
- Bereits vorhandene Auth-Accounts werden nicht doppelt angelegt
- Bereits vorhandene Profile in `users` werden nicht doppelt angelegt
- Es wird eine Ergebnis-Zusammenfassung ausgegeben

## Wichtiger Hinweis

Passwörter stehen in der CSV im Klartext. Datei nur lokal nutzen und nach dem Import löschen oder sicher ablegen.
