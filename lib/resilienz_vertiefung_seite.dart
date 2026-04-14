import 'package:flutter/material.dart';

import 'app_daten.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

/// Vertiefungstext „Stress, Resilienz, Salutogenese“ — Inhalte aus [AppDaten.resilienzVertiefungAbschnitte].
class ResilienzVertiefungSeite extends StatelessWidget {
  const ResilienzVertiefungSeite({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Wie die Forschung auf psychische Gesundheit blickt',
              style: AppStyles.bodyStyle.copyWith(
                color: AppStyles.textMuted,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppStyles.spacingL),
            ...AppDaten.resilienzVertiefungAbschnitte.map(
              (section) => _buildSection(context, section),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, Map<String, Object?> section) {
    final title = section['title'] as String? ?? '';
    final body = section['body'] as String? ?? '';
    final bodyAfterBullets = section['bodyAfterBullets'] as String?;
    final aside = section['aside'] as String?;
    final bullets = section['bullets'] as List<String>?;

    return Padding(
      padding: EdgeInsets.only(bottom: AppStyles.spacingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.subTitleStyle.copyWith(
              color: AppStyles.textDark,
              fontWeight: AppStyles.fontWeightSemiBold,
            ),
          ),
          SizedBox(height: AppStyles.spacingM),
          Text(
            body,
            style: AppStyles.bodyStyle.copyWith(height: 1.6),
          ),
          if (bullets != null && bullets.isNotEmpty) ...[
            SizedBox(height: AppStyles.spacingM),
            ...bullets.map(
              (line) => Padding(
                padding: EdgeInsets.only(bottom: AppStyles.spacingS),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: AppStyles.bodyStyle.copyWith(height: 1.6),
                    ),
                    Expanded(
                      child: _buildBulletLine(line),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (bodyAfterBullets != null && bodyAfterBullets.isNotEmpty) ...[
            SizedBox(height: AppStyles.spacingM),
            Text(
              bodyAfterBullets,
              style: AppStyles.bodyStyle.copyWith(height: 1.6),
            ),
          ],
          if (aside != null && aside.isNotEmpty) ...[
            SizedBox(height: AppStyles.spacingM),
            Text(
              aside,
              style: AppStyles.bodyStyle.copyWith(
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: AppStyles.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Erste Zeile bis zum ersten Doppelpunkt fett (z. B. **Verstehbarkeit:** aus Markdown).
  Widget _buildBulletLine(String line) {
    final colon = line.indexOf(':');
    if (colon > 0 && colon < line.length - 1) {
      final label = line.substring(0, colon + 1);
      final rest = line.substring(colon + 1).trimLeft();
      final baseStyle = AppStyles.bodyStyle.copyWith(
        height: 1.6,
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
    return Text(line, style: AppStyles.bodyStyle.copyWith(height: 1.6));
  }
}
