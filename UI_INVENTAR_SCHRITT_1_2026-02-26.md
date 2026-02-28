# Schritt 1: UI-Inventar (mbsr_app)

Stand: 26.02.2026
Scope dieses Schritts: nur Inventarisierung der aktuellen UI, keine strukturellen Refactors.

## 1) Relevante Seiten und Zweck

### 1.1 Hauptnavigation
- `Kurs` (Wochenuebersicht): `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/kurs_uebersicht.dart`
- `Mediathek`: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/mediathek_seite.dart`
- `Vertiefung`: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/vertiefung_seite.dart`

### 1.2 Vertiefende/sekundaere Seiten
- Wochen-Detailseite: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/wochen_detail_seite.dart`
- Textarchiv: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/text_archiv_seite.dart`
- Profil: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/profil_seite.dart`
- Downloads: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/downloads_seite.dart`
- Tag der Achtsamkeit: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/tag_der_achtsamkeit_seite.dart`
- Glossar/FAQ: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/glossar_faq_seite.dart`
- Literatur: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/literatur_seite.dart`

## 2) Aktuelle globale UI-Basis

### 2.1 Token-Layer
- Theme-Tokens (`calmDefault`, `calmVivid`) liegen zentral in:
  `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/core/theme_tokens.dart`
- Zentrale Styles (Farben, Textstile, Abstaende, Shape, Schatten) liegen in:
  `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/core/app_styles.dart`

### 2.2 Typografie-Basis
- Body in Tokens auf `17`, `w400`, `#1E1F1D`; Muted `#5F6662`.
- In der Praxis existieren lokale Overrides (z. B. `w600`, direkte Alpha-Mischungen, eigene Farben) in mehreren Seiten.

### 2.3 Theme-Anbindung
- Web setzt Sans-Stack (`Helvetica Neue`) + Heading-Familie (`Lora`) in:
  `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/main.dart`
- Trotz globaler Theme-Basis werden viele Textstile lokal ueberschrieben.

## 3) Inventar der UI-Bausteine (Ist-Zustand)

### 3.1 Wiederkehrende Header-Labels (Duplikate)
Lokale `_buildSectionHeader`-Implementierungen mit leicht unterschiedlichen Parametern:
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/wochen_detail_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/vertiefung_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/literatur_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/tag_der_achtsamkeit_seite.dart`

### 3.2 Surface-Icon-Buttons (Duplikate)
Sehr aehnliche Implementierung in:
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/wochen_detail_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/mediathek_seite.dart`

### 3.3 SOS-/Notfall-Items (Duplikate)
Sehr aehnliche Item-Karten in:
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/wochen_detail_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/mediathek_seite.dart`

### 3.4 Audio-Listenkarten (Duplikate)
Parallel gepflegte Audio-Kartenlogik in:
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/wochen_detail_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/mediathek_seite.dart`

Gemeinsamkeiten: Loading-/Playing-State, identischer Kartenaufbau, identische Controls.

### 3.5 PDF-Karten (Duplikate)
Aehnliche PDF-Karten in:
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/wochen_detail_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/downloads_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/tag_der_achtsamkeit_seite.dart`

### 3.6 Reading-Karten (inkonsistent)
- Wochen-Lesesektion: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/widgets/weekly_reading_section.dart`
- Textarchiv: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/text_archiv_seite.dart`

Abweichungen:
- Archiv nutzt eigene Farbtokens `_readingTextColor/_readingMetaColor`.
- Unterschiedliche Gewichtungen/Zeilenhoehen/Quellenzeilen.

### 3.7 Karten-Surfaces in Wochenansicht
In `wochen_detail_seite.dart` parallel vorhanden:
- `_buildTintedCard`
- `_buildNeutralAccentCard`
- `_buildAdaptiveCard`

=> Zwei visuelle Modi (getoent vs neutral) sind vorhanden, aber nicht als expliziter globaler Standard formuliert.

## 4) Inventar pro Seite (kurz)

### 4.1 Kursuebersicht
Datei: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/kurs_uebersicht.dart`
- Wochen als Kartenraster.
- Eigener Mini-/Full-Player-Bereich.
- Eigene Floating Bottom-Navigation.
- Eigene Kartenmuster fuer Woche + Tag-der-Achtsamkeit.

### 4.2 Wochen-Detailseite
Datei: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/wochen_detail_seite.dart`
- Kerninhalt je Woche: Fokus, Reflexion, Uebungshinweise, Praxis, Audio, PDFs, optional Volltexte.
- Viele spezialisierte Card-Builder.
- Notfall-Koffer integriert.

### 4.3 Mediathek
Datei: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/mediathek_seite.dart`
- Audio-Liste mit Suche + Tipp-/Info-Controls.
- SOS-Sheet.
- Doppelte Grundlogik zur Wochen-Detail-Audioliste.

### 4.4 Vertiefung
Datei: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/vertiefung_seite.dart`
- Intro + Feature-Microcards + grosse Navigationskarten.
- Eigener Schatten-Wrapper `_buildShadowCard`.

### 4.5 Profil
Datei: `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/profil_seite.dart`
- Funktionskarten (Statistik, Downloads, Theme).
- Wiederkehrender Kartenaufbau analog zu anderen Seiten.

### 4.6 Tag der Achtsamkeit / Literatur / Downloads / Glossar-FAQ
Dateien:
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/tag_der_achtsamkeit_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/literatur_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/downloads_seite.dart`
- `/Users/ch70bure/ki_projects/privat/mbsr_app/lib/glossar_faq_seite.dart`

- Alle nutzen Card-basierte Listen, aber mit lokalen Varianten fuer Farben, Radius, Padding, Typogewichte.

## 5) Zustandsbilder (State-Handling) im UI

Positiv vorhanden:
- Loading-State bei Audio-Play-Buttons.
- Empty-State in Downloads ("Noch keine Downloads verfuegbar.").
- "folgt"-State im Textarchiv fuer noch nicht freigeschaltete Wochen.

Uneinheitlich:
- Kein einheitliches, zentrales State-Pattern fuer Empty/Loading/Error ueber alle Seiten.

## 6) Hauptabweichungen, die Schritt 2 standardisieren muss

1. Duplizierte Builder statt zentraler Shared-Widgets (Header, Audio-Card, PDF-Card, Surface-Buttons, SOS-Item).
2. Gemischte Typografiegewichte in Fliesstexten (teils `w400`, teils `w600`).
3. Unterschiedliche Card-Radien und Innenabstaende je Seite.
4. Unterschiedliche Border-/Alpha-Logik je Screen.
5. Lese-Sektion und Textarchiv sind visuell/typografisch nicht voll synchron.
6. Teilweise harte Zahlenwerte statt konsequenter Token-Nutzung.

## 7) Offene Punkte fuer Schritt 2 (UI-Standard)

- Verbindliche Definition fuer:
  - Karten-Typen (neutral, getoent, interaktiv, info-only)
  - Header-Label-Stil
  - List-Row-Pattern (Icon + Titel + Meta + Chevron)
  - Audio-Card als einheitliche Komponente
  - PDF-Card als einheitliche Komponente
  - Reading-Card als einheitliche Komponente
- Festlegen, wann getoente Flaechen erlaubt sind und wann neutral/weiss Pflicht ist.
- Festlegen fixer Typografie-Regeln fuer Fliesstext vs Titel vs Meta.

