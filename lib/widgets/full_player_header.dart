import 'package:flutter/material.dart';
import '../core/app_styles.dart';

class FullPlayerHeader extends StatelessWidget {
  final ButtonStyle iconButtonStyle;
  final VoidCallback onStop;
  final VoidCallback onClose;

  const FullPlayerHeader({
    super.key,
    required this.iconButtonStyle,
    required this.onStop,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppStyles.softBrown.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.stop_rounded,
                color: AppStyles.textDark,
                size: AppStyles.iconSizeL,
              ),
              style: iconButtonStyle,
              onPressed: onStop,
              tooltip: 'Audio stoppen',
            ),
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: AppStyles.textDark,
                size: AppStyles.iconSizeL,
              ),
              style: iconButtonStyle,
              onPressed: onClose,
              tooltip: 'Player schließen',
            ),
          ],
        ),
      ],
    );
  }
}
