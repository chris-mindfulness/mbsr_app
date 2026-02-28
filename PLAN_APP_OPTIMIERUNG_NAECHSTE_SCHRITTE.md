# Plan: Nächste Schritte zur App-Optimierung

Stand: 26.02.2026 (aktualisiert)

## Wiedereinstieg nach Pause (kurz)

1. Zuerst visuelle Feinabnahme in Wochen 1-8 (Karten sichtbar, ruhig, konsistent).
2. Danach inhaltliche Ueberarbeitung von Woche 2 (gleiche Logik wie Woche 1).
3. Appwrite-Basispruefung als separater Abschlussblock.
4. Detail-Stand siehe `UEBERGABE_PAUSE_2026-02-26.md`.

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
- Regression-Schutz erweitert:
  - Session-Refresh-Policy für 401/Cache-Verhalten extrahiert und getestet
  - Seek-Policy für Vor-/Zurückspulen extrahiert und getestet
- Kleine UX-Konsolidierung für textlastige Wochenbereiche:
  - begrenzte Lesebreite auf großen Screens
  - einheitlichere Zeilenhöhe in den langen Tipp-Blöcken
- Website-Stil-Pilot in `Vertiefung` umgesetzt:
  - nicht klickbare Microcards im Website-Stil als kompakte Info-Zeile
  - subtile 3D-Tiefe für große Vertiefungs-Karten via neue Shadow-Tokens
  - neuer Widget-Test sichert Sichtbarkeit + Klickverhalten ab
- Wochenansicht `Kurs` auf Kartenraster umgestellt:
  - Wochen 1-8 als responsive Karten (Desktop 2-spaltig, mobil 1-spaltig)
  - einheitliche Öffnungslogik für Wochen-Details
  - `Tag der Achtsamkeit` als eigenständige Karte klar abgesetzt
- Kartenstil-Differenzierung umgesetzt:
  - Wochenübersicht bleibt bewusst neutral (kein Transparenz-Look)
  - Transparenz und Farbflächen sind in den Wochen-Detailkarten aktiv (Zitat, Übungen, Notfall, Alltag, Tipp-Karten)
- Stabilitätsfix Wochenübersicht (Web) umgesetzt:
  - Renderfehler durch `Spacer` in unbounded Karten-Column beseitigt
  - Wochenansicht rendert wieder vollständig, Navigation ist wieder nutzbar
- Inhaltliche Überarbeitung gestartet:
  - Woche 1 als erster Durchlauf überarbeitet (klare Sprache, präzisere Anleitung, konsistente Du-Ansprache)
  - nächster sinnvoller Schritt: Woche 2 im selben Muster angleichen
- Wochenansicht Woche 1 visuell nachgeschärft:
  - zentrale Inhaltskarten von transparenter Tönung auf neutrale weiße Karten umgestellt
  - Farbigkeit nur als Akzent geführt (linke Akzentkante + Icons/Titel)
  - Zielbild: ruhiger wie Wochenübersicht, aber weiterhin klar differenzierte Bereiche
- Folgefix Darstellungsfehler Woche 1:
  - neutrale Karten-Implementierung für Web vereinfacht, nachdem Inhalte in einzelnen Karten nicht zuverlässig sichtbar waren
  - neue Basis: stabiler weißer Kartenkörper + kleiner Akzentbalken oben
- Rollout des Kartenstils auf alle Kurswochen:
  - zentrale Inhaltskarten in Wochen 1-8 verwenden denselben neutralen Kartenmodus
  - Tippkarten der Wochen 3/4/5-8 ebenfalls auf denselben Modus angeglichen

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
