#!/usr/bin/env bash
# Startet einen lokalen Webserver im Projektroot mbsr_app (eine Ebene über diesem Skript).
# Danach im Browser eine der URLs öffnen (siehe Ausgabe unten).

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PORT="${1:-8765}"

echo ""
echo "  Ordner: $ROOT"
echo ""
echo "  Diese URL im Browser öffnen:"
echo "    http://127.0.0.1:${PORT}/preview_week1_avatar.html"
echo ""
echo "  Alternative (Vorschau aus tool/-Ordner):"
echo "    http://127.0.0.1:${PORT}/tool/preview_week1_avatar.html"
echo ""
echo "  Nur das Bild testen:"
echo "    http://127.0.0.1:${PORT}/assets/images/avatar/mbsr_avatar_autopilot_w1.png"
echo ""
echo "  Beenden: Ctrl+C"
echo ""

exec python3 -m http.server "$PORT"
