# Code-Analyse: MBSR-Kursbegleit-App

**Datum:** 2026-03-20
**Autor:** Claude Opus 4.6 (automatisierte Analyse)
**Scope:** Vollständige Codebase (`lib/`, `test/`, `pubspec.yaml`, Projektregeln)
**Methode:** Manuelle Durchsicht aller 51 Dart-Quelldateien und 8 Testdateien
**Revision:** v1.1 — Korrektur nach Cross-Review mit Cursor (Claude Opus 4.6 im Agent-Modus)

---

## Zusammenfassung

| Dimension | Note | Stärke | Schwäche | Top-Empfehlung |
|---|:---:|---|---|---|
| 1. Architektur & Modularität | 3 | Klare Singleton-Services, saubere Routing-Trennung | `wochen_detail_seite.dart` (1.754 Z.) und `kurs_uebersicht.dart` (999 Z.) zu groß | Große Seiten in Sub-Widgets aufteilen |
| 2. Testabdeckung | 2–3 | Tests auf kritische Pfade fokussiert (Auth, Seek, Design-Tokens, Datenintegrität) | Nur 8 Testdateien / 28 Testfälle bei 51 Quelldateien; keine Integrations-/E2E-Tests | Integrationstests für Login→Role-Gate→Routing ergänzen |
| 3. Sicherheit & Auth | 3–4 | Fail-closed Rollenzuweisung, Session-Retry mit Backoff, benutzerfreundliche Fehlermeldungen | Rollen-Cache in SharedPreferences ohne TTL; Error-Leak in `login_screen.dart` | TTL für gecachte Rollen einführen |
| 4. Code-Qualität | 3 | Konsistente AppStyles-Nutzung, gute Kommentierung, `kDebugMode`-Guards | Magic Numbers, nicht-zentralisierte Texte, Legacy-Datei `app_colors.dart` | Magic Numbers extrahieren, `app_colors.dart` entfernen |
| 5. UX-Architektur | 4 | Responsive Zwei-Spalten-Layout, Offline-Banner, glassmorphe Navigation | Inkonsistente Breakpoints (760px vs. 860px), keine Skeleton-Loading-States | Breakpoints vereinheitlichen |
| 6. Performance | 3 | Audio-Debouncing, Preloading, Recovery-Mechanismus | Kein Lazy Loading der Seiten, vollständige Listen-Rebuilds bei Suche | IndexedStack oder PageView für Tab-Navigation |
| 7. DSGVO & Rechtliches | 2 | Datenschutz-Dialog vorhanden, lokale Statistiken, keine Google-Fonts-Verbindung | Pflichtangaben nach Art. 13 DSGVO fehlen fast vollständig | Datenschutzerklärung dringend vervollständigen |
| 8. Dependency-Hygiene | 3 | Schlankes Dependency-Set (6 Packages), keine unnötigen Abhängigkeiten | `appwrite` ein Major-Release zurück (20.3.3 → 22.0.0), `app_colors.dart` verwaist | Appwrite-Major-Upgrade mit Regressionstests planen |

**Gesamtnote: 3,0 / 5** — Solide Basis mit klaren Verbesserungspunkten vor einem Go-Live.

> **Hinweis zu Bewertungskorridoren:** Die Noten bei Testabdeckung (2–3) und Sicherheit (3–4) sind bewusst als Korridor angegeben. Die untere Note gewichtet die fehlende Breite bzw. die offenen Risiken stärker, die obere Note die Qualität der vorhandenen Priorisierung bzw. die architektonische Gesamtstruktur. Beide Perspektiven sind fachlich begründbar.

---

## 1. Architektur & Modularität

### Stärken

Die App folgt einem nachvollziehbaren Pattern: Singleton-Services (`AuthService`, `AudioService`, `AppwriteClient`, `ThemeModeController`) stellen Backend-Zugriff und Zustandsverwaltung bereit. Policies (`SessionRefreshPolicy`, `SeekPolicy`) sind als reine Funktionen implementiert und damit isoliert testbar. Die zentrale Datenhaltung in `app_daten.dart` als Single Source of Truth verhindert inkonsistente Kursdaten.

