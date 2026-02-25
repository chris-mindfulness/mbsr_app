# Notiz: Refresh-Logout (einfach erklärt)

## Ziel
Beim Neuladen der Seite (Refresh) sollst du nicht sofort rausfliegen.

## Was jetzt im Code umgesetzt ist
Es gibt jetzt **2 Schutzebenen**:

1. **Kein Auto-Logout mehr** im `AuthWrapper`, wenn Rollenprüfung beim Start kurz scheitert.
2. **Lokaler Fallback-Cache**:
   - Letzter erfolgreicher User wird lokal gespeichert.
   - Letzte erfolgreiche Rollen-Info wird lokal gespeichert.
   - Wenn Appwrite beim Refresh kurz keine Session/Antwort liefert, nutzt die App diese lokalen Daten als Fallback.

Zusätzlich:
- Rollenprofil wird über neues und altes Schema geprüft (TablesDB + Legacy-Fallback).

Betroffene Dateien:
- `lib/services/auth_service.dart`
- `lib/auth/auth_wrapper.dart`

## Was das praktisch bedeutet
Wenn du eingeloggt warst und die Seite neu lädst, soll die App dich nicht mehr direkt auf „ausgeloggt“ setzen, nur weil die Session-/Rollenabfrage kurz fehlschlägt.

## Offener Punkt (später glätten)
Der Refresh wirkt noch optisch unruhig:
- Splash/Fade-in kommt nochmal
- kurzes doppeltes „Zucken“

Das ist aktuell ein UX-Problem im Übergang, kein harter Logout-Fehler.

## Update 25.02.2026 (Refresh-UX)
Es wurde ein kleiner UX-Stabilisierungs-Schritt umgesetzt:

1. Splash wird beim Start übersprungen, wenn ein User schon geladen ist.
2. Rollenabfrage wird pro User als Future gecacht (kein ständiges Neu-Laden bei jedem Rebuild).
3. Während Rollenladen wird ein einfacher Loader gezeigt (nicht mehr der animierte Splash).
4. Der Button „Erneut versuchen“ startet jetzt die Rollenabfrage wirklich neu.

Erwartung nach dem Update:
- Weniger bis kein doppeltes Zucken beim Reload.
- Kein mehrfaches Splash-Logo bei stabilem Refresh.

## Wichtiger Klartext
Das ist ein **Frontend-Fallback**, damit die Nutzerführung stabiler ist.
Wenn die Session-Infrastruktur im Backend (Cookie/Domain/Appwrite-Platform) nicht sauber ist, sollte das zusätzlich serverseitig geprüft werden.

## Aktueller technischer Status
- `flutter analyze --no-pub`: **No issues found**
- `flutter build web --no-pub`: erfolgreich

## Praxistest
1. Einloggen
2. Unterseite öffnen
3. Refresh drücken
4. Prüfen, ob du in der App bleibst

## Update 25.02.2026 (Nutzer-Rückmeldung)

Beobachtung:
- Beim Verlassen des Browsers und späterem Zurückkehren bleibt der Login jetzt erhalten.

Einordnung:
- Das passt zu den umgesetzten Auth-Änderungen (lokaler Fallback, robuster Session-Check, kein harter Auto-Logout bei kurzzeitigem Rollenproblem).
- Das Verhalten ist damit deutlich stabiler als vorher.

Wichtig:
- Die eigentliche Session-Lebensdauer (z. B. „90 Tage“) wird weiterhin serverseitig in Appwrite bestimmt.

## Update 25.02.2026 (Refresh-Flicker reduziert)

Umgesetzt:
- Erster Auth-Snapshot nach Refresh wird nicht mehr als "frischer Login" gewertet.
- Dadurch kein unnötiger Redirect auf `/home`, wenn schon eine Unterseite offen war.
- Bei kurzem `ConnectionState.waiting` nach abgeschlossenem Splash wird jetzt ein kleiner Inline-Loader gezeigt statt erneutem Voll-Splash mit Logo.
- Splash-Animation wurde deutlich beschleunigt (kürzerer Start-Delay + kürzere Fade/Scale-Dauer).

Betroffene Dateien:
- `lib/auth/auth_wrapper.dart`
- `lib/splash_screen.dart`

Technischer Check:
- `flutter analyze --no-pub lib/auth/auth_wrapper.dart lib/splash_screen.dart`: erfolgreich.
- `flutter test --no-pub test/data/app_daten_integrity_test.dart`: erfolgreich.
