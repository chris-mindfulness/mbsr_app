# Resilienz – Inhalte für die App

Quelldokument für die geplante Integration von Resilienz-Inhalten in die MBSR-App.
Analog zu `GUT_ZU_WISSEN_KARTEN.md` und `LITERATUR_APP.md` aufgebaut: zuerst die fertigen Texte, dann die Cursor-Anleitung für die technische Umsetzung.

Erstellt: 2026-04-14 | Autor: Chris Hahn

---

## Quelle

Paraphrasierte Zusammenfassung des Kapitels 1 aus Böhme, R. (2019): *Resilienz: Die psychische Widerstandskraft* (S. 7–12). Die Zusammenfassung liegt unter `mbsr_achtsamkeit/bücher/Resilienz (Böhme, 2019).pdf` und wurde für Lehr- und App-Zwecke vorbereitet. Alle Texte in diesem Dokument sind redaktionell für den MBSR-Kontext adaptiert – keine Übernahme von Originalformulierungen.

Ergänzt durch eigenständige Recherche zu Salutogenese (Antonovsky), Kohärenzgefühl und empirischen MBSR-Effekten auf Resilienzmaße (u. a. Khoury et al., 2015; Galante et al., 2018).

Stilregeln: siehe `GUT_ZU_WISSEN_GUIDELINE.md`. Kein Wellness-Sprech, keine Optimierungsrhetorik.

---

## 1. Glossar-Einträge (neu)

Einzubauen in `lib/glossar_faq_seite.dart`, Methode `_buildGlossarList`, innerhalb der Liste `terms`. Die Liste wird später alphabetisch sortiert – Reihenfolge in der Quelldatei also egal.

```dart
{
  'term': 'Resilienz',
  'def':
      'Die Fähigkeit, psychische Gesundheit unter Belastung zu erhalten oder nach Krisen wiederherzustellen. Der Begriff kommt aus der Physik (lateinisch resilire, zurückspringen). In der Psychologie meint er keine Härte, sondern eher Flexibilität: Die Psyche bleibt formbar statt starr. Resilienz ist kein Persönlichkeitsmerkmal, sondern ein Zusammenspiel persönlicher und sozial vermittelter Ressourcen.',
},
{
  'term': 'Salutogenese',
  'def':
      'Ein von Aaron Antonovsky in den 1970ern geprägtes Konzept. Die Leitfrage verschiebt sich: nicht "Was macht krank?", sondern "Was hält gesund?". Krankheit und Gesundheit werden nicht als Gegensatz verstanden, sondern als Kontinuum. Achtsamkeitsbasierte Verfahren passen gut in diese Perspektive, weil sie nicht Symptome bekämpfen, sondern gesundheitsförderliche Haltungen kultivieren.',
},
{
  'term': 'Kohärenzgefühl (Sense of Coherence)',
  'def':
      'Antonovskys Kernkonstrukt. Ein hohes Kohärenzgefühl gilt als schützender Faktor für psychische Gesundheit und besteht aus drei Komponenten: Verstehbarkeit (Erlebnisse lassen sich einordnen), Handhabbarkeit (das eigene Leben lässt sich aktiv gestalten) und Sinnhaftigkeit (Anstrengungen erscheinen sinnvoll). Die drei Dimensionen eignen sich auch als Reflexionsraster in belastenden Phasen.',
},
{
  'term': 'Posttraumatische Belastungsstörung (PTBS)',
  'def':
      'Psychische Folgestörung nach traumatischen Ereignissen, diagnostisch klar definiert. Auch wenn ein Großteil der Menschen mindestens einmal ein potenziell traumatisches Ereignis erlebt, entwickelt nur eine Minderheit eine PTBS. Häufiger sind unspezifische Folgen wie Erschöpfung, Schlafstörungen oder somatische Beschwerden. Bei Verdacht auf trauma-bezogene Belastung ist professionelle Abklärung wichtig; MBSR ist kein Ersatz für therapeutische Behandlung.',
},
```

---

## 2. Gut-zu-wissen-Karte (neu)

**Redaktionelle Entscheidung:** Nur eine Karte. Der Bereich „Gut zu wissen" ist als kuratierte Impulssammlung konzipiert, nicht als Themenkatalog. Eine Ausdehnung auf drei Resilienz-Karten würde das Verhältnis kippen. Die beiden ursprünglich geplanten weiteren Karten (*„Belastung gehört zum Leben"* und *„Drei Fragen, die gesund halten"*) sind inhaltlich in die Vertiefungsseite (Abschnitt 4) gewandert – dort gehören sie stilistisch auch hin, weil sie deklarativ-erklärend angelegt sind.

