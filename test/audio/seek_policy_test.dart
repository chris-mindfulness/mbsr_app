import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/audio/seek_policy.dart';

void main() {
  group('SeekPolicy', () {
    test('spult relativ vor, wenn Ziel innerhalb der Dauer liegt', () {
      final target = resolveSeekTarget(
        current: const Duration(seconds: 30),
        offset: const Duration(seconds: 10),
        knownDuration: const Duration(minutes: 2),
      );

      expect(target, const Duration(seconds: 40));
    });

    test('begrenzt auf 0 bei Rueckspulen unter 0', () {
      final target = resolveSeekTarget(
        current: const Duration(seconds: 5),
        offset: const Duration(seconds: -10),
        knownDuration: const Duration(minutes: 2),
      );

      expect(target, Duration.zero);
    });

    test('begrenzt auf bekannte Gesamtdauer bei Vorspulen ueber Ende', () {
      final duration = const Duration(seconds: 95);
      final target = resolveSeekTarget(
        current: const Duration(seconds: 90),
        offset: const Duration(seconds: 10),
        knownDuration: duration,
      );

      expect(target, duration);
    });

    test('ohne bekannte Dauer wird nur die Untergrenze geprueft', () {
      final target = resolveSeekTarget(
        current: const Duration(seconds: 50),
        offset: const Duration(seconds: 30),
      );

      expect(target, const Duration(seconds: 80));
    });
  });
}
