import 'package:flutter/material.dart';

/// Wiederverwendbarer Branding-Block mit reiner Logo-Darstellung.
/// Wird auf dem Splash-Screen und der Willkommen-Seite identisch genutzt.
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
      ],
    );
  }
}
