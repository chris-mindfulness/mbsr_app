# Plan: Nächste Schritte zur App-Optimierung

Stand: 26.02.2026 (aktualisiert)

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
- Struktur- und Benennungs-Update umgesetzt (8-Wochen-Logik):
  - Wochentitel originalnäher ausgerichtet:
    - Woche 1: `Achtsamkeit`
    - Woche 4: `Stress in Körper und Geist`
    - Woche 5: `Achtsamkeit gegenüber stressverschärfenden Gedanken`
    - Woche 6: `Achtsame Kommunikation`
    - Woche 8: `Abschied und Neubeginn`
  - Begriff im Glossar angepasst:
    - `Schwierige Kommunikation` -> `Achtsame Kommunikation`
  - Wochenblock umbenannt:
    - `Deine Übungen` -> `Hinweise zu deinen Übungen dieser Woche`
  - Reihenfolge in der Wochenansicht neu geordnet:
    - `Titel/Teaser/Fokus -> Zitat -> Hinweise zu deinen Übungen dieser Woche -> Deine Praxis diese Woche`
- Notfall-Koffer in Wochenansichten ergänzt:
  - pro Woche direkter Einstieg ohne Umweg über Mediathek
  - Bottom-Sheet mit Akuthilfe + Schnellstart `Ankommen`
- Woche 5-8 inhaltlich geschärft:
  - neue kompakte Hilfekarten je Woche mit `Wenn es schwierig wird`
  - Fokus auf typische Hürden (Gedanken, Kommunikation, Selbstfürsorge, Transfer nach Kursende)
- Typografie an Website-Basis angeglichen:
  - Body-Werte auf Website-Standard gesetzt (`17px`, `1.6`, `#1E1F1D`, normales Gewicht)
  - dedizierte Muted-Farbe ergänzt (`#5F6662`) und in Kernbereichen verwendet
  - Woche-4-Lesemodus von Heavy-Overrides auf globale Typografie zurückgeführt
  - Web-Fontstack im Theme explizit mit Fallbacks abgebildet (Sans + Heading-Familie)
  - zusätzlicher Token-Test für Typografie-Basiswerte ergänzt
- Technische Checks nach den Änderungen erfolgreich:
  - `flutter analyze --no-pub` grün
  - `flutter test --no-pub` grün

## Was offen bleibt (sinnvoll, aber nicht kritisch)

### 1) Appwrite-Basis final manuell prüfen
Status: offen (Backend-Check)

Ziel:
Weniger Abhängigkeit von Fallback-Logik, stabiler Normalpfad.

Akzeptanz:
- `/account` bleibt nach Refresh stabil gültig.
- Profil wird direkt gefunden, ohne Zwischenfehlerseite.

### 2) Visuelle Feinabnahme Typografie (manuell)
Status: offen (Kurzcheck im Browser)

Ziel:
Final bestätigen, dass die Typografie in realer Nutzung 1:1 wie gewünscht wirkt.

Akzeptanz:
- Woche 4 und Mediathek sind subjektiv klar website-nah.
- Falls nötig nur minimale Feinkorrektur einzelner Tokens (kein neuer Umbau).
