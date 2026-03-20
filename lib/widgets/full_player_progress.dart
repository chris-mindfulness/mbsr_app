import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../audio_service.dart';
import '../core/app_styles.dart';

class FullPlayerProgress extends StatelessWidget {
  final AudioService audioService;

  const FullPlayerProgress({super.key, required this.audioService});

  String _formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60);
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: audioService.durationStream,
      builder: (context, durationSnapshot) {
        final duration = durationSnapshot.data ?? Duration.zero;
        final hasKnownDuration = duration.inSeconds > 0;
        return StreamBuilder<Duration>(
          stream: audioService.positionStream,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            final clampedPosition = hasKnownDuration
                ? Duration(
                    seconds: position.inSeconds.clamp(0, duration.inSeconds),
                  )
                : position;

            return Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20,
                    ),
                    activeTrackColor: AppStyles.primaryOrange,
                    inactiveTrackColor: AppStyles.primaryOrange.withValues(
                      alpha: 0.1,
                    ),
                    thumbColor: AppStyles.primaryOrange,
                  ),
                  child: Slider(
                    value: hasKnownDuration
                        ? clampedPosition.inSeconds.toDouble()
                        : 0,
                    max: hasKnownDuration ? duration.inSeconds.toDouble() : 1.0,
                    onChanged: hasKnownDuration
                        ? (value) {
                            HapticFeedback.selectionClick();
                            audioService.seek(Duration(seconds: value.toInt()));
                          }
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(clampedPosition),
                        style: AppStyles.bodyStyle.copyWith(
                          fontSize: 12,
                          color: AppStyles.textDark,
                        ),
                      ),
                      Text(
                        hasKnownDuration ? _formatDuration(duration) : '--:--',
                        style: AppStyles.bodyStyle.copyWith(
                          fontSize: 12,
                          color: AppStyles.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
