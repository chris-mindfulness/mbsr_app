import 'package:flutter/material.dart';

import '../core/app_styles.dart';

class SectionHeaderLabel extends StatelessWidget {
  const SectionHeaderLabel({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.only(left: AppStyles.spacingS),
  });

  final String title;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: AppStyles.bodyStyle.copyWith(
          letterSpacing: 1.2,
          fontWeight: AppStyles.fontWeightSemiBold,
          fontSize: 12,
          color: AppStyles.textMuted,
        ),
      ),
    );
  }
}
