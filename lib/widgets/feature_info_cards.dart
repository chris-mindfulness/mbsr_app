import 'package:flutter/material.dart';

import '../core/app_styles.dart';

class FeatureInfoCards extends StatelessWidget {
  const FeatureInfoCards({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 760;
        final gap = AppStyles.featureChipGap;
        final cardWidth = useTwoColumns
            ? (constraints.maxWidth - gap) / 2
            : constraints.maxWidth;

        final items = <_FeatureInfoItem>[
          _FeatureInfoItem(
            icon: Icons.menu_book_outlined,
            label: 'MBSR 8-Wochen-Kurs',
            color: AppStyles.infoBlue,
          ),
          _FeatureInfoItem(
            icon: Icons.help_outline,
            label: 'Wissen & Hilfe',
            color: AppStyles.accentCyan,
          ),
          _FeatureInfoItem(
            icon: Icons.library_books_outlined,
            label: 'Textarchiv',
            color: AppStyles.primaryOrange,
          ),
          _FeatureInfoItem(
            icon: Icons.science_outlined,
            label: 'Literatur & Forschung',
            color: AppStyles.successGreen,
          ),
        ];

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map(
                (item) => SizedBox(width: cardWidth, child: _FeatureCard(item)),
              )
              .toList(),
        );
      },
    );
  }
}

class _FeatureInfoItem {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureInfoItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureInfoItem item;

  const _FeatureCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppStyles.featureChipPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyles.featureChipRadius),
        border: Border.all(
          color: AppStyles.borderColor.withValues(alpha: 0.75),
          width: 1,
        ),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: item.color.withValues(alpha: 0.32)),
            ),
            child: Icon(item.icon, size: 18, color: item.color),
          ),
          AppStyles.spacingMHorizontal,
          Expanded(
            child: Text(
              item.label,
              style: AppStyles.bodyStyle.copyWith(
                fontWeight: AppStyles.fontWeightSemiBold,
                color: AppStyles.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
