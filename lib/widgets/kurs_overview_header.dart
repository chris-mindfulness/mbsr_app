import 'package:flutter/material.dart';
import '../core/app_styles.dart';

class KursOverviewHeader extends StatelessWidget {
  const KursOverviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppStyles.spacingL,
        AppStyles.spacingM,
        AppStyles.spacingL,
        AppStyles.spacingXL,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppStyles.primaryOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.self_improvement,
              color: AppStyles.primaryOrange,
              size: AppStyles.iconSizeXL,
            ),
          ),
          SizedBox(height: AppStyles.spacingL + AppStyles.spacingS),
          Text(
            "Dein MBSR-Kurs",
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
          ),
          AppStyles.spacingSBox,
          Text(
            "8-Wochen-Achtsamkeitsprogramm",
            style: AppStyles.bodyStyle.copyWith(color: AppStyles.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
