import 'dart:ui';

import 'package:flutter/material.dart';

import 'theme_mode_controller.dart';
import 'theme_tokens.dart';

class AppStyles {
  static AppThemeTokens get _tokens => ThemeModeController.instance.tokens;

  // Global Colors (dynamisch über Theme-Modus)
  static Color get bgColor => _tokens.bgColor;
  static Color get primaryOrange => _tokens.primaryOrange;
  static Color get accentOrange => _tokens.accentOrange;
  static Color get accentPink => _tokens.accentPink;
  static Color get accentCoral => _tokens.accentCoral;
  static Color get successGreen => _tokens.successGreen;
  static Color get accentCyan => _tokens.accentCyan;
  static Color get textDark => _tokens.textDark;
  static Color get softBrown => textDark;
  static Color get sageGreen => successGreen;
  static Color get borderColor => _tokens.borderColor;

  // Semantische Farben
  static Color get infoBlue => _tokens.infoBlue;
  static Color get warningYellow => _tokens.warningYellow;
  static Color get errorRed => _tokens.errorRed;

  // Background intensity tokens
  static double get decorativeBlobAlphaScale =>
      _tokens.decorativeBlobAlphaScale;
  static double get ambientBlobAlphaScale => _tokens.ambientBlobAlphaScale;

  // Border Radius
  static const double borderRadius = 28.0;
  static RoundedRectangleBorder get cardShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    side: BorderSide(color: borderColor.withValues(alpha: 0.45), width: 1.4),
  );

  // Typography weights
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightLight = FontWeight.w300;

  static TextStyle get titleStyle => TextStyle(
    fontSize: _tokens.titleFontSize,
    fontWeight: fontWeightBold,
    color: textDark,
    height: 1.2,
    letterSpacing: -0.4,
  );

  static TextStyle get headingStyle => TextStyle(
    fontSize: _tokens.headingFontSize,
    fontWeight: fontWeightBold,
    color: textDark,
    height: 1.24,
    letterSpacing: -0.25,
  );

  static TextStyle get subTitleStyle => TextStyle(
    fontSize: _tokens.subTitleFontSize,
    fontWeight: _tokens.subTitleFontWeight,
    color: textDark,
    height: 1.42,
    letterSpacing: 0.0,
  );

  static TextStyle get bodyStyle => TextStyle(
    fontSize: _tokens.bodyFontSize,
    fontWeight: _tokens.bodyFontWeight,
    color: textDark,
    height: 1.62,
    letterSpacing: _tokens.bodyLetterSpacing,
  );

  static TextStyle get smallTextStyle => TextStyle(
    fontSize: _tokens.smallFontSize,
    fontWeight: _tokens.smallFontWeight,
    color: textDark,
    height: 1.4,
    letterSpacing: 0.16,
  );

  static TextStyle get decorativeTextStyle => TextStyle(
    fontSize: _tokens.bodyFontSize,
    fontWeight: _tokens.smallFontWeight,
    color: textDark,
    height: 1.5,
    letterSpacing: 0.2,
    fontStyle: FontStyle.italic,
  );

  // Glass effects
  static ImageFilter get glassBlur =>
      ImageFilter.blur(sigmaX: _tokens.glassSigma, sigmaY: _tokens.glassSigma);
  static Color get glassBackground =>
      Colors.white.withValues(alpha: _tokens.glassBackgroundAlpha);
  static Color get glassBorder =>
      Colors.white.withValues(alpha: _tokens.glassBorderAlpha);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  static EdgeInsets get cardPadding => const EdgeInsets.all(spacingL);
  static EdgeInsets get cardPaddingLarge => const EdgeInsets.all(spacingXL);
  static EdgeInsets get cardPaddingSmall => const EdgeInsets.all(spacingM);

  static EdgeInsets get buttonPadding =>
      const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM);
  static EdgeInsets get buttonPaddingSmall =>
      const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS);

  static EdgeInsets get inputPadding =>
      const EdgeInsets.symmetric(horizontal: 20.0, vertical: spacingM);

  static EdgeInsets get sectionPadding => const EdgeInsets.all(spacingL);
  static EdgeInsets get sectionPaddingLarge => const EdgeInsets.all(spacingXL);

  static EdgeInsets get listPadding => const EdgeInsets.all(spacingL);
  static EdgeInsets get listPaddingHorizontal =>
      const EdgeInsets.symmetric(horizontal: spacingL);

  static EdgeInsets get screenPadding => const EdgeInsets.all(spacingL);
  static EdgeInsets get screenPaddingHorizontal =>
      const EdgeInsets.symmetric(horizontal: spacingL);

  static Widget get spacingXSBox => const SizedBox(height: spacingXS);
  static Widget get spacingSBox => const SizedBox(height: spacingS);
  static Widget get spacingMBox => const SizedBox(height: spacingM);
  static Widget get spacingLBox => const SizedBox(height: spacingL);
  static Widget get spacingXLBox => const SizedBox(height: spacingXL);
  static Widget get spacingXXLBox => const SizedBox(height: spacingXXL);

  static Widget get spacingXSHorizontal => const SizedBox(width: spacingXS);
  static Widget get spacingSHorizontal => const SizedBox(width: spacingS);
  static Widget get spacingMHorizontal => const SizedBox(width: spacingM);
  static Widget get spacingLHorizontal => const SizedBox(width: spacingL);

  // Icon tokens
  static const double iconSizeXS = 16.0;
  static const double iconSizeS = 20.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  static Color get iconColorActive => primaryOrange;
  static Color get iconColorInactive => textDark.withValues(alpha: 0.45);
  static Color get iconColorSuccess => successGreen;
  static Color get iconColorOnWhite => textDark.withValues(alpha: 0.65);

  // Badge
  static BoxDecoration badgeDecoration({required Color color}) =>
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(12.0));

  static TextStyle get badgeTextStyle => TextStyle(
    color: Colors.white,
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const double badgeHeight = 20.0;
  static EdgeInsets get badgePadding =>
      const EdgeInsets.symmetric(horizontal: spacingS, vertical: spacingXS);

  static Widget buildSubtleDivider({double? height}) {
    return Container(
      height: height ?? 0.5,
      margin: const EdgeInsets.symmetric(vertical: spacingM),
      color: textDark.withValues(alpha: 0.1),
    );
  }

  static Widget buildSpacingDivider() {
    return const SizedBox(height: spacingL);
  }

  static BoxDecoration get tooltipDecoration {
    return BoxDecoration(
      color: textDark.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static TextStyle get tooltipTextStyle {
    return TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
    );
  }

  static EdgeInsets get tooltipPadding =>
      const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS);
}
