# Teilnehmenden-Import (nur das Nötige)

## 1) API-Zugang setzen (sicher)

```bash
export APPWRITE_ENDPOINT="https://api.mindfulpractice.de/v1" && export APPWRITE_PROJECT_ID="696befd00018180d10ff"
read -rs "APPWRITE_API_KEY?Appwrite API Key: "; echo; export APPWRITE_API_KEY
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

Optional danach Key wieder aus der Session entfernen:

```bash
unset APPWRITE_API_KEY
```

Hinweis: Den Key niemals als `APPWRITE_API_KEY=...` in die Shell schreiben, sonst ist er sichtbar.