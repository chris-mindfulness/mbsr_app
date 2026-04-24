import 'package:flutter/material.dart';
import '../core/app_styles.dart';

/// Wiederverwendbarer Branding-Block: Spa-Icon, Titel, Name, Claim.
/// Wird auf dem Splash-Screen und der Willkommen-Seite identisch genutzt,
/// damit der Übergang visuell nahtlos ist.
class BrandingHeader extends StatelessWidget {
  const BrandingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/branding/logo_primary.png',
          width: 320,
          fit: BoxFit.contain,
        ),
        SizedBox(height: AppStyles.spacingL),
        Text(
          'Präsenz • Verbundenheit • Mitgefühl',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: AppStyles.textDark.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
