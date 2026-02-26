import 'package:flutter/material.dart';

import '../core/app_styles.dart';

class WeeklyReadingSection extends StatelessWidget {
  final List<Map<String, String>> readingCards;
  final String? readingSummary;
  final bool archiveEligible;
  final VoidCallback onOpenArchive;
  final bool readabilityPilot;
  final bool showIntroSummary;
  final bool showSourceRef;

  const WeeklyReadingSection({
    super.key,
    required this.readingCards,
    required this.onOpenArchive,
    this.readingSummary,
    this.archiveEligible = false,
    this.readabilityPilot = false,
    this.showIntroSummary = true,
    this.showSourceRef = true,
  });

  double _maxReadingWidth() => 980;

  @override
  Widget build(BuildContext context) {
    if (readingCards.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final bodyFontSize = screenWidth >= 900 ? 17.0 : 17.0;
    final sectionHeaderStyle = AppStyles.bodyStyle.copyWith(
      letterSpacing: 1.2,
      fontWeight: AppStyles.fontWeightSemiBold,
      fontSize: 12,
      color: AppStyles.textMuted,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _maxReadingWidth()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: AppStyles.spacingS),
              child: Text("LESEN (VOLLTEXT)", style: sectionHeaderStyle),
            ),
            AppStyles.spacingMBox,
            if (showIntroSummary &&
                readingSummary != null &&
                readingSummary!.trim().isNotEmpty) ...[
              Container(
                padding: AppStyles.cardPadding,
                margin: EdgeInsets.only(bottom: AppStyles.spacingM),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppStyles.infoBlue.withValues(alpha: 0.45),
                    width: 1.4,
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
                        readingSummary!,
                        style: AppStyles.bodyStyle.copyWith(
                          fontSize: bodyFontSize,
                          fontWeight: AppStyles.fontWeightRegular,
                          color: AppStyles.textDark,
                          height: 1.6,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ...readingCards.map((readingCard) {
              return _buildReadingCard(
                readingCard,
                isWideLayout: screenWidth >= 900,
                showSourceRef: showSourceRef,
              );
            }),
            if (archiveEligible) ...[
              AppStyles.spacingSBox,
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: onOpenArchive,
                  icon: const Icon(Icons.library_books_outlined),
                  label: const Text("Alle Volltexte im Archiv"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReadingCard(
    Map<String, String> readingCard, {
    required bool isWideLayout,
    required bool showSourceRef,
  }) {
    final title = readingCard['title']?.trim() ?? 'Abschnitt';
    final body = readingCard['body']?.trim() ?? '';
    final sourceRef = readingCard['source_ref']?.trim();

    if (body.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape.copyWith(
        side: BorderSide(
          color: AppStyles.borderColor.withValues(alpha: 0.8),
          width: readabilityPilot ? 1.4 : 1.6,
        ),
      ),
      child: Builder(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(
              horizontal: AppStyles.spacingL + 6,
              vertical: AppStyles.spacingS,
            ),
            childrenPadding: EdgeInsets.fromLTRB(
              AppStyles.spacingL + 6,
              AppStyles.spacingM,
              AppStyles.spacingL + 6,
              AppStyles.spacingL + 8,
            ),
            iconColor: AppStyles.primaryOrange,
            collapsedIconColor: AppStyles.textMuted,
            title: Text(
              title,
              style: AppStyles.subTitleStyle.copyWith(
                fontSize: 17,
                color: AppStyles.textDark,
                fontWeight: AppStyles.fontWeightSemiBold,
              ),
            ),
            children: [
              if (readabilityPilot) AppStyles.spacingSBox,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  body,
                  style: AppStyles.bodyStyle.copyWith(
                    fontSize: isWideLayout ? 17.0 : 17.0,
                    fontWeight: AppStyles.fontWeightRegular,
                    height: 1.6,
                    color: AppStyles.textDark,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              if (showSourceRef &&
                  sourceRef != null &&
                  sourceRef.isNotEmpty) ...[
                AppStyles.spacingMBox,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Quelle: $sourceRef",
                    style: AppStyles.smallTextStyle.copyWith(
                      color: AppStyles.textMuted,
                      fontSize: 13,
                      fontWeight: AppStyles.fontWeightRegular,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