Das Routing über `AppRouter` mit konstanten Route-Strings ist typsicher und erweiterbar. Die `AuthWrapper` trennt Authentifizierung sauber von der Inhalts-Navigation.

### Schwächen

Die `wochen_detail_seite.dart` ist mit 1.754 Zeilen die größte Datei und vereint zu viele Verantwortlichkeiten: Audio-Wiedergabe, PDF-Download, Reflexionsfragen, Lesemodus, SOS-Bereich und Wochenaufgaben. Die `kurs_uebersicht.dart` (999 Zeilen) enthält neben der Kursübersicht auch den kompletten Mini-Player und Full-Screen-Player.

Es gibt keine Dependency Injection — alle Services werden über Singletons aufgerufen. Das macht Unit-Tests schwieriger, weil Mocking nur über Workarounds möglich ist.

State Management erfolgt rein über `setState`, `StreamBuilder` und `FutureBuilder`. Bei der aktuellen App-Größe ist das tragbar, skaliert aber schlecht bei wachsender Komplexität.

### Empfehlungen

- `wochen_detail_seite.dart` in Sub-Widgets aufteilen: `WochenAudioSection`, `WochenPdfSection`, `WochenReflexionSection`, `WochenLeseSection`
- Mini-Player und Full-Screen-Player aus `kurs_uebersicht.dart` in eigene Widgets extrahieren
- Mittelfristig: Riverpod oder Provider für State Management evaluieren

---

## 2. Testabdeckung & Teststrategie

### Vorhandene Tests (8 Dateien, 28 Testfälle)

| Testdatei | Testet | Fälle | Bewertung |
|---|---|:---:|---|
| `seek_policy_test.dart` | Audio-Seek-Grenzen | 4 | Gut, deckt Randfälle ab |
| `app_daten_integrity_test.dart` | Datenstruktur-Konsistenz | 3 | Exzellent, prüft Duplikate und Referenzen |
| `typografie_web_abgleich_tokens_test.dart` | Design-Token-Konsistenz | 3 | Gut |
| `woche4_readability_tokens_test.dart` | WCAG-Kontrastverhältnisse | 3 | Sehr gut, prüft 4.5:1 und 3:1 |
| `auth_exception_test.dart` | Fehler-Mapping (401, 429, 500, 503) | 5 | Gut |
| `session_refresh_policy_test.dart` | Session-Entscheidungslogik | 3 | Gut, kritischer Pfad abgedeckt |
| `vertiefung_feature_cards_pilot_test.dart` | Widget-Interaktivität | 4 | Gut |
| `woche4_lesemodus_test.dart` | Lesemodus-Widget + Navigation | 3 | Exzellent, End-to-End für Woche 4 |

### Fehlende Tests (priorisiert)

1. **AuthService (Login/Logout-Flow)** — kritischster ungetesteter Pfad
2. **AudioService (Play/Pause/Stop/Recovery)** — komplexe Zustandsmaschine mit Timer-Logik
3. **LoginScreen** — Formularvalidierung, Fehleranzeige
4. **NutzungsTracker** — Streak-Berechnung, Statistik-Aggregation
5. **AppRouter** — Route-Auflösung, Fallback-Verhalten

### Empfehlungen

- Testabdeckung auf mindestens 40% der Quelldateien anheben (aktuell ~16%)
- Integrations-Tests für den Auth-Flow (Login → Rollen-Check → Redirect)
- Golden-File-Tests für kritische UI-Screens

---

## 3. Sicherheit & Authentifizierung

### Stärken

Die Auth-Architektur ist durchdacht: `AuthService` → `AuthWrapper` → `AppRouter` bilden eine lückenlose Kette. Die Rollenzuweisung ist fail-closed — ohne serverseitig bestätigtes `role == 'mbsr'` gibt es keinen Zugriff auf Kursinhalte. Session-Checks verwenden Retry mit Backoff (3 Versuche, 2s Pause). Fehler werden in Production generisch angezeigt (`AuthException._fromAppwriteException` unterscheidet Debug/Production).

