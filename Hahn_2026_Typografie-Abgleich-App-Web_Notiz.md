# Typografie-Abgleich App vs. Website (Notiz)

Stand: 26.02.2026  
Status: Umgesetzt (Basisabgleich). Offene Restaufgabe ist nur eine kurze visuelle Feinabnahme.

## 12 Kommentare / Anforderungen (vom Nutzer)
1. Die Schrift in der App wirkte zuerst zu dünn und zu blass.
2. Nach der letzten Anpassung wirkt die Schrift jetzt zu stark/zu hart.
3. Ziel ist Lesbarkeit wie auf der Website als Referenz.
4. Wenn möglich soll dieselbe Schriftart wie auf der Website genutzt werden.
5. App und Website sollen typografisch klarer angeglichen werden.
6. Im Akkordeon ist die Überschrift sichtbar stärker als der Fließtext; das wirkt uneinheitlich.
7. Fließtext auf cremig-hellem Hintergrund bleibt schwer zu lesen.
8. Kontrast soll klar sein, aber nicht „überzeichnet“.
9. Die Darstellung soll professionell und ruhig bleiben, nicht technisch „hart“.
10. Lesbarkeit für längeres digitales Lesen hat Vorrang.
11. Aktuell keine weitere Bearbeitung; erst dokumentieren.
12. Thema Typografie gezielt in einem späteren, eigenen Schritt erneut angehen.

## Warum Website-Typografie nicht automatisch 1:1 in Flutter-Web aussieht
Kurz in einfachen Worten:

- Website (Astro/CSS) und App (Flutter Web) rendern Text technisch unterschiedlich.
- In CSS wird Font-Weight oft anders „gemischt“ als in Flutter (v. a. bei Variable Fonts).
- Flutter zeichnet Text anders auf der Canvas; dadurch wirken dieselben Werte teils dünner oder härter.
- Helle Kartenflächen plus Transparenz verändern die wahrgenommene Stärke zusätzlich.
- Deshalb ergibt derselbe Hex-Farbwert und dasselbe nominelle Gewicht nicht automatisch denselben visuellen Eindruck.

## Umgesetzte Basiswerte
- Body: `17px`, `line-height 1.6`, `font-weight 400`
- Textfarbe: `#1E1F1D`
- Muted-Text: `#5F6662`
- Woche-4-Lesetexte nutzen nun globale Fließtext-Styles statt Heavy-Overrides
- Web-Theme nutzt expliziten Sans-Stack mit Fallbacks; Heading-Style separat hinterlegt

## Noch offen (kurzer Sichtcheck)
- Browser-Feinabnahme für Woche 4, Mediathek und Vertiefung
- Nur falls nötig: minimale Token-Korrekturen in kleinen Schritten
