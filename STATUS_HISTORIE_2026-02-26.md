# Status-Historie App (26.02.2026)

## Heute umgesetzt

1. Wochentitel auf originalnahe Benennung angepasst:
   - Woche 1: `Achtsamkeit`
   - Woche 4: `Stress in Körper und Geist`
   - Woche 5: `Achtsamkeit gegenüber stressverschärfenden Gedanken`
   - Woche 6: `Achtsame Kommunikation`
   - Woche 8: `Abschied und Neubeginn`
2. Glossar-Begriff mitgezogen:
   - `Schwierige Kommunikation` -> `Achtsame Kommunikation`
3. Block umbenannt:
   - `Deine Übungen` -> `Hinweise zu deinen Übungen dieser Woche`
4. Reihenfolge in der Wochenansicht angepasst:
   - `Titel/Teaser/Fokus -> Zitat -> Hinweise zu deinen Übungen dieser Woche -> Deine Praxis diese Woche`
5. Notfall-Koffer in allen Wochenansichten ergänzt:
   - direkter Einstieg pro Woche
   - Bottom-Sheet mit Akut-Hilfen und Schnellstart `Ankommen`
6. Woche 5-8 inhaltlich geschärft:
   - je Woche kompakte Hilfekarte
   - `Wenn es schwierig wird` mit kurzen, praxisnahen Leitpunkten

## Geprüft

- `flutter analyze --no-pub`: ohne Befunde
- `flutter test --no-pub`: alle Tests grün

## Offene nächste Schritte

1. Typografie-Abgleich App/Web später in eigenem Schritt finalisieren (bereits separat notiert).
2. Appwrite-Basisprüfung manuell abschließen (Stabilität ohne Fallback-Layer verifizieren).
