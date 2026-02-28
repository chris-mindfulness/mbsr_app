# Regel für unsere Zusammenarbeit (einfach)

Stand: 25.02.2026

## Grundregel
Wenn ich dir Prüfpunkte, To-dos oder nächste Schritte nenne, schreibe ich sie als `.md`-Datei in den Projektordner.

## Wie ich schreibe
- kurze, einfache Sätze
- klare Überschriften
- keine Fachsprache ohne Erklärung

## Wie ich aktualisiere
Bei Änderungen passe ich die bestehende Notiz-Datei an und ergänze Datum/Status.

## Ziel
Du sollst die nächsten Schritte jederzeit ohne Chatverlauf direkt im Ordner nachlesen können.

## Produkt-Präferenzen (merken für alle nächsten Schritte)

Stand: 25.02.2026

### Was gut passt
- klare, ruhige Oberfläche ohne visuelles Durcheinander
- eindeutige Buttons mit klarer Hinterlegung und einheitlicher Form
- klare Schließen-Optionen (`X`) bei eingeblendeten Karten/Sheets/Dialogs
- einfache Bedienung für nicht-technikaffine Teilnehmende
- pragmatische Verbesserungen statt Spielerei

### Was vermieden werden soll
- versteckte oder nur bei Hover sichtbare Bedienelemente
- inkonsistente Button-Stile (mal flach, mal gefüllt, mal kaum sichtbar)
- Overlays, die Inhalte verdecken (z. B. Unterlagen, Listenende)
- unnötig komplexe Interaktionen ohne klaren Nutzen

### Entscheidungsregel
Bei UI-Entscheidungen gilt:
1. Erst Klarheit und Lesbarkeit.
2. Dann konsistente Bedienlogik.
3. Dann visuelle Details.

## Test-Regel vor jedem Push (ohne Hintergrund-Automatik)

Stand: 26.02.2026

- Tests laufen nur, wenn wir sie aktiv starten.
- Es läuft nichts dauerhaft im Hintergrund.
- Vor jedem Commit/Push wird lokal geprüft:
  1. `flutter analyze --no-pub`
  2. `flutter test --no-pub`
- Nur wenn beide Prüfungen grün sind, wird gepusht.
