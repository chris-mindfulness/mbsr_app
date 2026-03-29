import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/core/app_config.dart';

void main() {
  test(
    'passwordResetRedirectUrl ist gesetzt und zeigt auf Produktionspfad wenn kein define',
    () {
      expect(AppConfig.passwordResetRedirectUrl, isNotEmpty);
      expect(
        AppConfig.passwordResetRedirectUrl,
        'https://app.mindfulpractice.de/reset-password',
      );
    },
  );
}
