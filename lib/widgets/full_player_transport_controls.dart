import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../audio_service.dart';
import '../core/app_styles.dart';
import 'animated_play_button.dart';

class FullPlayerTransportControls extends StatelessWidget {
  final AudioService audioService;
  final VoidCallback onSeekBack;
  final VoidCallback onSeekForward;
  final ButtonStyle buttonStyle;

  const FullPlayerTransportControls({
    super.key,
    required this.audioService,
    required this.onSeekBack,
    required this.onSeekForward,
    required this.buttonStyle,
  });

  Widget _buildTransportButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 30),
      tooltip: tooltip,
      style:
          buttonStyle.copyWith(
            minimumSize: const WidgetStatePropertyAll(Size(58, 58)),
            fixedSize: const WidgetStatePropertyAll(Size(58, 58)),
            foregroundColor: WidgetStatePropertyAll(AppStyles.softBrown),
            backgroundColor: WidgetStatePropertyAll(
              Colors.white.withValues(alpha: 0.98),
            ),
          ),
      onPressed: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTransportButton(
          icon: Icons.replay_10_rounded,
          tooltip: '10 Sekunden zurück',
          onPressed: onSeekBack,
        ),
        AppStyles.spacingLHorizontal,
        StreamBuilder<AudioServiceStatus>(
          stream: audioService.statusStream,
          builder: (context, snapshot) {
            final isPlaying = audioService.status == AudioServiceStatus.playing;
            return AnimatedPlayButton(
              isPlaying: isPlaying,
              size: 56,
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
        AppStyles.spacingLHorizontal,
        _buildTransportButton(
          icon: Icons.forward_10_rounded,
          tooltip: '10 Sekunden vor',
          onPressed: onSeekForward,
        ),
      ],
    );
  }
}
