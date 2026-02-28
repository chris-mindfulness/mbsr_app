# Schritt 2: Verbindlicher UI-Standard (mbsr_app)

Stand: 26.02.2026
Basis: Inventar aus `UI_INVENTAR_SCHRITT_1_2026-02-26.md`.
Ziel: Verbindliche Regeln fuer Klarheit, Einheitlichkeit und stabile Wartbarkeit.

## 1) Geltungsbereich

Dieser Standard gilt fuer alle App-Seiten in `lib/`.
Abweichungen sind nur erlaubt, wenn sie fachlich notwendig sind und explizit dokumentiert werden.

## 2) Verbindliche Design-Tokens

### 2.1 Typografie (Pflicht)
- Fliesstext: `AppStyles.bodyStyle` (`17`, `w400`, `height 1.6`, `textDark`).
- Sekundaertext/Meta: `AppStyles.smallTextStyle` (`15`, `w400`, `textMuted`).
- Kartenueberschrift: `AppStyles.subTitleStyle` (nur lokal max `w600`).
- Keine Fliesstext-Overrides mit `w600/w700`.
- Keine direkte Alpha-Abmilderung auf Fliesstextfarbe.

### 2.2 Farben (Pflicht)
- Nur semantische Farben aus `AppStyles`.
- Oberflaechen standardmaessig `Colors.white`.
- Getoente Flaechen nur fuer klar abgegrenzte Hinweis-/Statuskarten.

### 2.3 Radius/Border/Schatten (Pflicht)
- Standardkarte: `AppStyles.cardShape` + `AppStyles.softCardShadow`.
- Kein frei gewaehlter Radius ausser in begruendeten Sonderfaellen (Bottom-Sheet Handle etc.).

### 2.4 Spacing (Pflicht)
- Nur `AppStyles.spacing*`-Tokens verwenden.
- Harte Zahlen nur fuer technisch notwendige Feinkorrekturen (muss kommentiert werden).

## 3) Verbindliche Komponentenfamilien

## 3.1 Section Header Label
Einheitliches Pattern fuer Ueberschriften wie `FÜR DEN ALLTAG`, `REFLEXION`, `UNTERLAGEN`:
- Stil: `bodyStyle`-Ableitung, `12`, `w600`, `letterSpacing 1.2`, `textMuted`.
- Eine zentrale Implementierung (Shared-Widget), keine lokalen Klone.

## 3.2 Surface Icon Button
Einheitliches Pattern fuer kleine runde/abgerundete Funktionsicons (z. B. Gluehbirne, Info):
- gleiche Groesse, Border, Hintergrund, Tooltip-Verhalten.
- zentrale Implementierung als Shared-Widget.

## 3.3 Standard Interactive Card Row
Einheitliches Pattern fuer klickbare Listenkarten (PDF, Downloads, Literatur, Profilfunktionen):
- links Icon-Badge,
- Mitte Titel + optional Meta,
- rechts Chevron/External-Icon,
- einheitliche Innenabstaende.

## 3.4 Audio Card
Ein zentrales Audio-Kartenpattern fuer Wochenansicht und Mediathek:
- Zustand: loading/playing/idle,
- identische Titel-/Dauerzeile,
- identische Zusatzactions (Tipps/Info).

## 3.5 Reading Accordion Card
Ein zentrales Akkordeon-Pattern fuer Volltexte:
- gleiche Tile-Paddings,
- gleiche Textstile,
- Quelle optional per Parameter ein-/ausblendbar,
- kein paralleler Sonderstil im Archiv.

## 3.6 Notfall/SOS Item
Ein zentrales Item-Pattern fuer Notfall-Koffer/SOS.

## 4) Verbindliche Flaechenlogik

### 4.1 Standard: Neutral
- Alle Kerninhalte (Wocheninhalt, Listen, Lesetexte, Medienlisten) auf neutralen weissen Karten.

### 4.2 Akzent: Sparsam
- Farbe nur als Akzent (Icon, kleine Badge, schmale Leiste).
- Vollflaechige Transparenz nicht als Standard fuer lange Textbloecke.

### 4.3 Tinted Cards (Ausnahme)
Erlaubt fuer:
- kompakte Hinweise,
- positive/unterstuetzende Statusmeldungen,
- visuelle Trennung einzelner Spezialbloecke.

Nicht erlaubt fuer:
- lange Fliesstextabschnitte,
- komplette Seiten als Grundmodus.

## 5) Verbindliche State-Patterns

Jede relevante Liste/Karte kennt dieselben drei Zustaende:
- Loading (sichtbar und ruhig, keine Layoutspruenge),
- Empty (klare kurze Textmeldung),
- Error (kurze, handlungsorientierte Meldung + Retry falls sinnvoll).

Ziel: gleiches Verhalten in Kurs, Mediathek, Downloads, Archiv.

## 6) Zuordnung Seite -> Komponentenstandard

- `kurs_uebersicht.dart`:
  - Wochenkarte = Standard Interactive Card (Variante "Week").
- `wochen_detail_seite.dart`:
  - Section Header Label, Audio Card, PDF Card, Notfall/SOS Item, Reading Accordion.
- `mediathek_seite.dart`:
  - Audio Card, Surface Icon Button, Notfall/SOS Item.
- `vertiefung_seite.dart`:
  - Standard Interactive Card + Feature-Microcards (Info-only).
- `profil_seite.dart`, `downloads_seite.dart`, `literatur_seite.dart`, `tag_der_achtsamkeit_seite.dart`:
  - Standard Interactive Card Row.
- `text_archiv_seite.dart`:
  - Reading Accordion Card + Week availability card (folgt/verfuegbar).

## 7) Verbindliche Refactor-Ziele fuer Schritt 3

1. Duplikate durch Shared-Widgets ersetzen (Header, SurfaceIconButton, SOSItem, ReadingCard/Akkordeon).
2. Typografie-Overrides in Fliesstexten entfernen.
3. Harte Spacing-/Radius-Werte reduzieren und auf Tokens vereinheitlichen.
4. Archiv-Reading und Wochen-Reading optisch/typografisch angleichen.

## 8) Nicht-Ziele in Schritt 3

- Keine inhaltliche Textumformulierung.
- Kein Routing-Umbau.
- Kein Backend-/Appwrite-Umbau.
- Keine Aenderung der Audio-Login-Logik.

## 9) Abnahmekriterien fuer den Standard

- Sichtpruefung: gleiche Typografie- und Card-Hierarchie in allen Hauptseiten.
- Technisch: keine neuen Analyzer-Warnungen.
- Tests: bestehende Tests gruen, plus relevante Widget-Tests weiter stabil.

