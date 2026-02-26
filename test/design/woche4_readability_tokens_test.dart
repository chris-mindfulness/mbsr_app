import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Woche 4 Readability Tokens', () {
    const white = Color(0xFFFFFFFF);
    const textStrong = Color(0xFF111827);
    const textDefault = Color(0xFF1F2937);
    const textMuted = Color(0xFF334155);

    const primaryReadable = Color(0xFFBE5444);
    const successReadable = Color(0xFF437D75);
    const infoReadable = Color(0xFF55779D);
    const pinkReadable = Color(0xFFA0556C);

    test('Pilot-Textfarben erfüllen mindestens 4.5:1', () {
      expect(_contrastRatio(textStrong, white), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(textDefault, white), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(textMuted, white), greaterThanOrEqualTo(4.5));
    });

    test('Pilot-UI-Akzentfarben erfüllen mindestens 3:1', () {
      expect(_contrastRatio(primaryReadable, white), greaterThanOrEqualTo(3.0));
      expect(_contrastRatio(successReadable, white), greaterThanOrEqualTo(3.0));
      expect(_contrastRatio(infoReadable, white), greaterThanOrEqualTo(3.0));
      expect(_contrastRatio(pinkReadable, white), greaterThanOrEqualTo(3.0));
    });

    test('Fließtext bleibt auf pilotierten Tönungsflächen >= 4.5:1', () {
      final primarySurface = _blendOverWhite(primaryReadable, 0.05);
      final successSurface = _blendOverWhite(successReadable, 0.07);

      expect(
        _contrastRatio(textDefault, primarySurface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrastRatio(textDefault, successSurface),
        greaterThanOrEqualTo(4.5),
      );
    });
  });
}

double _contrastRatio(Color foreground, Color background) {
  final fg = _relativeLuminance(foreground);
  final bg = _relativeLuminance(background);
  final lighter = fg > bg ? fg : bg;
  final darker = fg > bg ? bg : fg;
  return (lighter + 0.05) / (darker + 0.05);
}

double _relativeLuminance(Color color) {
  double channel(double c) {
    return c <= 0.03928
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

Color _blendOverWhite(Color topColor, double alpha) {
  int blend(double top, int bottom) =>
      (((top * 255) * alpha) + (bottom * (1 - alpha))).round().clamp(0, 255);

  return Color.fromARGB(
    255,
    blend(topColor.r, 255),
    blend(topColor.g, 255),
    blend(topColor.b, 255),
  );
}