### Schwächen

**Rollen-Cache ohne TTL:** Der gecachte Rollen-Eintrag in SharedPreferences hat kein Ablaufdatum. Wird einem User die Rolle serverseitig entzogen, behält er lokal Zugriff, bis der Cache manuell gelöscht wird.

**Error-Leak im LoginScreen (Zeile 98):** Bei Login-Fehlern wird `e.toString()` direkt angezeigt. Zwar fängt `AuthException` die meisten Fälle ab, aber der generische `catch(e)`-Block (Zeile 96-109) kann interne Fehlermeldungen preisgeben (z.B. `XMLHttpRequest error`-Details).

**Passwort-Reset ohne Zielseite:** Die Redirect-URL (`https://app.mindfulpractice.de/reset-password`) existiert laut Routing nicht als Route. Nutzer landen nach Klick auf den Reset-Link potentiell auf einer 404-Seite.

**`RoleResolution.fromFallback` ungenutzt:** Das Feld `fromFallback` in `RoleResolution` wird zwar im Debug-Log geprüft, hat aber keinen Einfluss auf die Zugriffsentscheidung. Das ist entweder toter Code oder eine unvollständige Sicherheitsfunktion.

### Empfehlungen

- TTL von 24h für gecachte Rollen einführen
- Login-Error-Handling: generischen `catch(e)` durch spezifische Exception-Typen ersetzen
- Route `/reset-password` implementieren oder Redirect-URL anpassen
- `fromFallback` entweder nutzen (z.B. eingeschränkter Zugriff) oder entfernen

---

## 4. Code-Qualität & Wartbarkeit

### Stärken

- Konsistente `AppStyles`-Nutzung für Farben, Typografie und Spacing
- `kDebugMode`-Guards vor allen Debug-Ausgaben (kein `print()`)
- Gute Kommentierung der Service-Klassen und Policies
- Saubere Projektregeln in `.cursor/rules/mbsr-projekt.mdc`

### Schwächen

**Magic Numbers:** Zahlreiche hard-codierte Werte durchziehen die UI-Dateien. Beispiele: Responsive Breakpoints (760px in `feature_info_cards.dart`, 860px in `kurs_uebersicht.dart`), Animationsdauern (450ms, 420ms, 200ms), Widget-Größen (48, 56, 58px). Diese sollten als benannte Konstanten in `AppStyles` oder einer `AppDimensions`-Klasse definiert werden.

**Nicht-zentralisierte Texte:** Trotz `constants/app_texts.dart` sind die meisten UI-Texte direkt in den Dateien hard-codiert. Besonders betrifft das `glossar_faq_seite.dart` (277 Zeilen, fast ausschließlich Text), `literatur_seite.dart` und `exercise_tips_sheet.dart`. Das erschwert Korrekturen und macht eine spätere Lokalisierung unmöglich.

**Legacy-Code:** `app_colors.dart` (35 Zeilen) definiert ein alternatives Farbschema, wird aber nirgends importiert. Die Datei ist toter Code und sollte entfernt werden.

**Namenskonvention:** Die Mischung aus Deutsch (Dateinamen, Variablen: `wochenDaten`, `mediathekAudios`) und Englisch (Klassen: `AudioService`, `ConnectivityService`) ist gewollt und konsistent innerhalb der jeweiligen Ebene. Das ist für ein deutsches Projekt akzeptabel, erschwert aber internationale Zusammenarbeit.

**Duplizierter Code:** Die PDF-Pending-Erkennung (Prüfung auf Platzhalter-IDs und "folgt"-Text) existiert in `downloads_seite.dart` und `tag_der_achtsamkeit_seite.dart` in leicht unterschiedlicher Form.

### Empfehlungen

- Magic Numbers in benannte Konstanten extrahieren
- Alle UI-Texte nach `AppTexts` oder `app_daten.dart` zentralisieren
- `app_colors.dart` entfernen
- PDF-Pending-Logik in eine Hilfsfunktion in `AppDaten` auslagern

