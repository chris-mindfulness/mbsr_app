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
      'Diese App wird über Appwrite und Cloudflare bereitgestellt. '
      'Zur Bereitstellung und Absicherung (CDN, DDoS-Schutz) nutzen wir Cloudflare. '
      'Dabei werden technisch notwendige Verbindungsdaten verarbeitet.\n\n'
      'Für die Funktion werden lokal im Browser technisch notwendige Daten gespeichert '
      '(z. B. Sitzungs- und Rolleninformationen für stabilen Login).';

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
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: AppStyles.textDark,
            fontWeight: FontWeight.bold,
          ),
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
