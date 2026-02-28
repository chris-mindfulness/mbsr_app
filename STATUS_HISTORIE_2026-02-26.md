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
9. Regression-Absicherung für Refresh/Login ergänzt:
   - neue Policy `lib/auth/session_refresh_policy.dart`
   - in `AuthService.initialize()` eingebunden
   - neuer Test `test/services/session_refresh_policy_test.dart`
10. Regression-Absicherung für Vor-/Zurückspulen ergänzt:
   - neue Seek-Policy `lib/audio/seek_policy.dart`
   - in `KursUebersicht._seekRelative()` eingebunden
   - neuer Test `test/audio/seek_policy_test.dart`
11. Kleine UX-Konsolidierung bei textlastigen Flächen umgesetzt:
   - Wochenansicht mit begrenzter Lesebreite auf großen Screens
   - Zeilenhöhe in längeren Tipp-Blöcken vereinheitlicht (ruhigeres Lesen)
12. Lokaler Host für visuelle Feinabnahme gestartet:
   - `http://0.0.0.0:8080`
13. Design-Pilot in `Vertiefung` umgesetzt (Website-Microcards):
   - neue, nicht klickbare Feature-Zeile mit 4 Info-Karten
   - Labels: `MBSR 8-Wochen-Kurs`, `Wissen & Hilfe`, `Textarchiv`, `Literatur & Forschung`
14. Subtiler 3D-Effekt eingeführt:
   - neue Token für ruhigen Kartenschatten + Feature-Chip-Abstände/Radius
   - bestehende Vertiefungs-Hauptkarten mit leichtem, statischem Tiefeneffekt
15. Neuer Widget-Test für den Pilot ergänzt:
   - `test/widgets/vertiefung_feature_cards_pilot_test.dart`
   - prüft: 4 Feature-Karten sichtbar, nicht klickbar, bestehende Hauptkarten weiterhin klickbar
16. Wochenansicht (`Kurs`) auf Kartenlayout umgestellt:
   - Wochen 1-8 als responsive Karten dargestellt (Desktop 2-spaltig, mobil 1-spaltig)
   - zentrale Navigation in die Wochen-Detailseite über vereinheitlichte Öffnungslogik
   - `Tag der Achtsamkeit` als eigene hervorgehobene Karte unterhalb des Wochenrasters
17. Kartenstil korrekt getrennt:
   - Wochenübersicht (`Kurs`) bleibt neutral und klar (weiße Karten)
   - Transparenz/Farbflächen sind gezielt in der Wochen-Detailansicht der einzelnen Sitzungen umgesetzt
   - dort nutzen zentrale Inhaltsblöcke nun den gleichen Kartencharakter mit leichter Tönung + subtiler Tiefe
18. Render-Fix für leere Kursansicht (Web):
   - Fallback für unendliche Layout-Breite im Wochenraster ergänzt
   - verhindert, dass der Kurs-Block bei bestimmten Web-Layouts leer bleibt
19. Root-Cause-Fix für leere Wochenübersicht + blockierte Navigation:
   - Ursache: `Spacer` in einer `Column` mit unbeschränkter Höhe im Wochenkarten-Widget
   - bestätigter Fehler: `RenderFlex children have non-zero flex but incoming height constraints are unbounded`
   - Fix: `Spacer` entfernt, Karten-Column auf `mainAxisSize: min` mit statischem Abstand umgestellt
20. Überarbeitung Woche 1 begonnen und umgesetzt (Inhalt):
   - Teaser präzisiert (Ankommen, Autopilot, Körper als Anker, realistische Übungsdosis)
   - Fokus klarer formuliert
   - Alltagstipp konkreter und alltagsnäher gemacht
   - Reflexionsfragen stärker auf Selbstbeobachtung und Rückkehr in Körperkontakt ausgerichtet
   - Wochenaufgaben sprachlich geschärft (gleiches Ziel, klarere Handlungsanweisungen)
21. Wochenansicht Woche 1 visuell beruhigt (Kartenstil):
   - farbig-transparente Flächen in den zentralen Woche-1-Karten durch neutrale weiße Karten ersetzt
   - beibehaltene Farbigkeit nur als Akzent (schmale linke Farbleiste + Icon/Titel-Farbe)
   - umgesetzt für: Zitat, Hinweise zu Übungen, Notfall-Koffer, Alltagstipp, Praxis-Hinweis, Body-Scan-Tipps
   - Ziel: bessere Lesbarkeit und ruhigerer Gesamteindruck bei gleichbleibender Orientierung