---

## 5. UX-Architektur & Responsiveness

### Stärken

Responsive Zwei-Spalten-Layouts sind an mehreren Stellen implementiert (Wochenkarten ab 860px, Feature-Cards ab 760px, Textarchiv mit dynamischem Padding). Das Offline-Banner über `ConnectivityService` informiert Nutzer sofort bei Verbindungsverlust. Die Glassmorphe-Navigation und das Ambient-Background geben der App ein kohärentes, ruhiges Erscheinungsbild.

### Schwächen

Die Breakpoints sind nicht vereinheitlicht (760px vs. 860px). Es fehlen Skeleton-Loading-States — beim Laden von Profildaten oder Statistiken erscheint nur ein generischer Spinner. Die Suchfunktion in der Mediathek hat kein Debouncing und triggert bei jedem Tastendruck einen vollständigen Listen-Rebuild.

### Empfehlungen

- Einheitliche Breakpoints definieren (z.B. `compact < 600`, `medium < 960`, `expanded ≥ 960`)
- Skeleton-Screens für Profil und Statistiken
- Debounced Search (300ms Verzögerung)

---

## 6. Performance & Bundle-Optimierung

### Stärken

Der AudioService implementiert Debouncing (500ms), Preloading für Metadaten und einen Recovery-Mechanismus bei Netzwerkproblemen (max 3 Versuche). Buffering-Timeouts (8s) erkennen hängende Streams.

### Schwächen

Alle drei Tab-Seiten (Kurs, Mediathek, Vertiefung) werden bei jedem Tab-Wechsel neu aufgebaut, weil sie als frische Widget-Instanzen in einer Liste erzeugt werden. Ein `IndexedStack` oder `PageView` würde den Zustand erhalten und unnötige Rebuilds vermeiden.

Die Wochenkarten und Audio-Listen werden vollständig gerendert — bei 8 Wochen und 10 Audios ist das noch akzeptabel, aber nicht zukunftssicher.

Die dekorativen Hintergründe (`DecorativeBlobs`, `AmbientBackground`) nutzen `CustomPaint` mit Animationen. Auf leistungsschwachen Geräten könnten diese Performance-Probleme verursachen, da `shouldRepaint` nicht in allen Fällen optimiert ist.

### Empfehlungen

- Tab-Navigation auf `IndexedStack` umstellen
- `const`-Konstruktoren wo möglich nutzen (einige Widgets sind bereits `const`)
- Performance-Profiling auf Low-End-Geräten durchführen

---

## 7. DSGVO & Rechtliches

### Kritischer Befund

Die Datenschutzerklärung in `legal_dialogs.dart` umfasst nur zwei kurze Absätze und ist für eine öffentlich zugängliche Web-App mit Nutzerverwaltung **nicht DSGVO-konform**. Folgende Pflichtangaben nach Art. 13 DSGVO fehlen:

1. **Name und Kontaktdaten des Verantwortlichen** — nur im Impressum, nicht in der Datenschutzerklärung
2. **Zwecke und Rechtsgrundlage der Verarbeitung** (Art. 6 DSGVO) — fehlt vollständig
3. **Empfänger der Daten** — Appwrite und Cloudflare werden erwähnt, aber ohne Details (Serverstandort, Auftragsverarbeitungsvertrag)
4. **Speicherdauer** — fehlt
5. **Betroffenenrechte** (Auskunft, Löschung, Widerspruch, Datenportabilität) — fehlt
6. **Recht auf Beschwerde bei Aufsichtsbehörde** — fehlt
7. **Information über Cookies / lokale Speicherung** — SharedPreferences werden erwähnt, aber nicht als "Cookies oder ähnliche Technologien" klassifiziert
8. **Freiwilligkeit der Angaben** — fehlt
9. **Drittlandtransfer** — Cloudflare verarbeitet Daten potentiell in den USA, kein Hinweis auf Standardvertragsklauseln

### Empfehlungen

