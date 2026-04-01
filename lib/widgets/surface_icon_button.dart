import 'package:flutter/material.dart';

import '../core/app_styles.dart';

class SurfaceIconButton extends StatelessWidget {
  const SurfaceIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Hellgrauer Ton + Rand + Schatten: auf weißem Seitengrund wirkt die Fläche
    // als erkennbare Schaltfläche (reines Weiß ging mit dem Hintergrund unter).
    final fill = Color.lerp(AppStyles.bgColor, AppStyles.borderColor, 0.48)!;
    final outline = AppStyles.borderColor.withValues(alpha: 0.88);

    return Material(
      color: fill,
      elevation: 1.2,
      shadowColor: AppStyles.textDark.withValues(alpha: 0.16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: outline, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Icon(icon, size: 22, color: color),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          foregroundColor: color,
          backgroundColor: Colors.transparent,
          minimumSize: const Size(40, 40),
          fixedSize: const Size(40, 40),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
