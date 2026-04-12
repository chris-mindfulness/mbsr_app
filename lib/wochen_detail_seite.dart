import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'audio_service.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/notfall_koffer_sheet.dart';
import 'widgets/offline_banner.dart';
import 'app_daten.dart';
import 'widgets/avatar_audio_clip.dart';
import 'widgets/pdf_link_card.dart';
import 'widgets/weekly_reading_section.dart';
import 'widgets/section_header_label.dart';
import 'text_archiv_seite.dart';

class WochenDetailSeite extends StatefulWidget {
  final String wochenNummer;
  final String titel;
  final List<Map<String, String>> pdfs;
  final List<String> wochenAufgaben;
  final String? fokus;
  final String? zitat;
  final String? zitatAutor;
  final String? alltagsTipp;
  final List<String>? reflexionsFragen;
  final String? teaser;
  final String? einfuehrung;
  final List<Map<String, String>> readingCards;
  final String? readingSummary;
  final bool archiveEligible;
  final String? avatarImage;
  /// Kein Wochen-Illustrationsbild (z. B. bis passende Motive vorliegen).
  final bool wochenAvatarAusblenden;
  final Map<String, dynamic>? infoClips;
  /// Öffnet den Mediathek-Tab im Kursbereich (von der verschachtelten Route aus).
  final VoidCallback? onOpenMediathek;

  /// Ersetzt die App-Bar-Anzeige „Woche n“ (z. B. „Block 1 von 2“). [wochenNummer] bleibt „Woche 9“ für die Navigation.
  final String? wochenKopfzeile;

  const WochenDetailSeite({
    super.key,
    required this.wochenNummer,
    required this.titel,
    required this.pdfs,
    this.wochenAufgaben = const [],
    this.fokus,
    this.zitat,
    this.zitatAutor,
    this.alltagsTipp,
    this.reflexionsFragen,
    this.teaser,
    this.einfuehrung,
    this.readingCards = const [],
    this.readingSummary,
    this.archiveEligible = false,
    this.avatarImage,
    this.wochenAvatarAusblenden = false,
    this.infoClips,
    this.onOpenMediathek,
    this.wochenKopfzeile,
  });

  @override
  State<WochenDetailSeite> createState() => _WochenDetailSeiteState();
}

class _WochenDetailSeiteState extends State<WochenDetailSeite> {
  final AudioService _audioService = AudioService();

  late final int _currentWeekIndex;

  @override
  void initState() {
    super.initState();
    _currentWeekIndex = int.tryParse(
          widget.wochenNummer.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        1;
  }

  double _responsiveHorizontalPadding(double width) {
    if (width >= 1400) return 72;
    if (width >= 1100) return 56;
    if (width >= 900) return 40;
    return 24;
  }

  double _contentMaxWidth(double width) {
    if (width >= 1700) return 1100;
    if (width >= 1200) return 980;
    return width;
  }

  static const double _weekBannerQuoteBreakpoint = 640;

  /// Wochenbild + Zitat als eine Kachel (mobil gestapelt, breiter Bildschirm: nebeneinander).
  Widget _buildWeekAvatarBanner({
    required bool neutralSurface,
    required double layoutWidth,
  }) {
    if (widget.wochenAvatarAusblenden) {
      return const SizedBox.shrink();
    }
    final path = widget.avatarImage ?? AppDaten.defaultWeekAvatarAsset;
    final quote = widget.zitat;
    final hasQuote = quote != null && quote.trim().isNotEmpty;

    Widget imageArea({required double height, required bool roundTopOnly}) {
      final radius = BorderRadius.vertical(
        top: const Radius.circular(20),
        bottom: roundTopOnly ? Radius.zero : const Radius.circular(20),
      );
      return ClipRRect(
        borderRadius: radius,
        child: Container(
          width: double.infinity,
          height: height,
          color: AppStyles.softBrown.withValues(alpha: 0.06),
          alignment: Alignment.center,
          child: Image.asset(
            path,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.self_improvement_rounded,
                size: 72,
                color: AppStyles.softBrown.withValues(alpha: 0.35),
              );
            },
          ),
        ),
      );
    }

