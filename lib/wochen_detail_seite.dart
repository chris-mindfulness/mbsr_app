import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/offline_banner.dart';
import 'app_daten.dart';
import 'audio_service.dart';
import 'widgets/animated_play_button.dart';
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
    final currentWeekIndex =
        int.tryParse(widget.wochenNummer.replaceAll(RegExp(r'[^0-9]'), '')) ??
        1;
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
              icon: const Icon(
                Icons.chevron_left,
                color: AppStyles.softBrown,
                size: 32,
              ),
              onPressed: () => _navigateToWeek(-1),
              tooltip: "Vorherige Woche",
            ),
          if (hasNext)
            IconButton(
              icon: const Icon(
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
                  AppStyles.spacingL,
                  AppStyles.spacingS,
                  AppStyles.spacingL,
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
                          const Icon(
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

                  // PRAXIS (AUDIOS)
                  if (widget.audioRefs != null &&
                      widget.audioRefs!.isNotEmpty) ...[
                    _buildSectionHeader("DEINE PRAXIS DIESE WOCHE"),
                    AppStyles.spacingMBox,
                    if (widget.wochenNummer.contains("1")) ...[
                      Container(
                        padding: AppStyles.cardPadding,
                        margin: EdgeInsets.only(bottom: AppStyles.spacingM),
                        decoration: BoxDecoration(
                          color: AppStyles.infoBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppStyles.infoBlue.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppStyles.infoBlue,
                              size: 24,
                            ),
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
                    ..._getAudiosForWeek().map(
                      (audio) => _buildAudioCard(audio),
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  // BODY-SCAN TIPPS (nur Woche 1)
                  if (widget.wochenNummer.contains("1")) ...[
                    _buildBodyScanTipps(),
                    AppStyles.spacingXLBox,
                  ],

                  // SITZMEDITATION TIPPS (nur Woche 4)
                  if (widget.wochenNummer.contains("4")) ...[
                    _buildSitzmeditationTipps(),
                    AppStyles.spacingXLBox,
                  ],

                  // ACHTSAME BEWEGUNG TIPPS (nur Woche 3)
                  if (widget.wochenNummer.contains("3")) ...[
                    _buildBewegungTipps(),
                    AppStyles.spacingXLBox,
                  ],

                  // ALLTAGSTIPP
                  if (widget.alltagsTipp != null) ...[
                    _buildSectionHeader("FÜR DEN ALLTAG"),
                    AppStyles.spacingMBox,
                    Container(
                      padding: AppStyles.cardPadding,
                      decoration: BoxDecoration(
                        color: AppStyles.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppStyles.successGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
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
                  if (widget.reflexionsFragen != null &&
                      widget.reflexionsFragen!.isNotEmpty) ...[
                    _buildSectionHeader("REFLEXION"),
                    AppStyles.spacingMBox,
                    ...widget.reflexionsFragen!.map(
                      (frage) => Padding(
                        padding: EdgeInsets.only(bottom: AppStyles.spacingM),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.edit_note,
                              color: AppStyles.accentPink,
                              size: 24,
                            ),
                            AppStyles.spacingMHorizontal,
                            Expanded(
                              child: Text(
                                frage,
                                style: AppStyles.bodyStyle.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppStyles.spacingXLBox,
                  ],

                  // Wochenaufgaben Sektion
                  if (widget.wochenAufgaben.isNotEmpty) ...[
                    Container(
                      padding: AppStyles.cardPadding,
                      decoration: BoxDecoration(
                        color: AppStyles.primaryOrange.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppStyles.primaryOrange.withValues(alpha: 0.1),
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
                          color: AppStyles.softBrown.withValues(alpha: 0.5),
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
    return allAudios
        .where((audio) => widget.audioRefs!.contains(audio['title']))
        .toList();
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
                  "Kein Problem - einfach weiter.",
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
          _buildBewegungTippBullet("Ruhig atmen können = gute Dosierung."),

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
                  '"Erste Kante": Bis zum ersten Signal, dann bleiben oder zurück.',
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
                  "Vergleichen auftaucht? Kurz merken, zurück zu Empfindungen.",
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
                  "Kein Problem - einfach weiter.",
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: AppStyles.spacingS),
      child: Text(
        title,
        style: AppStyles.bodyStyle.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: AppStyles.softBrown.withValues(alpha: 0.8),
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
                                color: AppStyles.softBrown.withValues(alpha: 0.6),
                              ),
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
                  color: AppStyles.softBrown.withValues(alpha: 0.1),
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
