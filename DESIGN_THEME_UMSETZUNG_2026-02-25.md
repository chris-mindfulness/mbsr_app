# Design-Update: Theme-Schalter (Stand 25.02.2026)

## Was wurde umgesetzt

1. Zwei Design-Modi in der App:
- `Ruhig` (Standard): gedämpftere Farben, weniger visuelle Reize, ruhiger Hintergrund.
- `Lebendig`: näher am bisherigen Look, aber weiterhin reduziert.

2. Nutzer-Schalter im Profil:
- Seite: `Profil`
- Bereich: `Darstellung`
- Auswahl: `Ruhig` / `Lebendig`
- Die Auswahl bleibt gespeichert (auch nach Refresh/Neustart).

3. Technische Basis:
- Zentrale Theme-Tokens eingeführt.
- Farben, Typografie und Glass-Effekt werden zentral vom gewählten Modus gesteuert.

4. Beruhigung der Oberfläche:
- Hintergrund-Animationen verlangsamt.
- Dekorative Blobs im ruhigen Modus deutlich reduziert.
- In der Mediathek/Kurskarte kleine Hierarchie-Schärfung (Metadaten ruhiger dargestellt).

## Betroffene Dateien (Kern)
- `lib/core/theme_tokens.dart`
- `lib/core/theme_mode_controller.dart`
- `lib/core/app_styles.dart`
- `lib/main.dart`
- `lib/profil_seite.dart`
- `lib/widgets/decorative_blobs.dart`
- `lib/widgets/ambient_background.dart`

## Qualitätssicherung
- `flutter analyze --no-pub`: erfolgreich
- `flutter test --no-pub test/data/app_daten_integrity_test.dart`: erfolgreich

## So prüfst du es schnell
1. App öffnen
2. `Profil` öffnen
3. In `Darstellung` zwischen `Ruhig` und `Lebendig` umschalten
4. Zurück in `Kurs`/`Mediathek` und den Unterschied prüfen
5. Refresh machen und prüfen, ob die gewählte Darstellung bleibt
