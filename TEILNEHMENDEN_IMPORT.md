# Teilnehmenden-Import (nur das Nötige)

## Wichtig vorweg

- **Import und Git passieren getrennt.** Du musst für den Import **keinen** `git commit` machen. Der Import ist nur ein Befehl auf deinem Rechner.
- **Nicht committen:** `import/teilnehmende.csv` (steht in `.gitignore`) — dort stehen echte E-Mails und Passwörter. Auch den **API-Key** niemals in eine Datei schreiben, die ins Repo soll.
- **Committen** nur normale App-Änderungen (Code, Doku ohne Geheimnisse).

## Datei vorbereiten

- Echte Daten: `import/teilnehmende.csv` (lokal anlegen, Spalten wie in `import/teilnehmende.example.csv`).
- Du kannst in Excel pflegen und als **CSV** speichern; das Import-Skript liest nur CSV (Komma oder Semikolon erkennt es selbst).
- **Kodierung:** Zuerst wird **UTF-8** gelesen. Ist die Datei typischer **Excel-Export (Latin-1/Windows-1252)**, erkennt das Skript das und liest mit Fallback — in der Konsole erscheint ein kurzer Hinweis. Für saubere Umlaute in den Namen weiterhin **CSV UTF-8** speichern, wenn möglich.

**Hinweis zum Befehl:** `dart run tool/import_participants.dart …` ist ein **reines Dart-Tool** (ohne Flutter-Engine). Es reicht, im Ordner `mbsr_app` zu sein; `dart` kommt z. B. aus dem Flutter-SDK (`…/flutter/bin/dart`).

## Ablauf im Terminal (Schritt für Schritt)

**1. Terminal öffnen** und in den App-Ordner wechseln:

```bash
cd /Users/ch70bure/ki_projects/privat/mbsr_achtsamkeit/mbsr_app
```

(Pfad anpassen, falls dein Projekt woanders liegt.)

**2. Öffentliche Appwrite-Werte setzen** (die sind unkritisch, stehen auch in der Doku):

```bash
export APPWRITE_ENDPOINT="https://api.mindfulpractice.de/v1"
export APPWRITE_PROJECT_ID="696befd00018180d10ff"
```

**3. API-Key „blind“ eingeben** — du siehst beim Tippen **keine Zeichen**, das ist Absicht:

```bash
read -rs "APPWRITE_API_KEY?Appwrite API Key: "; echo; export APPWRITE_API_KEY
```

**Achtung:** Die Zeile muss **komplett** so enden: `export APPWRITE_API_KEY` (mit Namen am Ende).  
Nur `read …; echo; export` ausführen **ohne** `APPWRITE_API_KEY` setzt **keinen** Key — dann zeigt die Shell nur eine lange Variablenliste und `dart run` meldet `Fehlende Umgebungsvariable: APPWRITE_API_KEY`.

- Nach Enter wartet die Shell: Key tippen oder einfügen, wieder **Enter**.
- Der Key liegt nur in **dieser** Terminal-Sitzung, nicht im Git.

**Kurz prüfen** (ohne den Key anzuzeigen):

```bash
test -n "$APPWRITE_API_KEY" && echo "APPWRITE_API_KEY ist gesetzt" || echo "FEHLT — Schritt 3 wiederholen"
```

**4. Testlauf** (nichts wird in Appwrite geschrieben):

```bash
dart run tool/import_participants.dart --file import/teilnehmende.csv --dry-run
```

**5. Echter Import** (wenn der Test passt):

```bash
dart run tool/import_participants.dart --file import/teilnehmende.csv
```

**6. Key wieder aus der Sitzung entfernen** (gute Gewohnheit):

```bash
unset APPWRITE_API_KEY
```

## Optional: Tabellen-IDs überschreiben

Nur nötig, wenn dein Appwrite anders heißt als der Standard:

```bash
export APPWRITE_DATABASE_ID="mbsr_database"
export APPWRITE_USERS_TABLE_ID="users"
export DEFAULT_ROLE="mbsr"
```

## Kurzfassung (alles in einem Block)

```bash
export APPWRITE_ENDPOINT="https://api.mindfulpractice.de/v1" && export APPWRITE_PROJECT_ID="696befd00018180d10ff"
read -rs "APPWRITE_API_KEY?Appwrite API Key: "; echo; export APPWRITE_API_KEY
dart run tool/import_participants.dart --file import/teilnehmende.csv --dry-run
dart run tool/import_participants.dart --file import/teilnehmende.csv
unset APPWRITE_API_KEY
```

## Sicherheit in einem Satz

Den Key **nicht** so setzen: `APPWRITE_API_KEY=dein_key` direkt in die Zeile tippen — dann ist er auf dem Bildschirm und oft in der Shell-Historie sichtbar. Mit `read -s` bleibt die Eingabe unsichtbar.
