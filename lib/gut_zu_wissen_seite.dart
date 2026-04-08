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
            ...karten.map(_buildCard),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, String> karte) {
    final title = karte['title']?.trim() ?? 'Abschnitt';
    final body = karte['body']?.trim() ?? '';

    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
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
              child: Text(
                body,
                style: AppStyles.bodyStyle.copyWith(
                  fontSize: 17,
                  fontWeight: AppStyles.fontWeightRegular,
                  height: 1.6,
                  color: AppStyles.textDark,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
