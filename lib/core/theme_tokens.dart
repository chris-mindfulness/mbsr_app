import 'package:flutter/material.dart';

enum AppVisualMode { calmDefault, calmVivid }

class AppThemeTokens {
  final Color bgColor;
  final Color primaryOrange;
  final Color accentOrange;
  final Color accentPink;
  final Color accentCoral;
  final Color successGreen;
  final Color accentCyan;
  final Color textDark;
  final Color textMuted;
  final Color borderColor;
  final Color infoBlue;
  final Color warningYellow;
  final Color errorRed;

  final double titleFontSize;
  final double headingFontSize;
  final double subTitleFontSize;
  final FontWeight subTitleFontWeight;
  final double bodyFontSize;
  final FontWeight bodyFontWeight;
  final double bodyLetterSpacing;
  final double smallFontSize;
  final FontWeight smallFontWeight;

  final double glassSigma;
  final double glassBackgroundAlpha;
  final double glassBorderAlpha;

  final double decorativeBlobAlphaScale;
  final double ambientBlobAlphaScale;

  const AppThemeTokens({
    required this.bgColor,
    required this.primaryOrange,
    required this.accentOrange,
    required this.accentPink,
    required this.accentCoral,
    required this.successGreen,
    required this.accentCyan,
    required this.textDark,
    required this.textMuted,
    required this.borderColor,
    required this.infoBlue,
    required this.warningYellow,
    required this.errorRed,
    required this.titleFontSize,
    required this.headingFontSize,
    required this.subTitleFontSize,
    required this.subTitleFontWeight,
    required this.bodyFontSize,
    required this.bodyFontWeight,
    required this.bodyLetterSpacing,
    required this.smallFontSize,
    required this.smallFontWeight,
    required this.glassSigma,
    required this.glassBackgroundAlpha,
    required this.glassBorderAlpha,
    required this.decorativeBlobAlphaScale,
    required this.ambientBlobAlphaScale,
  });
}

const AppThemeTokens calmDefaultTokens = AppThemeTokens(
  bgColor: Color(0xFFFFFFFF),
  primaryOrange: Color(0xFFE06E5A),
  accentOrange: Color(0xFFCB8D6E),
  accentPink: Color(0xFFC67A8D),
  accentCoral: Color(0xFFD5A1A9),
  successGreen: Color(0xFF5D988F),
  accentCyan: Color(0xFF6F9FA1),
  textDark: Color(0xFF1E1F1D),
  textMuted: Color(0xFF5F6662),
  borderColor: Color(0xFFD9DEE2),
  infoBlue: Color(0xFF6D8FB3),
  warningYellow: Color(0xFFC6A34E),
  errorRed: Color(0xFFC67A72),
  titleFontSize: 27,
  headingFontSize: 21,
  subTitleFontSize: 18,
  subTitleFontWeight: FontWeight.w600,
  bodyFontSize: 17,
  bodyFontWeight: FontWeight.w400,
  bodyLetterSpacing: 0.0,
  smallFontSize: 15,
  smallFontWeight: FontWeight.w400,
  glassSigma: 9,
  glassBackgroundAlpha: 0.82,
  glassBorderAlpha: 0.34,
  decorativeBlobAlphaScale: 0.5,
  ambientBlobAlphaScale: 0.45,
);

const AppThemeTokens calmVividTokens = AppThemeTokens(
  bgColor: Color(0xFFFFFFFF),
  primaryOrange: Color(0xFFFF6B6B),
  accentOrange: Color(0xFFFF8C69),
  accentPink: Color(0xFFFF6B9D),
  accentCoral: Color(0xFFFF8FA3),
  successGreen: Color(0xFF4ECDC4),
  accentCyan: Color(0xFF5BC0BE),
  textDark: Color(0xFF1E1F1D),
  textMuted: Color(0xFF5F6662),
  borderColor: Color(0xFFE0E0E0),
  infoBlue: Color(0xFF6B9BD2),
  warningYellow: Color(0xFFFFC107),
  errorRed: Color(0xFFE57373),
  titleFontSize: 28,
  headingFontSize: 22,
  subTitleFontSize: 18,
  subTitleFontWeight: FontWeight.w600,
  bodyFontSize: 17,
  bodyFontWeight: FontWeight.w400,
  bodyLetterSpacing: 0.0,
  smallFontSize: 15,
  smallFontWeight: FontWeight.w400,
  glassSigma: 15,
  glassBackgroundAlpha: 0.6,
  glassBorderAlpha: 0.2,
  decorativeBlobAlphaScale: 0.9,
  ambientBlobAlphaScale: 0.9,
);
