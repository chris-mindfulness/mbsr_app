# E-Mail: Begleit-App vorstellen (Vorlage)

**Verwendung:** Mailtext unten kopieren, Platzhalter ersetzen, versenden. Du-Form, gleiche App-URL für alle.  
**Technischer Abgleich:** Login-Hilfe wie in `HILFE_LOGIN_BROWSER.md` (Meldung „Profil wird geprüft”, URL `https://app.mindfulpractice.de`). Produktions-URL entspricht dem Standard in `lib/core/app_config.dart` (`passwordResetRedirectUrl`-Host).

---

## Platzhalter

| Platzhalter      | Ersetzen durch                          |
|------------------|-----------------------------------------|
| `[VORNAME]`      | Vorname der/des Teilnehmenden           |
| `[PASSWORT]`     | Passwort aus dem Teilnehmenden-Import   |
| `[DEIN_NAME]`    | Dein Name / Signatur                    |

---

## Betreff

Dein Zugang zur MBSR-Begleit-App

---

## Mailtext (ab hier kopieren)

Liebe/r [VORNAME],

hier kommt dein Zugang zur Begleit-App für unser MBSR-Training. Die App läuft im Browser – auf dem Handy genauso wie am Computer. Du musst nichts installieren.

So meldest du dich an

1. Öffne auf deinem Handy oder Computer einen Browser (z. B. Safari, Chrome, Firefox oder Edge).
2. Gib in die Adresszeile oben ein: https://app.mindfulpractice.de
3. Melde dich mit diesen Zugangsdaten an:
   E-Mail: genau die Adresse, an die diese Nachricht geht.
   Passwort: [PASSWORT]
   Bitte gut aufbewahren und nicht weitergeben.

Nach dem Einloggen findest du dort die Wocheninhalte, Meditationsanleitungen und Vertiefungstexte zum Kurs. Du bleibst in der Regel über längere Zeit eingeloggt und musst dich nicht bei jedem Öffnen neu anmelden.

App-Symbol auf dem Handy anlegen (optional)

Wenn du die App häufig auf dem Handy nutzt, kannst du dir ein Symbol auf dem Startbildschirm anlegen – dann öffnet sie sich wie eine normale App.

iPhone oder iPad (Safari): Tippe unten auf das Teilen-Symbol (das Quadrat mit dem Pfeil nach oben) und wähle „Zum Home-Bildschirm”.
Android (z. B. Chrome): Tippe oben rechts auf die drei Punkte (⋮) und wähle „Zum Startbildschirm hinzufügen” oder „App installieren”.

Wenn die Anmeldung nicht klappt

Falls nach dem Einloggen „Profil wird geprüft” erscheint oder die Seite sich nicht öffnet, hilft meistens Folgendes:

1. In der App auf „Abmelden” klicken (am Handy: tippen).
2. Im Browser Verlauf und Websitedaten für mindfulpractice.de löschen. (Am Computer meist unter Einstellungen → Datenschutz → Websitedaten. Am Handy je nach Browser etwas unterschiedlich.)
3. Den Browser komplett schließen, neu öffnen und unter https://app.mindfulpractice.de noch einmal einloggen.

Falls es danach immer noch nicht geht: Probiere einen anderen Browser (z. B. Chrome statt Safari oder umgekehrt). Am Handy kann auch ein kurzer Wechsel zwischen WLAN und Mobilfunk helfen. Wenn nichts davon funktioniert, schreib mir kurz, welches Gerät und welchen Browser du verwendest – bei Bedarf gern mit einem Screenshot der Meldung.

Passwort vergessen?

Die Passwort-zurücksetzen-Funktion in der App ist derzeit noch nicht freigeschaltet. Wenn du dein Passwort nicht mehr findest, melde dich einfach bei mir – ich schicke dir ein neues.

Viel Spaß beim Erkunden – und wenn dir etwas auffällt oder du eine Idee hast, schreib mir gern. Die App ist noch im Aufbau, und Rückmeldungen helfen mir sehr, sie besser zu machen.

Herzliche Grüße
Chris

---

## Hinweis für dich (nicht in die Mail)

- Keine Secrets in Git committen: Passwörter nur pro Person in der Versendung, nicht diese Datei mit echten Passwörtern füllen oder ablegen.
- Inhalt der Fehlerbehandlung an `HILFE_LOGIN_BROWSER.md` angelehnt, dort ohne Du-Form für andere Kanäle nachnutzbar.
- Safari auf dem iPhone ist bei Sitzungsdaten oft strenger als andere Browser – die Schritte unter „Wenn die Anmeldung nicht klappt” decken das ab.
