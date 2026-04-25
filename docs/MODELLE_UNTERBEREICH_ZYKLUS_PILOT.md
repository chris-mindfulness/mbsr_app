# Modelle-Unterbereich mit Pilot "Zyklus von Denken und Fühlen"

Kurzplan für den sicheren Einstieg in einen neuen Unterbereich `Modelle` in der Vertiefung.

---

## Ziel

- In `Vertiefung` einen neuen Unterbereich `Modelle` einführen.
- Als erstes Beispiel das Modul `Der Zyklus von Denken und Fühlen` integrieren.
- Stabilität der bestehenden App jederzeit schützen.

---

## Warum der Unterbereich sinnvoll ist

- Modelle erklären das "Warum" hinter den Übungen.
- Visuelle Hilfen bleiben oft besser im Gedächtnis.
- Inhalte werden sauber gebündelt statt verstreut.
- Weitere Modelle können später nach gleichem Muster folgen.

---

## Informationsarchitektur (einfacher Start)

In `Vertiefung` zunächst ein neuer Abschnitt:

- `Modelle`
  - Karte 1: `Der Zyklus von Denken und Fühlen` (Pilot)

Wichtig: Kein Umbau der ganzen Seite. Nur ein neuer Abschnitt mit einer Karte.

---

## Pilotumfang (Version 1)

Die erste App-Version des Piloten ist bewusst klein:

1. Einordnungstext (Worum geht es? Warum wichtig?)
2. Visuelle Zyklusdarstellung
3. "Ich bemerke den Zyklus"-Interaktion
4. Kurze 3-Atemzüge-Anleitung
5. Reflexionsfeld "letzten Zyklus nachzeichnen"

Fallback:

- Wenn Interaktion ausfällt, wird nur Lesekarte angezeigt.

---

## Technische Umsetzung (kleine, sichere Schritte)

### Schritt 1: Datenmodell in `app_daten.dart`

- Neuer Inhaltseintrag für den Piloten.
- Felder: `id`, `title`, `summary`, `category = modelle`, `isInteractive`.
- Noch keine tiefe Logik.

### Schritt 2: Vertiefungsseite erweitern

- In `lib/vertiefung_seite.dart` neuen Abschnitt `Modelle` anzeigen.
- Karte "Der Zyklus von Denken und Fühlen" einfügen.
- Karte öffnet zunächst eine einfache Zielseite.

### Schritt 3: Zielseite anlegen

- Neue Datei: `lib/zyklus_denken_fuehlen_seite.dart` (oder im Feature-Ordner, falls schon vorhanden).
- Erst statisch mit Einordnung + Leseteil + Platzhalter für Interaktion.

### Schritt 4: Interaktion schrittweise aktivieren

- Zyklus-Animation
- Button-Logik
- 3-Atemzüge-Miniablauf
- Reflexionsfeld

### Schritt 5: Optional lokales Speichern

- Nur UX-Daten (z. B. letzter eigener Zyklus).
- Kein Eingriff in Auth/Audio/Kernlogik.

---

## Stabilitätsregeln für diesen Pilot

- Kein Eingriff in:
  - `AuthService`
  - `AudioService` / `BellService`
  - App-Start in `main.dart`
- Nur additive Änderungen (neuer Abschnitt + neue Seite).
- Feature bleibt rückbaubar:
  - Karte entfernen
  - Route entfernen
  - Seite löschen

Siehe auch:

- `docs/STABILITAETS_POLICY_MBSR_APP.md`
- `docs/CHECKLISTE_VOR_EINBAU.md`

---

## Definition of Done (Pilot)

Pilot gilt als fertig, wenn:

- Abschnitt `Modelle` in Vertiefung sichtbar ist
- Karte öffnet die Zyklus-Seite fehlerfrei
- Interaktion funktioniert (Start, Bemerken, Reset)
- Fallback auf Lesekarte ist vorhanden
- `flutter analyze --no-pub` und `flutter test --no-pub` sind grün

---

## Empfohlene Reihenfolge für Commits

1. `feat(vertiefung): abschnitt "Modelle" mit zyklus-karte anlegen`
2. `feat(modelle): seite "Zyklus von Denken und Fühlen" als pilot einbauen`
3. `feat(modelle): interaktion für zyklus (bemerken + atemzüge) aktivieren`
4. `chore(modelle): fallback und stabile fehlerbehandlung nachziehen`
