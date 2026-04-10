# mbsr_app

Flutter-Web-App für die MBSR-Kursbegleitung.

## Schnellstart

```bash
cd /Users/ch70bure/ki_projects/privat/mbsr_app
```

Wenn `flutter` nicht global verfügbar ist, nutze das lokale SDK:

```bash
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter --version
```

Abhängigkeiten laden und App lokal starten:

```bash
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter pub get
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter run -d chrome
```

Optional können Appwrite-Werte per `--dart-define` gesetzt werden:

```bash
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter run -d chrome \
  --dart-define=APPWRITE_ENDPOINT=https://api.mindfulpractice.de/v1 \
  --dart-define=APPWRITE_PROJECT_ID=696befd00018180d10ff
```

Passwort-Reset-Redirect (Standard: Produktions-URL): nur bei Bedarf überschreiben, siehe `docs/prozesse/PASSWORT_RESET_REDIRECT.md`.

Alternativ auf macOS testen:

```bash
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter run -d macos
```

Wichtige Tasten im laufenden Terminal: `r` Hot Reload, `R` Hot Restart, `q` Beenden.

## Qualitätscheck

```bash
HOME=/tmp /Users/ch70bure/ki_projects/privat/flutter/bin/flutter analyze --no-pub
HOME=/tmp /Users/ch70bure/ki_projects/privat/flutter/bin/flutter test --no-pub
HOME=/tmp /Users/ch70bure/ki_projects/privat/flutter/bin/flutter build web --no-pub
```

## Deployment

Deployment läuft über GitHub Actions nach Push auf `main`.
Workflow: `.github/workflows/deploy.yml`
Ziel: Cloudflare Pages (`mindfulpractice-app`).

## Kursdaten & Mediathek

- Inhalte: `lib/app_daten.dart` (Audios, Wochenverweise, Texte).
- Appwrite Storage: View- und Download-URLs zentral in `lib/core/appwrite_storage_urls.dart`; Streaming im Player, optionaler Datei-Download in der Mediathek (siehe `AppTexts.mediathekDownloadHint`).
- Mehrere Sprecher-Varianten derselben Übung: im Titel `(Name)` ergänzen und überall dieselbe Zeichenkette in `audioRefs` verwenden — siehe auch `CLAUDE.md` im übergeordneten Ordner `mbsr_achtsamkeit/`.

## Dokumentation

- `PLAN_APP_OPTIMIERUNG_NAECHSTE_SCHRITTE.md` — Roadmap und offene Punkte
- `APPWRITE_SETUP.md` — Backend-Konfiguration (DB, Storage, Auth)
- `CHECKLISTE_APPWRITE_PRUEFEN.md` — Troubleshooting bei Login-/Profil-Problemen
- `TEILNEHMENDEN_IMPORT.md` — Batch-Import für Teilnehmende (Auth + Rollenprofil)
- `SECURITY_AUDIT_2026-02-28.md` — Go-Live-Audit mit Entscheidungsgrundlage
- `.cursor/rules/mbsr-projekt.mdc` — Projektregeln (automatisch in jeder AI-Session aktiv)
