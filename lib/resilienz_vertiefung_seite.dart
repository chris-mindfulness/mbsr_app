import 'package:flutter/material.dart';

import 'app_daten.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

/// Vertiefung „Stress, Resilienz, Salutogenese“ — Inhalt aus [AppDaten.resilienzVertiefungAbschnitte], als Akkordeons.
class ResilienzVertiefungSeite extends StatelessWidget {
  const ResilienzVertiefungSeite({super.key});

  static Color _stripeColor(int index) {
    final colors = <Color>[
      AppStyles.accentCyan,
      AppStyles.infoBlue,
      AppStyles.successGreen,
      AppStyles.primaryOrange,
      AppStyles.accentPink,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final sections = AppDaten.resilienzVertiefungAbschnitte;
    final n = sections.length;

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          'Stress, Resilienz, Salutogenese',
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DecorativeBlobs(
        child: ListView(
          padding: AppStyles.listPadding,
          children: [
            _buildIntroCard(context),
            SizedBox(height: AppStyles.spacingL),
            ...sections.asMap().entries.map(
                  (e) => _buildAccordionSection(
                    context,
                    index: e.key,
                    total: n,
                    section: e.value,
                    stripeColor: _stripeColor(e.key),
                  ),
                ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context) {
    return Container(
      padding: AppStyles.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppStyles.accentCyan.withValues(alpha: 0.45),
          width: 1.4,
        ),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.psychology_outlined,
                color: AppStyles.accentCyan,
                size: 28,
              ),
              AppStyles.spacingMHorizontal,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wissenschaftlicher Hintergrund',
                      style: AppStyles.subTitleStyle.copyWith(
                        fontWeight: AppStyles.fontWeightSemiBold,
                        color: AppStyles.textDark,
                      ),
                    ),
                    SizedBox(height: AppStyles.spacingS),
                    Text(
                      'Wie die Forschung auf psychische Gesundheit blickt',
                      style: AppStyles.smallTextStyle.copyWith(
                        color: AppStyles.textMuted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppStyles.spacingM),
          Text(
            'Öffne die Abschnitte nach Bedarf — so bleibt Orientierung erhalten, ohne lange Textblöcke scrollen zu müssen.',
            style: AppStyles.bodyStyle.copyWith(
              color: AppStyles.textDark,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionSection(
    BuildContext context, {
    required int index,
    required int total,
    required Map<String, Object?> section,
    required Color stripeColor,
  }) {
    final title = section['title'] as String? ?? '';
    final iconAccent = stripeColor;

    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: stripeColor),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: index == 0,
                  maintainState: true,
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
                  iconColor: iconAccent,
                  collapsedIconColor: AppStyles.textMuted,
                  title: Text(
                    title,
                    style: AppStyles.subTitleStyle.copyWith(
                      fontSize: 17,
                      color: AppStyles.textDark,
                      fontWeight: AppStyles.fontWeightSemiBold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: AppStyles.spacingXS),
                    child: Text(
                      'Teil ${index + 1} von $total',
                      style: AppStyles.smallTextStyle.copyWith(
                        color: AppStyles.textMuted,
                      ),
                    ),
                  ),
                  children: [
                    _buildSectionContent(section, stripeColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(Map<String, Object?> section, Color accent) {
    final body = section['body'] as String? ?? '';
    final bodyAfterBullets = section['bodyAfterBullets'] as String?;
    final aside = section['aside'] as String?;
    final bullets = section['bullets'] as List<String>?;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            body,
            style: AppStyles.bodyStyle.copyWith(
              fontSize: 17,
              height: 1.6,
            ),
          ),
          if (bullets != null && bullets.isNotEmpty) ...[
            SizedBox(height: AppStyles.spacingM),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppStyles.spacingM),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accent.withValues(alpha: 0.28),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drei Dimensionen (Antonovsky)',
                    style: AppStyles.smallTextStyle.copyWith(
                      fontWeight: AppStyles.fontWeightSemiBold,
                      color: AppStyles.textDark,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: AppStyles.spacingS),
                  ...bullets.map(
                    (line) => Padding(
                      padding: EdgeInsets.only(bottom: AppStyles.spacingS),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.circle,
                              size: 6,
                              color: accent,
                            ),
                          ),
                          SizedBox(width: AppStyles.spacingS),
                          Expanded(child: _buildBulletLine(line)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (bodyAfterBullets != null && bodyAfterBullets.isNotEmpty) ...[
            SizedBox(height: AppStyles.spacingM),
            Text(
              bodyAfterBullets,
              style: AppStyles.bodyStyle.copyWith(
                fontSize: 17,
                height: 1.6,
              ),
            ),
          ],
          if (aside != null && aside.isNotEmpty) ...[
            SizedBox(height: AppStyles.spacingM),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppStyles.spacingM),
              decoration: BoxDecoration(
                color: AppStyles.infoBlue.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppStyles.infoBlue.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppStyles.infoBlue,
                  ),
                  SizedBox(width: AppStyles.spacingS),
                  Expanded(
                    child: Text(
                      aside,
                      style: AppStyles.bodyStyle.copyWith(
                        fontSize: 16,
                        height: 1.55,
                        fontStyle: FontStyle.italic,
                        color: AppStyles.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBulletLine(String line) {
    final colon = line.indexOf(':');
    if (colon > 0 && colon < line.length - 1) {
      final label = line.substring(0, colon + 1);
      final rest = line.substring(colon + 1).trimLeft();
      final baseStyle = AppStyles.bodyStyle.copyWith(
        fontSize: 17,
        height: 1.55,
        color: AppStyles.textDark,
      );
      return Text.rich(
        TextSpan(
          style: baseStyle,
          children: [
            TextSpan(
              text: label,
              style: baseStyle.copyWith(
                fontWeight: AppStyles.fontWeightSemiBold,
              ),
            ),
            TextSpan(text: ' $rest'),
          ],
        ),
      );
    }
    return Text(
      line,
      style: AppStyles.bodyStyle.copyWith(fontSize: 17, height: 1.55),
    );
  }
}
