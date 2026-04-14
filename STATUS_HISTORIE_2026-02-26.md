# mbsr_app — Status & Entwicklungsgeschichte

Diese Datei fasst **Meilensteine und Kontext** zusammen. Sie ersetzt kein `git log`. Vor Releases: `flutter analyze --no-pub` und `flutter test --no-pub` ausführen (konkrete Testanzahl variiert mit dem Repo).

---

## Was davon heute noch gültig ist (Kurzüberblick, Stand April 2026)

Die Tabelle beschreibt den **aktuellen Sollzustand**; die Chronologie unten vermerkt, wann die jeweiligen Pakete eingeführt wurden.

| Bereich | Inhalt |
|--------|--------|
| **Kursinhalt & Navigation** | Originalnähere Wochentitel, feste Reihenfolge der Blöcke (u. a. Zitat → Hinweise zu Übungen → Praxis), Notfall-Koffer pro Woche |
| **Layout** | Wochenübersicht als Kartenraster; Detailseiten mit einheitlichem neutralem Kartenstil (Wochen 1–8); „Tag der Achtsamkeit“ als eigene Karte |
| **Vertiefung** | Website-nahe Microcards; Pilot mit Widget-Test abgesichert |
| **Design** | Typografie über `AppStyles` / `theme_tokens` website-nah; Muted-Farbe; Design-Tests für Kern-Tokens |
| **Stabilität** | `session_refresh_policy`, `seek_policy`; AudioService gegen Exceptions gehärtet (Go-Live März 2026); Fehler-UI in Mediathek/Miniplayer |
| **Avatar-Audio** | `AvatarAudioClip`, gemeinsame Stop-Logik mit Mediathek; Seek-Bar; Kopf-Begrüßung (`AppDaten.begruessung`) mit Storage-ID; in `infoClips` pro Woche sind `begruessung` / `psychoedukation` teils noch ohne `appwrite_id` (Platzhalter bis finale Audios) |
| **Mediathek** | Optionaler Download über Storage-`/download`; Hinweis bei instabilem Netz; Sprecher-Varianten im Titel `(Name)` konsistent zu `audioRefs` |
| **Teilnehmende** | Batch-Import: `TEILNEHMENDEN_IMPORT.md`; Import-Skript verifiziert bei 5xx, ob der Auth-Nutzer angelegt wurde |

**Weiterhin maßgebliche Referenzen:**

- `UI_STANDARD_SCHRITT_2_2026-02-26.md` — verbindliche UI-Regeln für neue Arbeiten  
- `UI_INVENTAR_SCHRITT_1_2026-02-26.md` — historisches Ist-Inventar (Februar 2026); Duplikate aus §3 sind größtenteils durch Shared Widgets abgebaut — Dokument dient der Nachvollziehbarkeit  
- `PLAN_APP_OPTIMIERUNG_NAECHSTE_SCHRITTE.md` — Roadmap und offene, nicht kritische Punkte  

Die frühere Datei `UEBERGABE_PAUSE_2026-02-26.md` ist **nicht mehr vorhanden**; Wiedereinstieg und Stand sind hier und im Plan dokumentiert.

---

## Noch offen (übergeordnet, nicht blockierend)

1. Manuelle Browser-Prüfung: Avatar-Clips (Seek, Wiederholen, Scroll) und kurze visuelle Feinabnahme (z. B. Woche 4, Mediathek, Vertiefung).  
2. Appwrite: Normalpfad und Session/Profil gelegentlich gegen `CHECKLISTE_APPWRITE_PRUEFEN.md` prüfen.  

Detaillierte Akzeptanzkriterien: `PLAN_APP_OPTIMIERUNG_NAECHSTE_SCHRITTE.md`.

---

## Chronologische Historie (Archiv)

### Februar 2026 — Hauptpaket (Kompakt)

In einem größeren Block u. a.: Wochentitel und Glossar, Umbenennung und Reihenfolge der Wochenblöcke, Notfall-Koffer, inhaltliche Schärfung Woche 5–8, Typografie/Web-Theme, Session-Refresh- und Seek-Policies inkl. Tests, begrenzte Lesebreite, Vertiefungs-Pilot mit 3D-Schatten-Tokens, Wochenraster + Tag-der-Achtsamkeit-Karte, Trennung Kartenstil Übersicht vs. Detail, Render-Fixes für leere Web-Ansicht (u. a. `Spacer`/unbounded Height), inhaltliche und visuelle Überarbeitung Woche 1, Rollout neutraler Karten Woche 1–8. Anschließend UI-Inventar, UI-Standard und Einführung der Shared Widgets (Section Header, Surface-Icon, SOS, Audio-Karte, PDF-Karte, Standard-Listenkarte) mit Rollout auf Kernseiten.

### Update 25.03.2026 — Go-Live-Härtung

AudioService-Methoden abgesichert; `onError` auf relevanten Streams; Fehler sichtbar in `AudioItemCard` / `MiniPlayerBar`; leere Mediathek-Suche mit Hinweis; Lint/Logout-Texte; Kursinhalt (Cowork-Session) in `app_daten.dart`.

### Update 28.03.2026 — Avatar-Audio-Clips

Widget `AvatarAudioClip`; Wiederholen nach Ende; `AutomaticKeepAliveClientMixin` beim Scrollen; nur ein Clip aktiv; interaktive Seek-Leiste.

### Update 07.04.2026 — Clip-Logik und Platzhalter

Position der Wochen-Intro-Clips; Begrüßung im Kurskopf; gegenseitiges Stoppen Mediathek/Avatar; Typanpassung Stop-Listener; Platzhalter für noch fehlende Storage-IDs.

### Update April 2026 — Mediathek & Benennung

Optionaler Download; Sprecher-Kennzeichnung im Titel und passende `audioRefs`.

### Import-Tool (April 2026)

`tool/import_participants.dart`: Bei HTTP-5xx nach `POST /users` wird per List-API geprüft, ob der Nutzer dennoch existiert (Appwrite kann fälschlich 500 liefern, obwohl der Account angelegt wurde).
