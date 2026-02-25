# Checkliste: Appwrite prüfen (einfach)

Stand: 25.02.2026
Ziel: Refresh soll eingeloggt bleiben und Profil soll gefunden werden.

## 1) Web-Plattform in Appwrite prüfen
Ort: `Project -> Platforms -> Web`

Prüfen:
- URL ist exakt richtig (inkl. `https://`)
- richtige Domain/Subdomain (z. B. `app.mindfulpractice.de`)
- keine alte/falsche Test-Domain als einzige aktive URL

## 2) Endpoint und Projekt-ID prüfen
Ort: `.env` in der App

Prüfen:
- `APPWRITE_ENDPOINT` zeigt auf das richtige Projekt
- `APPWRITE_PROJECT_ID` ist korrekt

## 3) Profil-Daten prüfen
Ort: `Database mbsr_database` -> `users`

Prüfen:
- Es gibt einen Eintrag für die E-Mail des Test-Users
- Feld `email` ist korrekt
- Feld `role` existiert und ist `mbsr`

## 4) Rechte prüfen
Ort: Tabelle/Collection `users` -> Permissions

Prüfen:
- eingeloggter Nutzer darf sein Profil lesen
- oder es gibt eine passende Team/Role-Regel

## 5) Browser-Test nach Deploy
Im Browser (DevTools -> Network) prüfen nach Refresh:
- Request `/account` ist `200` oder `401`

Interpretation:
- `/account = 200` -> Session ist da, Problem liegt eher bei Profil-Daten/Mapping
- `/account = 401` -> Session/Cookie/Domain-Problem

## 6) Was aktuell im Code schon abgefangen wird
- Kein sofortiger Auto-Logout mehr bei fehlender Rollen-Antwort
- Lokaler Fallback für User/Rolle aktiv
- Legacy- und neues Profil-Lesen werden beide versucht
