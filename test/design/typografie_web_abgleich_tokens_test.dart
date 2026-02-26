import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/core/app_styles.dart';
import 'package:mbsr_app/core/theme_tokens.dart';

void main() {
  group('Typografie Web-Abgleich', () {
    test('Basiswerte fuer calmDefault entsprechen Website-Referenz', () {
      expect(calmDefaultTokens.textDark, const Color(0xFF1E1F1D));
      expect(calmDefaultTokens.textMuted, const Color(0xFF5F6662));
      expect(calmDefaultTokens.bodyFontSize, 17);
      expect(calmDefaultTokens.bodyFontWeight, FontWeight.w400);
      expect(calmDefaultTokens.bodyLetterSpacing, 0.0);
      expect(calmDefaultTokens.smallFontWeight, FontWeight.w400);
    });

    test('Basiswerte fuer calmVivid bleiben typografisch identisch', () {
      expect(calmVividTokens.textDark, const Color(0xFF1E1F1D));
      expect(calmVividTokens.textMuted, const Color(0xFF5F6662));
      expect(calmVividTokens.bodyFontSize, 17);
      expect(calmVividTokens.bodyFontWeight, FontWeight.w400);
      expect(calmVividTokens.bodyLetterSpacing, 0.0);
      expect(calmVividTokens.smallFontWeight, FontWeight.w400);
    });

    test('AppStyles spiegelt die zentralen Lesewerte', () {
      expect(AppStyles.bodyStyle.fontSize, 17);
      expect(AppStyles.bodyStyle.fontWeight, FontWeight.w400);
      expect(AppStyles.bodyStyle.height, 1.6);
      expect(AppStyles.bodyStyle.letterSpacing, 0.0);
      expect(AppStyles.bodyStyle.color, const Color(0xFF1E1F1D));
      expect(AppStyles.textMuted, const Color(0xFF5F6662));
    });
  });
}
