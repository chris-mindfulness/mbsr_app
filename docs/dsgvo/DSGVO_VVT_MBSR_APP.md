# DSGVO VVT – MBSR App

Stand: 2026-03-20  
Status: Entwurf zur Finalisierung

## 1) Verantwortlicher

- Verantwortlicher: [BITTE EINTRAGEN]
- Anschrift: [BITTE EINTRAGEN]
- Kontakt E-Mail: [BITTE EINTRAGEN]

## 2) Verarbeitungstätigkeit

- Bezeichnung: Betrieb der MBSR-Kursbegleit-App (Web)
- Zweck:
  - Bereitstellung von Kursinhalten (Audio/PDF)
  - Anmeldung und Zugriffskontrolle für Teilnehmende
  - Verwaltung von Nutzerzugängen
- Rechtsgrundlage (typisch):
  - Vertragserfüllung (Art. 6 Abs. 1 lit. b DSGVO)
  - ggf. berechtigtes Interesse (Art. 6 Abs. 1 lit. f DSGVO) für IT-Sicherheit
- Kategorien betroffener Personen:
  - (Ehemalige) Kursteilnehmende
- Kategorien personenbezogener Daten:
  - E-Mail-Adresse
  - Name
  - Rollen-/Zugriffsstatus (`role`)
  - technische Nutzungs-/Sitzungsdaten (Session-bezogen)

## 3) Empfänger / Auftragsverarbeiter

- Appwrite (Auth/DB/Storage) – [AV-Status eintragen]
- Cloudflare Pages (Hosting/Delivery) – [AV-Status eintragen]
- Weitere Dienstleister: [BITTE EINTRAGEN oder "keine"]

## 4) Drittlandtransfer

- Aktueller Status: [BITTE EINTRAGEN]
- Falls ja:
  - Zielland/Anbieter: [BITTE EINTRAGEN]
  - Transfergrundlage (z. B. SCC): [BITTE EINTRAGEN]

## 5) Löschfristen / Aufbewahrung

- Nutzerkonten aktiver Teilnehmender: [BITTE EINTRAGEN]
- Nutzerkonten ehemaliger Teilnehmender: [BITTE EINTRAGEN]
- Rollenprofile (`users`-Tabelle): [BITTE EINTRAGEN]
- Protokoll-/Fehlerdaten: [BITTE EINTRAGEN]

## 6) Technische und organisatorische Maßnahmen (Kurzverweis)

- Zugriff nur mit Auth + Rollenprüfung (`mbsr`)
- Fail-closed Zugriffskontrolle
- Secrets nicht im Frontend-Bundle (`dart-define`, kein `.env` im Repo)
- Details siehe `DSGVO_TOM_MBSR_APP.md`

## 7) Interne Zuständigkeit

- Fachlich zuständig: [BITTE EINTRAGEN]
- Datenschutz/Compliance zuständig: [BITTE EINTRAGEN]
- Letzte Prüfung am: [BITTE EINTRAGEN]
