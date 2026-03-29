# Prozess: Passwort-Reset-Redirect-URL

Stand: 29.03.2026

## Zweck

Appwrite verschickt beim Passwort-Reset eine E-Mail mit einem Link. Dieser Link muss zu einer **fest erlaubten** URL zurückführen. Die App übergibt diese URL nur an `createRecovery`; sie kommt **ausschließlich** aus dem Build (`AppConfig.passwordResetRedirectUrl`), **nicht** aus Formularfeldern oder der API.

## Standard (Produktion)

- **Kein** `--dart-define` nötig.
- Standardwert: `https://app.mindfulpractice.de/reset-password`
- CI/CD (`flutter build web` ohne extra Defines) nutzt automatisch diesen Wert.

## Lokal testen (optional)

1. **Appwrite:** Unter Auth die gewählte Redirect-URL zur Liste der erlaubten URLs hinzufügen (exakt gleicher String, inkl. `http`/`https`, Pfad, kein trailing Slash wenn nicht beabsichtigt).
2. **App starten** mit z. B.:

```bash
flutter run -d chrome \
  --dart-define=APPWRITE_ENDPOINT=https://api.mindfulpractice.de/v1 \
  --dart-define=APPWRITE_PROJECT_ID=696befd00018180d10ff \
  --dart-define=APP_PASSWORD_RESET_REDIRECT_URL=http://localhost:8080/reset-password
```

Port und Host müssen zu deiner laufenden Web-App passen (`flutter run` zeigt die URL in der Konsole).

3. **Reset anstoßen** mit einer E-Mail, die als Appwrite-User existiert.
4. Link aus der E-Mail öffnet dann die lokale App unter `/reset-password`.

## Sicherheit (kurz)

| Regel | Begründung |
|--------|------------|
| URL nur via `dart-define` / Default | Verhindert Open-Redirect und Manipulation durch Clients. |
| Jede genutzte URL in Appwrite erlauben | Appwrite lehnt unbekannte Redirects ab; reduziert Missbrauch. |
| Localhost-URLs nur für Entwicklung | In Produktion kein `localhost` in erlaubten URLs, wenn nicht nötig. |
| Produktions-Build ohne abweichendes Define | Versehentliches Ausliefern einer Dev-URL wird vermieden. |

## Code-Stellen

- Konfiguration: `lib/core/app_config.dart` (`APP_PASSWORD_RESET_REDIRECT_URL`)
- Aufruf: `lib/services/auth_service.dart` → `sendPasswordResetEmail`

## Checkliste vor Go-Live

- [ ] Produktive Redirect-URL steht in Appwrite als erlaubt.
- [ ] Kein Release-Workflow setzt `APP_PASSWORD_RESET_REDIRECT_URL` auf localhost.
- [ ] Passwort-Reset einmal mit echtem Postfach gegen die **deployte** App getestet.
