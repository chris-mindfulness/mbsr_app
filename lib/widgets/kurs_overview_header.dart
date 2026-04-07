import 'package:flutter/material.dart';
import '../app_daten.dart';
import '../core/app_styles.dart';
import 'avatar_audio_clip.dart';

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
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 140,
                maxHeight: 140,
              ),
              child: Image.asset(
                AppDaten.welcomeHelloAvatarAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
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
                  );
                },
              ),
            ),
          ),
          AppStyles.spacingMBox,
          Center(
            child: AvatarAudioClip(
              appwriteId: AppDaten.begruessung['appwrite_id'],
              label: 'Begruessung',
              durationHint: AppDaten.begruessung['duration'],
            ),
          ),
          AppStyles.spacingMBox,
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
