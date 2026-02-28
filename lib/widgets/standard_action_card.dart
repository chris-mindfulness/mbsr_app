import 'package:flutter/material.dart';

import '../core/app_styles.dart';

class StandardActionCard extends StatelessWidget {
  const StandardActionCard({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.accentColor,
    this.subtitle,
    this.meta,
    this.onTap,
    this.trailingIcon = Icons.chevron_right,
    this.showTrailing = true,
    this.showShadow = false,
    this.alignTop = false,
    this.margin,
    this.contentPadding,
    this.titleStyle,
    this.subtitleStyle,
    this.metaStyle,
    this.iconContainerSize = 48,
    this.iconSize = 24,
  });

  final String title;
  final String? subtitle;
  final String? meta;
  final IconData leadingIcon;
  final Color accentColor;
  final VoidCallback? onTap;
  final IconData trailingIcon;
  final bool showTrailing;
  final bool showShadow;
  final bool alignTop;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? metaStyle;
  final double iconContainerSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin ?? EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        child: Padding(
          padding: contentPadding ?? AppStyles.cardPadding,
          child: Row(
            crossAxisAlignment: alignTop
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(leadingIcon, color: accentColor, size: iconSize),
              ),
              SizedBox(width: AppStyles.spacingL - AppStyles.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle ?? AppStyles.subTitleStyle),
                    if (meta != null && meta!.isNotEmpty) ...[
                      AppStyles.spacingXSBox,
                      Text(
                        meta!,
                        style:
                            metaStyle ??
                            AppStyles.bodyStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                      ),
                    ],
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      if (meta != null && meta!.isNotEmpty)
                        AppStyles.spacingSBox
                      else
                        AppStyles.spacingXSBox,
                      Text(
                        subtitle!,
                        style:
                            subtitleStyle ??
                            AppStyles.bodyStyle.copyWith(
                              fontSize: 13,
                              color: AppStyles.textMuted,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showTrailing)
                Icon(trailingIcon, color: AppStyles.borderColor, size: 20),
            ],
          ),
        ),
      ),
    );

    if (!showShadow) {
      return card;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: card,
    );
  }
}
