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
7. Typografie-Abgleich zur Website umgesetzt:
   - zentrale Tokens auf Website-Basis gesetzt (`17px`, `1.6`, `w400`, `#1E1F1D`)
   - Muted-Token eingeführt (`#5F6662`) und in Kernbereichen genutzt
   - Woche-4-Lesemodus auf globale Fließtext-Typografie zurückgeführt
   - Web-Theme um Fontstack-Fallbacks erweitert (Sans + Heading)
8. Neuer Design-Test ergänzt:
   - `test/design/typografie_web_abgleich_tokens_test.dart`
   - prüft typografische Basiswerte für beide Theme-Modi

## Geprüft

- `flutter analyze --no-pub`: ohne Befunde
- `flutter test --no-pub`: alle Tests grün

## Offene nächste Schritte

1. Kurze visuelle Feinabnahme im Browser (Woche 4 + Mediathek + Vertiefung).
2. Appwrite-Basisprüfung manuell abschließen (Stabilität ohne Fallback-Layer verifizieren).
