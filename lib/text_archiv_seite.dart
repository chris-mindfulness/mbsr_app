import 'package:flutter/material.dart';

import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class TextArchivSeite extends StatelessWidget {
  final List<Map<String, dynamic>> wochenDaten;
  final int? initialWeekNumber;

  const TextArchivSeite({
    super.key,
    required this.wochenDaten,
    this.initialWeekNumber,
  });

  static const Color _readingTextColor = Color(0xFF111827);
  static const Color _readingMetaColor = Color(0xFF374151);

  double _responsiveHorizontalPadding(double width) {
    if (width >= 1400) return 72;
    if (width >= 1100) return 56;
    if (width >= 900) return 40;
    return 24;
  }

  List<Map<String, dynamic>> _sortedWeeks() {
    final sorted = List<Map<String, dynamic>>.from(wochenDaten);
    sorted.sort((a, b) {
      final aNum = int.tryParse('${a['n'] ?? ''}') ?? 0;
      final bNum = int.tryParse('${b['n'] ?? ''}') ?? 0;
      return aNum.compareTo(bNum);
    });
    return sorted;
  }

  List<Map<String, String>> _readingCardsForWeek(Map<String, dynamic> week) {
    final raw = week['readingCards'];
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map((entry) => Map<String, String>.from(entry.cast<String, String>()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final weeks = _sortedWeeks();
    final horizontalPadding = _responsiveHorizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text("Textarchiv", style: AppStyles.headingStyle),
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
      ),
      body: DecorativeBlobs(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppStyles.spacingM,
            horizontalPadding,
            AppStyles.spacingXXL,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: AppStyles.cardPadding,
                      margin: EdgeInsets.only(bottom: AppStyles.spacingL),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppStyles.infoBlue.withValues(alpha: 0.55),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            color: AppStyles.infoBlue,
                            size: 24,
                          ),
                          AppStyles.spacingMHorizontal,
                          Expanded(
                            child: Text(
                              "Hier findest du die Volltexte der Kurswochen. Für den Pilot ist Woche 4 vollständig freigeschaltet, weitere Wochen folgen schrittweise.",
                              style: AppStyles.bodyStyle.copyWith(
                                color: AppStyles.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...weeks.map((week) => _buildWeekEntry(context, week)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekEntry(BuildContext context, Map<String, dynamic> week) {
    final weekNumber = int.tryParse('${week['n'] ?? ''}') ?? 0;
    final title = '${week['t'] ?? 'Kurswoche'}';
    final summary = '${week['readingSummary'] ?? ''}'.trim();
    final cards = _readingCardsForWeek(week);
    final isAvailable = week['archiveEligible'] == true && cards.isNotEmpty;
    final isHighlighted =
        initialWeekNumber != null && weekNumber == initialWeekNumber;
    final isWideLayout = MediaQuery.sizeOf(context).width >= 900;

    if (!isAvailable) {
      return Card(
        margin: EdgeInsets.only(bottom: AppStyles.spacingM),
        elevation: 0,
        color: Colors.white,
        shape: AppStyles.cardShape,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppStyles.spacingL,
            vertical: AppStyles.spacingS,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppStyles.softBrown.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: AppStyles.softBrown.withValues(alpha: 0.55),
              size: 22,
            ),
          ),
          title: Text(
            'Woche $weekNumber: $title',
            style: AppStyles.subTitleStyle,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Volltexte folgen',
              style: AppStyles.smallTextStyle.copyWith(
                color: AppStyles.softBrown.withValues(alpha: 0.65),
              ),
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppStyles.softBrown.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'folgt',
              style: AppStyles.smallTextStyle.copyWith(
                color: AppStyles.softBrown.withValues(alpha: 0.7),
                fontWeight: AppStyles.fontWeightSemiBold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape.copyWith(
        side: BorderSide(
          color: isHighlighted
              ? AppStyles.primaryOrange.withValues(alpha: 0.5)
              : AppStyles.borderColor.withValues(alpha: 0.75),
          width: isHighlighted ? 2.0 : 1.4,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isHighlighted,
          tilePadding: EdgeInsets.symmetric(
            horizontal: AppStyles.spacingL,
            vertical: AppStyles.spacingS,
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            AppStyles.spacingL,
            0,
            AppStyles.spacingL,
            AppStyles.spacingL,
          ),
          iconColor: AppStyles.primaryOrange,
          collapsedIconColor: AppStyles.primaryOrange,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppStyles.primaryOrange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.library_books_outlined,
              color: AppStyles.primaryOrange,
              size: 22,
            ),
          ),
          title: Text(
            'Woche $weekNumber: $title',
            style: AppStyles.subTitleStyle,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Volltext verfügbar',
              style: AppStyles.smallTextStyle.copyWith(
                color: AppStyles.primaryOrange.withValues(alpha: 0.9),
              ),
            ),
          ),
          children: [
            if (summary.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppStyles.primaryOrange.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  summary,
                  style: AppStyles.bodyStyle.copyWith(
                    fontSize: isWideLayout ? 17 : 16,
                    fontWeight: FontWeight.w600,
                    height: 1.72,
                    color: _readingTextColor,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              AppStyles.spacingMBox,
            ],
            ...cards.map(
              (card) => _buildReadingCard(card, isWideLayout: isWideLayout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingCard(
    Map<String, String> card, {
    required bool isWideLayout,
  }) {
    final title = card['title']?.trim() ?? 'Abschnitt';
    final body = card['body']?.trim() ?? '';
    final sourceRef = card['source_ref']?.trim();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppStyles.spacingS),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppStyles.borderColor.withValues(alpha: 0.8),
          width: 1.6,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.subTitleStyle.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: _readingTextColor,
            ),
          ),
          AppStyles.spacingMBox,
          Text(
            body,
            style: AppStyles.bodyStyle.copyWith(
              fontSize: isWideLayout ? 17.5 : 16.5,
              fontWeight: FontWeight.w600,
              height: 1.75,
              color: _readingTextColor,
              letterSpacing: 0.08,
            ),
          ),
          if (sourceRef != null && sourceRef.isNotEmpty) ...[
            AppStyles.spacingSBox,
            Text(
              "Quelle: $sourceRef",
              style: AppStyles.smallTextStyle.copyWith(
                fontSize: 13,
                color: _readingMetaColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
