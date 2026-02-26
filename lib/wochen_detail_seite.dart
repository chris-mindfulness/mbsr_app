import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/offline_banner.dart';
import 'app_daten.dart';
import 'audio_service.dart';
import 'widgets/animated_play_button.dart';
import 'widgets/exercise_tips_sheet.dart';
import 'widgets/weekly_reading_section.dart';
import 'text_archiv_seite.dart';
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
  final String? teaser;
  final List<Map<String, String>> readingCards;
  final String? readingSummary;
  final bool archiveEligible;

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
    this.teaser,
    this.readingCards = const [],
    this.readingSummary,
    this.archiveEligible = false,
  });

  @override
  State<WochenDetailSeite> createState() => _WochenDetailSeiteState();
}

class _WochenDetailSeiteState extends State<WochenDetailSeite> {
  final AudioService _audioService = AudioService();
  static const Color _pilotTextStrong = Color(0xFF101418);
  static const Color _pilotTextDefault = Color(0xFF171A1D);
  static const Color _pilotPrimaryReadable = Color(0xFF9F3F32);
  static const Color _pilotSuccessReadable = Color(0xFF3F7A72);
  static const Color _pilotInfoReadable = Color(0xFF4B6F95);
  static const Color _pilotPinkReadable = Color(0xFF944A61);

  double _responsiveHorizontalPadding(double width) {
    if (width >= 1400) return 72;
    if (width >= 1100) return 56;
    if (width >= 900) return 40;
    return 24;
  }

