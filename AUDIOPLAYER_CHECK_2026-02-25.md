# Audioplayer-Check (Stand 25.02.2026)

## Ziel
Kurze technische und visuelle Einschätzung des Audioplayers ohne Umbau.

## Ergebnis in einem Satz
Der Player ist funktional insgesamt stabil, hat aber noch UX-Unruhe und ein paar technische Risiken bei Fehler-/Recovery-Fällen.

## Was gut ist (Stärken)
- Hintergrundnutzung ist grundsätzlich unterstützt: Beim `paused`-State wird Audio nicht automatisch gestoppt.
- Stabilisierung gegen Hänger ist eingebaut (`buffering timeout` + Recovery-Versuche in `lib/audio_service.dart`).
- Robustes Tracking ist vorhanden: 80%-Schwelle, Schutz gegen Doppel-Tracking, Plausibilitätsprüfung der Hörzeit.
- Einheitlicher Service über alle Seiten (Singleton `AudioService`) sorgt für konsistentes Verhalten.
- UI-Feedback ist klar: Loading-Spinner, aktiver Status, Mini-Player + Full-Player.
- Analyse-Lauf ist sauber:
  - `flutter analyze --no-pub lib/audio_service.dart lib/kurs_uebersicht.dart lib/mediathek_seite.dart lib/widgets/exercise_tips_sheet.dart`
  - Ergebnis: `No issues found`.

## Was noch nicht sauber ist (Schwächen)
- Kein automatischer Audio-Test vorhanden (nur Daten-Integritätstests). Regressionen im Player fallen daher erst manuell auf.
- Optimistisches Umschalten auf `playing` kann bei Fehlern kurz falschen UI-Status zeigen.
- Beim Schließen des Full-Players wird Audio immer gestoppt (`whenComplete -> _audioService.stop()` in `lib/kurs_uebersicht.dart`). Das kann für Nutzer unerwartet sein.
- Es gibt weiterhin visuelle Unruhe im Übergang (von dir beschrieben als leichtes Flickern/Zucken).
- Native Background-Audio-Flags sind in den Plattformdateien nicht explizit gesetzt (relevant, falls später native App-Verteilung geplant ist).

## Nutzerfeedback (wichtig für Design)
- Sehr positives Feedback zu den Tipp-Karten mit Glühbirne (Bottom-Sheet, von unten hochfahrend).
- Dieser Stil wird als besonders klar, hochwertig und gut lesbar wahrgenommen.
- Empfehlung für spätere Designphase: Audio-Detailansichten stärker an diesen Stil angleichen (Kontrast, Klarheit, Fokus auf eine Handlung).

## Nächste sinnvolle Schritte (ohne Appwrite-Aufwand)
1. Visual-Flicker im Audiofluss glätten (Statuswechsel und Übergänge reduzieren).
2. Stop-Verhalten beim Schließen des Full-Players als bewusstes UX-Verhalten prüfen (optional: weiterlaufen lassen).
3. 2-3 kleine Unit-/Widget-Tests für Audio-Zustände ergänzen (play/pause/loading/error).

## Umsetzung 25.02.2026 (Block 1)

Umgesetzt:
- Full-Player-Schließen stoppt Audio nicht mehr automatisch (`lib/kurs_uebersicht.dart`).
- Resume läuft jetzt über eigene Service-Methode `resumeCurrent()` statt erneutes `play({...})` in der UI.
- Optimistisches Sofort-`playing` beim Laden wurde entfernt; bei neuem Track wird erst geladen, dann abgespielt (`lib/audio_service.dart`).

Validierung:
- `flutter analyze --no-pub lib/audio_service.dart lib/kurs_uebersicht.dart`: erfolgreich.
- `flutter test --no-pub test/data/app_daten_integrity_test.dart`: erfolgreich.

## Umsetzung 25.02.2026 (Block 2: Tipp-Sheet Mobile)

Problem:
- Auf dem Handy füllte das Tipp-Sheet teils den gesamten Bildschirm, dadurch war „außerhalb klicken zum Schließen" nicht mehr zuverlässig möglich.

Fix:
- Sheet-Höhe auf max. 88% der Bildschirmhöhe begrenzt.
- Expliziten Schließen-Button (`X`) oben rechts ergänzt.
- Dismiss/Drag explizit aktiviert (`isDismissible: true`, `enableDrag: true`).

Betroffene Datei:
- `lib/widgets/exercise_tips_sheet.dart`

Validierung:
- `flutter analyze --no-pub lib/widgets/exercise_tips_sheet.dart lib/mediathek_seite.dart lib/wochen_detail_seite.dart`: erfolgreich.
- `flutter test --no-pub test/data/app_daten_integrity_test.dart`: erfolgreich.
