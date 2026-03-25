import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../audio_service.dart';
import '../core/app_styles.dart';
import 'animated_play_button.dart';

class MiniPlayerBar extends StatelessWidget {
  final AudioService audioService;
  final ButtonStyle stopButtonStyle;

  const MiniPlayerBar({
    super.key,
    required this.audioService,
    required this.stopButtonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: AppStyles.glassBlur,
        child: Container(
          decoration: BoxDecoration(
            color: AppStyles.glassBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppStyles.glassBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppStyles.primaryOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.self_improvement,
                      color: AppStyles.primaryOrange,
                      size: AppStyles.iconSizeM,
                    ),
                  ),
                  AppStyles.spacingMHorizontal,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audioService.currentTitle ?? '',
                          style: AppStyles.subTitleStyle.copyWith(
                            fontSize: 14,
                            fontWeight: AppStyles.fontWeightSemiBold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Tippen für Details",
                          style: AppStyles.smallTextStyle.copyWith(
                            fontSize: 11,
                            color: AppStyles.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<AudioServiceStatus>(
                    stream: audioService.statusStream,
                    builder: (context, snapshot) {
                      final status = audioService.status;
                      final isPlaying =
                          status == AudioServiceStatus.playing;
                      final isError =
                          status == AudioServiceStatus.error;
                      if (isError) {
                        return IconButton(
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: AppStyles.errorRed,
                            size: 28,
                          ),
                          tooltip: 'Erneut versuchen',
                          onPressed: () {
                            audioService.resumeCurrent();
                          },
                        );
                      }
                      return AnimatedPlayButton(
                        isPlaying: isPlaying,
                        size: 40,
                        showShadow: false,
                        onPressed: () {
                          if (isPlaying) {
                            audioService.pause();
                          } else {
                            audioService.resumeCurrent();
                          }
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.stop_rounded,
                      color: AppStyles.textDark,
                      size: 24,
                    ),
                    style: stopButtonStyle,
                    tooltip: 'Audio stoppen',
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      await audioService.stop();
                    },
                  ),
                ],
              ),
              AppStyles.spacingSBox,
              StreamBuilder<Duration>(
                stream: audioService.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = audioService.duration ?? Duration.zero;
                  final progress = duration.inSeconds > 0
                      ? position.inSeconds / duration.inSeconds
                      : 0.0;

                  return Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppStyles.primaryOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppStyles.primaryOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
