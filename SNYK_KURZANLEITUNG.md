# Snyk Kurzanleitung (optional)

Stand: 25.02.2026

## Brauche ich Snyk?

Nicht für den normalen Betrieb der App.
Aber sinnvoll für Sicherheitschecks der Abhängigkeiten.

## Minimaler Ablauf

Im Projektordner:

```bash
cd /Users/ch70bure/ki_projects/privat/mbsr_app
```

1) Snyk installieren (einmalig)

```bash
npm install -g snyk
```

2) Snyk anmelden (einmalig)

```bash
snyk auth
```

3) Schnellen Scan ausführen

```bash
./snyk-scan.sh
```

## Was wird dabei geprüft?

- Dart/Flutter-Abhängigkeiten aus `pubspec.yaml` und `pubspec.lock`

## Optionaler kompletter Scan

```bash
./snyk-scan-complete.sh
```

Dieser kann zusätzlich native Android-Abhängigkeiten prüfen und dauert länger.

## Empfehlung für dieses Projekt

- Vor Releases oder 1x pro Monat `./snyk-scan.sh` ausführen.
- Ergebnisse nur dann in Updates umsetzen, wenn wirklich ein relevantes Risiko gemeldet wird.
