import 'package:flutter/material.dart';

import '../core/app_styles.dart';
import 'animated_play_button.dart';
import 'surface_icon_button.dart';

class AudioItemCard extends StatelessWidget {
  const AudioItemCard({
    super.key,
    required this.audio,
    required this.isCurrent,
    required this.isPlaying,
    required this.isLoading,
    this.isError = false,
    required this.onPlay,
    required this.onTips,
    this.onDownload,
    this.onInfo,
    this.idleTitleColor,
    this.showPlayingIndicator = false,
    this.durationPrefix = '',
    this.margin,
  });

  final Map<String, String> audio;
  final bool isCurrent;
  final bool isPlaying;
  final bool isLoading;
  final bool isError;
  final VoidCallback onPlay;
  final VoidCallback onTips;
  final VoidCallback? onDownload;
  final VoidCallback? onInfo;
  final Color? idleTitleColor;
  final bool showPlayingIndicator;
  final String durationPrefix;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final title = audio['title'] ?? 'Audio';
    final duration = audio['duration'] ?? '';

    return Card(
      margin: margin ?? EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape.copyWith(
        side: BorderSide(
          color: isCurrent
              ? AppStyles.primaryOrange.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.15),
          width: isCurrent ? 2 : 1.5,
        ),
      ),
      child: InkWell(
        onTap: onPlay,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: EdgeInsets.all(AppStyles.spacingL - AppStyles.spacingS),
          child: Row(
            children: [
              isError
                  ? Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppStyles.errorRed.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: AppStyles.errorRed,
                        size: 28,
                      ),
                    )
                  : isLoading
                  ? Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppStyles.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : AnimatedPlayButton(
                      isPlaying: isPlaying,
                      size: 56,
                      showShadow: false,
                      onPressed: onPlay,
                    ),
              SizedBox(width: AppStyles.spacingL - AppStyles.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.subTitleStyle.copyWith(
                        color: isCurrent
                            ? AppStyles.primaryOrange
                            : (idleTitleColor ?? AppStyles.textDark),
                      ),
                    ),
                    SizedBox(
                      height:
                          AppStyles.spacingM -
                          AppStyles.spacingS -
                          AppStyles.spacingXS,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppStyles.textMuted,
                        ),
                        AppStyles.spacingXSHorizontal,
                        Text(
                          '$durationPrefix$duration',
                          style: AppStyles.smallTextStyle.copyWith(
                            color: AppStyles.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SurfaceIconButton(
                icon: Icons.lightbulb_outline,
                color: AppStyles.infoBlue,
                tooltip: 'Tipps zur Übung',
                onPressed: onTips,
              ),
              if (onDownload != null)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: SurfaceIconButton(
                    icon: Icons.download_outlined,
                    color: AppStyles.softBrown,
                    tooltip:
                        'Übung als Datei speichern (z. B. bei schwachem Internet)',
                    onPressed: onDownload!,
                  ),
                ),
              if (onInfo != null)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: SurfaceIconButton(
                    icon: Icons.info_outline,
                    color: AppStyles.textDark,
                    tooltip: 'Info zur Übung',
                    onPressed: onInfo!,
                  ),
                ),
              if (showPlayingIndicator && isPlaying)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppStyles.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
