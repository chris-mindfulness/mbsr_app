# Security- & Go-Live-Audit — 28.02.2026

## Kontext

Unabhängiger Review des aktuellen App-Stands vor Freischaltung für Kursteilnehmende.
Durchgeführt in zwei Phasen:

- **Phase 1 (Codex 5.3):** Technische Härtung — `.env`-Migration, Auth-Fallback auf fail-closed, Dependency-Bereinigung.
- **Phase 2 (Opus 4.6):** Unabhängiger Security-Review aller Änderungen + Gesamtbewertung.

Alle Prüfungen basieren auf dem tatsächlichen Quellcode, nicht auf Dokumentation.

---

## 1. `.env`-Migration

### Was geändert wurde

| Datei | Änderung |
|---|---|
| `.env` | Gelöscht, in `.gitignore` aufgenommen |
| `.env.example` | Neu erstellt (Referenzwerte) |
| `pubspec.yaml` | Asset-Eintrag `- .env` entfernt, `flutter_dotenv` Dependency entfernt |
| `lib/core/app_config.dart` | `dotenv.env[...]` → `String.fromEnvironment(...)` mit Compile-Time-Defaults |
| `lib/main.dart` | `dotenv.load()`-Block und Import entfernt |
| `README.md` | Dokumentation für `--dart-define` ergänzt |

### Bewertung

Korrekt und vollständig umgesetzt.

Hinweis: `.env` war zuvor im Git-Index getrackt. Beim nächsten Commit wird sie durch die Löschung aus dem Index entfernt. Die Git-History enthält weiterhin die alten Werte (Endpoint + Project-ID). Da es sich um öffentliche Client-Werte handelt (im JS-Bundle ohnehin sichtbar), ist das kein kritisches Geheimnis.

**Status: Erledigt. Kein Blocker.**

---

## 2. Auth: Fail-Closed statt Fail-Open

### Vorher (Risiko)

Wenn kein Profil-Dokument in Appwrite gefunden wurde, wurde automatisch die Rolle `mbsr` zugewiesen:

```dart
// ALT — auth_service.dart
final fallbackRole = <String, dynamic>{
  'email': email,
  'role': AppConfig.mbsrRole,
  'name': name,
};
await _saveCachedRole(fallbackRole);
return const RoleResolution(role: AppConfig.mbsrRole, fromFallback: true);
```

Das bedeutete: Jeder authentifizierte User ohne Profil-Dokument bekam automatisch Zugang.

### Nachher (gehärtet)

```dart
// NEU — auth_service.dart
return const RoleResolution(role: null);
```

Im AuthWrapper greift dann korrekt:

```dart
// auth_wrapper.dart
if (role != 'mbsr') {
  return _buildErrorScreen(
    title: 'Profil wird geprüft',
    message: 'Du bist angemeldet, aber dein Kursprofil konnte ...',
    icon: Icons.lock_outline,
  );
}
```

Da `null != 'mbsr'` → `true`, wird bei fehlendem Profil der Zugriff gesperrt. Kein Weg vorbei — alle Routen laufen durch `_getTargetPage`, und der Role-Check kommt vor jeder Inhaltseite.

### Toter Code

`RoleResolution.fromFallback` und der zugehörige Check in `auth_wrapper.dart` (Zeile 325) sind jetzt unreachable, da `fromFallback` nie mehr auf `true` gesetzt wird. Kosmetisch aufräumbar, nicht sicherheitsrelevant.

**Status: Sicher. Kein Blocker.**

---

## 3. Session-Cache-Verhalten

### Mechanismus

1. Beim App-Start wird ein gecachter User aus `SharedPreferences` geladen.
2. Server-Check per `account.get()` mit 3 Retries und 15s Timeout.
3. Bei 401 **mit** Cache → User bleibt lokal „eingeloggt" (UX-Entscheidung gegen Logout-Schleifen).
4. Bei 401 **ohne** Cache → User wird korrekt ausgeloggt.

### Warum das kein Security-Bypass ist

Auch wenn der User lokal als „eingeloggt" erscheint, scheitert der anschließende `resolveRoleForEmail`-Call an Appwrite, wenn die Session serverseitig ungültig ist. Daten können nicht abgerufen werden, weil Appwrite-API-Calls mit ungültiger Session fehlschlagen.

### Schwachstelle (gering)

`getCurrentUser()` fängt alle Fehler ab und fällt stillschweigend auf den Cache zurück. Wird derzeit nicht in sicherheitskritischen Pfaden genutzt.

**Status: Akzeptabel für Go-Live. Langfristig vereinfachen.**

---

## 4. Appwrite Client-seitige Angriffsfläche

| Prüfpunkt | Ergebnis |
|---|---|
| Endpoint + Project-ID im Bundle sichtbar | Normal bei Client-SDKs, kein Problem |
| Database-/Collection-/Bucket-IDs als Konstanten | Normal, Appwrite erzwingt Permissions serverseitig |
| `signUp()` im Code vorhanden | Nicht von UI aufgerufen (nur `login()` in `login_screen.dart`) |
| Direkter Storage-Zugriff | Nicht gefunden im Client-Code |

`signUp()` existiert als Admin-/Migrations-Methode. Ob die Appwrite-API Self-Registration erlaubt, hängt von der **Serverkonfiguration** ab — nicht vom Client-Code.

**Status: Client-seitig sauber. Serverseitige Permissions separat prüfen (siehe Abschnitt 8).**

