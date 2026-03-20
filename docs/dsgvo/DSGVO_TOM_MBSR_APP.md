# DSGVO TOM – MBSR App

Stand: 2026-03-20  
Status: Entwurf zur Finalisierung

## 1) Zugriffskontrolle

- Authentifizierung über Appwrite Accounts
- Autorisierung über Rollenprofil (`role == 'mbsr'`)
- Fail-closed-Logik: kein Zugriff ohne gültiges Rollenprofil
- Admin-Zugriffe auf Appwrite auf berechtigte Personen begrenzt

## 2) Weitergabekontrolle

- Zugriff auf personenbezogene Daten nur über definierte Appwrite-/Hosting-Zugänge
- API-Keys rollenbasiert und zweckgebunden (Least Privilege)
- Schlüsselrotation bei Verdacht/Kompromittierung

## 3) Eingabekontrolle / Nachvollziehbarkeit

- Änderungen an App-Code per Git-Commit nachvollziehbar
- Importprozesse dokumentiert (`TEILNEHMENDEN_IMPORT.md`)
- Betriebsrelevante Änderungen über CI/CD sichtbar

## 4) Verfügbarkeitskontrolle

- Hosting über Cloudflare Pages
- Backend über Appwrite
- Maßnahmen bei Ausfall:
  - Incident dokumentieren
  - Wiederanlauf prüfen
  - Kommunikation intern festlegen

## 5) Integrität

- Rollenprüfung serverseitig gestützt (Appwrite-Datenprofil)
- Keine offenen Rollenfallbacks im Auth-Flow
- Build-/Qualitätsprüfungen über GitHub Actions

## 6) Datensparsamkeit

- Minimale Profildaten in `users`-Tabelle:
  - `email`
  - `name`
  - `role`
- Keine unnötige Speicherung sensibler Zusatzdaten

## 7) Geheimnisschutz

- Keine produktiven Secrets im Git-Repo
- API-Keys nur lokal/temporär nutzen
- Import-CSV mit Passwörtern nur lokal und kurzzeitig aufbewahren

## 8) Offene Punkte zur Finalisierung

- AV-Verträge final dokumentieren
- Drittlandtransfer-Bewertung ergänzen
- Lösch- und Incident-Prozess als SOP finalisieren
