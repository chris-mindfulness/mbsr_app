# App starten (einfach)

Stand: 25.02.2026

## 1) In den Projektordner wechseln

```bash
cd /Users/ch70bure/ki_projects/privat/mbsr_app
```

## 2) Flutter prüfen

Variante A (wenn `flutter` im PATH ist):

```bash
flutter --version
```

Variante B (sicher, mit lokalem SDK):

```bash
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter --version
```

## 3) Abhängigkeiten laden

```bash
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter pub get
```

## 4) App lokal starten

Web (empfohlen für schnellen Test):

```bash
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter run -d chrome
```

Optional:

```bash
/Users/ch70bure/ki_projects/privat/flutter/bin/flutter run -d macos
```

## 5) Wichtige Tasten im laufenden Terminal

- `r` = Hot Reload
- `R` = Hot Restart
- `q` = Beenden

## 6) Vor Deploy kurz prüfen

```bash
HOME=/tmp /Users/ch70bure/ki_projects/privat/flutter/bin/flutter analyze --no-pub
HOME=/tmp /Users/ch70bure/ki_projects/privat/flutter/bin/flutter build web --no-pub
```
