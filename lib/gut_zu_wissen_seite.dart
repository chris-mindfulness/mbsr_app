import 'package:flutter/material.dart';

import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class GutZuWissenSeite extends StatelessWidget {
  final List<Map<String, String>> karten;

  const GutZuWissenSeite({super.key, required this.karten});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          "Gut zu wissen",
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
                    Icons.lightbulb_outline,
                    color: AppStyles.infoBlue,
                    size: 24,
                  ),
                  AppStyles.spacingMHorizontal,
                  Expanded(
                    child: Text(
                      "Vertiefende Impulse aus der Verhaltenspsychologie als Ergänzung zur MBSR-Praxis.",
                      style: AppStyles.bodyStyle.copyWith(
                        color: AppStyles.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...karten.asMap().entries.map(
              (e) => _buildCard(e.value, e.key),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  static const _akzentFarben = <Color Function()>[
    _orange,
    _green,
    _cyan,
    _blue,
    _pink,
  ];
  static Color _orange() => AppStyles.primaryOrange;
  static Color _green() => AppStyles.successGreen;
  static Color _cyan() => AppStyles.accentCyan;
  static Color _blue() => AppStyles.infoBlue;
  static Color _pink() => AppStyles.accentPink;

  Widget _buildCard(Map<String, String> karte, int index) {
    final title = karte['title']?.trim() ?? 'Abschnitt';
    final body = karte['body']?.trim() ?? '';
    final farbe = _akzentFarben[index % _akzentFarben.length]();

    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(width: 4, color: farbe),
          Expanded(
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildCardContent(body),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static final _bodyTextStyle = AppStyles.bodyStyle.copyWith(
    fontSize: 17,
    fontWeight: AppStyles.fontWeightRegular,
    height: 1.6,
    color: AppStyles.textDark,
    letterSpacing: 0.0,
  );

  Widget _buildCardContent(String body) {
    final absaetze = body.split('\n\n');
    final letzterAbsatz = absaetze.last.trim();
    final istFrage = letzterAbsatz.endsWith('?');

    if (!istFrage || absaetze.length < 2) {
      return Text(body, style: _bodyTextStyle);
    }

    final haupttext = absaetze.sublist(0, absaetze.length - 1).join('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(haupttext, style: _bodyTextStyle),
        SizedBox(height: AppStyles.spacingM),
        Container(
          padding: EdgeInsets.all(AppStyles.spacingM),
          decoration: BoxDecoration(
            color: AppStyles.successGreen.withValues(alpha: 0.06),
            border: Border(
              left: BorderSide(
                color: AppStyles.successGreen.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            letzterAbsatz,
            style: AppStyles.bodyStyle.copyWith(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppStyles.textDark.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
