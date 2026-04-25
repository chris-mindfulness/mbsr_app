# README Vertiefung-Prototypen

## Zweck

Diese Dateien sind Arbeitsgrundlagen für neue Vertiefungs-Elemente.  
Sie sind **nicht** automatisch in der App eingebaut.

## Dateien in diesem Bereich

- `zyklus_demo.html`  
  Interaktiver HTML-Prototyp für "Der Zyklus von Denken und Fühlen".  
  Dient zur inhaltlichen und didaktischen Abstimmung vor Flutter-Einbau.

- `STABILITAETS_POLICY_MBSR_APP.md`  
  Sicherheits- und Arbeitsregeln für Erweiterungen.  
  Ziel: App-Basis stabil halten, neue Features isoliert und kontrolliert einführen.

- `CHECKLISTE_VOR_EINBAU.md`  
  Operativer Kurzcheck vor jedem Einbau eines neuen Moduls.

- `MODELLE_UNTERBEREICH_ZYKLUS_PILOT.md`  
  Umsetzungsleitfaden für den neuen Unterbereich `Modelle` und das Pilotmodul.

## Wie die Demo genutzt wird

1. Lokal im Browser öffnen (z. B. mit `open mbsr_app/docs/zyklus_demo.html`).
2. Inhalt, Sprache und Ablauf mit Kurslogik abgleichen.
3. Erst nach Freigabe als Flutter-Modul umsetzen.

## Verbindliche Regel für den Einbau

Neue Elemente werden nur eingebaut, wenn:

- sie die Stabilitäts-Policy erfüllen,
- klar isoliert sind (Feature-Modul),
- und die Basisfunktionen nicht gefährden.