  int _getCurrentWeekIndex() {
    return int.tryParse(
          widget.wochenNummer.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        1;
  }

  void _play(Map<String, String> audio) async {
    HapticFeedback.lightImpact();
    try {
      await _audioService.play(audio);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Fehler beim Laden des Audios."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSurfaceIconButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 22, color: color),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        foregroundColor: color,
        backgroundColor: Colors.white.withValues(alpha: 0.98),
        minimumSize: const Size(40, 40),
        fixedSize: const Size(40, 40),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppStyles.borderColor.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }

  // Öffnet den Notfall-Koffer direkt aus der Wochenansicht.
  void _showNotfallKofferSheet() {
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
              _buildNotfallItem(
                icon: Icons.timer,
                title: "Kurzes Ankommen (ca. 3 Min)",
                description:
                    "Eine kurze Pause zum Sammeln. Startet die Übung „Ankommen“.",
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  final audio = AppDaten.getAlleAudios().firstWhere(
                    (a) => a['title'] == 'Ankommen',
                    orElse: () => {},
                  );
                  if (audio.isNotEmpty) _play(audio);
                },
              ),
              const SizedBox(height: 16),
              _buildNotfallItem(
                icon: Icons.accessibility_new,
                title: "Körper orientieren",
                description:
                    "Spüre beide Füße auf dem Boden und nimm 3 ruhige Atemzüge.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotfallItem({
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppStyles.errorRed.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppStyles.errorRed.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppStyles.errorRed, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.subTitleStyle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppStyles.bodyStyle.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.play_circle_outline,
                color: AppStyles.errorRed,
                size: 32,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotfallKofferCard() {
    return Container(
      padding: AppStyles.cardPadding,
      decoration: BoxDecoration(
        color: AppStyles.errorRed.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppStyles.errorRed.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.support_agent, color: AppStyles.errorRed, size: 28),
          AppStyles.spacingMHorizontal,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notfall-Koffer",
                  style: AppStyles.subTitleStyle.copyWith(
                    color: AppStyles.errorRed,
                  ),
                ),
                AppStyles.spacingSBox,
                Text(
                  "Wenn es dir gerade zu viel wird: Öffne den Notfall-Koffer für eine schnelle Stabilisierung.",
                  style: AppStyles.bodyStyle.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _showNotfallKofferSheet,
            child: const Text("Öffnen"),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _getWeekSupportConfig(int weekIndex) {
    switch (weekIndex) {
      case 5:
        return {
          'title': 'Tipps für Gedankenarbeit',
          'intro':
              'Gedanken müssen nicht weggehen. Du übst, sie zu bemerken und freundlicher mit ihnen umzugehen.',
          'icon': Icons.psychology_alt_outlined,
          'color': AppStyles.infoBlue,
          'sections': [
            {
              'title': 'Gedankenkarussell',
              'bullets': [
                "Gib dem Gedanken ein kurzes Label, z. B. „Sorge“ oder „Planen“.",
                "Komme dann sanft zum Atem oder zu den Kontaktpunkten zurück.",
              ],
            },
            {
              'title': 'Selbstkritik',
              'bullets': [
                "Frage dich: Würde ich so auch mit einem guten Freund sprechen?",
                "Formuliere den Satz neu, klar und respektvoll dir gegenüber.",
              ],
            },
            {
              'title': 'Kein Effekt spürbar',
              'bullets': [
                "Wirkung entsteht oft über Wiederholung, nicht über einen einzelnen Tag.",
                "Bleib bei kurzen, verlässlichen Einheiten statt bei Perfektion.",
              ],
            },
          ],
        };
      case 6:
        return {
          'title': 'Tipps für achtsame Kommunikation',
          'intro':
              'In Gesprächen hilft es, erst zu regulieren und dann zu reagieren. Kleine Pausen machen einen großen Unterschied.',
          'icon': Icons.forum_outlined,
          'color': AppStyles.accentPink,
          'sections': [
            {
              'title': 'Vor dem Gespräch',
              'bullets': [
                "Nimm dir 1 ruhigen Atemzug und spüre kurz deine Füße.",
                "Setze eine klare Intention: verstehen statt gewinnen.",
              ],
            },
            {
              'title': 'Wenn du getriggert bist',
              'bullets': [
                "Sprich langsamer und kürzer, statt sofort zu argumentieren.",
                "Bitte bei Bedarf um eine kurze Pause, bevor es eskaliert.",
              ],
            },
            {
              'title': 'Nach dem Gespräch',
              'bullets': [
                "Notiere 1 Punkt, der gut lief, und 1 Punkt für den nächsten Versuch.",
                "Vermeide Nachgrübeln, indem du bewusst zum Körper zurückkehrst.",
              ],
            },
          ],
        };
      case 7:
        return {
          'title': 'Tipps für Selbstfürsorge',
          'intro':
              'Selbstfürsorge ist keine Belohnung nach Leistung, sondern eine Grundlage für Stabilität im Alltag.',
          'icon': Icons.favorite_border,
          'color': AppStyles.successGreen,
          'sections': [
            {
              'title': 'Zu wenig Zeit',
              'bullets': [
                "Plane bewusst ein 5-Minuten-Minimum statt auf den perfekten Moment zu warten.",
                "Verknüpfe die Praxis mit einem festen Tagesanker.",
              ],
            },
            {
              'title': 'Schuldgefühl bei Pausen',
              'bullets': [
                "Erinnere dich: Regeneration erhöht langfristig deine Handlungsfähigkeit.",
                "Eine kurze Pause ist Verantwortung, nicht Rückzug.",
              ],
            },
            {
              'title': 'Alte Muster kommen zurück',
              'bullets': [
                "Rückfälle sind Lernmomente, kein Scheitern.",
                "Starte klein neu und halte den Ton mit dir freundlich.",
              ],
            },
          ],
        };
      case 8:
        return {
          'title': 'Tipps für die Zeit nach dem Kurs',
          'intro':
              'Nach dem Kurs hilft ein einfacher, realistischer Plan mehr als ein großer Vorsatz.',
          'icon': Icons.flag_outlined,
          'color': AppStyles.primaryOrange,
          'sections': [
            {
              'title': 'Praxis fällt weg',
              'bullets': [
                "Definiere eine feste Minimalpraxis für volle Tage.",
                "Halte den Einstieg niedrig, damit du dranbleibst.",
              ],
            },
            {
              'title': 'Motivation schwankt',
              'bullets': [
                "Orientiere dich an Wirkung statt an Stimmung.",
                "Notiere kurz, was dir die Übung im Alltag erleichtert.",
              ],
            },
            {
              'title': 'Einzelne Tage auslassen',
              'bullets': [
                "Steige am nächsten Tag direkt wieder ein, ohne Aufhol-Druck.",
                "Kontinuität entsteht durch Rückkehr, nicht durch Perfektion.",
              ],
            },
          ],
        };
      default:
        return null;
    }
  }

  Widget _buildWeekSupportTipps(int weekIndex) {
    final config = _getWeekSupportConfig(weekIndex);
    if (config == null) {
      return const SizedBox.shrink();
    }

    final accentColor = config['color'] as Color;
    final sections = List<Map<String, dynamic>>.from(config['sections']);

    return Container(
      padding: AppStyles.cardPadding,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(config['icon'] as IconData, color: accentColor, size: 28),
              AppStyles.spacingMHorizontal,
              Expanded(
                child: Text(
                  config['title'] as String,
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: 18,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          AppStyles.spacingMBox,
          Text(
            config['intro'] as String,
            style: AppStyles.bodyStyle.copyWith(height: 1.5),
          ),
          AppStyles.spacingLBox,
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.only(top: AppStyles.spacingS),
              title: Text(
                "Wenn es schwierig wird",
                style: AppStyles.subTitleStyle.copyWith(color: accentColor),
              ),
              iconColor: accentColor,
              collapsedIconColor: accentColor,
              children: sections
                  .map(
                    (section) => _buildWeekSupportSection(
                      section['title'] as String,
                      List<String>.from(section['bullets']),
                      accentColor,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSupportSection(
    String title,
    List<String> bullets,
    Color accentColor,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.bodyStyle.copyWith(
              fontWeight: AppStyles.fontWeightBold,
              color: AppStyles.textDark,
            ),
          ),
          AppStyles.spacingSBox,
          ...bullets.map((item) => _buildWeekSupportBullet(item, accentColor)),
        ],
      ),
    );
  }

  Widget _buildWeekSupportBullet(String text, Color accentColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          AppStyles.spacingSHorizontal,
          Expanded(
            child: Text(text, style: AppStyles.bodyStyle.copyWith(height: 1.4)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Navigation Logic
    final currentWeekIndex = _getCurrentWeekIndex();
    final isReadabilityPilot = currentWeekIndex == 4;
    final isWideLayout = MediaQuery.sizeOf(context).width >= 900;
    final hasPrev = currentWeekIndex > 1;
    final hasNext = currentWeekIndex < 8;
    final horizontalPadding = _responsiveHorizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

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
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppStyles.softBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (hasPrev)
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: AppStyles.softBrown,
                size: 32,
              ),
              onPressed: () => _navigateToWeek(-1),
              tooltip: "Vorherige Woche",
            ),
          if (hasNext)
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: AppStyles.softBrown,
                size: 32,
              ),
              onPressed: () => _navigateToWeek(1),
              tooltip: "Nächste Woche",
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: DecorativeBlobs(
        alphaMultiplier: isReadabilityPilot ? 0.55 : 1.0,
        child: Column(
          children: [
            // Offline-Banner
            const ConnectivityOfflineBanner(
              message: 'Offline - Audios können nicht geladen werden',
              horizontalMargin: 24,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppStyles.spacingS,
                  horizontalPadding,
                  20, // Weniger Padding unten, da Nav-Bar kommt
                ),
                children: [
                  Text(widget.titel, style: AppStyles.titleStyle),
                  if (widget.teaser != null) ...[
                    AppStyles.spacingMBox,
                    Text(
                      widget.teaser!,
                      style: AppStyles.bodyStyle.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppStyles.textDark,
                      ),
                    ),
                  ],
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
                        color: AppStyles.softBrown.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppStyles.softBrown.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: AppStyles.softBrown,
                            size: 32,
                          ),
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
                                color: AppStyles.softBrown,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  // Hinweise zu den Übungen + Audio-Praxis (früh für klare Orientierung)
                  if (widget.wochenAufgaben.isNotEmpty) ...[
                    Container(
                      padding: AppStyles.cardPadding,
                      decoration: BoxDecoration(
                        color: isReadabilityPilot
                            ? _pilotPrimaryReadable.withValues(alpha: 0.05)
                            : AppStyles.primaryOrange.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isReadabilityPilot
                              ? _pilotPrimaryReadable.withValues(alpha: 0.22)
                              : AppStyles.primaryOrange.withValues(alpha: 0.1),
                          width: isReadabilityPilot ? 1.4 : 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                color: isReadabilityPilot
                                    ? _pilotPrimaryReadable
                                    : AppStyles.primaryOrange,
                                size: 24,
                              ),
                              SizedBox(
                                width: AppStyles.spacingM - AppStyles.spacingS,
                              ),
                              Text(
                                "Hinweise zu deinen Übungen dieser Woche",
                                style: AppStyles.headingStyle.copyWith(
                                  fontSize: 18,
                                  color: isReadabilityPilot
                                      ? _pilotTextStrong
                                      : AppStyles.primaryOrange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppStyles.spacingL - AppStyles.spacingS,
                          ),
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
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      color: isReadabilityPilot
                                          ? _pilotSuccessReadable
                                          : AppStyles.sageGreen,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        AppStyles.spacingM - AppStyles.spacingS,
                                  ),
                                  Expanded(
                                    child: Text(
                                      aufgabe,
                                      style: AppStyles.bodyStyle.copyWith(
                                        height: isReadabilityPilot ? 1.7 : 1.6,
                                        fontWeight: isReadabilityPilot
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isReadabilityPilot
                                            ? _pilotTextDefault
                                            : AppStyles.textDark,
                                        fontSize: isReadabilityPilot
                                            ? (isWideLayout ? 18 : 17)
                                            : AppStyles.bodyStyle.fontSize,
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
                    SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS),
                  ],

                  _buildNotfallKofferCard(),
                  AppStyles.spacingXLBox,

                  if (currentWeekIndex >= 5 && currentWeekIndex <= 8) ...[
                    _buildWeekSupportTipps(currentWeekIndex),
                    AppStyles.spacingXLBox,
                  ],

                  if (widget.audioRefs != null &&
                      widget.audioRefs!.isNotEmpty) ...[
                    _buildSectionHeader(
                      "DEINE PRAXIS DIESE WOCHE",
                      readabilityPilot: isReadabilityPilot,
                    ),
                    AppStyles.spacingMBox,
                    if (currentWeekIndex <= 2) ...[
                      Container(
                        padding: AppStyles.cardPadding,
                        margin: EdgeInsets.only(bottom: AppStyles.spacingM),
                        decoration: BoxDecoration(
                          color: isReadabilityPilot
                              ? _pilotInfoReadable.withValues(alpha: 0.07)
                              : AppStyles.infoBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isReadabilityPilot
                                ? _pilotInfoReadable.withValues(alpha: 0.24)
                                : AppStyles.infoBlue.withValues(alpha: 0.3),
                            width: isReadabilityPilot ? 1.4 : 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: isReadabilityPilot
                                  ? _pilotInfoReadable
                                  : AppStyles.infoBlue,
                              size: 24,
                            ),
                            AppStyles.spacingMHorizontal,
                            Expanded(
                              child: Text(
                                "Hinweis: In der Mediathek findest du auch längere Versionen des Body-Scans (27 & 35 Min), falls du mehr Zeit hast.",
                                style: AppStyles.bodyStyle.copyWith(
                                  fontSize: isReadabilityPilot
                                      ? (isWideLayout ? 18 : 17)
                                      : 13,
                                  color: isReadabilityPilot
                                      ? _pilotTextDefault
                                      : AppStyles.textDark,
                                  fontWeight: isReadabilityPilot
                                      ? FontWeight.w600
                                      : AppStyles.fontWeightRegular,
                                  height: isReadabilityPilot ? 1.7 : 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ..._getAudiosForWeek().map(
                      (audio) => _buildAudioCard(audio),
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  // BODY-SCAN TIPPS (nur Woche 1)
                  if (currentWeekIndex <= 2) ...[
                    _buildBodyScanTipps(),
                    AppStyles.spacingXLBox,
                  ],

                  // SITZMEDITATION TIPPS (nur Woche 4)
                  if (currentWeekIndex == 4) ...[
                    _buildSitzmeditationTipps(),
                    AppStyles.spacingXLBox,
                  ],

                  // ACHTSAME BEWEGUNG TIPPS (nur Woche 3)
                  if (currentWeekIndex == 3) ...[
                    _buildBewegungTipps(),
                    AppStyles.spacingXLBox,
                  ],

                  // ALLTAGSTIPP
                  if (widget.alltagsTipp != null) ...[
                    _buildSectionHeader(
                      "FÜR DEN ALLTAG",
                      readabilityPilot: isReadabilityPilot,
                    ),
                    AppStyles.spacingMBox,
                    Container(
                      padding: AppStyles.cardPadding,
                      decoration: BoxDecoration(
                        color: isReadabilityPilot
                            ? _pilotSuccessReadable.withValues(alpha: 0.07)
                            : AppStyles.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isReadabilityPilot
                              ? _pilotSuccessReadable.withValues(alpha: 0.24)
                              : AppStyles.successGreen.withValues(alpha: 0.3),
                          width: isReadabilityPilot ? 1.4 : 1.0,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: isReadabilityPilot
                                ? _pilotSuccessReadable
                                : AppStyles.successGreen,
                            size: 28,
                          ),
                          AppStyles.spacingMHorizontal,
                          Expanded(
                            child: Text(
                              widget.alltagsTipp!,
                              style: AppStyles.bodyStyle.copyWith(
                                color: isReadabilityPilot
                                    ? _pilotTextDefault
                                    : AppStyles.textDark,
                                height: isReadabilityPilot ? 1.7 : 1.5,
                                fontSize: isReadabilityPilot
                                    ? (isWideLayout ? 18 : 17)
                                    : AppStyles.bodyStyle.fontSize,
                                fontWeight: isReadabilityPilot
                                    ? FontWeight.w600
                                    : AppStyles.fontWeightRegular,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  // REFLEXION
                  if (widget.reflexionsFragen != null &&
                      widget.reflexionsFragen!.isNotEmpty) ...[
                    _buildSectionHeader(
                      "REFLEXION",
                      readabilityPilot: isReadabilityPilot,
                    ),
                    AppStyles.spacingMBox,
                    ...widget.reflexionsFragen!.map(
                      (frage) => Padding(
                        padding: EdgeInsets.only(bottom: AppStyles.spacingM),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.edit_note,
                              color: isReadabilityPilot
                                  ? _pilotPinkReadable
                                  : AppStyles.accentPink,
                              size: 24,
                            ),
                            AppStyles.spacingMHorizontal,
                            Expanded(
                              child: Text(
                                frage,
                                style: AppStyles.bodyStyle.copyWith(
                                  fontStyle: isReadabilityPilot
                                      ? FontStyle.normal
                                      : FontStyle.italic,
                                  color: isReadabilityPilot
                                      ? _pilotTextDefault
                                      : AppStyles.textDark,
                                  fontSize: isReadabilityPilot
                                      ? (isWideLayout ? 18 : 17)
                                      : AppStyles.bodyStyle.fontSize,
                                  fontWeight: isReadabilityPilot
                                      ? FontWeight.w600
                                      : AppStyles.fontWeightRegular,
                                  height: isReadabilityPilot ? 1.7 : 1.62,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  if (widget.readingCards.isNotEmpty) ...[
                    WeeklyReadingSection(
                      readingCards: widget.readingCards,
                      readingSummary: widget.readingSummary,
                      archiveEligible: widget.archiveEligible,
                      readabilityPilot: isReadabilityPilot,
                      showIntroSummary: !isReadabilityPilot,
                      showSourceRef: !isReadabilityPilot,
                      onOpenArchive: _openTextArchiv,
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  if (widget.pdfs.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildSectionHeader(
                        "UNTERLAGEN",
                        readabilityPilot: isReadabilityPilot,
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
    return allAudios
        .where((audio) => widget.audioRefs!.contains(audio['title']))
        .toList();
  }

  List<Map<String, String>> _extractReadingCards(
    Map<String, dynamic> weekData,
  ) {
    final raw = weekData['readingCards'];
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map((item) => Map<String, String>.from(item.cast<String, String>()))
        .toList();
  }

  void _showTipsForAudio(Map<String, String> audio) {
    final title = audio['title'];
    if (title == null || title.isEmpty) return;
    ExerciseTipsSheet.show(
      context,
      audioTitle: title,
      weekIndex: _getCurrentWeekIndex(),
      sourceLabel: widget.wochenNummer,
    );
  }

  void _navigateToWeek(int direction) {
    final currentWeekIndex =
        int.tryParse(widget.wochenNummer.replaceAll(RegExp(r'[^0-9]'), '')) ??
        1;
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
          wochenAufgaben: List<String>.from(
            nextWeekData['wochenAufgaben'] ?? [],
          ),
          fokus: nextWeekData['fokus'],
          zitat: nextWeekData['zitat'],
          zitatAutor: nextWeekData['zitatAutor'],
          alltagsTipp: nextWeekData['alltagsTipp'],
          reflexionsFragen: nextWeekData['reflexionsFragen'] != null
              ? List<String>.from(nextWeekData['reflexionsFragen'])
              : null,
          audioRefs: nextWeekData['audioRefs'] != null
              ? List<String>.from(nextWeekData['audioRefs'])
              : null,
          teaser: nextWeekData['teaser'],
          readingCards: _extractReadingCards(nextWeekData),
          readingSummary: nextWeekData['readingSummary'] as String?,
          archiveEligible: nextWeekData['archiveEligible'] == true,
        ),
      ),
    );
  }

  // ============================================
  // BODY-SCAN TIPPS (nur Woche 1)
  // ============================================
  Widget _buildBodyScanTipps() {
    return Container(
      padding: AppStyles.cardPadding,
      decoration: BoxDecoration(
        color: AppStyles.accentCyan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppStyles.accentCyan.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.self_improvement,
                color: AppStyles.accentCyan,
                size: 28,
              ),
              AppStyles.spacingMHorizontal,
              Expanded(
                child: Text(
                  "Tipps für den Body-Scan",
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: 18,
                    color: AppStyles.accentCyan,
                  ),
                ),
              ),
            ],
          ),
          AppStyles.spacingMBox,

          // Intro
          Text(
            "Der Body-Scan ist eine Einladung, deinen Körper so wahrzunehmen, wie er gerade ist - ohne etwas ändern zu müssen. Du erforschst, was da ist.",
            style: AppStyles.bodyStyle.copyWith(height: 1.5),
          ),
          AppStyles.spacingLBox,

          // 5 Kernprinzipien
          Text(
            "5 Kernprinzipien",
            style: AppStyles.subTitleStyle.copyWith(color: AppStyles.textDark),
          ),
          AppStyles.spacingSBox,
          _buildTippBullet(
            "Was auch passiert - weitermachen. Auch Abschweifen gehört dazu.",
          ),
          _buildTippBullet(
            "Gedanken bemerken, nicht stoppen. Dann sanft zurückkehren.",
          ),
          _buildTippBullet(
            "Kein Wettbewerb. Regelmäßig üben zählt mehr als perfekt üben.",
          ),
          _buildTippBullet(
            "Erwartungen nicht füttern. Da sein und schauen, was passiert.",
          ),
          _buildTippBullet(
            '"So ist es gerade." - Nicht gegen Unangenehmes kämpfen.',
          ),

          AppStyles.spacingMBox,

          // Merksatz
          Container(
            padding: EdgeInsets.all(AppStyles.spacingM),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: AppStyles.accentCyan.withValues(alpha: 0.6),
                  size: 24,
                ),
                AppStyles.spacingSHorizontal,
                Expanded(
                  child: Text(
                    "Es geht nicht darum, etwas zu erreichen - sondern zu bemerken, was schon da ist.",
                    style: AppStyles.bodyStyle.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppStyles.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppStyles.spacingLBox,

          // Aufklappbarer Detailbereich
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.only(top: AppStyles.spacingS),
              title: Text(
                "Wenn es schwierig wird",
                style: AppStyles.subTitleStyle.copyWith(
                  color: AppStyles.accentCyan,
                ),
              ),
              iconColor: AppStyles.accentCyan,
              collapsedIconColor: AppStyles.accentCyan,
              children: [
                _buildTippSektion("Abschweifen", [
                  "Völlig normal - passiert allen, immer wieder.",
                  "Bemerken ist bereits Achtsamkeit.",
                  "Freundlich zurückkommen, ohne dich zu bewerten.",
                ]),
                _buildTippSektion("Schläfrigkeit", [
                  "Augen leicht öffnen kann helfen.",
                  "Ein paar tiefere Atemzüge nehmen.",
                  "Position minimal verändern oder im Sitzen üben.",
                ]),
                _buildTippSektion("Unruhe", [
                  "Kleine Bewegungen sind erlaubt (schlucken, Schultern lösen).",
                  "Du musst nicht verkrampft stillhalten.",
                  "Unruhe wahrnehmen, nicht wegdrücken.",
                ]),
                _buildTippSektion("Schmerz / Unwohlsein", [
                  "Erkunden statt ertragen: Was genau spürst du?",
                  "Position anpassen ist jederzeit okay.",
                  "Fokus weiten (ganzer Körper, Geräusche) oder neutralen Anker wählen.",
                ]),
                _buildTippSektion("Nichts spüren", [
                  'Auch "neutral" oder "taub" ist eine Erfahrung.',
                  "Kontaktpunkte nutzen: Wo liegt dein Körper auf?",
                  "Wenn es sich zu viel oder abgeschnitten anfühlt: Augen öffnen, im Raum orientieren, dann neu entscheiden.",
                ]),
                _buildTippSektion("Erwartungen & Leistungsdruck", [
                  'Es gibt kein "richtig" oder "falsch".',
                  "Ziel ist nicht, Gedanken zu steuern - sondern zu bemerken.",
                  "Jede Übung ist anders. Vergleichen hilft nicht.",
                ]),
                _buildTippSektion("Dranbleiben & Routine", [
                  "Ein festes Zeitfenster hilft beim Dranbleiben.",
                  "Wiederholung ist Teil des Lernens - nicht Langeweile.",
                  "Optional: Kurze Notiz nach der Übung (Was war da?).",
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTippBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppStyles.accentCyan,
              shape: BoxShape.circle,
            ),
          ),
          AppStyles.spacingSHorizontal,
          Expanded(
            child: Text(text, style: AppStyles.bodyStyle.copyWith(height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildTippSektion(String titel, List<String> punkte) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titel,
            style: AppStyles.bodyStyle.copyWith(
              fontWeight: AppStyles.fontWeightBold,
              color: AppStyles.textDark,
            ),
          ),
          AppStyles.spacingSBox,
          ...punkte.map((p) => _buildTippBullet(p)),
        ],
      ),
    );
  }

  // ============================================
  // SITZMEDITATION TIPPS (nur Woche 4)
  // ============================================
  Widget _buildSitzmeditationTipps() {
    return Container(
      padding: AppStyles.cardPadding,
      decoration: BoxDecoration(
        color: AppStyles.accentPink.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppStyles.accentPink.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.airline_seat_recline_normal,
                color: AppStyles.accentPink,
                size: 28,
              ),
              AppStyles.spacingMHorizontal,
              Expanded(
                child: Text(
                  "Tipps zur Sitzmeditation",
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: 18,
                    color: AppStyles.accentPink,
                  ),
                ),
              ),
            ],
          ),
          AppStyles.spacingMBox,

          // Intro
          Text(
            "Die Sitzmeditation ist eine Einladung, mit dem Atem als Anker da zu sein - und dich auch dem zu öffnen, was sonst noch auftaucht.",
            style: AppStyles.bodyStyle.copyWith(height: 1.5),
          ),
          AppStyles.spacingLBox,

          // 5 Kernprinzipien
          Text(
            "5 Kernprinzipien",
            style: AppStyles.subTitleStyle.copyWith(color: AppStyles.textDark),
          ),
          AppStyles.spacingSBox,
          _buildSitzTippBullet(
            "Den Atem spüren, ohne ihn zu steuern (Bauch, Brust oder Nase).",
          ),
          _buildSitzTippBullet(
            "Abschweifen ist normal. Bemerken, dann freundlich zurückkehren.",
          ),
          _buildSitzTippBullet(
            "Kein Wettbewerb. Immer wieder zurückkommen - das ist die Übung.",
          ),
          _buildSitzTippBullet(
            "Weite üben: Wahrnehmen, was im Vordergrund ist, ohne festzuhalten.",
          ),
          _buildSitzTippBullet(
            '"So ist es gerade." - Auch Unruhe und Langeweile gehören dazu.',
          ),

          AppStyles.spacingMBox,

          // Merksatz
          Container(
            padding: EdgeInsets.all(AppStyles.spacingM),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: AppStyles.accentPink.withValues(alpha: 0.6),
                  size: 24,
                ),
                AppStyles.spacingSHorizontal,
                Expanded(
                  child: Text(
                    "Der Atem atmet sich selbst. Du bist da und spürst mit.",
                    style: AppStyles.bodyStyle.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppStyles.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppStyles.spacingLBox,

          // Aufklappbarer Detailbereich
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.only(top: AppStyles.spacingS),
              title: Text(
                "Wenn es schwierig wird",
                style: AppStyles.subTitleStyle.copyWith(
                  color: AppStyles.accentPink,
                ),
              ),
              iconColor: AppStyles.accentPink,
              collapsedIconColor: AppStyles.accentPink,
              children: [
                _buildSitzTippSektion("Abschweifen", [
                  "Völlig normal - passiert allen, immer wieder.",
                  'Kurzes Label hilft: "Planen", "Erinnern" - dann zurück.',
                  "Die Rückkehr ist der Übungsmoment, nicht das Stillsein.",
                ]),
                _buildSitzTippSektion("Schläfrigkeit", [
                  "Augen leicht öffnen, Wirbelsäule aufrichten.",
                  "Ein paar tiefere Atemzüge nehmen.",
                  "Position minimal anpassen - aufrechter sitzen kann helfen.",
                ]),
                _buildSitzTippSektion("Unruhe", [
                  "Kleine Bewegungen sind erlaubt (Schultern lösen, schlucken).",
                  "Kontaktpunkte spüren: Sitzfläche, Füße, Hände.",
                  "Unruhe wahrnehmen, nicht wegdrücken.",
                ]),
                _buildSitzTippSektion("Atem zu subtil / Atem steuern", [
                  "Atem kaum spürbar? Kontaktpunkte als Backup-Anker nutzen.",
                  "Du steuerst den Atem? Lass ihn wieder von selbst kommen.",
                  "Nur mitspüren, nicht machen. Der Körper atmet von allein.",
                ]),
                _buildSitzTippSektion("Offenes Gewahrsein schwer", [
                  "Stufenweise öffnen: Atem - Körper - Geräusche - offenes Feld.",
                  "Nimm wahr, was gerade am deutlichsten ist.",
                  "Zu viel? Kurz zurück zum Atem, dann wieder öffnen.",
                ]),
                _buildSitzTippSektion("Erwartungen & Leistungsdruck", [
                  'Es gibt kein "richtig" oder "falsch".',
                  'Ziel ist nicht "ruhig werden" - sondern bemerken.',
                  "Jede Übung ist anders. Vergleichen hilft nicht.",
                ]),
                _buildSitzTippSektion("Dranbleiben & Routine", [
                  "Ein festes Zeitfenster hilft beim Dranbleiben.",
                  "Wiederholung ist Teil des Lernens - nicht Langeweile.",
                  "Optional: Kurze Notiz nach der Übung (Was war da?).",
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSitzTippBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppStyles.accentPink,
              shape: BoxShape.circle,
            ),
          ),
          AppStyles.spacingSHorizontal,
          Expanded(
            child: Text(text, style: AppStyles.bodyStyle.copyWith(height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildSitzTippSektion(String titel, List<String> punkte) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titel,
            style: AppStyles.bodyStyle.copyWith(
              fontWeight: AppStyles.fontWeightBold,
              color: AppStyles.textDark,
            ),
          ),
          AppStyles.spacingSBox,
          ...punkte.map((p) => _buildSitzTippBullet(p)),
        ],
      ),
    );
  }

  // ============================================
  // ACHTSAME BEWEGUNG TIPPS (nur Woche 3)
  // ============================================
  Widget _buildBewegungTipps() {
    return Container(
      padding: AppStyles.cardPadding,
      decoration: BoxDecoration(
        color: AppStyles.sageGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppStyles.sageGreen.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.accessibility_new,
                color: AppStyles.sageGreen,
                size: 28,
              ),
              AppStyles.spacingMHorizontal,
              Expanded(
                child: Text(
                  "Tipps für achtsame Bewegung",
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: 18,
                    color: AppStyles.sageGreen,
                  ),
                ),
              ),
            ],
          ),
          AppStyles.spacingMBox,

          // Intro
          Text(
            "Achtsame Bewegung ist eine Einladung, deinen Körper in Bewegung zu erforschen - nicht an einem Ideal, sondern so, wie er heute ist.",
            style: AppStyles.bodyStyle.copyWith(height: 1.5),
          ),
          AppStyles.spacingLBox,

          // 5 Kernprinzipien
          Text(
            "5 Kernprinzipien",
            style: AppStyles.subTitleStyle.copyWith(color: AppStyles.textDark),
          ),
          AppStyles.spacingSBox,
          _buildBewegungTippBullet(
            "Weniger ist oft mehr: sanft, klein und langsam statt zu viel.",
          ),
          _buildBewegungTippBullet(
            "Grenzen respektieren. Intensität bei 3-5 von 10 halten.",
          ),
          _buildBewegungTippBullet(
            "Spüre Kontakt, Dehnung, Wärme - ohne zu bewerten.",
          ),
          _buildBewegungTippBullet(
            "Pausen sind Teil der Übung. Jederzeit stoppen ist okay.",
          ),
          _buildBewegungTippBullet(
            "Wenn du ruhig weiteratmen kannst, ist die Intensität meist passend.",
          ),

          AppStyles.spacingMBox,

          // Merksatz
          Container(
            padding: EdgeInsets.all(AppStyles.spacingM),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: AppStyles.sageGreen.withValues(alpha: 0.6),
                  size: 24,
                ),
                AppStyles.spacingSHorizontal,
                Expanded(
                  child: Text(
                    "Es geht nicht darum, irgendwo anzukommen - sondern zu spüren, wo du gerade bist.",
                    style: AppStyles.bodyStyle.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppStyles.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppStyles.spacingLBox,

          // Aufklappbarer Detailbereich
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.only(top: AppStyles.spacingS),
              title: Text(
                "Wenn es schwierig wird",
                style: AppStyles.subTitleStyle.copyWith(
                  color: AppStyles.sageGreen,
                ),
              ),
              iconColor: AppStyles.sageGreen,
              collapsedIconColor: AppStyles.sageGreen,
              children: [
                _buildBewegungTippSektion("Grenzen & Dosierung", [
                  "Bis zum ersten deutlichen Körpersignal gehen; dort bleiben oder etwas zurückgehen.",
                  "Kannst du dabei ruhig atmen? Wenn nein: weniger machen.",
                  "Variationen nutzen: kleinerer Radius, langsamer, stabiler.",
                ]),
                _buildBewegungTippSektion("Schmerz / Unwohlsein", [
                  "Erkunden statt ertragen: Dehnreiz okay, stechend nicht.",
                  "Bei stechendem Schmerz: sofort raus, Position anpassen.",
                  "Bei Unsicherheit: weniger machen oder Übung auslassen.",
                ]),
                _buildBewegungTippSektion("Erwartungen & Leistungsdruck", [
                  'Es gibt kein "richtig" oder "falsch". Jede Variation zählt.',
                  "Wenn Vergleichen auftaucht: kurz bemerken, dann zurück zu Körperempfindungen.",
                  "Jede Übung ist anders. Vergleichen hilft nicht.",
                ]),
                _buildBewegungTippSektion("Unruhe", [
                  "Verlangsame absichtlich: halbe Geschwindigkeit.",
                  "Kontaktpunkte spüren: Füße, Hände, Boden.",
                  "Unruhe wahrnehmen, nicht wegdrücken.",
                ]),
                _buildBewegungTippSektion("Körperbild / Selbstkritik", [
                  'Selbstkritik als Ereignis erkennen ("Bewerten"), nicht als Wahrheit.',
                  "Fokus auf neutrale Daten: Druck, Temperatur, Kontakt.",
                  "So üben, dass es sicher und würdevoll bleibt.",
                ]),
                _buildBewegungTippSektion("Nichts spüren", [
                  'Auch "neutral" ist eine Erfahrung.',
                  "Kontaktpunkte nutzen: Wo berührt dein Körper den Boden?",
                  "Wenn es sich zu viel oder abgeschnitten anfühlt: Augen öffnen, im Raum orientieren, dann neu entscheiden.",
                ]),
                _buildBewegungTippSektion("Dranbleiben & Routine", [
                  "Ein festes Zeitfenster hilft beim Dranbleiben.",
                  "Wiederholung ist Teil des Lernens - nicht Langeweile.",
                  "Optional: Kurze Notiz nach der Übung (Was war da?).",
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBewegungTippBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppStyles.sageGreen,
              shape: BoxShape.circle,
            ),
          ),
          AppStyles.spacingSHorizontal,
          Expanded(
            child: Text(text, style: AppStyles.bodyStyle.copyWith(height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildBewegungTippSektion(String titel, List<String> punkte) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titel,
            style: AppStyles.bodyStyle.copyWith(
              fontWeight: AppStyles.fontWeightBold,
              color: AppStyles.textDark,
            ),
          ),
          AppStyles.spacingSBox,
          ...punkte.map((p) => _buildBewegungTippBullet(p)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool readabilityPilot = false}) {
    return Padding(
      padding: EdgeInsets.only(left: AppStyles.spacingS),
      child: Text(
        title,
        style: readabilityPilot
            ? AppStyles.bodyStyle.copyWith(
                letterSpacing: 1.1,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: _pilotTextStrong,
              )
            : AppStyles.bodyStyle.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppStyles.softBrown.withValues(alpha: 0.8),
              ),
      ),
    );
  }

  void _openTextArchiv() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextArchivSeite(
          wochenDaten: AppDaten.wochenDaten,
          initialWeekNumber: _getCurrentWeekIndex(),
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
        final bool isPlaying =
            isCurrent && _audioService.status == AudioServiceStatus.playing;
        final bool isLoading =
            isCurrent && _audioService.status == AudioServiceStatus.loading;

        return Card(
          margin: EdgeInsets.only(bottom: AppStyles.spacingM),
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
                            color: isCurrent
                                ? AppStyles.primaryOrange
                                : AppStyles.softBrown,
                          ),
                        ),
                        AppStyles.spacingXSBox,
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppStyles.softBrown.withValues(alpha: 0.5),
                            ),
                            AppStyles.spacingXSHorizontal,
                            Text(
                              audio['duration'] ?? '',
                              style: AppStyles.smallTextStyle.copyWith(
                                color: AppStyles.softBrown.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildSurfaceIconButton(
                    icon: Icons.lightbulb_outline,
                    color: AppStyles.infoBlue,
                    tooltip: 'Tipps zur Übung',
                    onPressed: () => _showTipsForAudio(audio),
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
                  color: AppStyles.softBrown.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: AppStyles.softBrown,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(pdf['title']!, style: AppStyles.subTitleStyle),
              ),
              Icon(Icons.open_in_new, color: AppStyles.borderColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