Die übernommene Karte *„Resilienz ist nicht Härte"* ist bewusst ausgewählt: Sie ist am direktesten praxisrelevant und greift genau die Verwechslung von Stärke und Verhärtung auf, die Teilnehmende tatsächlich in die Übung mitbringen.

Einzubauen in `lib/app_daten.dart`, Liste `gutZuWissenKarten`, am Ende der Liste.

```dart
{
  'id': 'gzw-resilienz-nicht-haerte',
  'title': 'Resilienz ist nicht Härte',
  'body':
      'Resilienz wird im Alltag oft mit "Widerstandsfähigkeit" übersetzt. Das klingt nach Zähnezusammenbeißen, nach Ankämpfen gegen die Umstände. Der ursprüngliche Begriff aus der Physik meint etwas anderes: die Fähigkeit, nach Verformung wieder in die Ausgangsform zurückzukehren. Nicht Starrheit, sondern Flexibilität.\n\n'
      'Diese Unterscheidung ist praxisrelevant. Wer glaubt, stärker werden heiße härter werden, versteift sich in Übungen ebenso wie im Alltag. Die Achtsamkeitspraxis arbeitet in die andere Richtung: differenzierter wahrnehmen, weicher zulassen, klarer reagieren. Stabilität entsteht hier nicht durch Verhärtung, sondern durch geschmeidigeren Kontakt mit dem, was gerade ist.\n\n'
      'Wo in deinem Alltag verwechselst du gerade Stärke mit Härte?',
},
```

---

## 3. FAQ-Ergänzung

Einzubauen in `lib/glossar_faq_seite.dart`, Methode `_buildFaqList`, innerhalb der Liste `faqs`. Passt thematisch in die Nähe der Frage „Ist MBSR eine Therapie?".

```dart
{
  'q': 'Ist MBSR ein Resilienztraining?',
  'a':
      'Das hängt davon ab, wie eng man den Begriff fasst. Studien zeigen, dass MBSR nachweislich Resilienzmaße verbessert — in diesem Sinn ja. Konzeptionell unterscheidet sich MBSR aber von klassischen Resilienzprogrammen wie dem Penn Resilience Program: Diese arbeiten gezielt an Denkmustern und Bewertungen. MBSR setzt früher an, bei der Wahrnehmung selbst, und überlässt Veränderung den daraus entstehenden Einsichten. Beide Zugänge teilen die salutogenetische Perspektive nach Antonovsky.',
},
```

---

## 4. Vertiefungsseite (primärer Ausbau)

Dies ist der zentrale Integrationspunkt, nicht ein optionaler Zusatz. Die Vertiefungsseite nimmt Tiefe auf, ohne die kuratierten Karten aufzublähen, und schafft gleichzeitig einen Container für spätere Themen (Stresstheorien, Achtsamkeitsforschung, Neuroplastizität).

**Neue Sektion in `lib/vertiefung_seite.dart`:** `WISSENSCHAFTLICHER HINTERGRUND` – bewusst thematisch offen gerahmt, damit die Sektion wachsen kann.

**Erste Karte:** „Stress, Resilienz, Salutogenese"
- Untertitel: „Wie die Forschung auf psychische Gesundheit blickt"
- Icon: `Icons.psychology_outlined`
- Akzentfarbe: `AppStyles.accentCyan` oder `AppStyles.infoBlue`

**Zielseite:** `lib/resilienz_vertiefung_seite.dart` (neu). Struktur analog zu `gut_zu_wissen_seite.dart`, aber mit einem linearen Lesefluss statt Expansionskarten – der Inhalt ist zusammenhängender Fließtext, nicht modular.

**Inhalt der Seite:** Volltext siehe `RESILIENZ_VERTIEFUNGSSEITE.md`. Fünf Abschnitte:

1. Belastung als Normalfall
2. Was Resilienz meint – und was nicht
3. Historische Linien (Stoizismus, Werner & Smith, Antonovsky, Hardiness)
4. Kritik am Resilienzkonzept
5. Bezug zu MBSR

Der Volltext ist so ausgearbeitet, dass er ohne weitere Bearbeitung direkt als String-Literale oder als strukturiertes Datenmodell in die Flutter-Seite übernommen werden kann.

---

## Cursor-Anleitung

Schrittweise Umsetzung, von leicht nach aufwendig. Jeder Schritt ist eigenständig committable.

### Schritt 1: Glossar-Einträge

**Datei:** `mbsr_app/lib/glossar_faq_seite.dart`
**Methode:** `_buildGlossarList`, Liste `terms`

