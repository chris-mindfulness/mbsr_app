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
}
