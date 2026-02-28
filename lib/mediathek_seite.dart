import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_daten.dart';
import 'audio_service.dart';
import 'constants/app_texts.dart';
import 'core/app_styles.dart';
import 'widgets/audio_item_card.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/exercise_tips_sheet.dart';
import 'widgets/offline_banner.dart';
import 'widgets/sos_item_card.dart';
import 'widgets/subtle_divider.dart';
import 'widgets/surface_icon_button.dart';

class MediathekSeite extends StatefulWidget {
  const MediathekSeite({super.key});

  @override
  State<MediathekSeite> createState() => _MediathekSeiteState();
}

class _MediathekSeiteState extends State<MediathekSeite> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _play(Map<String, String> audio) async {
    // Haptisches Feedback beim Start
    HapticFeedback.lightImpact();

    try {
      await _audioService.play(audio);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Fehler beim Laden des Audios. Bitte Internetverbindung prüfen.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSOSDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppStyles.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (sheetContext) => SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppStyles.softBrown.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        tooltip: 'Schließen',
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppStyles.softBrown,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.support_agent,
                    color: AppStyles.errorRed,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Notfall-Koffer",
                    style: AppStyles.headingStyle.copyWith(
                      color: AppStyles.errorRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Erste Hilfe bei akutem Stress",
                style: AppStyles.subTitleStyle,
              ),
              const SizedBox(height: 16),
              _buildSOSItem(
                icon: Icons.timer,
                title: "Kurzes Ankommen (ca. 3 Min)",
                description:
                    "Eine kurze Pause zum Sammeln. Startet die Übung „Ankommen“.",
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  // Startet bewusst die Übung "Ankommen" als kurze Akut-Hilfe.
                  final audio = AppDaten.getAlleAudios().firstWhere(
                    (a) => a['title'] == 'Ankommen',
                    orElse: () => {},
                  );
                  if (audio.isNotEmpty) _play(audio);
                },
              ),
              const SizedBox(height: 16),
              _buildSOSItem(
                icon: Icons.accessibility_new,
                title: "Körper spüren",
                description:
                    "Spüre deine Füße auf dem Boden. Nimm 3 tiefe Atemzüge.",
                onTap: null, // Nur Info
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSOSItem({
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return SosItemCard(
      icon: icon,
      title: title,
      description: description,
      onTap: onTap,
      accentColor: AppStyles.errorRed,
    );
  }

  Widget _buildSurfaceIconButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return SurfaceIconButton(
      icon: icon,
      color: color,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  void _showAudioInfo(Map<String, String> audio) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppStyles.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (sheetContext) => SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppStyles.softBrown.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        tooltip: 'Schließen',
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppStyles.softBrown,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(audio['title']!, style: AppStyles.headingStyle),
              const SizedBox(height: 16),
              Text(
                audio['description'] ?? "Keine Beschreibung verfügbar.",
                style: AppStyles.bodyStyle.copyWith(height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExerciseTipsForAudio(Map<String, String> audio) {
    final title = audio['title'];
    if (title == null || title.isEmpty) return;
    ExerciseTipsSheet.show(
      context,
      audioTitle: title,
      sourceLabel: 'Mediathek',
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> audios = AppDaten.getAlleAudios();

    if (_searchQuery.isNotEmpty) {
      audios = audios
          .where(
            (a) =>
                a['title']!.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecorativeBlobs(
        child: Column(
          children: [
            // Header mit Info-Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppStyles.spacingL,
                AppStyles.spacingM,
                AppStyles.spacingM,
                AppStyles.spacingS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mediathek', style: AppStyles.headingStyle),
                  Row(
                    children: [
                      // SOS-Button
                      _buildSurfaceIconButton(
                        icon: Icons.support_agent,
                        color: AppStyles.errorRed,
                        tooltip: 'Notfall-Koffer',
                        onPressed: () => _showSOSDialog(context),
                      ),
                      const SizedBox(width: 8),
                      _buildSurfaceIconButton(
                        icon: Icons.info_outline,
                        color: AppStyles.softBrown,
                        tooltip: 'Über das Tracking',
                        onPressed: () => _showTrackingInfo(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SubtleDivider(height: 1, verticalMargin: 0),
            const SubtleDivider(height: 1, verticalMargin: 0),
            // Offline-Banner
            const ConnectivityOfflineBanner(
              message: 'Offline - Audios können nicht geladen werden',
              horizontalMargin: AppStyles.spacingL,
              verticalMargin: AppStyles.spacingS,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppStyles.spacingL,
                vertical: AppStyles.spacingM,
              ),
              child: TextField(
                controller: _searchController,
                style: AppStyles.bodyStyle,
                decoration: InputDecoration(
                  hintText: "Suchen...",
                  hintStyle: AppStyles.bodyStyle.copyWith(
                    color: AppStyles.textMuted,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppStyles.softBrown),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: AppStyles.inputPadding,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppStyles.primaryOrange,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: audios.length,
                padding: EdgeInsets.fromLTRB(
                  AppStyles.spacingL,
                  AppStyles.spacingS,
                  AppStyles.spacingL,
                  24,
                ),
                itemBuilder: (context, i) {
                  final audio = audios[i];
                  final String audioId = audio['appwrite_id'] ?? '';

                  return StreamBuilder<AudioServiceStatus>(
                    stream: _audioService.statusStream,
                    builder: (context, snapshot) {
                      final bool isCurrent =
                          _audioService.currentAppwriteId == audioId;
                      final bool isPlaying =
                          isCurrent &&
                          _audioService.status == AudioServiceStatus.playing;
                      final bool isLoading =
                          isCurrent &&
                          _audioService.status == AudioServiceStatus.loading;

                      return AudioItemCard(
                        audio: audio,
                        isCurrent: isCurrent,
                        isPlaying: isPlaying,
                        isLoading: isLoading,
                        onPlay: () => _play(audio),
                        onTips: () => _showExerciseTipsForAudio(audio),
                        onInfo:
                            (audio['description'] != null &&
                                audio['description']!.isNotEmpty)
                            ? () => _showAudioInfo(audio)
                            : null,
                        idleTitleColor: AppStyles.textDark,
                        showPlayingIndicator: true,
                        durationPrefix: '• ',
                        margin: const EdgeInsets.only(bottom: 16),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Zeigt Tracking-Info-Dialog
  void _showTrackingInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(
                AppTexts.trackingInfoTitle,
                style: AppStyles.headingStyle.copyWith(fontSize: 20),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, color: AppStyles.softBrown),
              tooltip: 'Schließen',
              onPressed: () => Navigator.of(dialogContext).pop(),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        content: Text(AppTexts.trackingInfoText, style: AppStyles.bodyStyle),
        backgroundColor: AppStyles.bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Verstanden",
              style: AppStyles.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: AppStyles.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
