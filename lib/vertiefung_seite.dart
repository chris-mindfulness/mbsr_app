import 'package:flutter/material.dart';
import 'literatur_seite.dart';
import 'glossar_faq_seite.dart';
import 'text_archiv_seite.dart';
import 'gut_zu_wissen_seite.dart';
import 'resilienz_vertiefung_seite.dart';
import 'zyklus_denken_fuehlen_seite.dart';
import 'app_daten.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';
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
    final hasZusatzUebungen = zusatzUebungen.isNotEmpty;
    final hasModelle = AppDaten.vertiefungModelle.isNotEmpty;
    final zyklusModell = hasModelle ? AppDaten.vertiefungModelle.first : null;

    return DecorativeBlobs(
      child: ListView(
        padding: AppStyles.listPadding,
        children: [
          // Header
          Text("Vertiefung", style: AppStyles.headingStyle),
          AppStyles.spacingSBox,
          Text(
            "Optionales Material für Praxis, Nachschlagen und Quellen",
            style: AppStyles.bodyStyle.copyWith(color: AppStyles.textMuted),
          ),
          AppStyles.spacingXLBox,

          _buildSectionHeader("PRAXIS VERTIEFEN"),
          AppStyles.spacingMBox,

          StandardActionCard(
            title: "Gut zu wissen",
            subtitle:
                "Optionale Vertiefung: Gewohnheiten und Praxis im Alltag",
            leadingIcon: Icons.lightbulb_outline,
            accentColor: AppStyles.infoBlue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GutZuWissenSeite(
                  karten: AppDaten.gutZuWissenKarten,
                ),
              ),
            ),
            showShadow: true,
          ),

          if (hasZusatzUebungen) ...[
            AppStyles.spacingMBox,
            StandardActionCard(
              title: "Zusätzliche Übungen",
              subtitle: "Weitere Übungsimpulse für deinen Alltag",
              leadingIcon: Icons.self_improvement_outlined,
              accentColor: AppStyles.successGreen,
              onTap: () => _showZusatzUebungenSheet(context),
              showShadow: true,
            ),
          ],

          SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px

          _buildSectionHeader("NACHSCHLAGEN"),
          AppStyles.spacingMBox,

          StandardActionCard(
            title: "Begriffe & Fragen",
            subtitle: "Glossar und häufige Fragen nachschlagen",
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
            subtitle: "Texte zu den Kurswochen",
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

          _buildSectionHeader("WISSENSCHAFTLICHER HINTERGRUND"),
          AppStyles.spacingMBox,

          StandardActionCard(
            title: "Stress, Resilienz, Salutogenese",
            subtitle: "Wie die Forschung auf psychische Gesundheit blickt",
            leadingIcon: Icons.psychology_outlined,
            accentColor: AppStyles.accentCyan,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ResilienzVertiefungSeite(),
              ),
            ),
            showShadow: true,
          ),

          if (hasModelle) ...[
            SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
            _buildSectionHeader("MODELLE"),
            AppStyles.spacingMBox,
            StandardActionCard(
              title: zyklusModell?['title'] ?? 'Modelle',
              subtitle:
                  zyklusModell?['summary'] ??
                  'Visuelle Lernhilfen für die Vertiefung',
              leadingIcon: Icons.model_training_outlined,
              accentColor: AppStyles.accentOrange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ZyklusDenkenFuehlenSeite(),
                ),
              ),
              showShadow: true,
            ),
          ],

          SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px

          _buildSectionHeader("QUELLEN"),
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

  void _showZusatzUebungenSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: AppStyles.softCardShadow,
          ),
          padding: EdgeInsets.fromLTRB(
            AppStyles.spacingL,
            AppStyles.spacingL,
            AppStyles.spacingL,
            AppStyles.spacingXL,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Zusätzliche Übungen", style: AppStyles.subTitleStyle),
                AppStyles.spacingMBox,
                ...zusatzUebungen.map(
                  (uebung) => Padding(
                    padding: EdgeInsets.only(bottom: AppStyles.spacingM),
                    child: Text(
                      "• ${uebung['title'] ?? 'Übung'}"
                      "${(uebung['description'] ?? '').trim().isEmpty ? '' : ': ${uebung['description']!.trim()}'}",
                      style: AppStyles.bodyStyle.copyWith(
                        color: AppStyles.textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return SectionHeaderLabel(title: title);
  }
}