    if (!hasQuote) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300, maxHeight: 220),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  path,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.self_improvement_rounded,
                        size: 72,
                        color: AppStyles.softBrown.withValues(alpha: 0.35),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    final cardMaxW = math.min(layoutWidth, 520.0);
    final sideBySide = layoutWidth >= _weekBannerQuoteBreakpoint;

    final quoteStripColor = neutralSurface
        ? AppStyles.softBrown.withValues(alpha: 0.07)
        : AppStyles.softBrown.withValues(alpha: 0.1);
    final dividerColor = AppStyles.softBrown.withValues(alpha: 0.14);

    Widget quoteContent({bool scrollable = false}) {
      final column = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppStyles.softBrown.withValues(alpha: 0.85),
            size: 28,
          ),
          SizedBox(height: AppStyles.spacingS),
          Text(
            quote.trim(),
            textAlign: TextAlign.center,
            style: AppStyles.decorativeTextStyle.copyWith(
              fontSize: 17,
              height: 1.55,
            ),
          ),
          if (widget.zitatAutor != null) ...[
            SizedBox(height: AppStyles.spacingM),
            Text(
              '— ${widget.zitatAutor}',
              textAlign: TextAlign.center,
              style: AppStyles.smallTextStyle.copyWith(
                fontWeight: AppStyles.fontWeightSemiBold,
                color: AppStyles.softBrown,
              ),
            ),
          ],
        ],
      );
      // Volle Breite nötig: sonst schrumpft der graue Streifen auf die Textbreite
      // (Column mit crossAxisAlignment.center + kurzem Zitat).
      final padded = Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: SizedBox(
          width: double.infinity,
          child: column,
        ),
      );
      if (!scrollable) return padded;
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: SizedBox(
          width: double.infinity,
          child: column,
        ),
      );
    }

    final outerDecoration = neutralSurface
        ? BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppStyles.borderColor.withValues(alpha: 0.7),
              width: 1.2,
            ),
            boxShadow: AppStyles.softCardShadow,
          )
        : BoxDecoration(
            color: AppStyles.softBrown.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppStyles.softBrown.withValues(alpha: 0.18),
              width: 1.2,
            ),
            boxShadow: AppStyles.softCardShadow,
          );

    final Widget bannerCore = sideBySide
        ? SizedBox(
            height: 232,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Container(
                      color: AppStyles.softBrown.withValues(alpha: 0.06),
                      alignment: Alignment.center,
                      child: Image.asset(
                        path,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.self_improvement_rounded,
                            size: 64,
                            color: AppStyles.softBrown.withValues(alpha: 0.35),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: quoteStripColor,
                      border: Border(
                        left: BorderSide(color: dividerColor, width: 1),
                      ),
                    ),
                    child: Center(child: quoteContent(scrollable: true)),
                  ),
                ),
              ],
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              imageArea(height: 200, roundTopOnly: true),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: quoteStripColor,
                  border: Border(top: BorderSide(color: dividerColor, width: 1)),
                ),
                child: quoteContent(scrollable: false),
              ),
            ],
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: cardMaxW),
            child: Container(
              decoration: outerDecoration,
              clipBehavior: Clip.antiAlias,
              child: bannerCore,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  /// Nur Notfall-Koffer: direktes Abspielen (Sonderstatus), sonst Mediathek.
  void _playNotfallAudio(Map<String, String> audio) {
    if (audio['upload_status'] == 'pending') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Diese Übung ist noch nicht als Audio bereit — folgt nach dem Upload.',
              style: AppStyles.bodyStyle,
            ),
            backgroundColor: AppStyles.softBrown,
          ),
        );
      }
      return;
    }

    HapticFeedback.lightImpact();
    unawaited(_invokeNotfallPlay(audio));
  }

  Future<void> _invokeNotfallPlay(Map<String, String> audio) async {
    try {
      await _audioService.play(audio);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fehler beim Laden des Audios. Bitte Internetverbindung prüfen.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showNotfallKofferSheet() {
    NotfallKofferSheet.show(
      context,
      onPlayNotfallAudio: _playNotfallAudio,
    );
  }

  Widget _buildTintedCard({
    required Widget child,
    required Color accentColor,
    double fillAlpha = 0.08,
    double borderAlpha = 0.24,
    double radius = 24,
    double borderWidth = 1.2,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding ?? AppStyles.cardPadding,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: fillAlpha),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: accentColor.withValues(alpha: borderAlpha),
          width: borderWidth,
        ),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: child,
    );
  }

  Widget _buildNeutralAccentCard({
    required Widget child,
    required Color accentColor,
    double radius = 24,
    double borderWidth = 1.2,
    EdgeInsetsGeometry? padding,
  }) {
    final baseBorderColor = AppStyles.borderColor.withValues(alpha: 0.7);
    final contentPadding = padding ?? AppStyles.cardPadding;

    return Container(
      padding: contentPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: baseBorderColor, width: borderWidth),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 4,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: AppStyles.spacingM),
          child,
        ],
      ),
    );
  }

  Widget _buildAdaptiveCard({
    required Widget child,
    required Color accentColor,
    required bool neutralSurface,
    double fillAlpha = 0.08,
    double borderAlpha = 0.24,
    double radius = 24,
    double borderWidth = 1.2,
    EdgeInsetsGeometry? padding,
  }) {
    if (neutralSurface) {
      return _buildNeutralAccentCard(
        child: child,
        accentColor: accentColor,
        radius: radius,
        borderWidth: borderWidth,
        padding: padding,
      );
    }
    return _buildTintedCard(
      child: child,
      accentColor: accentColor,
      fillAlpha: fillAlpha,
      borderAlpha: borderAlpha,
      radius: radius,
      borderWidth: borderWidth,
      padding: padding,
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
                "Nimm dir einen ruhigen Atemzug und spüre kurz deine Füße.",
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

  Widget _buildWeekSupportTipps(int weekIndex, {bool neutralSurface = false}) {
    final config = _getWeekSupportConfig(weekIndex);
    if (config == null) {
      return const SizedBox.shrink();
    }

    final accentColor = config['color'] as Color;
    final sections = List<Map<String, dynamic>>.from(config['sections']);

    return _buildAdaptiveCard(
      accentColor: accentColor,
      neutralSurface: neutralSurface,
      fillAlpha: 0.08,
      borderAlpha: 0.24,
      radius: 24,
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
            child: Text(text, style: AppStyles.bodyStyle.copyWith(height: 1.6)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Navigation Logic
    final currentWeekIndex = _currentWeekIndex;
    final isReadabilityPilot = currentWeekIndex == 4;
    final maxWoche = AppDaten.hoechsteKurswocheNumerisch;
    final useCleanCardsForWeeks =
        currentWeekIndex >= 1 && currentWeekIndex <= maxWoche;
    final hasPrev =
        AppDaten.vorherigeFreigegebeneWocheVor(currentWeekIndex) != null;
    final hasNext =
        AppDaten.naechsteFreigegebeneWocheNach(currentWeekIndex) != null;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = _responsiveHorizontalPadding(screenWidth);
    final contentMaxWidth = _contentMaxWidth(screenWidth);
    final bannerLayoutWidth = math.min(
      contentMaxWidth,
      screenWidth - 2 * horizontalPadding,
    );

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          widget.wochenKopfzeile ?? widget.wochenNummer,
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
          // Notfall-Koffer – immer erreichbar, unabhaengig vom Scroll-Stand.
          IconButton(
            icon: Icon(
              Icons.support_agent,
              color: AppStyles.errorRed.withValues(alpha: 0.85),
              size: 22,
            ),
            onPressed: _showNotfallKofferSheet,
            tooltip: "Notfall-Koffer",
          ),
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
              message: 'Offline – Audios können nicht geladen werden',
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
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ═══════════════════════════════════
                          // ANKOMMEN
                          // ═══════════════════════════════════

                          // ── 1. TITEL ──
                          Text(widget.titel, style: AppStyles.titleStyle),
                          AppStyles.spacingMBox,

                          // ── 2. AVATAR-BANNER (+ Zitat als eine Kachel) ──
                          _buildWeekAvatarBanner(
                            neutralSurface: useCleanCardsForWeeks,
                            layoutWidth: bannerLayoutWidth,
                          ),

                          // ── 3. EINFÜHRUNGSTEXT (Kurz-Audios: nur Mediathek) ──
                          if (widget.einfuehrung != null ||
                              widget.teaser != null)
                            Text(
                              widget.einfuehrung ?? widget.teaser!,
                              style: AppStyles.bodyStyle.copyWith(
                                color: AppStyles.textDark,
                              ),
                            ),
                          AppStyles.spacingXLBox,

                          // ═══════════════════════════════════
                          // PLAN – „Was mache ich diese Woche?"
                          // ═══════════════════════════════════

                          // ── 5. WOCHENAUFGABEN ──
                          if (widget.wochenAufgaben.isNotEmpty) ...[
                            _buildAdaptiveCard(
                              accentColor: AppStyles.primaryOrange,
                              neutralSurface: useCleanCardsForWeeks,
                              fillAlpha: 0.05,
                              borderAlpha: 0.14,
                              radius: 28,
                              borderWidth: 1.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.assignment_outlined,
                                        color: AppStyles.primaryOrange,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width:
                                            AppStyles.spacingM -
                                            AppStyles.spacingS,
                                      ),
                                      Text(
                                        "Wochenaufgaben",
                                        style: AppStyles.headingStyle.copyWith(
                                          fontSize: 18,
                                          color: AppStyles.primaryOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        AppStyles.spacingL - AppStyles.spacingS,
                                  ),
                                  ...widget.wochenAufgaben.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final aufgabe = entry.value;
                                    final isKernuebung = index == 0;
                                    Widget aufgabeRow = Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 2,
                                          ),
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            color: AppStyles.sageGreen,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              AppStyles.spacingM -
                                              AppStyles.spacingS,
                                        ),
                                        Expanded(
                                          child: Text(
                                            aufgabe,
                                            style: AppStyles.bodyStyle.copyWith(
                                              height: 1.6,
                                              fontWeight:
                                                  AppStyles.fontWeightRegular,
                                              color: AppStyles.textDark,
                                              fontSize:
                                                  AppStyles.bodyStyle.fontSize,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                    if (isKernuebung) {
                                      aufgabeRow = Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.fromLTRB(
                                          14,
                                          12,
                                          14,
                                          12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppStyles.primaryOrange
                                              .withValues(alpha: 0.07),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border(
                                            left: BorderSide(
                                              color: AppStyles.primaryOrange
                                                  .withValues(alpha: 0.85),
                                              width: 3,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Kernübung diese Woche',
                                              style: AppStyles.smallTextStyle
                                                  .copyWith(
                                                    fontWeight: AppStyles
                                                        .fontWeightSemiBold,
                                                    color:
                                                        AppStyles.primaryOrange,
                                                    letterSpacing: 0.2,
                                                  ),
                                            ),
                                            SizedBox(height: AppStyles.spacingS),
                                            aufgabeRow,
                                          ],
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: AppStyles.spacingM,
                                      ),
                                      child: aufgabeRow,
                                    );
                                  }),
                                  SizedBox(height: AppStyles.spacingM),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.library_music_outlined,
                                        color: AppStyles.softBrown.withValues(
                                          alpha: 0.85,
                                        ),
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width:
                                            AppStyles.spacingM -
                                            AppStyles.spacingS,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Alle geführten Audioübungen findest du in der Mediathek.',
                                          style: AppStyles.bodyStyle.copyWith(
                                            height: 1.55,
                                            color: AppStyles.textDark,
                                            fontWeight:
                                                AppStyles.fontWeightRegular,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.onOpenMediathek != null) ...[
                                    SizedBox(height: AppStyles.spacingS),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton.icon(
                                        onPressed: widget.onOpenMediathek,
                                        icon: Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 18,
                                          color: AppStyles.softBrown,
                                        ),
                                        label: Text(
                                          'Zur Mediathek',
                                          style: AppStyles.bodyStyle.copyWith(
                                            fontWeight:
                                                AppStyles.fontWeightSemiBold,
                                            color: AppStyles.softBrown,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 4,
                                          ),
                                          foregroundColor: AppStyles.softBrown,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(
                              height: AppStyles.spacingXL + AppStyles.spacingS,
                            ),
                          ],

                          // ═══════════════════════════════════
                          // PRAXIS – Tipps zum Üben (Audios: Mediathek)
                          // ═══════════════════════════════════

                          if (currentWeekIndex <= 2) ...[
                            if (widget.wochenAufgaben.isNotEmpty)
                              AppStyles.spacingMBox,
                            Container(
                              margin: EdgeInsets.only(
                                bottom: AppStyles.spacingM,
                              ),
                              child: _buildAdaptiveCard(
                                accentColor: AppStyles.infoBlue,
                                neutralSurface: useCleanCardsForWeeks,
                                fillAlpha: 0.1,
                                borderAlpha: 0.3,
                                radius: 20,
                                borderWidth: 1.0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: AppStyles.infoBlue,
                                      size: 24,
                                    ),
                                    AppStyles.spacingMHorizontal,
                                    Expanded(
                                      child: Text(
                                        'In der Mediathek findest du mehrere '
                                        'Body-Scan-Anleitungen in unterschiedlichen '
                                        'Längen und mit verschiedenen Stimmen — '
                                        'such dir aus, was zu dir passt.',
                                        style: AppStyles.bodyStyle.copyWith(
                                          fontSize:
                                              AppStyles.bodyStyle.fontSize,
                                          color: AppStyles.textDark,
                                          fontWeight:
                                              AppStyles.fontWeightRegular,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _buildBodyScanTipps(
                              neutralSurface: useCleanCardsForWeeks,
                            ),
                            AppStyles.spacingXLBox,
                          ],
                          if (currentWeekIndex == 3) ...[
                            if (widget.wochenAufgaben.isNotEmpty)
                              AppStyles.spacingMBox,
                            _buildBewegungTipps(
                              neutralSurface: useCleanCardsForWeeks,
                            ),
                            AppStyles.spacingXLBox,
                          ],
                          if (currentWeekIndex == 4) ...[
                            if (widget.wochenAufgaben.isNotEmpty)
                              AppStyles.spacingMBox,
                            _buildSitzmeditationTipps(
                              neutralSurface: useCleanCardsForWeeks,
                            ),
                            AppStyles.spacingXLBox,
                          ],

                          // ── 7. FÜR DEN ALLTAG ──
                          if (widget.alltagsTipp != null) ...[
                            _buildSectionHeader("FÜR DEN ALLTAG"),
                            AppStyles.spacingMBox,
                            _buildAdaptiveCard(
                              accentColor: AppStyles.successGreen,
                              neutralSurface: useCleanCardsForWeeks,
                              fillAlpha: 0.1,
                              borderAlpha: 0.3,
                              radius: 20,
                              borderWidth: 1.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: AppStyles.successGreen,
                                    size: 28,
                                  ),
                                  AppStyles.spacingMHorizontal,
                                  Expanded(
                                    child: Text(
                                      widget.alltagsTipp!,
                                      style: AppStyles.bodyStyle.copyWith(
                                        color: AppStyles.textDark,
                                        height: 1.6,
                                        fontSize: AppStyles.bodyStyle.fontSize,
                                        fontWeight: AppStyles.fontWeightRegular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppStyles.spacingXLBox,
                          ],

                          // ═══════════════════════════════════
                          // VERTIEFUNG – für Neugierige
                          // ═══════════════════════════════════

                          // ── 8. FOKUS (Zitat oben im Avatar-Banner) ──
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

                          // Intro-Clip direkt unter Bild/Zitat.
                          if (widget.infoClips != null) ...[
                            _buildInfoClipWidget(
                              key: 'begruessung',
                              label: 'Begrüßung zur Woche',
                            ),
                            AppStyles.spacingXLBox,
                          ],

                          // ── 9. PSYCHOEDUKATION (ReadingCards) ──
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

                          // ── 11. SUPPORT-TIPPS (nur Woche 5–8) ──
                          if (currentWeekIndex >= 5 &&
                              currentWeekIndex <= 8) ...[
                            _buildWeekSupportTipps(
                              currentWeekIndex,
                              neutralSurface: useCleanCardsForWeeks,
                            ),
                            AppStyles.spacingXLBox,
                          ],

                          // ── 12. REFLEXION ──
                          if (widget.reflexionsFragen != null &&
                              widget.reflexionsFragen!.isNotEmpty) ...[
                            _buildSectionHeader("REFLEXION"),
                            AppStyles.spacingMBox,
                            ...widget.reflexionsFragen!.map(
                              (frage) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppStyles.spacingM,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.edit_note,
                                      color: AppStyles.accentPink,
                                      size: 24,
                                    ),
                                    AppStyles.spacingMHorizontal,
                                    Expanded(
                                      child: Text(
                                        frage,
                                        style: AppStyles.bodyStyle.copyWith(
                                          fontStyle: FontStyle.normal,
                                          color: AppStyles.textDark,
                                          fontSize:
                                              AppStyles.bodyStyle.fontSize,
                                          fontWeight:
                                              AppStyles.fontWeightRegular,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AppStyles.spacingXLBox,
                          ],

                          // ═══════════════════════════════════
                          // REFERENZ
                          // ═══════════════════════════════════

                          // ── 13. UNTERLAGEN (PDFs) ──
                          if (widget.pdfs.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildSectionHeader("UNTERLAGEN"),
                            ),
                            ..._buildUnterlagenPdfWidgets(),
                            const SizedBox(height: 40),
                          ],
                        ],
                      ),
                    ),
                  ),
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

  Map<String, dynamic>? _clipByKey(String key) {
    final clips = widget.infoClips;
    if (clips == null) return null;
    final raw = clips[key];
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  Widget _buildInfoClipWidget({
    required String key,
    required String label,
  }) {
    final clip = _clipByKey(key);
    final id = clip?['appwrite_id']?.toString();
    final duration = clip?['duration']?.toString();
    return Center(
      child: AvatarAudioClip(
        appwriteId: id,
        label: label,
        durationHint: duration,
      ),
    );
  }

  void _navigateToWeek(int direction) {
    final int? nextWeekIndex = direction > 0
        ? AppDaten.naechsteFreigegebeneWocheNach(_currentWeekIndex)
        : AppDaten.vorherigeFreigegebeneWocheVor(_currentWeekIndex);

    if (nextWeekIndex == null) return;

    final nextWeekData = AppDaten.wochenDaten.firstWhere(
      (w) => w['n'] == nextWeekIndex.toString(),
      orElse: () => {},
    );

    if (nextWeekData.isEmpty) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WochenDetailSeite(
          wochenNummer: "Woche ${nextWeekData['n']}",
          wochenKopfzeile: nextWeekData['wochenKopfzeile'] as String?,
          titel: nextWeekData['t'],
          pdfs: AppDaten.pdfMapsFromRaw(nextWeekData['pdfs'] as List<dynamic>?),
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
          teaser: nextWeekData['teaser'],
          einfuehrung: nextWeekData['einfuehrung'],
          readingCards: _extractReadingCards(nextWeekData),
          readingSummary: nextWeekData['readingSummary'] as String?,
          archiveEligible: nextWeekData['archiveEligible'] == true,
          avatarImage: nextWeekData['avatarImage'] as String?,
          wochenAvatarAusblenden:
              nextWeekData['wochenAvatarAusblenden'] == true,
          infoClips: nextWeekData['infoClips'] as Map<String, dynamic>?,
          onOpenMediathek: widget.onOpenMediathek,
        ),
      ),
    );
  }

  // ============================================
  // BODY-SCAN TIPPS (Woche 1–2)
  // ============================================
  Widget _buildBodyScanTipps({bool neutralSurface = false}) {
    return _buildAdaptiveCard(
      accentColor: AppStyles.accentCyan,
      neutralSurface: neutralSurface,
      fillAlpha: 0.08,
      borderAlpha: 0.2,
      radius: 24,
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
            "Du liegst da und wanderst mit der Aufmerksamkeit durch deinen Körper. Nicht um etwas zu verändern, sondern um wahrzunehmen, was gerade da ist.",
            style: AppStyles.bodyStyle.copyWith(height: 1.6),
          ),
          AppStyles.spacingLBox,

          // Orientierung
          Text(
            "Orientierung",
            style: AppStyles.subTitleStyle.copyWith(color: AppStyles.textDark),
          ),
          AppStyles.spacingSBox,
          _buildTippBullet(
            "Abschweifen gehört dazu. Zurückkommen ist die Übung.",
          ),
          _buildTippBullet(
            "Gedanken tauchen auf — bemerke sie und kehre sanft zurück.",
          ),
          _buildTippBullet(
            "Regelmäßig üben zählt mehr als perfekt üben.",
          ),
          _buildTippBullet(
            "Lass Erwartungen los. Schau, was passiert.",
          ),
          _buildTippBullet(
            "Auch Unangenehmes darf da sein — du musst nicht dagegen ankämpfen.",
          ),

          AppStyles.spacingMBox,

          // Merksatz
          Container(
            padding: EdgeInsets.all(AppStyles.spacingM),
            decoration: BoxDecoration(
              color: neutralSurface
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: neutralSurface
                  ? Border.all(
                      color: AppStyles.borderColor.withValues(alpha: 0.55),
                      width: 1.0,
                    )
                  : null,
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
                    "Es geht nicht darum, etwas zu erreichen — sondern zu bemerken, was schon da ist.",
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
                  "Passiert allen, immer wieder — das ist völlig normal.",
                  "Dass du es bemerkst, ist bereits Achtsamkeit.",
                  "Komm freundlich zurück, ohne dich zu bewerten.",
                ]),
                _buildTippSektion("Schläfrigkeit", [
                  "Öffne die Augen leicht.",
                  "Nimm ein paar tiefere Atemzüge.",
                  "Verändere die Position oder übe im Sitzen.",
                ]),
                _buildTippSektion("Unruhe", [
                  "Kleine Bewegungen sind erlaubt — schlucken, Schultern lösen.",
                  "Du musst nicht verkrampft stillhalten.",
                  "Nimm die Unruhe wahr, statt sie wegzudrücken.",
                ]),
                _buildTippSektion("Schmerz / Unwohlsein", [
                  "Erkunde statt zu ertragen: Was genau spürst du?",
                  "Position anpassen ist jederzeit okay.",
                  "Weite den Fokus — ganzer Körper, Geräusche — oder wähle einen neutralen Anker.",
                ]),
                _buildTippSektion("Nichts spüren", [
                  "Auch neutral oder taub ist eine Erfahrung.",
                  "Spüre die Kontaktpunkte: Wo liegt dein Körper auf?",
                  "Wenn es sich abgeschnitten anfühlt: Augen öffnen, im Raum orientieren, dann neu entscheiden.",
                ]),
                _buildTippSektion("Erwartungen", [
                  "Es gibt kein richtig oder falsch.",
                  "Ziel ist nicht, Gedanken zu steuern — sondern sie zu bemerken.",
                  "Jede Übung ist anders. Vergleichen bringt nichts.",
                ]),
                _buildTippSektion("Dranbleiben", [
                  "Ein festes Zeitfenster hilft.",
                  "Wiederholung ist Lernen, nicht Langeweile.",
                  "Wenn du magst: eine kurze Notiz nach der Übung — was war da?",
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
            child: Text(text, style: AppStyles.bodyStyle.copyWith(height: 1.6)),
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
  Widget _buildSitzmeditationTipps({bool neutralSurface = false}) {
    return _buildAdaptiveCard(
      accentColor: AppStyles.accentPink,
      neutralSurface: neutralSurface,
      fillAlpha: 0.08,
      borderAlpha: 0.2,
      radius: 24,
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
            "Du sitzt, spürst den Atem und bist da. Nicht mehr, nicht weniger. Von dort aus öffnest du dich schrittweise für alles, was auftaucht.",
            style: AppStyles.bodyStyle.copyWith(height: 1.6),
          ),
          AppStyles.spacingLBox,

          // Orientierung
          Text(
            "Orientierung",
            style: AppStyles.subTitleStyle.copyWith(color: AppStyles.textDark),
          ),
          AppStyles.spacingSBox,
          _buildSitzTippBullet(
            "Spüre den Atem — an Bauch, Brust oder Nase — ohne ihn zu steuern.",
          ),
          _buildSitzTippBullet(
            "Abschweifen ist normal. Bemerken, zurückkehren — das ist die Übung.",
          ),
          _buildSitzTippBullet(
            "Regelmäßigkeit zählt mehr als Dauer.",
          ),
          _buildSitzTippBullet(
            "Nimm wahr, was im Vordergrund steht, ohne daran festzuhalten.",
          ),
          _buildSitzTippBullet(
            "Auch Unruhe und Langeweile gehören dazu.",
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
                  "Passiert allen, immer wieder — völlig normal.",
                  "Benenne kurz, was da war — Planen, Erinnern — und komm zurück.",
                  "Die Rückkehr ist der Übungsmoment, nicht das Stillsein.",
                ]),
                _buildSitzTippSektion("Schläfrigkeit", [
                  "Öffne die Augen leicht, richte die Wirbelsäule auf.",
                  "Nimm ein paar tiefere Atemzüge.",
                  "Setz dich aufrechter hin — das allein verändert oft viel.",
                ]),
                _buildSitzTippSektion("Unruhe", [
                  "Kleine Bewegungen sind erlaubt — Schultern lösen, schlucken.",
                  "Spüre die Kontaktpunkte: Sitzfläche, Füße, Hände.",
                  "Nimm die Unruhe wahr, statt sie wegzudrücken.",
                ]),
                _buildSitzTippSektion("Atem zu subtil / Atem steuern", [
                  "Atem kaum spürbar? Kontaktpunkte als Anker nutzen.",
                  "Du steuerst den Atem? Lass ihn einfach von selbst kommen.",
                  "Nur mitspüren, nicht machen. Dein Körper atmet von allein.",
                ]),
                _buildSitzTippSektion("Offenes Gewahrsein", [
                  "Stufenweise öffnen: Atem, Körper, Geräusche, offenes Feld.",
                  "Nimm wahr, was gerade am deutlichsten da ist.",
                  "Zu weit? Kurz zurück zum Atem, dann wieder öffnen.",
                ]),
                _buildSitzTippSektion("Erwartungen", [
                  "Es gibt kein richtig oder falsch.",
                  "Ziel ist nicht, ruhig zu werden — sondern zu bemerken.",
                  "Jede Übung ist anders. Vergleichen bringt nichts.",
                ]),
                _buildSitzTippSektion("Dranbleiben", [
                  "Ein festes Zeitfenster hilft.",
                  "Wiederholung ist Lernen, nicht Langeweile.",
                  "Wenn du magst: eine kurze Notiz nach der Übung — was war da?",
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
            child: Text(text, style: AppStyles.bodyStyle.copyWith(height: 1.6)),
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
  Widget _buildBewegungTipps({bool neutralSurface = false}) {
    return _buildAdaptiveCard(
      accentColor: AppStyles.sageGreen,
      neutralSurface: neutralSurface,
      fillAlpha: 0.12,
      borderAlpha: 0.25,
      radius: 24,
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
            "Du erkundest deinen Körper in Bewegung — nicht an einem Ideal gemessen, sondern so, wie er heute ist.",
            style: AppStyles.bodyStyle.copyWith(height: 1.6),
          ),
          AppStyles.spacingLBox,

          // Orientierung
          Text(
            "Orientierung",
            style: AppStyles.subTitleStyle.copyWith(color: AppStyles.textDark),
          ),
          AppStyles.spacingSBox,
          _buildBewegungTippBullet(
            "Weniger ist oft mehr — sanft, klein und langsam statt zu viel.",
          ),
          _buildBewegungTippBullet(
            "Deine Grenzen geben Orientierung. Respektiere sie.",
          ),
          _buildBewegungTippBullet(
            "Spüre Kontakt, Dehnung, Wärme — ohne zu bewerten.",
          ),
          _buildBewegungTippBullet(
            "Pausen gehören dazu. Jederzeit stoppen ist okay.",
          ),
          _buildBewegungTippBullet(
            "Wenn du ruhig weiteratmen kannst, passt die Intensität.",
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
                    "Es geht nicht darum, irgendwo anzukommen — sondern zu spüren, wo du gerade bist.",
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
                  "Geh bis zum ersten deutlichen Körpersignal — bleib dort oder geh etwas zurück.",
                  "Kannst du dabei ruhig atmen? Wenn nein: weniger machen.",
                  "Nutze Variationen: kleinerer Radius, langsamer, stabiler.",
                ]),
                _buildBewegungTippSektion("Schmerz / Unwohlsein", [
                  "Erkunde statt zu ertragen: Dehnreiz ist okay, stechend nicht.",
                  "Bei stechendem Schmerz: sofort raus, Position anpassen.",
                  "Unsicher? Weniger machen oder die Übung auslassen.",
                ]),
                _buildBewegungTippSektion("Erwartungen", [
                  "Es gibt kein richtig oder falsch. Jede Variation zählt.",
                  "Vergleichen taucht auf? Kurz bemerken, dann zurück zum Spüren.",
                  "Jede Übung ist anders. Vergleichen bringt nichts.",
                ]),
                _buildBewegungTippSektion("Unruhe", [
                  "Verlangsame absichtlich — halbe Geschwindigkeit.",
                  "Spüre die Kontaktpunkte: Füße, Hände, Boden.",
                  "Nimm die Unruhe wahr, statt sie wegzudrücken.",
                ]),
                _buildBewegungTippSektion("Selbstkritik", [
                  "Selbstkritik ist ein Ereignis — keine Wahrheit.",
                  "Richte den Fokus auf neutrale Daten: Druck, Temperatur, Kontakt.",
                  "Übe so, dass es sicher und würdevoll bleibt.",
                ]),
                _buildBewegungTippSektion("Nichts spüren", [
                  "Auch neutral ist eine Erfahrung.",
                  "Spüre die Kontaktpunkte: Wo berührt dein Körper den Boden?",
                  "Wenn es sich abgeschnitten anfühlt: Augen öffnen, im Raum orientieren, dann neu entscheiden.",
                ]),
                _buildBewegungTippSektion("Dranbleiben", [
                  "Ein festes Zeitfenster hilft.",
                  "Wiederholung ist Lernen, nicht Langeweile.",
                  "Wenn du magst: eine kurze Notiz nach der Übung — was war da?",
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
            child: Text(text, style: AppStyles.bodyStyle.copyWith(height: 1.6)),
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

  Widget _buildSectionHeader(String title) {
    return SectionHeaderLabel(title: title);
  }

  List<Widget> _buildUnterlagenPdfWidgets() {
    final kurs = widget.pdfs
        .where(
          (p) => AppDaten.pdfKindOf(p) == AppDaten.pdfKindKursunterlage,
        )
        .toList();
    final arbeitsblatt = widget.pdfs
        .where(
          (p) => AppDaten.pdfKindOf(p) == AppDaten.pdfKindArbeitsblatt,
        )
        .toList();
    final out = <Widget>[];
    if (kurs.isNotEmpty) {
      out.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildSectionHeader("KURSHEFT"),
        ),
      );
      out.addAll(kurs.map((pdf) => _buildPdfCard(pdf)));
    }
    if (arbeitsblatt.isNotEmpty) {
      out.add(AppStyles.spacingMBox);
      out.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildSectionHeader("ARBEITSBLATT"),
        ),
      );
      out.addAll(arbeitsblatt.map((pdf) => _buildPdfCard(pdf)));
    }
    return out;
  }

  void _openTextArchiv() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextArchivSeite(
          wochenDaten: AppDaten.wochenDaten,
          initialWeekNumber: _currentWeekIndex,
        ),
      ),
    );
  }

  Widget _buildPdfCard(Map<String, String> pdf) {
    final appwriteId = pdf['appwrite_id'];
    final title = pdf['title'] ?? 'PDF';
    final url =
        '${AppConfig.appwriteEndpoint}/storage/buckets/${AppConfig.pdfsBucketId}/files/$appwriteId/view?project=${AppConfig.appwriteProjectId}';
    final isArbeitsblatt =
        AppDaten.pdfKindOf(pdf) == AppDaten.pdfKindArbeitsblatt;
    final blattInfo = pdf['blattInfo']?.trim();
    final hasBlattInfo = blattInfo != null && blattInfo.isNotEmpty;

    final card = PdfLinkCard(
      title: title,
      onTap: () => launchUrl(Uri.parse(url)),
      isPending: false,
      showPendingSubtitle: false,
      leadingIcon: isArbeitsblatt
          ? Icons.edit_note_outlined
          : Icons.description_outlined,
      leadingColor:
          isArbeitsblatt ? AppStyles.primaryOrange : AppStyles.softBrown,
      readyTrailingIcon: Icons.open_in_new,
      pendingTrailingIcon: Icons.schedule,
      layout: PdfCardLayout.row,
      margin: EdgeInsets.only(bottom: hasBlattInfo ? 10 : 16),
    );

    if (!hasBlattInfo) {
      return card;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        card,
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            blattInfo,
            style: AppStyles.smallTextStyle.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }
}
