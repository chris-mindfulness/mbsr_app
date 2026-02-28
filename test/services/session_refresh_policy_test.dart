import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/auth/session_refresh_policy.dart';

void main() {
  group('SessionRefreshPolicy', () {
    test('401 mit Cache bleibt im eingeloggten Zustand', () {
      final decision = resolveSessionRefreshDecision(
        errorCode: 401,
        hasCachedUser: true,
      );

      expect(decision, SessionRefreshDecision.useCachedUser);
    });

    test('401 ohne Cache setzt auf ausgeloggt', () {
      final decision = resolveSessionRefreshDecision(
        errorCode: 401,
        hasCachedUser: false,
      );

      expect(decision, SessionRefreshDecision.setLoggedOut);
    });

    test('nicht-401 Fehler behalten den aktuellen Zustand', () {
      final decision = resolveSessionRefreshDecision(
        errorCode: 500,
        hasCachedUser: true,
      );

      expect(decision, SessionRefreshDecision.keepCurrentState);
    });
  });
}
