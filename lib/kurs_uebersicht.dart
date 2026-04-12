import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'wochen_detail_seite.dart';
import 'vertiefung_seite.dart';
import 'profil_seite.dart';
import 'tag_der_achtsamkeit_seite.dart';
import 'app_daten.dart';
import 'mediathek_seite.dart';
import 'web_utils.dart' show setRoute;
import 'core/app_styles.dart';
import 'audio_service.dart';
import 'widgets/ambient_background.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/offline_banner.dart';
import 'widgets/subtle_divider.dart';
import 'widgets/full_player_header.dart';
import 'widgets/full_player_now_playing.dart';
import 'widgets/full_player_progress.dart';
import 'widgets/full_player_transport_controls.dart';
import 'widgets/floating_bottom_nav.dart';
import 'widgets/kurs_overview_header.dart';
import 'widgets/mini_player_bar.dart';
import 'audio/seek_policy.dart';

class KursUebersicht extends StatefulWidget {
  final String kursTyp;
  final int initialIndex;

  const KursUebersicht({
    super.key,
    this.kursTyp = "MBSR",
    this.initialIndex = 0,
  });

  @override
  State<KursUebersicht> createState() => _KursUebersichtState();
}

class _KursUebersichtState extends State<KursUebersicht> {
  /// Einheitliche Kartenhöhe in der Wochen-Übersicht (Wrap mit 2 Spalten).
  static const double _weekOverviewCardHeight = 364.0;

