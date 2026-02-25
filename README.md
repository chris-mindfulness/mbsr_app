# mbsr_app

Flutter-Web-App für die MBSR-Kursbegleitung.

## Schnellstart

Im Projektordner:

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

## Qualitätscheck

```bash
HOME=/tmp /Users/ch70bure/ki_projects/privat/flutter/bin/flutter analyze --no-pub
HOME=/tmp /Users/ch70bure/ki_projects/privat/flutter/bin/flutter build web --no-pub
```

## Deployment

Deployment läuft über GitHub Actions nach Push auf `main`.
Workflow: `.github/workflows/deploy.yml`
Ziel: Cloudflare Pages (`mindfulpractice-app`).

## Wichtige Doku-Dateien

- `PLAN_APP_OPTIMIERUNG_NAECHSTE_SCHRITTE.md` (aktueller Gesamtstatus)
- `NOTIZ_REFRESH_LOGOUT.md` (Login/Refresh-Verhalten)
- `AUDIOPLAYER_CHECK_2026-02-25.md` (Audio-Status)
- `DESIGN_THEME_UMSETZUNG_2026-02-25.md` (UI-Modi)
- `APPWRITE_SETUP.md` + `CHECKLISTE_APPWRITE_PRUEFEN.md` (Backend-Prüfung)
- `OFFENE_PUNKTE_9_10.md` (inhaltliche Punkte)
- `PRUEFUNG_MD_TXT_DATEIEN_2026-02-25.md` (Doku-Bereinigung)
- `SNYK_KURZANLEITUNG.md` (optional, Security-Check)