22. Darstellungsfehler in Woche-1-Karten behoben:
   - Ursache: zu komplexe Border-Variante in der neuen neutralen Karte führte im Web-Rendering zu unzuverlässiger Darstellung
   - Fix: neutrale Karte technisch vereinfacht (solider Basisrahmen + innenliegende linke Akzentleiste)
   - Ergebnis: Inhalte in den Karten wieder stabil sichtbar
23. Folgeanpassung zur Stabilisierung:
   - neutrale Karten erneut auf einfachste Struktur reduziert (weiße Karte + kleiner Akzentbalken oben + normaler Inhalt)
   - Hintergrund: robustes Rendering priorisiert, um leere/unsichtbare Karteninhalte auszuschließen
   - lokaler Web-Host danach komplett neu gestartet (kein Hot-Reload-Pfad)
24. Kartenstil auf alle Kurswochen ausgerollt:
   - neutraler Kartenstil nicht nur für Woche 1, sondern für Wochen 1-8 in den zentralen Inhaltskarten aktiv
   - auch Woche-3/4/5-8-Tippkarten auf denselben Kartenmodus umgestellt
   - Ziel: einheitlicher, ruhiger Look über alle Kurswochen hinweg
25. Pause-Uebergabe dokumentiert:
   - separate Uebergabe-Datei erstellt: `UEBERGABE_PAUSE_2026-02-26.md`
   - enthaelt: aktueller Stand, offenes Paket, klarer Wiedereinstieg
26. Pause-Aufraeumen ausgefuehrt:
   - lokaler Flutter-Web-Server (Port 8080) beendet
   - keine offenen Host-Prozesse fuer die Pause
27. Sequenzarbeit Schritt 1 abgeschlossen:
   - UI-Inventar als eigener Bericht erstellt (`UI_INVENTAR_SCHRITT_1_2026-02-26.md`)
   - relevante Seiten, Duplikat-Bausteine, Token-Stand und offene Standardisierungspunkte erfasst
28. Sequenzarbeit Schritt 2 abgeschlossen:
   - verbindlicher UI-Standard als eigener Bericht erstellt (`UI_STANDARD_SCHRITT_2_2026-02-26.md`)
   - Regeln fuer Typografie, Karten, Header, States, Akzentflaechen und Refactor-Ziele festgelegt
29. Sequenzarbeit Schritt 3 abgeschlossen:
   - Shared-Widgets eingefuehrt: `section_header_label.dart`, `surface_icon_button.dart`, `sos_item_card.dart`
   - duplizierte Implementierungen in Wochen-Detail und Mediathek auf Shared-Komponenten umgestellt
   - Section-Header in Wochen-Detail, Vertiefung, Literatur, Tag der Achtsamkeit und Profil auf einheitliche Komponente ausgerichtet
   - Reading-Typografie im Textarchiv auf zentrale AppStyles-Werte vereinheitlicht (ohne Sonderfarben/Sondergewichte im Fliesstext)
30. Nächste 2 Standardisierungspunkte umgesetzt:
   - Audio-Karte als Shared-Widget eingeführt: `lib/widgets/audio_item_card.dart`
   - Wochen-Detailseite und Mediathek nutzen jetzt dieselbe Audio-Kartenkomponente
31. PDF-Karte als Shared-Widget umgesetzt:
   - neue zentrale Komponente: `lib/widgets/pdf_link_card.dart`
   - angebunden in Wochen-Detail, Downloads und Tag der Achtsamkeit
   - zwei Layoutmodi (Row/ListTile) zur risikofreien Migration ohne Funktionsverlust
32. Standard-Listenkarte zentralisiert:
   - neue Komponente: `lib/widgets/standard_action_card.dart`
   - vereinheitlichtes Pattern fuer `Icon + Titel + Meta/Untertitel + Trailing-Icon`
   - optionaler subtiler Schatten integriert (Website-nahe Kartenanmutung)
33. Standard-Listenkarte in Kernseiten ausgerollt:
   - `Vertiefung`: Wissen & Hilfe, Textarchiv, Literatur & Forschung
   - `Profil`: Statistiken, Downloads
   - `Literatur`: Buecher- und Artikelkarten

## Geprüft

- `flutter analyze --no-pub`: ohne Befunde
- `flutter test --no-pub`: alle Tests grün

## Offene nächste Schritte

1. Kurze visuelle Feinabnahme im Browser (Woche 4 + Mediathek + Vertiefung) abschließen.
2. Appwrite-Basisprüfung manuell abschließen (Stabilität ohne Fallback-Layer verifizieren).
