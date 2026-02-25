# Plan: Nächste Schritte zur App-Optimierung

Stand: 25.02.2026 (konsolidiert)

## Was bereits erledigt ist

- Login/Refresh stabilisiert:
  - kein harter Auto-Logout mehr bei kurzzeitigen Backend-Problemen
  - Retry + 401-Unterscheidung + lokale Fallbacks
  - „Profil nicht gefunden“-Schleife behoben
- Refresh-UX beruhigt:
  - weniger Voll-Splash beim Reload
  - weniger visuelles Zucken
- Audio-Flow verbessert:
  - Full-Player schließt ohne Auto-Stop
  - Resume ohne Neu-Laden
  - Tipp-Sheet auf Mobile robust schließbar (`X`, Drag, max. Höhe)
- UI-Design angepasst:
  - Theme-Modi `Ruhig` (Standard) und `Lebendig`
  - Umschalter im Profil, Auswahl bleibt gespeichert
- Inhaltliche Schärfung umgesetzt:
  - Tipps pro Übung/Phase konsistenter verfügbar
  - Glossar/FAQ deutlich fokussierter und verständlicher
- Letzte technische Basis-Checks waren erfolgreich:
  - `flutter analyze --no-pub`
  - `flutter test --no-pub test/data/app_daten_integrity_test.dart`

## Was offen bleibt (sinnvoll, aber nicht kritisch)

### 1) Appwrite-Basis final manuell prüfen
Status: offen (Backend-Check)

Ziel:
Weniger Abhängigkeit von Fallback-Logik, stabiler Normalpfad.

Akzeptanz:
- `/account` bleibt nach Refresh stabil gültig.
- Profil wird direkt gefunden, ohne Zwischenfehlerseite.

### 2) Visuelles Refresh-Feintuning
Status: optional

Ziel:
Restliches Mikro-Flickern beim Reload weiter glätten.

Akzeptanz:
- Beim Refresh kein spürbares Doppel-Rendering im sichtbaren Bereich.

### 3) Leichte technische Aufräumung (nur bei Bedarf)
Status: optional

Ziel:
Wartbarkeit verbessern, ohne neue Komplexität.

Akzeptanz:
- Kleine refactorings nur dort, wo klarer Nutzen besteht (z. B. wiederkehrende UI-Bausteine).
- Keine Verhaltensänderung in Login/Audio/Kursfluss.
