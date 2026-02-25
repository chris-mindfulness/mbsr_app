# UI-Check und Player-Empfehlung

Stand: 25.02.2026

## 1) Check: Lassen sich alle eingeblendeten Elemente sauber schließen?

Kurzfazit: Ja. Alle aktuell verwendeten Bottom-Sheets/Dialogs haben jetzt einen klaren Schließen-Pfad.

Geprüfte Elemente:

1. Full-Player (Kursübersicht)
- Schließen: `X`
- Zusätzlich: `Stop` beendet Audio vollständig
- Zusätzlich: Drag/Dismiss möglich

2. Tipps-Sheet (Glühbirne)
- Schließen: `X`
- Zusätzlich: Drag/Dismiss möglich

3. Notfall-Koffer (Mediathek)
- Schließen: `X`
- Zusätzlich: Drag/Dismiss möglich

4. Audio-Info (Mediathek)
- Schließen: `X`
- Zusätzlich: Drag/Dismiss möglich

5. Tracking-Info (Mediathek)
- Schließen: `X`
- Zusätzlich: Button `Verstanden`

6. Tracking-Info (Statistik)
- Schließen: `X`
- Zusätzlich: Button `Verstanden`

7. Impressum/Datenschutz-Dialoge
- Schließen: `X`
- Zusätzlich: Button `Schließen`

## 2) Problem aus Screenshot (Überlappung)

Befund:
- Der Mini-Player liegt als Overlay über dem Content.
- In Wochenseiten verdeckt er im unteren Bereich Inhalte (z. B. Unterlagen), obwohl man weiter scrollt.

Warum das passiert:
- Der Player ist aktuell visuell "über" dem Layout platziert.
- Die Scroll-Fläche darunter reserviert nicht immer konsistent genug Platz.

## 3) Frage: Immer großer Player statt klein+groß?

Kurzantwort: Für deine Zielgruppe eher **nein**.

Begründung:
- Viele Teilnehmende hören Audio und lesen parallel Aufgaben/Unterlagen.
- Ein immer großer Player blockiert genau dieses Verhalten.
- Für nicht-technikaffine Nutzer ist nicht "groß oder klein" das Problem, sondern unklare Überlappung und zu viele Optionen.

## 4) Empfohlene saubere Lösung (für nicht-technikaffine Nutzung)

Empfehlung: **Mini-Player behalten + Full-Player optional**, aber den Mini-Player **layoutfest einbinden**.

Konkret:
1. Der Mini-Player bleibt unten sichtbar (Play/Pause/Stop, Titel).
2. Die Seite reserviert dafür immer echten Platz (kein Überdecken mehr).
3. Full-Player bleibt optional bei Tap auf den Mini-Player.
4. Mini-Player-Funktionen bewusst schlank halten (kein Feature-Overload).

Vorteil:
- Nutzer können hören und gleichzeitig lesen.
- Keine verdeckten Inhalte.
- Bedienung bleibt einfach.

## 5) Klare Umsetzungsoptionen

Option A: Immer Full-Player
- Plus: maximal einfaches Bedienmodell
- Minus: blockiert Lesen/Arbeiten in den Wochenansichten
- Empfehlung: nicht passend für deinen Kurskontext

Option B: Mini + Full (verbessert)
- Plus: flexibel, aber klar
- Plus: passt zu "Audio läuft im Hintergrund"
- Minus: braucht saubere Layout-Integration
- Empfehlung: **beste Option**

## 6) Akzeptanzkriterien für die Umsetzung

1. Kein Inhalt in Wochen-/Mediathek-/Vertiefungsseiten wird vom Mini-Player verdeckt.
2. Unterste Karte/Datei bleibt vollständig sichtbar und klickbar.
3. Mini-Player hat klar sichtbare Kernaktionen: Play/Pause, Stop, Öffnen.
4. Full-Player bleibt rein optional.
5. Auf Mobilgeräten und Desktop identisches Grundverhalten.

## 7) Empfohlene nächste Umsetzung (in 2 Schritten)

Schritt 1:
- Layout so umbauen, dass der Player keinen Content mehr überlagert, sondern Platz reserviert.

Schritt 2:
- Mini-Player visuell vereinfachen (nur Kernaktionen), damit Bedienung für Einsteiger klar bleibt.

