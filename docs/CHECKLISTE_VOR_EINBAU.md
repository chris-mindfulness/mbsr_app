# Checkliste vor Einbau

Kurzcheck vor jedem neuen Vertiefungsmodul.

## 10 Punkte (alle mit Ja beantworten)

1. Ziel und Nutzen des Moduls sind klar beschrieben.
2. Modul ist isoliert geplant (eigener Bereich, keine Kern-Eingriffe).
3. Kernbereiche bleiben unberührt (Auth, Audio, Routing-Basis, App-Start).
4. Feature kann zentral deaktiviert werden (Not-Aus vorhanden).
5. Sicherer Fallback ist definiert (z. B. Lesekarte statt Absturz).
6. Lokaler Speicher ist klar begrenzt (nur UX-Daten, keine Security-Logik).
7. UX-Texte sind klar, konsistent und sprachlich korrekt (inkl. Umlaute).
8. Kein neuer Dependency-Einbau ohne vorherige Abstimmung.
9. Testplan steht fest (Smoke-Test + relevante Modul-Tests).
10. Freigabe erfolgt nur, wenn `flutter analyze --no-pub` und `flutter test --no-pub` grün sind.

## Stop-Regel

Wenn ein Punkt nicht klar mit Ja beantwortet werden kann:  
**nicht einbauen**, zuerst klären.