---

## 5. CI/CD Pipeline

| Workflow | Inhalt | Bewertung |
|---|---|---|
| `quality.yml` | analyze + test + build (PRs + main) | Sauber |
| `deploy.yml` | build + Cloudflare Pages Deploy (main) | Sauber |

- Kein `.env`-File im CI nötig (Compile-Time-Defaults greifen).
- Secrets (`CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`) in GitHub Secrets.
- Build-Kommando ohne `--dart-define` nutzt korrekt die Produktions-Defaults.

**Status: Kein Problem.**

---

## 6. Code-Qualität (verifiziert)

| Prüfpunkt | Ergebnis |
|---|---|
| `print()` in `lib/` | Keine gefunden |
| `debugPrint` ohne `kDebugMode`-Guard | Keine gefunden (alle geschützt) |
| TODO/FIXME | 2× in `lib/nutzungs_tracker.dart` (zukünftiges Feature, akzeptabel) |
| `http://`-URLs in Dart-Code | Keine gefunden |
| Auskommentierter Code | Keiner gefunden |
| Skipped Tests | Keine gefunden |
| `flutter analyze` | 0 Befunde |
| `flutter test` | 28/28 grün |
| `flutter build web --release` | Erfolgreich |

**Status: Sauber.**

---

## 7. DSGVO / Rechtliches

### Impressum

Vorhanden in `legal_dialogs.dart`: Name, Adresse, E-Mail, Web. Ausreichend für TMG-Konformität.

### Datenschutzerklärung

**Unvollständig.** Aktueller Text:

> Diese App wird über Appwrite und Cloudflare bereitgestellt. Zur Bereitstellung und Absicherung (CDN, DDoS-Schutz) nutzen wir Cloudflare. Dabei werden technisch notwendige Verbindungsdaten verarbeitet.
>
> Für die Funktion werden lokal im Browser technisch notwendige Daten gespeichert (z. B. Sitzungs- und Rolleninformationen für stabilen Login).

Fehlende Pflichtangaben nach DSGVO:

- Verantwortlicher mit vollständiger Kontaktangabe (Art. 13 Abs. 1a)
- Welche personenbezogenen Daten erhoben werden (E-Mail, Name, IP, Session-Daten)
- Rechtsgrundlage der Verarbeitung (Art. 6 — vermutlich Art. 6 Abs. 1b, Vertragserfüllung)
- Betroffenenrechte (Auskunft, Löschung, Berichtigung, Widerspruch — Art. 15–21)
- Speicherdauer / Löschfristen
- Serverstandort des Appwrite-Servers (relevant für Drittlandtransfer)
- Cloudflare als Auftragsverarbeiter (mit Rechtsgrundlage)

**Status: Impressum OK. Datenschutzerklärung ist ein Go-Live-Risiko.** Für einen geschlossenen Kurskreis mit persönlicher Einladung kurzfristig tolerierbar, aber vor öffentlicher Sichtbarkeit zwingend nachzubessern.

---

## 8. Weitere Befunde

### Passwort-Reset-Route fehlt

Die Redirect-URL `https://app.mindfulpractice.de/reset-password` ist in `auth_service.dart` hardcodiert, aber `/reset-password` existiert nicht in `AppRouter`. Wenn ein User auf den Link in der Reset-Mail klickt, greift der Fallback-Router. Manuell testen, ob der Appwrite-Reset-Flow trotzdem funktioniert.

### Error-Leak im Login-Screen

`login_screen.dart` zeigt `e.toString()` in der SnackBar. Für `AuthException` ist das sauber (benutzerfreundliche Texte). Aber `catch (e)` fängt auch unerwartete Fehler ab, deren `.toString()` technische Details enthalten könnte. Ein generischer Fallback-Text wäre sicherer.

---

## 9. Go / No-Go Entscheidung

### GO mit Auflagen (für geschlossenen Teilnehmerkreis)

| Bereich | Status | Dringlichkeit |
|---|---|---|
| Auth Fail-Closed | Korrekt | Erledigt |
| `.env`-Handling | Korrekt | Commit noch nötig |
| Session-Resilience | Akzeptabel | Kein Blocker |
| Client-Sicherheit | Sauber | — |
| CI/CD | Sauber | — |
| Code-Qualität | Sauber | — |
| Datenschutzerklärung | Unvollständig | **Vor öffentlichem Go-Live nachbessern** |
| Passwort-Reset-Route | Unklar | **Manuell testen** |
| Appwrite Server-Permissions | Ungeprüft | **Manuell prüfen** |
| Toter Code (`fromFallback`) | Kosmetik | Niedrig |

### Vor Freischaltung noch erledigen (manuell, nicht Code)

1. **Appwrite-Dashboard:** Prüfen ob Self-Registration deaktiviert ist.
2. **Appwrite-Dashboard:** Collection- und Bucket-Permissions prüfen (nur authentifizierte User mit `mbsr`-Rolle?).
3. **Passwort-Reset-Flow** einmal komplett durchspielen.
4. **Datenschutztext** erweitern (kann auch kurzfristig nach Go-Live, wenn Teilnehmerkreis bekannt und klein).

### Gesamtbewertung

Die technische Absicherung ist nach den Codex-Änderungen solide. Für einen geschlossenen MBSR-Kurs mit persönlich eingeladenen Teilnehmenden: **Go.**
