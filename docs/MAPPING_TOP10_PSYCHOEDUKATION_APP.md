# Mapping: Psychoedukation → App-Oberflächen

**Bezug:** `Hahn_2026_Zuordnungstabelle_Huberman.md` (Runde A/B-Items) + `COWORK_UEBERGABE.md`
**Stand:** 2026-03-29 — **28** readingCards in `app_daten.dart` (Runde A + B, inkl. `w5-stickiness`). UI-Abschnitt **PSYCHOEDUKATION**. Stickiness als readingCard statt Audio-Clip.

---

## Nutzerpfad (wo erscheint es?)

| Schritt | UI | Technisch |
|--------|-----|-----------|
| 1 | Tab **Kurs** (Start nach Login) | `KursUebersicht` (`lib/kurs_uebersicht.dart`), Route `/home` |
| 2 | Wochenkarte antippen | `Navigator` pusht `WochenDetailSeite` |
| 3 | Längere Texte | Abschnitt **PSYCHOEDUKATION** → `WeeklyReadingSection` (`lib/widgets/weekly_reading_section.dart`) |
| 4 | Kurz-Audio „Zum Thema dieser Woche" | `AvatarAudioClip` in `WochenDetailSeite` (nach **Fokus**, vor Zitat) |
| 5 | Alle Wochentexte | **Vertiefung** → Textarchiv (`TextArchivSeite`, `lib/text_archiv_seite.dart`) – dieselben `readingCards` |
| 6 | Begriffe & FAQ | **Vertiefung** → Wissen & Hilfe (`GlossarFaqSeite`, `lib/glossar_faq_seite.dart`) |
| 7 | Akut-Hilfe (Text) | **Notfall-Koffer** in `WochenDetailSeite` und `MediathekSeite` (u. a. Seufzer, Ankommen) |

**Single Source of Truth:** `AppDaten.wochenDaten` in `lib/app_daten.dart`.
**Index:** `wochenDaten[0]` = Woche **1**, …, `wochenDaten[7]` = Woche **8**.

---

## Datenfelder (Pflicht für neue Inhalte)

### `readingCards` (pro Woche)

Jede Karte ist ein `Map<String, String>` mit:

| Key | Pflicht | Verwendung |
|-----|---------|------------|
| `id` | ja (sobald Liste nicht leer) | Stabile ID, z. B. `w1-goldberg-meta` |
| `title` | ja | Kartenüberschrift |
| `body` | ja | Fließtext |
| `source_ref` | entfernt | Quellen nur noch in Vertiefung / Literatur |

**Test:** `test/data/app_daten_integrity_test.dart` prüft `id`, `title`, `body`, wenn `readingCards` nicht leer ist.

### `readingSummary` (optional, pro Woche)

Kurzer Einleitungstext über den Karten (blau umrandeter Kasten). Nicht für jede Woche nötig.

### `infoClips.psychoedukation` (Audio-Clip)

```dart
'psychoedukation': {
  'appwrite_id': '<Storage-File-ID>',
  'duration': '1:00',  // Anzeige-Hinweis
},
```

**UI-Label:** „Zum Thema dieser Woche" (`lib/wochen_detail_seite.dart`).
Leere `appwrite_id`: Player nicht nutzbar – erst Audiodatei in Appwrite anlegen, dann ID eintragen.

### Skript-Anreicherung (SA)

Nicht in `app_daten.dart` modelliert. Quellskripte unter `avatar/audios_anleitungen/`. Snippets in `docs/SKRIPTE_PSYCHOEDUKATION_Entwuerfe.md`.

---

## Runde A: Woche → readingCards + Clips

Direkt abgeleitet aus Zuordnungstabelle (Prio A). Das sind die Items, die zuerst umgesetzt werden.

| Woche | `wochenDaten[i]` | Kanal | Exzerpt-Ref | Inhalt | ID-Vorschlag |
|-------|------------------|-------|-------------|--------|--------------|
| 1 | `i = 0` | RC | 1.14 | Über 300 Studien bestätigen: Achtsamkeit wirkt (Goldberg) | `w1-goldberg-meta` |
| 1 | `i = 0` | RC | 1.3 | 47 % im Autopiloten (Killingsworth/Gilbert, nuanciert) | `w1-autopilot` |
| 1 | `i = 0` | RC | 2.2 | Anfangs-Unruhe ist normal | `w1-anfangsunruhe` |
| 1 | `i = 0` | AC | 3.1 | Laktat des Geistes (Clip, 60–90 s) | — |
| 2 | `i = 1` | RC | 3.5 | Kino-Gleichnis: Zwei Arten von Flow | `w2-kino-gleichnis` |
| 2 | `i = 1` | RC | 2.7 | FA vs. OM – Grundvokabular | `w2-fa-om` |
| 3 | `i = 2` | RC | 3.8 | Freundschaft mit dem Geist statt Kampf | `w3-freundschaft-geist` |
| 4 | `i = 3` | RC | 1.12 | Stress ist nicht gleich Stress (Epel) | `w4-stresszeitskalen` |
| 4 | `i = 3` | RC | 1.13 | Stress und Gedächtnis (Kim & Kim) | `w4-stress-gedaechtnis` |
| 4 | `i = 3` | AC | Hub-Solo | Physiologischer Seufzer (Clip, 60–90 s) | — |
| 5 | `i = 4` | RC | 2.7 | Vom Tun zum Sein – OM operational | `w5-tun-sein` |
| 5 | `i = 4` | RC | 3.11 | Gefühle beobachten, bis sie sich verändern | `w5-gefuehle-beobachten` |
| 6 | `i = 5` | RC | 1.5 | Mitgefühl verändert Verhalten (Weng) | `w6-mitgefuehl` |
| 6 | `i = 5` | RC | 3.7 | Flourishing ist ansteckend | `w6-flourishing` |
| 6 | `i = 5` | RC | 1.17 | Meditation verbessert prosoziales Verhalten (Luberto) | `w6-prosozial-luberto` |
| 7 | `i = 6` | RC | 2.9 | Freundlichkeit ist angeboren, braucht Pflege | `w7-freundlichkeit` |
| 7 | `i = 6` | RC | 5 | Digitale Hygiene als Selbstfürsorge | `w7-digitale-hygiene` |
| 8 | `i = 7` | RC | 2.4 | Vier Säulen des Flourishing (Davidson) | `w8-vier-saeulen` |
| 8 | `i = 7` | RC | 2.6 | Konsistenz schlägt Intensität | `w8-konsistenz` |

