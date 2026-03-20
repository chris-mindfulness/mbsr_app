# DSGVO Löschkonzept – MBSR App

Stand: 2026-03-20  
Status: Entwurf zur Finalisierung

## Ziel

Personenbezogene Daten nicht länger speichern als erforderlich.

## Datenkategorien

- Appwrite Auth-Nutzer (E-Mail, Name, Status)
- Rollenprofile in `users`-Tabelle (`email`, `name`, `role`)
- ggf. Betriebs-/Fehlerprotokolle

## Vorschlag Löschregeln (anpassen/freigeben)

- Aktive Teilnehmende:
  - Speicherung während laufender Kurs-/Nutzungsphase
- Ehemalige Teilnehmende:
  - Löschung/Anonymisierung nach [X Monaten] ohne aktive Nutzung
- Test-/Dummy-Accounts:
  - zeitnah nach Testabschluss entfernen
- Import-CSV mit Passwörtern:
  - direkt nach erfolgreichem Import löschen oder verschlüsselt ablegen

## Operativer Prozess (monatlich)

1. Liste inaktiver Accounts prüfen
2. Freigabe für Löschung dokumentieren
3. Auth-Account löschen
4. zugehöriges Rollenprofil in `users` löschen
5. Maßnahme mit Datum kurz protokollieren

## Sonderfälle

- Rechtliche Aufbewahrungspflichten: [BITTE EINTRAGEN]
- Sicherheitsvorfälle/Forensik: [BITTE EINTRAGEN]

## Verantwortlichkeiten

- Fachliche Freigabe Löschung: [BITTE EINTRAGEN]
- Technische Durchführung: [BITTE EINTRAGEN]
- Protokollablage: [BITTE EINTRAGEN]
