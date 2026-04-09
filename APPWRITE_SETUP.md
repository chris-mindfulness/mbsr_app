# Appwrite Setup (aktuell, einfach)

Stand: 25.02.2026

Ziel: Die App soll stabil einloggen, Profil finden und Medien laden.

## Aktuelle Soll-Werte (aus dem Code)

- Endpoint: `https://api.mindfulpractice.de/v1`
- Project ID: `696befd00018180d10ff`
- Database ID: `mbsr_database`
- Users-Profil: `users`
- Medien-Bucket (Audio + PDF): `mbsr_content`
- Rollenwert für Kurszugang: `mbsr`

## 1) Basis in der App prüfen

Datei: `.env`

```env
APPWRITE_ENDPOINT=https://api.mindfulpractice.de/v1
APPWRITE_PROJECT_ID=696befd00018180d10ff
```

Wichtig:
- Endpoint und Project ID müssen zum gleichen Appwrite-Projekt gehören.

## 2) Web-Plattform in Appwrite prüfen

Ort in Appwrite: `Project -> Platforms -> Web`

Prüfen:
- Richtige produktive Domain ist eingetragen (inkl. `https://`).
- Falls lokal getestet wird, ist auch die lokale Web-URL erlaubt.

Wenn die Plattform-URL falsch ist, kann Refresh/Login instabil werden.

## 3) Datenbank-Struktur prüfen

Ort in Appwrite: `Databases -> mbsr_database`

Erwartet wird eine Users-Struktur mit ID `users`.
Diese wird für Rollenprüfung genutzt.

Pflichtfelder:
- `email` (String)
- `role` (String)

Optional:
- `name` (String)

Inhaltlich wichtig:
- Pro Auth-User muss ein passender Profil-Eintrag existieren.
- `email` muss exakt zur Login-E-Mail passen.
- `role` muss `mbsr` sein, wenn Zugang zur Kurs-App erlaubt sein soll.

## 4) Rechte für Profil-Zugriff prüfen

Der eingeloggte Nutzer muss sein eigenes Profil lesen können.

Wenn diese Berechtigung fehlt, kommt es zu:
- "Profil nicht gefunden"
- oder Hängenbleiben auf Profil-/Retry-Seiten

## 5) Storage-Bucket prüfen

Ort in Appwrite: `Storage`

Erwartet:
- Bucket ID: `mbsr_content`
- Enthält Audio- und PDF-Dateien
- IDs der Dateien müssen mit den IDs in der App zusammenpassen

Die App baut Medien-URLs so auf:

```text
{ENDPOINT}/storage/buckets/mbsr_content/files/{FILE_ID}/view?project={PROJECT_ID}
```

### Kursheft-PDFs: IDs nach Dateiwechsel

**Wichtig:** Wenn du Kursheft-PDFs in Appwrite **ersetzt oder neu hochlädst**, ändern sich die **File-IDs**. Dann musst du in **`lib/app_daten.dart`** die **`appwrite_id`** je Eintrag unter **`pdfs`** **pro Woche** (und beim **Tag der Achtsamkeit**) neu setzen — sonst zeigen die Links auf falsche oder fehlende Dateien.

Dauerhafte Checkliste: **`docs/ERINNERUNG_KURSHEFT_APPWRITE_IDS.md`**

## 6) Wichtiger Technik-Hinweis zum aktuellen Code

Die Rollenabfrage läuft aktuell in dieser Reihenfolge:
1. TablesDB (`users`) als primärer Weg
2. Legacy-Fallback über ältere Collection (`users`)
3. lokaler Fallback-Cache (nur zur Stabilisierung)

Das bedeutet:
- Neue Daten bitte im aktuellen `users`-Schema pflegen.
- Alte Legacy-Daten können Übergangsprobleme abfedern, sind aber nicht Zielzustand.

## 7) Schnelltest nach Änderung

1. Einloggen
2. Unterseite öffnen
3. Browser-Refresh
4. Prüfen: eingeloggt bleiben + Profil wird direkt geladen

Zusatzcheck in Browser DevTools (Network):
- Request `/account` sollte stabil `200` sein.

## 8) Wenn etwas nicht passt

Nutze diese Checkliste:
- `CHECKLISTE_APPWRITE_PRUEFEN.md`

Dort ist die Fehlersuche Schritt für Schritt beschrieben.

## 9) Passwort-Reset-Redirect

Die Redirect-URL für `createRecovery` kommt aus dem Build (`APP_PASSWORD_RESET_REDIRECT_URL` oder Standard `https://app.mindfulpractice.de/reset-password`). Sie muss in Appwrite unter den erlaubten Auth-URLs eingetragen sein.

**Fester Ablauf für Menschen und KI:** `docs/prozesse/PASSWORT_RESET_REDIRECT.md`
