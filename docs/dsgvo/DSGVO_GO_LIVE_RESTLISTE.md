# DSGVO Go-Live Restliste (MBSR App)

Stand: 2026-03-20

Ziel: Offene DSGVO-Punkte pragmatisch und nachvollziehbar abschließen.

## Ampel-Status

### Gruen (bereits gut)

- [x] Datenschutzhinweise in der App erweitert (Art.-13-relevante Punkte)
- [x] Zugriffsschutz fail-closed umgesetzt (kein offener Rollenfallback)
- [x] Secret-Handling verbessert (`.env` nicht im Bundle/Repo)
- [x] Betriebsprozess verbessert (Teilnehmenden-Import strukturiert)

### Gelb (zeitnah erledigen)

- [ ] VVT fuer die App vollständig dokumentieren
- [ ] Loesch- und Aufbewahrungskonzept schriftlich festlegen
- [ ] Prozess fuer Betroffenenrechte definieren (Auskunft, Korrektur, Loeschung)
- [ ] Interne Regel fuer Passwort-/CSV-Handling festlegen

### Rot (kritisch, falls offen)

- [ ] AV-Vertraege mit relevanten Dienstleistern final vorliegend
- [ ] Drittlandtransfer/Transfergrundlage dokumentiert (falls relevant)
- [ ] TOMs dokumentiert (Zugriffe, Rollen, Backups, Incident, Restore)

## Konkrete 7-Tage-Reihenfolge

1. AV-Vertraege und Drittlandthema final pruefen/dokumentieren.
2. Loeschfristen definieren (aktive Teilnehmende vs. ehemalige Teilnehmende).
3. VVT finalisieren (Zwecke, Datenarten, Empfaenger, Fristen, Rechtsgrundlage).
4. TOMs als 1-2 Seiten festhalten (technisch + organisatorisch).
5. SOP fuer Betroffenenrechte festlegen (Wer? Wie schnell? Welche Schritte?).
6. CSV/Passwort-Prozess intern schriftlich festhalten.
7. Abschlusssichtung und Freigabe dokumentieren (Datum, Verantwortliche Person).

## Minimal-Nachweise (Go-Live-Ordner)

Lege diese Nachweise gesammelt ab (z. B. in einem internen Compliance-Ordner):

- VVT (aktuelle Version)
- AV-Vertraege / DPA-Unterlagen
- Dokumentation Transfergrundlage (falls Drittland)
- TOM-Dokument
- Loeschkonzept
- SOP Betroffenenrechte
- Kurzes Abnahmeprotokoll (Datum + Name)

## Verknüpfte Arbeitsdokumente

- `DSGVO_VVT_MBSR_APP.md`
- `DSGVO_TOM_MBSR_APP.md`
- `DSGVO_LOESCHKONZEPT_MBSR_APP.md`
- `DSGVO_BETROFFENENRECHTE_SOP.md`

## Hinweis

Diese Liste ist eine praxisnahe Arbeitsgrundlage und ersetzt keine individuelle Rechtsberatung.
