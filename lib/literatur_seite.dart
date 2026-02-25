import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class LiteraturSeite extends StatelessWidget {
  const LiteraturSeite({super.key});

  final List<Map<String, String>> buecher = const [
    {
      'titel': 'Gesund durch Meditation',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Grundlagenwerk zu MBSR (deutsche Ausgabe).',
      'url':
          'https://www.hugendubel.de/de/fachbuecher/kunst/kunst-allgemein/detail/ISBN-9783426878378/Kabat-Zinn-Jon/Gesund-durch-Meditation',
    },
    {
      'titel': 'Im Alltag Ruhe finden',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Praktische Übungen für Alltag und Selbstregulation.',
      'url':
          'https://www.hugendubel.de/de/buch_gebunden/jon_kabat_zinn-im_alltag_ruhe_finden-46390095-produkt-details.html',
    },
    {
      'titel': 'Stressbewältigung durch Achtsamkeit',
      'autor': 'Linda Lehrhaupt & Petra Meibert',
      'info': 'MBSR-Praxisbuch (deutschsprachiger Standardtitel).',
      'url':
          'https://www.hugendubel.de/de/ebook_epub/linda_lehrhaupt_petra_meibert-stressbewaeltigung_durch_achtsamkeit-18913080-produkt-details.html',
    },
    {
      'titel': 'Achtsamkeit für Anfänger',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Einführung in die Meditation.',
      'url':
          'https://www.hugendubel.info/fachbuecher/kunst/kunst-allgemein/detail/ISBN-9783867814133/Kabat-Zinn-Jon/Achtsamkeit-f%C3%BCr-Anf%C3%A4nger',
    },
    {
      'titel': 'Achtsam durch den Tag',
      'autor': 'Jan Chozen Bays',
      'info': '53 Wege zu Achtsamkeit im Alltag.',
      'url':
          'https://www.hugendubel.de/de/buch_kartoniert/jan_chozen_bays-charley_ferrari-achtsam_durch_den_tag-10098360-produkt-details.html',
    },
    {
      'titel': 'Das Achtsamkeitsbuch',
      'autor': 'Michael Harrer',
      'info': 'Übungsbuch mit konkreten Anleitungen für Alltag und Therapie.',
      'url':
          'https://www.hugendubel.de/de/buch_kartoniert/michael_harrer-das_achtsamkeitsbuch-26706166-produkt-details.html',
    },
    {
      'titel': 'Zur Besinnung kommen',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Die Weisheit der Sinne entdecken.',
      'url':
          'https://www.hugendubel.de/de/fachbuecher/kunst/kunst-allgemein/detail/ISBN-9783867812467/Kabat-Zinn-Jon/Zur-Besinnung-kommen',
    },
  ];

  final List<Map<String, String>> artikel = const [
    {
      'titel': 'Mindfulness-based stress reduction and health benefits',
      'journal': 'Journal of Psychosomatic Research (2004)',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/15256293/',
    },
    {
      'titel':
          'Meditation programs for psychological stress and well-being: A systematic review and meta-analysis',
      'journal': 'JAMA Internal Medicine (2014)',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/24395196/',
    },
    {
      'titel':
          'Effect of mindfulness-based stress reduction vs cognitive behavioral therapy or usual care on chronic low back pain',
      'journal': 'JAMA (2016)',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/27002445/',
    },
    {
      'titel':
          'Randomized controlled trial of mindfulness meditation for generalized anxiety disorder',
      'journal': 'Journal of Clinical Psychiatry (2013)',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/23541163/',
    },
    {
      'titel': 'Mindfulness-based therapy: A comprehensive meta-analysis',
      'journal': 'Journal of Psychosomatic Research (2015)',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/25818837/',
    },
    {
      'titel':
          'Mechanisms of mindfulness-based stress reduction and cognitive behavioral therapy for chronic low back pain',
      'journal': 'Pain (2016)',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/27257859/',
    },
  ];

  Future<void> _oeffneUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Konnte $url nicht öffnen';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          "Literatur & Forschung",
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DecorativeBlobs(
        child: ListView(
          padding: AppStyles.listPadding,
          children: [
            _buildSectionHeader("BÜCHER"),
            AppStyles.spacingMBox,
            ...buecher.map((buch) => _buildBookCard(buch)),
            SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
            _buildSectionHeader("FACHARTIKEL & STUDIEN"),
            AppStyles.spacingMBox,
            ...artikel.map((art) => _buildArticleCard(art)),
            SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
          ],
        ),
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
          color: AppStyles.softBrown.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, String> buch) {
    final url = buch['url'];
    final isLinkAvailable = url != null && url.isNotEmpty;

    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: isLinkAvailable ? () => _oeffneUrl(url) : null,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: EdgeInsets.all(
            AppStyles.spacingL - AppStyles.spacingS,
          ), // 20px
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppStyles.softBrown.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.book_outlined,
                  color: AppStyles.softBrown,
                ),
              ),
              SizedBox(width: AppStyles.spacingL - AppStyles.spacingS), // 20px
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buch['titel']!, style: AppStyles.subTitleStyle),
                    AppStyles.spacingXSBox,
                    Text(
                      buch['autor']!,
                      style: AppStyles.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppStyles.sageGreen,
                      ),
                    ),
                    AppStyles.spacingSBox,
                    Text(
                      buch['info']!,
                      style: AppStyles.bodyStyle.copyWith(
                        fontSize: 13,
                        color: AppStyles.softBrown.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isLinkAvailable ? Icons.open_in_new : Icons.info_outline,
                color: AppStyles.borderColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, String> art) {
    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: () => _oeffneUrl(art['url']!),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: EdgeInsets.all(
            AppStyles.spacingL - AppStyles.spacingS,
          ), // 20px
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppStyles.spacingM - AppStyles.spacingS,
                ), // 12px
                decoration: BoxDecoration(
                  color: AppStyles.sageGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.science_outlined,
                  color: AppStyles.sageGreen,
                ),
              ),
              SizedBox(width: AppStyles.spacingL - AppStyles.spacingS), // 20px
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(art['titel']!, style: AppStyles.subTitleStyle),
                    AppStyles.spacingXSBox,
                    Text(
                      art['journal']!,
                      style: AppStyles.bodyStyle.copyWith(
                        fontSize: 12,
                        color: AppStyles.softBrown.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new,
                color: AppStyles.borderColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
