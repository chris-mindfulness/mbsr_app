import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/connectivity_service.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';
import 'app_daten.dart';
import 'audio_service.dart';
import 'widgets/animated_play_button.dart';
import 'widgets/subtle_divider.dart';
import 'package:flutter/services.dart';

class WochenDetailSeite extends StatefulWidget {
  final String wochenNummer;
  final String titel;
  final List<Map<String, String>> audios;
  final List<Map<String, String>> pdfs;
  final List<String> wochenAufgaben;
  final String? fokus;
  final String? zitat;
  final String? zitatAutor;
  final String? alltagsTipp;
  final List<String>? reflexionsFragen;
  final List<String>? audioRefs;

  const WochenDetailSeite({
    super.key,
    required this.wochenNummer,
    required this.titel,
    required this.audios,
    required this.pdfs,
    this.wochenAufgaben = const [],
    this.fokus,
    this.zitat,
    this.zitatAutor,
    this.alltagsTipp,
    this.reflexionsFragen,
    this.audioRefs,
  });

  @override
  State<WochenDetailSeite> createState() => _WochenDetailSeiteState();
}

class _WochenDetailSeiteState extends State<WochenDetailSeite> {
  final AudioService _audioService = AudioService();

  void _play(Map<String, String> audio) async {
    HapticFeedback.lightImpact();
    try {
      await _audioService.play(audio);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fehler beim Laden des Audios."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Navigation Logic
    final currentWeekIndex = int.tryParse(widget.wochenNummer.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    final hasPrev = currentWeekIndex > 1;
    final hasNext = currentWeekIndex < 8;

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          widget.wochenNummer,
          style: AppStyles.headingStyle.copyWith(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppStyles.softBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (hasPrev)
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppStyles.softBrown, size: 32),
              onPressed: () => _navigateToWeek(-1),
              tooltip: "Vorherige Woche",
            ),
          if (hasNext)
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppStyles.softBrown, size: 32),
              onPressed: () => _navigateToWeek(1),
              tooltip: "Nächste Woche",
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: DecorativeBlobs(
        child: Column(
          children: [
            // Offline-Banner
            StreamBuilder<bool>(
              stream: ConnectivityService.onlineStream,
              initialData: ConnectivityService.isOnline,
              builder: (context, snapshot) {
                final isOnline = snapshot.data ?? true;
                if (isOnline) return const SizedBox.shrink();

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 18,
                        color: Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Offline - Audios können nicht geladen werden',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppStyles.spacingL,
                  AppStyles.spacingS,
                  AppStyles.spacingL,
                  20, // Weniger Padding unten, da Nav-Bar kommt
                ),
                children: [
                  Text(widget.titel, style: AppStyles.titleStyle),
                  AppStyles.spacingXLBox,
                  if (widget.fokus != null) ...[
                    AppStyles.spacingMBox,
                    Text(
                      widget.fokus!,
                      style: AppStyles.headingStyle.copyWith(
                        color: AppStyles.primaryOrange,
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ],

                  AppStyles.spacingXLBox,

                  // ZITAT
                  if (widget.zitat != null) ...[
                    Container(
                      padding: AppStyles.cardPadding,
                      decoration: BoxDecoration(
                        color: AppStyles.softBrown.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppStyles.softBrown.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.format_quote, color: AppStyles.softBrown, size: 32),
                          AppStyles.spacingSBox,
                          Text(
                            widget.zitat!,
                            style: AppStyles.decorativeTextStyle.copyWith(
                              fontSize: 16,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (widget.zitatAutor != null) ...[
                            AppStyles.spacingMBox,
                            Text(
                              "- ${widget.zitatAutor}",
                              style: AppStyles.smallTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppStyles.softBrown.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  // PRAXIS (AUDIOS)
                  if (widget.audioRefs != null && widget.audioRefs!.isNotEmpty) ...[
                    _buildSectionHeader("DEINE PRAXIS DIESE WOCHE"),
                    AppStyles.spacingMBox,
                    if (widget.wochenNummer.contains("1")) ...[
                      Container(
                        padding: AppStyles.cardPadding,
                        margin: EdgeInsets.only(bottom: AppStyles.spacingM),
                        decoration: BoxDecoration(
                          color: AppStyles.infoBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppStyles.infoBlue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline, color: AppStyles.infoBlue, size: 24),
                            AppStyles.spacingMHorizontal,
                            Expanded(
                              child: Text(
                                "Hinweis: In der Mediathek findest du auch längere Versionen des Body-Scans (27 & 35 Min), falls du mehr Zeit hast.",
                                style: AppStyles.bodyStyle.copyWith(
                                  fontSize: 13,
                                  color: AppStyles.textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ..._getAudiosForWeek().map((audio) => _buildAudioCard(audio)),
                    AppStyles.spacingXLBox,
                  ],

                  // ALLTAGSTIPP
                  if (widget.alltagsTipp != null) ...[
                    _buildSectionHeader("FÜR DEN ALLTAG"),
                    AppStyles.spacingMBox,
                    Container(
                      padding: AppStyles.cardPadding,
                      decoration: BoxDecoration(
                        color: AppStyles.successGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppStyles.successGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline, color: AppStyles.successGreen, size: 28),
                          AppStyles.spacingMHorizontal,
                          Expanded(
                            child: Text(
                              widget.alltagsTipp!,
                              style: AppStyles.bodyStyle.copyWith(
                                color: AppStyles.textDark,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  // REFLEXION
                  if (widget.reflexionsFragen != null && widget.reflexionsFragen!.isNotEmpty) ...[
                    _buildSectionHeader("REFLEXION"),
                    AppStyles.spacingMBox,
                    ...widget.reflexionsFragen!.map((frage) => Padding(
                      padding: EdgeInsets.only(bottom: AppStyles.spacingM),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.edit_note, color: AppStyles.accentPink, size: 24),
                          AppStyles.spacingMHorizontal,
                          Expanded(
                            child: Text(
                              frage,
                              style: AppStyles.bodyStyle.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    )),
                    AppStyles.spacingXLBox,
                  ],

                  // Wochenaufgaben Sektion
                  if (widget.wochenAufgaben.isNotEmpty) ...[
                    Container(
                      padding: AppStyles.cardPadding,
                      decoration: BoxDecoration(
                        color: AppStyles.primaryOrange.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppStyles.primaryOrange.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.assignment_outlined,
                                color: AppStyles.primaryOrange,
                                size: 24,
                              ),
                              SizedBox(
                                width: AppStyles.spacingM - AppStyles.spacingS,
                              ), // 12px
                              Text(
                                "Deine Übungen",
                                style: AppStyles.headingStyle.copyWith(
                                  fontSize: 18,
                                  color: AppStyles.primaryOrange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppStyles.spacingL - AppStyles.spacingS,
                          ), // 20px
                          ...widget.wochenAufgaben.map(
                            (aufgabe) => Padding(
                              padding: EdgeInsets.only(
                                bottom: AppStyles.spacingM,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    child: const Icon(
                                      Icons.check_circle_outline,
                                      color: AppStyles.sageGreen,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        AppStyles.spacingM - AppStyles.spacingS,
                                  ), // 12px
                                  Expanded(
                                    child: Text(
                                      aufgabe,
                                      style: AppStyles.bodyStyle.copyWith(
                                        height: 1.6,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppStyles.spacingXL + AppStyles.spacingS,
                    ), // 40px
                  ],

                  if (widget.pdfs.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 16),
                      child: Text(
                        "UNTERLAGEN",
                        style: AppStyles.bodyStyle.copyWith(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppStyles.softBrown.withOpacity(0.5),
                        ),
                      ),
                    ),
                    ...widget.pdfs.map((pdf) => _buildPdfCard(pdf)),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
            // Navigation Bar
            // _buildWeekNavigation() entfernt, da jetzt in AppBar
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getAudiosForWeek() {
    if (widget.audioRefs == null) return [];
    final allAudios = AppDaten.getAlleAudios();
    return allAudios.where((audio) => widget.audioRefs!.contains(audio['title'])).toList();
  }

  void _navigateToWeek(int direction) {
    final currentWeekIndex = int.tryParse(widget.wochenNummer.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    final nextWeekIndex = currentWeekIndex + direction;
    
    if (nextWeekIndex < 1 || nextWeekIndex > 8) return;

    final nextWeekData = AppDaten.wochenDaten.firstWhere(
      (w) => w['n'] == nextWeekIndex.toString(),
      orElse: () => {},
    );

    if (nextWeekData.isEmpty) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WochenDetailSeite(
          wochenNummer: "Woche ${nextWeekData['n']}",
          titel: nextWeekData['t'],
          audios: const [],
          pdfs: List<Map<String, String>>.from(nextWeekData['pdfs']),
          wochenAufgaben: List<String>.from(nextWeekData['wochenAufgaben'] ?? []),
          fokus: nextWeekData['fokus'],
          zitat: nextWeekData['zitat'],
          zitatAutor: nextWeekData['zitatAutor'],
          alltagsTipp: nextWeekData['alltagsTipp'],
          reflexionsFragen: nextWeekData['reflexionsFragen'] != null ? List<String>.from(nextWeekData['reflexionsFragen']) : null,
          audioRefs: nextWeekData['audioRefs'] != null ? List<String>.from(nextWeekData['audioRefs']) : null,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: AppStyles.spacingS),
      child: Text(
        title,
        style: AppStyles.bodyStyle.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: AppStyles.softBrown.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildAudioCard(Map<String, String> audio) {
    final String audioId = audio['appwrite_id'] ?? '';
    
    return StreamBuilder<AudioServiceStatus>(
      stream: _audioService.statusStream,
      builder: (context, snapshot) {
        final bool isCurrent = _audioService.currentAppwriteId == audioId;
        final bool isPlaying = isCurrent && _audioService.status == AudioServiceStatus.playing;
        final bool isLoading = isCurrent && _audioService.status == AudioServiceStatus.loading;

        return Card(
          margin: EdgeInsets.only(bottom: AppStyles.spacingM),
          elevation: 0,
          color: Colors.white,
          shape: AppStyles.cardShape.copyWith(
            side: BorderSide(
              color: isCurrent ? AppStyles.primaryOrange.withOpacity(0.5) : Colors.grey.withOpacity(0.15),
              width: isCurrent ? 2 : 1.5,
            ),
          ),
          child: InkWell(
            onTap: () => _play(audio),
            borderRadius: BorderRadius.circular(28),
            child: Padding(
              padding: EdgeInsets.all(AppStyles.spacingL - AppStyles.spacingS),
              child: Row(
                children: [
                  isLoading
                      ? Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppStyles.primaryOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        )
                      : AnimatedPlayButton(
                          isPlaying: isPlaying,
                          size: 56,
                          showShadow: false,
                          onPressed: () => _play(audio),
                        ),
                  AppStyles.spacingMHorizontal,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audio['title']!,
                          style: AppStyles.subTitleStyle.copyWith(
                            color: isCurrent ? AppStyles.primaryOrange : AppStyles.softBrown,
                          ),
                        ),
                        AppStyles.spacingXSBox,
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: AppStyles.softBrown.withOpacity(0.5)),
                            AppStyles.spacingXSHorizontal,
                            Text(
                              audio['duration'] ?? '',
                              style: AppStyles.smallTextStyle.copyWith(color: AppStyles.softBrown.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPdfCard(Map<String, String> pdf) {
    final appwriteId = pdf['appwrite_id'];
    final url =
        '${AppConfig.appwriteEndpoint}/storage/buckets/${AppConfig.pdfsBucketId}/files/$appwriteId/view?project=${AppConfig.appwriteProjectId}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppStyles.softBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppStyles.softBrown,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(pdf['title']!, style: AppStyles.subTitleStyle),
              ),
              const Icon(
                Icons.open_in_new,
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