Die vier Map-Literale aus Abschnitt 1 an beliebiger Stelle innerhalb der `terms`-Liste einfügen. Die Liste wird am Ende der Methode via `sortedTerms` alphabetisch sortiert – Position im Quellcode spielt keine Rolle.

Nach dem Einfügen: `flutter analyze --no-pub` und `flutter test --no-pub` laufen lassen.

### Schritt 2: Gut-zu-wissen-Karte

**Datei:** `mbsr_app/lib/app_daten.dart`
**Liste:** `gutZuWissenKarten` (aktuell ab Zeile ~981)

Das Map-Literal aus Abschnitt 2 am Ende der Liste einfügen, vor der schließenden Klammer `];`. Die ID `gzw-resilienz-nicht-haerte` kollidiert nicht mit bestehenden Einträgen.

Kein Code in der Rendering-Logik muss geändert werden – die Karte wird automatisch in `GutZuWissenSeite` ausgespielt. Die Abschlussfrage (letzter Absatz mit Fragezeichen) wird in der UI dank bestehender Logik in `_buildCardContent` automatisch optisch abgesetzt.

### Schritt 3: FAQ-Ergänzung

**Datei:** `mbsr_app/lib/glossar_faq_seite.dart`
**Methode:** `_buildFaqList`, Liste `faqs`

Das Map-Literal aus Abschnitt 3 einfügen. Empfohlene Position: direkt nach dem bestehenden Eintrag „Ist MBSR eine Therapie?" (thematische Nähe).

### Schritt 4: Vertiefungsseite (separater PR, empfohlen)

Der eigentliche inhaltliche Schwerpunkt. Volltext liegt bereits in `docs/RESILIENZ_VERTIEFUNGSSEITE.md` vor.

1. **Neue Datei `lib/resilienz_vertiefung_seite.dart` anlegen.** Struktur kann sich an `gut_zu_wissen_seite.dart` orientieren, nutzt aber einen linearen Lesefluss (Text mit Überschriften), nicht Expansionskarten. Empfohlene Grobstruktur: AppBar mit Titel „Stress, Resilienz, Salutogenese", darunter ListView mit den fünf Abschnitten. Jeder Abschnitt: Überschrift (`AppStyles.subTitleStyle`), Fließtext (`AppStyles.bodyStyle`, Height 1.6). Zwischen Abschnitten `AppStyles.spacingXL` Abstand.
2. **Abschnittstexte** aus `RESILIENZ_VERTIEFUNGSSEITE.md` übernehmen. Option A: als private const String-Konstanten in der Widget-Klasse. Option B: als strukturierte Daten in `app_daten.dart` unter neuem Key `resilienzAbschnitte`. Empfehlung: Option B, weil damit künftige Texte desselben Musters (andere Wissenschaftshintergrund-Seiten) einheitlich abgelegt werden können.
3. **In `lib/vertiefung_seite.dart`** neue Sektion `WISSENSCHAFTLICHER HINTERGRUND` einfügen (Position: nach der QUELLEN-Sektion oder zwischen PRAXIS VERTIEFEN und NACHSCHLAGEN – redaktionelle Entscheidung). `StandardActionCard` mit `Icons.psychology_outlined`, Akzentfarbe `AppStyles.accentCyan`, Navigation zur neuen Seite.
4. **Routing** in `lib/routing/app_router.dart` ergänzen, falls Deep-Linking gewünscht. Route-Name-Vorschlag: `/vertiefung/wissenschaft/resilienz`.
5. **Glossar-Verlinkung** (optional): An den Abschnitten zu Salutogenese und Kohärenzgefühl in der Vertiefungsseite bietet sich ein Querverweis auf den Glossareintrag an. Minimalvariante: kein Link, nur konsistente Begriffsverwendung.

### Qualitätssicherung vor Commit

```bash
cd mbsr_app
flutter analyze --no-pub
flutter test --no-pub
```

Beides muss grün sein. Bei Warnings zu den neuen String-Literalen (z. B. doppelte Anführungszeichen): keine stilistische Änderung nötig, die bestehenden Einträge nutzen dasselbe Muster.

### Empfohlene Commit-Nachrichten

- `feat(glossar): Resilienz, Salutogenese, Kohärenzgefühl, PTBS aufnehmen`
- `feat(gut-zu-wissen): Karte "Resilienz ist nicht Härte"`
- `feat(faq): Frage zu MBSR und Resilienztraining`
- `feat(vertiefung): Sektion "Wissenschaftlicher Hintergrund" mit Resilienz-Seite`
