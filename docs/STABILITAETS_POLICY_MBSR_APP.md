# Stabilitäts-Policy für die MBSR-App

## Ziel

Die App-Basis bleibt langfristig stabil.  
Neue Inhalte dürfen den Kern nicht gefährden.

Leitsatz: **Stabilität zuerst. Erweiterung nur isoliert und kontrolliert.**

---

## 1) Kernschutz (nicht antasten ohne explizite Freigabe)

Diese Bereiche sind kritisch und werden nur mit gesonderter Entscheidung geändert:

- Auth-Flow (`AuthService`, `AuthWrapper`, Session-Logik)
- Audio-Pfade (`AudioService`, `BellService`, Mini-/Full-Player)
- Routing-Basis und App-Start (`main.dart`, zentrale Router-Logik)
- Datenquelle für Kursinhalte (`lib/app_daten.dart` als Single Source of Truth)

Regel: Neue Vertiefungs-Features greifen nicht direkt in diese Kernbereiche ein.

---

## 2) Prinzip fuer neue Features

Jedes neue Element wird als isoliertes Modul umgesetzt:

- eigener Feature-Ordner
- eigene UI + eigene Logik
- eigener lokaler Speicher (nur UX-Daten)
- klare Route
- klarer Fallback (Lesekarte statt Crash)

Regel: **Ein Modul darf bei Fehler nie die Gesamt-App blockieren.**

---

## 3) Feature-Flags und Not-Aus

Jedes neue Modul ist:

- standardmäßig deaktivierbar
- zentral ein-/ausschaltbar
- ohne Seiteneffekte entfernbar

Regel: Bei Auffälligkeit wird das Feature deaktiviert, nicht der Kern umgebaut.

---

## 4) Release-Disziplin

Keine Sammel-Releases für viele neue Spielarten.

Pro Release:

1. maximal ein neues interaktives Modul
2. Analyse + Tests grün:
   - `flutter analyze --no-pub`
   - `flutter test --no-pub`
3. manueller Smoke-Test:
   - Login
   - Home
   - Audio starten/stoppen
   - Navigation
   - neues Modul öffnen/schließen/reset

Erst dann Freigabe.

---

## 5) Mindestanforderungen je neuem Modul (Definition of Done)

Ein Modul ist erst "fertig", wenn:

- Route funktioniert
- Reset funktioniert
- lokales Speichern/Laden funktioniert
- Fehlerfall führt zu sicherem Fallback
- UX-Texte sind klar und korrekt (inkl. Umlaute)
- keine neuen Dependencies ohne Abstimmung
- Analyze/Test sind grün

---

## 6) Klare No-Gos

- kein unkontrolliertes Copy-Paste grosser Seiten
- keine Querverdrahtung in Kern-Services
- keine versteckten globalen Nebenwirkungen
- kein Hotfix im Kern für Feature-Probleme
- keine ungeprüften Massen-Einbauten

---

## 7) Vorgehensmodell für viele kommende Inhalte

1. Pilotmodul sauber einbauen
2. Muster stabilisieren
3. weitere Module nur nach gleichem Muster ergänzen
4. bei jedem Schritt rückbaubar bleiben

Ziel: Wachstum ohne Risiko für die jahrelang tragende Basis.

---

## 8) Entscheidungsregel bei Unsicherheit

Wenn unklar ist, ob eine Änderung den Kern berührt:

- **Stop**
- kurz Risiko einschätzen
- nur mit expliziter Freigabe weiter

Sicherheitsprinzip: **Im Zweifel Stabilität vor Tempo.**
