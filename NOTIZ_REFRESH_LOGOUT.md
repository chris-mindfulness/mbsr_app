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

Betroffene Dateien:
- `lib/services/auth_service.dart`
- `lib/auth/auth_wrapper.dart`

## Was das praktisch bedeutet
Wenn du eingeloggt warst und die Seite neu lädst, soll die App dich nicht mehr direkt auf „ausgeloggt“ setzen, nur weil die Session-/Rollenabfrage kurz fehlschlägt.

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
