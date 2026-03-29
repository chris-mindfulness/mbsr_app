# Übergabe Cowork → Cursor

Stand: 2026-03-29

## Kontext

In Cowork wurden evidenzbasierte Inhalte für die MindfulPractice-App aufbereitet: 17 Studien exzerpiert, nach Evidenzqualität bewertet (ROBUST/NUANCIERT/FRAGIL/OFFEN) und auf die 8 MBSR-Kurswochen × 3 Kanäle (readingCards, Audioclips, Skript-Anreicherung) gemappt. Daraus ergeben sich konkrete App-Features und Inhalte.

## Offene App-Features (Cursor-Aufgaben)

### BellService einbinden (vorhanden, nicht in UI)
`lib/audio/bell_service.dart` ist fertig implementiert (Singleton, just_audio, einmalig/verzögert/Intervall). Fehlt: Einbindung im Player-Widget als Start-/End-Glocke und eine Nutzer-Einstellung (Glocke an/aus).

### readingCards befüllen
`lib/app_daten.dart`: **Runde A** der Zuordnungstabelle ist eingepflegt (alle 8 Wochen, jeweils `archiveEligible: true`). Woche 1 zusätzlich Runde B (formale/Alltagspraxis, 5 Minuten). Redaktion und Feinschliff können weiter in den Texten erfolgen.

### Psychoedukations-Skripte (Entwürfe)
Kurze Clip-Skripte und Snippets für Meditationsanreicherung: `docs/SKRIPTE_PSYCHOEDUKATION_Entwuerfe.md`. Technische Zuordnung: `docs/MAPPING_TOP10_PSYCHOEDUKATION_APP.md`.

### Empfohlene Features (priorisiert)
1. Dosierungstracking mit Schwellenwert-Feedback (13 min/Tag als evidenzbasierte Schwelle)
2. Wochenspezifische readingCards mit Evidenz-Nuggets (Zuordnungstabelle als Vorlage)
3. Geführte Audiomeditationen in mehreren Längen (kurz 10–12 min, lang 20–30 min)
4. Informelles Praxis-Modul (achtsames Essen, Gehmeditation, kurze Audio-Anstöße 60–90 s)
5. Wochenstruktur als Leitnavigation (aktuelle Woche prominent, Rest zugänglich)
6. Offline-Fähigkeit für Audioinhalte (Download-Mechanismus pro Woche)
7. Konfigurierbare Übungserinnerungen (Opt-in, nicht aufdringlich)
8. Reflexions-Kurzjournal nach Übungen (optional, lokal gespeichert)
9. BellService als Session-Rahmen (siehe oben)
10. Evidenz-Transparenz: Quellenangabe unter readingCards ("Basiert auf: Autor, Jahr")

### Bewusst weggelassen
Social Features, Streaks, Badges, Community – die soziale Einbettung passiert im Präsenzkurs.

## Referenzdateien (im Achtsamkeitstraining-Archivordner, nur lesen)

Die inhaltliche Arbeit liegt im Archivordner, nicht im Repo:
- Exzerpt: `~/Achtsamkeitstraining/Literatur/Hahn_2026_Exzerpt_Huberman_Davidson.md`
- Zuordnungstabelle: `~/Achtsamkeitstraining/Literatur/Hahn_2026_Zuordnungstabelle_Huberman.md`
- Stilrichtlinien Meditationsskripte: `anleitungen/Hahn_2026_Stilrichtlinien.md`

## Vergleichsreferenz

Humin (ehem. Healthy Minds Innovations) – Healthy Minds Program App: kostenlose Meditations-App von Davidsons Center for Healthy Minds. Vier-Säulen-Framework (Awareness, Connection, Insight, Purpose). Validiert in 50+ Studien, inkl. RCT Goldberg et al. 2020. Relevant als Benchmark für Feature-Umfang und wissenschaftlichen Anspruch.