- Datenschutzerklärung von einem Juristen prüfen und vervollständigen lassen
- Text aus dem Dialog-Format in eine eigene Seite oder ein scrollbares Sheet auslagern (für die Länge einer vollständigen DSE ist ein AlertDialog ungeeignet)
- Cookie-Banner bzw. Consent-Management evaluieren (auch wenn nur technisch notwendige Daten gespeichert werden)

---

## 8. Dependency-Hygiene

### Aktuelle Dependencies

| Package | Version | Status | Anmerkung |
|---|---|---|---|
| `appwrite` | ^20.3.3 | **Major-outdated** (→ 22.0.0) | Nutzt TablesDB API; Major-Upgrade erfordert Regressionstests |
| `just_audio` | ^0.10.5 | Aktuell | Standard für Web-Audio |
| `url_launcher` | ^6.3.2 | Aktuell | — |
| `shared_preferences` | ^2.2.2 | Aktuell | — |
| `web` | ^1.1.0 | Aktuell | Ersetzt `dart:html` |
| `cupertino_icons` | ^1.0.8 | Aktuell | — |
| `flutter_lints` | ^6.0.0 | Offiziell, aber Basisprofil | Optional: strengeres Profil via `very_good_analysis` oder erweiterte `analysis_options.yaml` |

### Empfehlungen

- Appwrite-Major-Upgrade (20 → 22) in eigenem Branch mit Regressionstests durchführen
- Optional: `flutter_lints` durch strengeres Lint-Profil ergänzen (z.B. `very_good_analysis`)
- `analysis_options.yaml` mit strengeren Regeln konfigurieren (z.B. `prefer_const_constructors`, `avoid_dynamic_calls`)
- Regelmäßig `flutter pub outdated` ausführen

---

## Top 5 Maßnahmen (priorisiert)

### 1. Datenschutzerklärung vervollständigen (DSGVO)
**Priorität: Kritisch / Blockiert Go-Live**
Die aktuelle DSE erfüllt nicht die Mindestanforderungen nach Art. 13 DSGVO. Juristische Prüfung und Überarbeitung erforderlich.

### 2. Große Dateien refaktorisieren
**Priorität: Hoch**
`wochen_detail_seite.dart` (1.754 Z.) und `kurs_uebersicht.dart` (999 Z.) in semantische Sub-Widgets aufteilen. Das verbessert Wartbarkeit, Testbarkeit und Build-Performance.

### 3. Testabdeckung erhöhen
**Priorität: Hoch**
AuthService-Login-Flow, AudioService-Zustandsmaschine und NutzungsTracker-Statistiken testen. Ziel: mindestens 40% der Quelldateien mit Tests abgedeckt.

### 4. Sicherheitslücken schließen
**Priorität: Hoch**
TTL für Rollen-Cache, Error-Leak im LoginScreen beheben, Passwort-Reset-Route implementieren.

### 5. Code-Hygiene
**Priorität: Mittel**
Magic Numbers extrahieren, `app_colors.dart` entfernen, UI-Texte zentralisieren, `flutter_lints` aktualisieren, duplizierte PDF-Pending-Logik konsolidieren.

---

## Anhang: Dateiübersicht

| Verzeichnis | Dateien | Zeilen (ca.) | Funktion |
|---|:---:|:---:|---|
| `lib/` (Root) | 14 | ~5.800 | Seiten, Services, Daten |
| `lib/core/` | 5 | ~450 | Konfiguration, Styling, Theme |
| `lib/services/` | 2 | ~570 | Auth, Connectivity |
| `lib/auth/` | 2 | ~440 | Auth-Wrapper, Session-Policy |
| `lib/audio/` | 3 | ~220 | Audio-State, Bell, Seek |
| `lib/widgets/` | 16 | ~1.900 | Wiederverwendbare UI-Komponenten |
| `lib/routing/` | 1 | ~75 | Router |
| `lib/pages/` | 1 | ~130 | Home-Page |
| `lib/constants/` | 1 | ~43 | Text-Konstanten |
| `test/` | 8 | ~350 | Unit- und Widget-Tests |
| **Gesamt** | **53** | **~11.200** | |