  late int _currentIndex;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<NavigatorState> _kursNavigatorKey =
      GlobalKey<NavigatorState>();
  final AudioService _audioService = AudioService();

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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _updateUrl(_currentIndex);
  }

  void _updateUrl(int index) {
    switch (index) {
      case 0:
        setRoute('/home');
        break;
      case 1:
        setRoute('/mediathek');
        break;
      case 2:
        setRoute('/vertiefung');
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _seekRelative(Duration offset) async {
    final target = resolveSeekTarget(
      current: _audioService.position,
      offset: offset,
      knownDuration: _audioService.duration,
    );
    await _audioService.seek(target);
  }

  ButtonStyle _surfaceIconStyle({
    Color? foregroundColor,
    Color? backgroundColor,
    double radius = 14,
  }) {
    return IconButton.styleFrom(
      foregroundColor: foregroundColor ?? AppStyles.textDark,
      backgroundColor: backgroundColor ?? Colors.white.withValues(alpha: 0.95),
      minimumSize: const Size(44, 44),
      fixedSize: const Size(44, 44),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: AppStyles.borderColor.withValues(alpha: 0.55),
          width: 1.0,
        ),
      ),
    );
  }

  /// Öffnet den Full-Screen Player im Headspace-Stil
  void _showFullPlayer() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: AppStyles.bgColor,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (sheetContext) {
        final h = MediaQuery.sizeOf(sheetContext).height;
        return SizedBox(
          height: h * 0.95,
          child: _buildFullPlayerContent(sheetContext),
        );
      },
    );
  }

  Widget _buildFullPlayerContent(BuildContext sheetContext) {
    return AmbientBackground(
      child: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppStyles.spacingXL),
          child: Column(
            children: [
              AppStyles.spacingMBox,
              FullPlayerHeader(
                iconButtonStyle: _surfaceIconStyle(),
                onStop: () {
                  _audioService.stop();
                  Navigator.of(sheetContext).pop();
                },
                onClose: () {
                  Navigator.of(sheetContext).pop();
                },
              ),
              AppStyles.spacingLBox,

              Expanded(
                child: FullPlayerNowPlaying(
                  title: _audioService.currentTitle ?? 'Audio',
                ),
              ),

              AppStyles.spacingXXLBox,

              FullPlayerProgress(audioService: _audioService),

              AppStyles.spacingXLBox,

              FullPlayerTransportControls(
                audioService: _audioService,
                buttonStyle: _surfaceIconStyle(),
                onSeekBack: () => _seekRelative(const Duration(seconds: -10)),
                onSeekForward: () => _seekRelative(const Duration(seconds: 10)),
              ),

              const Spacer(),
              AppStyles.spacingXXLBox,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildKursPfad(),
      const MediathekSeite(),
      VertiefungSeite(
        tagDerAchtsamkeit: AppDaten.tagDerAchtsamkeit,
        zusatzUebungen: AppDaten.zusatzUebungen,
      ),
    ];

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text("MBSR Kurs", style: AppStyles.headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppStyles.softBrown,
              size: AppStyles.iconSizeL,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilSeite()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const ConnectivityOfflineBanner(
            message: 'Keine Internetverbindung',
            fontSize: 14,
          ),
          Expanded(child: pages[_currentIndex]),
        ],
      ),
      bottomNavigationBar: StreamBuilder<AudioServiceStatus>(
        stream: _audioService.statusStream,
        builder: (context, snapshot) {
          final hasActiveAudio = _audioService.currentAppwriteId != null;
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasActiveAudio)
                    GestureDetector(
                      onTap: _showFullPlayer,
                      child: MiniPlayerBar(
                        audioService: _audioService,
                        stopButtonStyle: _surfaceIconStyle(
                          backgroundColor: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                  if (hasActiveAudio) const SizedBox(height: 12),
                  FloatingBottomNav(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() => _currentIndex = index);
                      _updateUrl(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKursPfad() {
    return Navigator(
      key: _kursNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => DecorativeBlobs(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 28),
              children: [
                const KursOverviewHeader(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterRow(),
                      const SubtleDivider(),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final mediaWidth = MediaQuery.sizeOf(context).width;
                          final availableWidth = constraints.maxWidth.isFinite
                              ? constraints.maxWidth
                              : math
                                    .max(320.0, mediaWidth - (2 * 20))
                                    .toDouble();
                          // Etwas höherer Breakpoint: breitere Einzelkarten, mehr Platz für Text + Avatar.
                          final useTwoColumns = availableWidth >= 960;
                          final gap = AppStyles.featureChipGap;
                          final cardWidth = useTwoColumns
                              ? (availableWidth - gap) / 2
                              : availableWidth;

                          return Wrap(
                            spacing: gap,
                            runSpacing: gap,
                            children: AppDaten.wochenDaten.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final woche = entry.value;
                              return SizedBox(
                                width: cardWidth,
                                child: _buildWochenCard(context, woche, index),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      AppStyles.spacingMBox,
                      _buildTagDerAchtsamkeitCard(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: EdgeInsets.only(
        left: AppStyles.spacingS,
        bottom: AppStyles.spacingS,
      ),
      child: Text(
        "Wochen",
        style: AppStyles.headingStyle.copyWith(fontSize: 18),
      ),
    );
  }

  Color _weekCardAccent(int index) {
    const palette = [
      Color(0xFF5D988F),
      Color(0xFF6D8FB3),
      Color(0xFF6F9FA1),
      Color(0xFFE06E5A),
    ];
    return palette[index % palette.length];
  }

  void _openMediathekFromWeekDetail() {
    _kursNavigatorKey.currentState?.pop();
    setState(() {
      _currentIndex = 1;
      _updateUrl(1);
    });
  }

  void _openWeekDetail(BuildContext context, Map<String, dynamic> woche) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WochenDetailSeite(
          wochenNummer: "Woche ${woche['n']}",
          wochenKopfzeile: woche['wochenKopfzeile'] as String?,
          titel: woche['t'],
          pdfs: AppDaten.pdfMapsFromRaw(woche['pdfs'] as List<dynamic>?),
          wochenAufgaben: List<String>.from(woche['wochenAufgaben'] ?? []),
          fokus: woche['fokus'],
          zitat: woche['zitat'],
          zitatAutor: woche['zitatAutor'],
          alltagsTipp: woche['alltagsTipp'],
          reflexionsFragen: woche['reflexionsFragen'] != null
              ? List<String>.from(woche['reflexionsFragen'])
              : null,
          teaser: woche['teaser'],
          einfuehrung: woche['einfuehrung'],
          readingCards: _extractReadingCards(woche),
          readingSummary: woche['readingSummary'] as String?,
          archiveEligible: woche['archiveEligible'] == true,
          avatarImage: woche['avatarImage'] as String?,
          infoClips: woche['infoClips'] as Map<String, dynamic>?,
          onOpenMediathek: _openMediathekFromWeekDetail,
        ),
      ),
    );
  }

  Widget _buildWochenCard(
    BuildContext context,
    Map<String, dynamic> woche,
    int index,
  ) {
    final accentColor = _weekCardAccent(index);
    final teaser = (woche['teaser'] as String?)?.trim();
    final nachDemKurs = woche['nachDemKurs'] == true;
    final kartenBadge = (woche['wochenKartenBadge'] as String?)?.trim();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        shape: AppStyles.cardShape,
        elevation: 0,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          onTap: () => _openWeekDetail(context, woche),
          child: Padding(
            padding: AppStyles.cardPadding,
            child: SizedBox(
              height: _weekOverviewCardHeight - AppStyles.cardPadding.vertical,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.28),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                nachDemKurs
                                    ? Icons.self_improvement
                                    : Icons.calendar_today,
                                size: 14,
                                color: accentColor,
                              ),
                              AppStyles.spacingSHorizontal,
                              Text(
                                (kartenBadge != null && kartenBadge.isNotEmpty)
                                    ? kartenBadge
                                    : 'Woche ${woche['n']}',
                                style: AppStyles.smallTextStyle.copyWith(
                                  color: accentColor,
                                  fontWeight: AppStyles.fontWeightSemiBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppStyles.spacingMBox,
                        Text(
                          woche['t'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.subTitleStyle.copyWith(
                            color: AppStyles.textDark,
                            fontSize: 28,
                            height: 1.25,
                          ),
                        ),
                        AppStyles.spacingSBox,
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: teaser != null && teaser.isNotEmpty
                                ? Text(
                                    teaser,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.bodyStyle.copyWith(
                                      color: AppStyles.textMuted,
                                      height: 1.55,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        SizedBox(height: AppStyles.spacingL),
                        Row(
                          children: [
                            Text(
                              nachDemKurs ? 'Öffnen' : 'Woche öffnen',
                              style: AppStyles.bodyStyle.copyWith(
                                color: accentColor,
                                fontWeight: AppStyles.fontWeightSemiBold,
                              ),
                            ),
                            AppStyles.spacingXSHorizontal,
                            Icon(
                              Icons.chevron_right,
                              color: accentColor,
                              size: AppStyles.iconSizeM,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppStyles.spacingM),
                  SizedBox(
                    width: 118,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 118,
                            maxHeight: 118,
                          ),
                          child: Image.asset(
                            (woche['avatarImage'] as String?) ??
                                AppDaten.defaultWeekAvatarAsset,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.self_improvement_rounded,
                                size: 48,
                                color: accentColor.withValues(alpha: 0.35),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagDerAchtsamkeitCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        shape: AppStyles.cardShape.copyWith(
          side: BorderSide(
            color: AppStyles.accentPink.withValues(alpha: 0.38),
            width: 1.6,
          ),
        ),
        elevation: 0,
        color: AppStyles.accentPink.withValues(alpha: 0.08),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  TagDerAchtsamkeitSeite(daten: AppDaten.tagDerAchtsamkeit),
            ),
          ),
          child: Padding(
            padding: AppStyles.cardPadding,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppStyles.accentPink, AppStyles.accentCoral],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppStyles.accentPink.withValues(alpha: 0.24),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.spa, color: Colors.white),
                ),
                AppStyles.spacingMHorizontal,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tag der Achtsamkeit',
                        style: AppStyles.subTitleStyle.copyWith(
                          color: AppStyles.accentPink,
                          fontWeight: AppStyles.fontWeightBold,
                        ),
                      ),
                      AppStyles.spacingXSBox,
                      Text(
                        '${AppDaten.tagDerAchtsamkeit['datum']} · ${AppDaten.tagDerAchtsamkeit['uhrzeit']}',
                        style: AppStyles.bodyStyle.copyWith(
                          color: AppStyles.accentPink.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      AppStyles.spacingXSBox,
                      Text(
                        'Vertiefungstag mit längerer gemeinsamer Praxis.',
                        style: AppStyles.bodyStyle.copyWith(
                          color: AppStyles.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppStyles.accentPink,
                  size: AppStyles.iconSizeM,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