**Kanalübergreifend (SA, Runde A):**
- Doing → Being in allen Anleitungen (2.7)
- Einladender, nicht direktiver Ton in allen Texten (3.8)

---

## Runde B: Ergänzungen

| Woche | Kanal | Exzerpt-Ref | Inhalt | ID | Status |
|-------|-------|-------------|--------|----|--------|
| 1 | RC | 2.3 | Formale vs. Alltagspraxis | `w1-formal-alltag` | **done** |
| 1 | RC | 1.1 | 5 Minuten reichen (mit Limitation) | `w1-fuenf-minuten` | **done** |
| 2 | AC | 2.1 | States → Traits (Clip) | — | offen (Audio) |
| 2 | RC | 1.16 | Arbeitsgedächtnis (Whitfield) | `w2-arbeitsgedaechtnis` | **done** |
| 3 | RC | 4.3 | Wertschätzung beim Essen | `w3-essen` | **done** |
| 4 | RC | 3.3 | Meditation als Grundversorgung | `w4-grundversorgung` | **done** |
| 4 | SA | Hub-Solo | Panorama-Vision in Sitzmeditation | — | offen (SA) |
| 5 | RC | 3.2 | Stickiness (Emotionale Klebrigkeit) | `w5-stickiness` | **done** |
| 5 | RC | 1.15 | Decentering (Creswell) | `w5-decentering` | **done** |
| 5 | RC | 3.10 | Raus aus Stimulus und Response | `w5-stimulus-response` | **done** |
| 6 | SA | 4.5 | Metta-Abgleich mit Davidson-Protokoll | — | offen (SA) |
| 7 | RC | 2.8 | Meditation ersetzt keinen Schlaf | `w7-schlaf-mythos` | **done** |
| 8 | RC | 3.6 | Unabgelenktes Nicht-Meditieren | `w8-nicht-meditieren` | **done** |
| 8 | RC | 2.5 | Deklarativ + Prozedural | `w8-deklarativ-prozedural` | **done** |

**Kanalübergreifend (SA, Runde B):**
- Physiologischer Seufzer als Snippet in Sitzmeditation W4–5

---

## Psychoedukations-Skripte: Zuordnung

Skripte in `docs/SKRIPTE_PSYCHOEDUKATION_Entwuerfe.md` decken folgende Slots ab:

| Skript | Ziel-Slot | Runde | Status |
|--------|-----------|-------|--------|
| 1. Laktat des Geistes | W1 `infoClips.psychoedukation` | A | Entwurf |
| 2. Physiologischer Seufzer | W4 `infoClips.psychoedukation` | A | Entwurf |
| 3. States → Traits | W2 `infoClips.psychoedukation` | B | Entwurf |
| 4. Stickiness | → readingCard `w5-stickiness` | B | **done** |
| 5.1 Seufzer-Snippet | SA in Sitzmeditation W4–5 | B | Entwurf |
| 5.2 OM-Snippet | SA in Sitzmeditation W5 | A | Entwurf |
| 5.3 Decentering-Snippet | SA in Reflexion W5 | B | Entwurf |

---

## Appwrite / Produktion

- Neue Clips: Datei in Bucket `mbsr_content` hochladen → `appwrite_id` in die jeweilige Woche unter `infoClips.psychoedukation` eintragen.
- Woche 1 hat bereits einen `psychoedukation`-Slot mit ID. Entscheidung: bestehenden Clip ersetzen oder zweites Clip-Feld (erfordert Code-Änderung). Standard ohne Code: ein Psycho-Clip pro Woche.

---

## Verwandte Dokumente

- `docs/COWORK_UEBERGABE.md` – Feature-Empfehlungen und Übergabe-Kontext
- `Hahn_2026_Zuordnungstabelle_Huberman.md` (Repo-Root) – vollständige Zuordnung A/B/C
- `Hahn_2026_Exzerpt_Huberman_Davidson.md` (Archivordner Achtsamkeitstraining) – Studiendetails
