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
        Icon(
          Icons.spa_outlined,
          size: 80,
          color: AppStyles.primaryOrange,
        ),
        SizedBox(height: AppStyles.spacingL - AppStyles.spacingS),
        Text(
          'Achtsamkeitstraining',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: AppStyles.textDark,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          'Dr. Christian Hahn',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppStyles.successGreen,
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS),
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
