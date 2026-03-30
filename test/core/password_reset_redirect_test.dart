import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/core/app_config.dart';
import 'package:mbsr_app/web_utils.dart';

void main() {
  test(
    'passwordResetRedirectUrlForApp entspricht AppConfig wenn nicht Web (Tests)',
    () {
      expect(passwordResetRedirectUrlForApp(), AppConfig.passwordResetRedirectUrl);
    },
  );

  test('routePathOnly entfernt Query-String', () {
    expect(routePathOnly('/reset-password?userId=a&secret=b'), '/reset-password');
    expect(routePathOnly('/login'), '/login');
    expect(routePathOnly(null), null);
  });
}
