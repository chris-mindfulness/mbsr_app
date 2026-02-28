import 'package:flutter/material.dart';
import 'literatur_seite.dart';
import 'glossar_faq_seite.dart';
import 'text_archiv_seite.dart';
import 'app_daten.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/feature_info_cards.dart';
import 'widgets/section_header_label.dart';
import 'widgets/standard_action_card.dart';

class VertiefungSeite extends StatelessWidget {
  final Map<String, dynamic> tagDerAchtsamkeit;
  final List<Map<String, String>> zusatzUebungen;

  const VertiefungSeite({
    super.key,
    required this.tagDerAchtsamkeit,
    required this.zusatzUebungen,
  });

  @override
  Widget build(BuildContext context) {
    return DecorativeBlobs(
      child: ListView(
        padding: AppStyles.listPadding,
        children: [
          // Header
          Text("Vertiefung", style: AppStyles.headingStyle),
          AppStyles.spacingSBox,
          Text(
            "Zusätzliche Übungen und Ressourcen für deine Praxis",
            style: AppStyles.bodyStyle.copyWith(color: AppStyles.textMuted),
          ),
          AppStyles.spacingXLBox,
          const FeatureInfoCards(),
          AppStyles.spacingXLBox,

          _buildSectionHeader("ZUSÄTZLICHE ÜBUNGEN"),
          AppStyles.spacingMBox,

          // Coming soon Card
          _buildShadowCard(
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: AppStyles.cardShape,
              child: Padding(
                padding: AppStyles.cardPaddingLarge,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppStyles.softBrown.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.schedule,
                          size: 40,
                          color: AppStyles.softBrown.withValues(alpha: 0.3),
                        ),
                      ),
                      SizedBox(
                        height: AppStyles.spacingL - AppStyles.spacingS,
                      ), // 20px
                      Text(
                        "Coming soon",
                        style: AppStyles.subTitleStyle.copyWith(
                          color: AppStyles.textMuted,
                        ),
                      ),
                      AppStyles.spacingSBox,
                      Text(
                        "Neue Übungen werden in Kürze hinzugefügt",
                        textAlign: TextAlign.center,
                        style: AppStyles.bodyStyle.copyWith(
                          fontSize: 13,
                          color: AppStyles.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          AppStyles.spacingMBox,

          StandardActionCard(
            title: "Wissen & Hilfe",
            subtitle: "Glossar und häufige Fragen",
            leadingIcon: Icons.help_outline,
            accentColor: AppStyles.accentCyan,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GlossarFaqSeite()),
            ),
            showShadow: true,
          ),

          AppStyles.spacingMBox,

          StandardActionCard(
            title: "Textarchiv",
            subtitle: "Volltexte zu den Kurswochen",
            leadingIcon: Icons.library_books_outlined,
            accentColor: AppStyles.primaryOrange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TextArchivSeite(
                  wochenDaten: AppDaten.wochenDaten,
                  initialWeekNumber: 4,
                ),
              ),
            ),
            showShadow: true,
          ),

          SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px

          _buildSectionHeader("LITERATUR & FORSCHUNG"),
          AppStyles.spacingMBox,

          StandardActionCard(
            title: "Literatur & Forschung",
            subtitle: "Bücher, Artikel und Studien zu MBSR",
            leadingIcon: Icons.menu_book_outlined,
            accentColor: AppStyles.primaryOrange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LiteraturSeite()),
            ),
            showShadow: true,
          ),
          const SizedBox(height: 100), // Platz für Floating Nav
        ],
      ),
    );
  }

  Widget _buildShadowCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        boxShadow: AppStyles.softCardShadow,
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title) {
    return SectionHeaderLabel(title: title);
  }
}
