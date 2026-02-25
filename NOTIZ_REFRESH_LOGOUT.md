# Notiz: Refresh-Logout (einfach erklärt)

## Ziel
Beim Neuladen der Seite (Refresh) sollst du eingeloggt bleiben und ohne unnötiges Flackern weitermachen.

## Was umgesetzt ist

1. Auth-Stabilisierung:
- Kein harter Auto-Logout mehr bei kurzfristigen Rollen-/Netzwerkproblemen.
- Session-Check mit Retry und differenziertem 401-Verhalten.
- Lokaler Fallback für User/Rolle als Schutz gegen kurzzeitige Backend-Aussetzer.

2. Refresh-UX:
- Erster Auth-Snapshot nach Refresh wird nicht als frischer Login behandelt.
- Dadurch kein unnötiger Redirect auf `/home`, wenn schon eine Unterseite offen war.
- Bei kurzem `ConnectionState.waiting` wird nach abgeschlossenem Splash ein kleiner Inline-Loader gezeigt statt erneutem Voll-Splash.
- Splash-Animation wurde beschleunigt.

## Praktischer Effekt
- Eingeloggt bleiben nach Refresh ist deutlich stabiler.
- Seite bleibt beim Refresh eher auf der aktuellen Route.
- Visuelles Zucken ist reduziert.

## Restpunkt (optional)
- Leichtes Mikro-Flickern kann je nach Gerät/Netz noch auftreten.
- Das ist ein UX-Feintuning-Thema, kein kritischer Funktionsfehler.

## Wichtiger Hinweis
Die Session-Lebensdauer (z. B. „90 Tage“) wird serverseitig in Appwrite bestimmt.

## Betroffene Dateien
- `lib/services/auth_service.dart`
- `lib/auth/auth_wrapper.dart`
- `lib/splash_screen.dart`

## Technischer Status
- `flutter analyze --no-pub`: erfolgreich
- `flutter test --no-pub test/data/app_daten_integrity_test.dart`: erfolgreich
