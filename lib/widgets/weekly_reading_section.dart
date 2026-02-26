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

  static const Color _textStrong = Color(0xFF101418);
  static const Color _textDefault = Color(0xFF171A1D);
  static const Color _textMuted = Color(0xFF2D3742);
  static const Color _primaryReadable = Color(0xFFAD4738);
  static const Color _infoReadable = Color(0xFF4B6F95);

  @override
  Widget build(BuildContext context) {
    if (readingCards.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final bodyFontSize = screenWidth >= 900 ? 18.0 : 17.0;
    final sectionHeaderStyle = readabilityPilot
        ? AppStyles.bodyStyle.copyWith(
            letterSpacing: 1.1,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: _textStrong,
          )
        : AppStyles.bodyStyle.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppStyles.softBrown.withValues(alpha: 0.8),
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
                    color: readabilityPilot
                        ? _infoReadable.withValues(alpha: 0.42)
                        : AppStyles.infoBlue.withValues(alpha: 0.55),
                    width: readabilityPilot ? 1.4 : 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      color: readabilityPilot
                          ? _infoReadable
                          : AppStyles.infoBlue,
                      size: 24,
                    ),
                    AppStyles.spacingMHorizontal,
                    Expanded(
                      child: Text(
                        readingSummary!,
                        style: AppStyles.bodyStyle.copyWith(
                          fontSize: bodyFontSize,
                          fontWeight: readabilityPilot
                              ? FontWeight.w600
                              : FontWeight.w600,
                          color: readabilityPilot ? _textDefault : _textStrong,
                          height: readabilityPilot ? 1.7 : 1.72,
                          letterSpacing: readabilityPilot ? 0.0 : 0.1,
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
              readabilityPilot ? AppStyles.spacingM : AppStyles.spacingS + 4,
              AppStyles.spacingL + 6,
              AppStyles.spacingL + 8,
            ),
            iconColor: readabilityPilot
                ? _primaryReadable
                : AppStyles.primaryOrange,
            collapsedIconColor: readabilityPilot
                ? _textMuted
                : AppStyles.softBrown,
            title: Text(
              title,
              style: AppStyles.subTitleStyle.copyWith(
                fontSize: 17,
                color: _textStrong,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              if (readabilityPilot) AppStyles.spacingMBox,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  body,
                  style: AppStyles.bodyStyle.copyWith(
                    fontSize: isWideLayout ? 18.0 : 17.0,
                    fontWeight: readabilityPilot
                        ? FontWeight.w600
                        : FontWeight.w600,
                    height: readabilityPilot ? 1.7 : 1.75,
                    color: readabilityPilot ? _textDefault : _textStrong,
                    letterSpacing: readabilityPilot ? 0.0 : 0.08,
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
                      color: _textMuted,
                      fontSize: 13,
                      fontWeight: readabilityPilot
                          ? FontWeight.w500
                          : FontWeight.w600,
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
