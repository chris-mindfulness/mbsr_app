import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/services/auth_service.dart';

void main() {
  group('AuthException mapping', () {
    test('maps 401 to user-friendly credentials message', () {
      final ex = AuthException.fromAppwriteException(
        AppwriteException('unauthorized', 401),
      );

      expect(
        ex.message,
        'E-Mail oder Passwort falsch. Bitte prüfe deine Eingabe.',
      );
    });

    test('maps 429 to throttling message', () {
      final ex = AuthException.fromAppwriteException(
        AppwriteException('too many requests', 429),
      );

      expect(ex.message, 'Zu viele Fehlversuche. Bitte warte einen Moment.');
    });

    test('maps 500 to generic server message', () {
      final ex = AuthException.fromAppwriteException(
        AppwriteException('server error', 500),
      );

      expect(ex.message, 'Server-Fehler. Bitte versuche es später erneut.');
    });

    test('maps 503 to service unavailable message', () {
      final ex = AuthException.fromAppwriteException(
        AppwriteException('service unavailable', 503),
      );

      expect(ex.message, 'Service vorübergehend nicht verfügbar.');
    });

    test('unknown code keeps a diagnostic message in debug builds', () {
      final ex = AuthException.fromAppwriteException(
        AppwriteException('custom failure', 418),
      );

      expect(ex.message, contains('Fehler: custom failure'));
      expect(ex.message, contains('Code: 418'));
    });
  });
}
