import 'package:flutter/material.dart';

import '../core/app_styles.dart';

enum PdfCardLayout { row, listTile }

class PdfLinkCard extends StatelessWidget {
  const PdfLinkCard({
    super.key,
    required this.title,
    required this.onTap,
    this.isPending = false,
    this.pendingText = 'Wird zeitnah bereitgestellt.',
    this.leadingIcon = Icons.description_outlined,
    this.leadingColor,
    this.readyTrailingIcon = Icons.open_in_new,
    this.pendingTrailingIcon = Icons.schedule,
    this.layout = PdfCardLayout.row,
    this.margin,
    this.showPendingSubtitle = true,
  });

  final String title;
  final VoidCallback? onTap;
  final bool isPending;
  final String pendingText;
  final IconData leadingIcon;
  final Color? leadingColor;
  final IconData readyTrailingIcon;
  final IconData pendingTrailingIcon;
  final PdfCardLayout layout;
  final EdgeInsetsGeometry? margin;
  final bool showPendingSubtitle;

  @override
  Widget build(BuildContext context) {
    final accent = leadingColor ?? AppStyles.softBrown;

    if (layout == PdfCardLayout.listTile) {
      return Card(
        margin: margin ?? EdgeInsets.only(bottom: AppStyles.spacingM),
        elevation: 0,
        color: Colors.white,
        shape: AppStyles.cardShape,
        child: ListTile(
          onTap: isPending ? null : onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(leadingIcon, color: accent),
          ),
          title: Text(title, style: AppStyles.subTitleStyle),
          subtitle: isPending
              ? Text(
                  pendingText,
                  style: AppStyles.bodyStyle.copyWith(fontSize: 12),
                )
              : null,
          trailing: Icon(
            isPending ? pendingTrailingIcon : readyTrailingIcon,
            color: AppStyles.borderColor,
          ),
        ),
      );
    }

    return Card(
      margin: margin ?? EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: isPending ? null : onTap,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        child: Padding(
          padding: AppStyles.cardPadding,
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(leadingIcon, color: accent, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppStyles.subTitleStyle),
                    if (isPending && showPendingSubtitle) ...[
                      const SizedBox(height: 4),
                      Text(
                        pendingText,
                        style: AppStyles.bodyStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                isPending ? pendingTrailingIcon : readyTrailingIcon,
                color: AppStyles.borderColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
