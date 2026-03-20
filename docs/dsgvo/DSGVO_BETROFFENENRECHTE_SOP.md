# DSGVO SOP – Betroffenenrechte (MBSR App)

Stand: 2026-03-20  
Status: Entwurf zur Finalisierung

## Zweck

Einheitlicher Ablauf für Anfragen zu:

- Auskunft
- Berichtigung
- Löschung

## Eingangskanal

- Primär: [E-Mail-Adresse eintragen]
- Eingang dokumentieren (Datum, Name, Art der Anfrage)

## Fristen

- Eingang bestätigen: innerhalb von 3 Werktagen
- Bearbeitung vollständig: grundsätzlich innerhalb von 1 Monat

## Identitätsprüfung

- Anfrage nur bearbeiten, wenn Identität plausibel bestätigt ist
- Bei Unklarheit Rückfrage stellen und dokumentieren

## Ablauf je Anfrage

### 1) Auskunft

1. Betroffene Person identifizieren
2. Relevante Datenquellen prüfen:
   - Appwrite Auth
   - `users`-Tabelle
3. Antwort strukturiert erstellen
4. Versand dokumentieren

### 2) Berichtigung

1. Korrekturwunsch prüfen
2. Daten in Auth/`users` konsistent aktualisieren
3. Änderung dokumentieren
4. Abschluss anfragender Person bestätigen

### 3) Löschung

1. Löschvoraussetzungen prüfen
2. Auth-Account löschen
3. Rollenprofil in `users` löschen
4. Durchführung dokumentieren
5. Abschluss bestätigen

## Dokumentation (Pflicht)

Pro Fall minimal festhalten:

- Ticket/ID
- Datum Eingang/Ausgang
- Entscheidung
- durchführende Person

## Zuständigkeiten

- Erstprüfung: [BITTE EINTRAGEN]
- Fachfreigabe: [BITTE EINTRAGEN]
- Technische Umsetzung: [BITTE EINTRAGEN]
