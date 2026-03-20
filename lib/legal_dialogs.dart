import 'package:flutter/material.dart';
import 'core/app_styles.dart';

/// Zentrale Verwaltung für Impressum und Datenschutz-Dialoge
/// Verhindert Code-Duplikation über mehrere Dateien hinweg
class LegalDialogs {
  // Texte zentral definiert (Single Source of Truth)
  static const String impressumText =
      'Dr. Christian Hahn\n'
      'Salomonstr. 2\n'
      '04103 Leipzig\n\n'
      'E-Mail: achtsamkeit@belight-leipzig.de\n'
      'Web: www.mindfulpractice.de';

  static const String datenschutzText =
      'Verantwortlicher:\n'
      'Dr. Christian Hahn, Salomonstr. 2, 04103 Leipzig, '
      'E-Mail: achtsamkeit@belight-leipzig.de\n\n'
      'Zwecke der Verarbeitung:\n'
      'Bereitstellung der Kurs-App, Anmeldung, Rollenprüfung für den Kurszugang, '
      'Auslieferung von Audio- und PDF-Inhalten sowie technische Stabilität.\n\n'
      'Rechtsgrundlagen:\n'
      'Art. 6 Abs. 1 lit. b DSGVO (Vertrag/Kursdurchführung) und '
      'Art. 6 Abs. 1 lit. f DSGVO (technischer Betrieb, Sicherheit).\n\n'
      'Verarbeitete Daten:\n'
      'E-Mail-Adresse, Name (falls hinterlegt), technische Verbindungsdaten '
      '(z. B. IP-Adresse, Zeitstempel), Sitzungs- und Rolleninformationen.\n\n'
      'Empfänger/Auftragsverarbeitung:\n'
      'Appwrite (Authentifizierung, Datenbank, Dateispeicher) und Cloudflare '
      '(CDN, DDoS-Schutz). Es können Daten in Drittländern verarbeitet werden. '
      'Hierfür werden geeignete Garantien (z. B. EU-Standardvertragsklauseln) verwendet.\n\n'
      'Speicherdauer:\n'
      'Daten werden nur so lange gespeichert, wie es für Kursdurchführung, '
      'Betrieb und gesetzliche Pflichten erforderlich ist.\n\n'
      'Betroffenenrechte:\n'
      'Du hast das Recht auf Auskunft, Berichtigung, Löschung, Einschränkung, '
      'Datenübertragbarkeit und Widerspruch sowie das Recht auf Beschwerde bei '
      'einer Datenschutzaufsichtsbehörde.\n\n'
      'Lokale Speicherung:\n'
      'Im Browser werden technisch notwendige Informationen gespeichert '
      '(z. B. Sitzungs-/Rollen-Cache und Nutzungsdaten), um Anmeldung und Nutzung '
      'stabil bereitzustellen.\n\n'
      'Hinweis:\n'
      'Diese Kurzfassung ersetzt keine vollständige juristische Datenschutzprüfung.';

  /// Zeigt Impressum-Dialog
  static Future<void> showImpressum(BuildContext context) {
    return _showDialog(context, 'Impressum', impressumText);
  }

  /// Zeigt Datenschutz-Dialog
  static Future<void> showDatenschutz(BuildContext context) {
    return _showDialog(context, 'Datenschutz', datenschutzText);
  }

  /// Generischer Dialog für Rechtsinformationen
  static Future<void> _showDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppStyles.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, color: AppStyles.softBrown),
              tooltip: 'Schließen',
              onPressed: () => Navigator.of(dialogContext).pop(),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(color: AppStyles.textDark, height: 1.5),
          ),
        ),
        backgroundColor: AppStyles.bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Schließen',
              style: TextStyle(color: AppStyles.primaryOrange),
            ),
          ),
        ],
      ),
    );
  }
}
