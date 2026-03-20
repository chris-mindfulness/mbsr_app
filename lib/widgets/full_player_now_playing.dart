import 'package:flutter/material.dart';
import '../core/app_styles.dart';

class FullPlayerNowPlaying extends StatelessWidget {
  final String title;

  const FullPlayerNowPlaying({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppStyles.primaryOrange.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.self_improvement,
                size: 120,
                color: AppStyles.primaryOrange,
              ),
            ),
          ),
        ),
        AppStyles.spacingXXLBox,
        Text(
          title,
          style: AppStyles.titleStyle.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        AppStyles.spacingSBox,
        Text(
          "Achtsamkeitspraxis",
          style: AppStyles.bodyStyle.copyWith(
            color: AppStyles.textMuted,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
