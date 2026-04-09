import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/section_header_label.dart';
import 'widgets/standard_action_card.dart';

class _LiteraturBuch {
  const _LiteraturBuch({
    required this.titel,
    required this.autor,
    required this.info,
  });

  final String titel;
  final String autor;
  final String info;
}

class _LiteraturBuchKategorie {
  const _LiteraturBuchKategorie({
    required this.ueberschrift,
    required this.buecher,
  });

  final String ueberschrift;
  final List<_LiteraturBuch> buecher;
}

class LiteraturSeite extends StatelessWidget {
  const LiteraturSeite({super.key});

  /// Buchtipps ohne Shop-Links — Titel frei suchen (Hahn 2026).
  static const List<_LiteraturBuchKategorie> _buchKategorien = [
    _LiteraturBuchKategorie(
      ueberschrift: 'ACHTSAMKEIT',
      buecher: [
        _LiteraturBuch(
          titel: 'Gesund durch Meditation',
          autor: 'Jon Kabat-Zinn',
          info:
              'Das Standardwerk zu MBSR. Wer verstehen möchte, woher die Übungen kommen und was dahintersteckt, ist hier richtig.',
        ),
        _LiteraturBuch(
          titel: 'Im Alltag Ruhe finden',
          autor: 'Jon Kabat-Zinn',
          info:
              'Kürzere Kapitel, sehr alltagsnah. Gut geeignet als tägliche Lektüre in kleinen Dosen.',
        ),
        _LiteraturBuch(
          titel: 'Das Achtsamkeits-Buch',
          autor: 'Mark Williams & Danny Penman',
          info:
              'Ein 8-Wochen-Programm zum Selbststudium — als strukturierte Weiterarbeit nach dem Kurs.',
        ),
        _LiteraturBuch(
          titel: 'Das Wunder der Achtsamkeit',
          autor: 'Thich Nhat Hanh',
          info:
              'Ein Klassiker: knapp, poetisch, direkt. Ideal als Einstieg in das Denken einer der bedeutendsten Stimmen der Achtsamkeit.',
        ),
        _LiteraturBuch(
          titel: 'Stille',
          autor: 'Thich Nhat Hanh',
          info:
              'Über die Kraft der inneren Stille in einer reizüberfluteten Welt — zugänglicher als seine früheren Bücher.',
        ),
      ],
    ),
    _LiteraturBuchKategorie(
      ueberschrift: 'KONTEMPLATIVE PSYCHOLOGIE',
      buecher: [
        _LiteraturBuch(
          titel: 'Das weise Herz',
          autor: 'Jack Kornfield',
          info:
              'Eine Synthese aus buddhistischer Psychologie und westlicher Therapie. Tiefgründig, aber gut lesbar.',
        ),
        _LiteraturBuch(
          titel: 'Radikal akzeptieren',
          autor: 'Tara Brach',
          info:
              'Akzeptanz nicht als Konzept, sondern als gelebte Praxis. Viele konkrete Übungen und Geschichten.',
        ),
        _LiteraturBuch(
          titel: 'Loving-Kindness',
          autor: 'Sharon Salzberg',
          info:
              'Die Metta-Praxis (liebende Güte) ausführlich erklärt und eingebettet. Ergänzt den Mitgefühlsaspekt aus dem Kurs.',
        ),
      ],
    ),
    _LiteraturBuchKategorie(
      ueberschrift: 'SELBSTMITGEFÜHL & EMOTIONALE RESILIENZ',
      buecher: [
        _LiteraturBuch(
          titel: 'Selbstmitgefühl',
          autor: 'Kristin Neff',
          info:
              'Die führende Forscherin zum Thema beschreibt, was Selbstmitgefühl ist — und was es nicht ist. Empirisch fundiert, kein Selbsthilfe-Ratgeber im klassischen Sinne.',
        ),
        _LiteraturBuch(
          titel: 'Die Gaben der Unvollkommenheit',
          autor: 'Brené Brown',
          info:
              'Über Scham, Verletzlichkeit und Selbstakzeptanz. Sehr hohe Resonanz bei Menschen, die gerade etwas über sich gelernt haben.',
        ),
      ],
    ),
    _LiteraturBuchKategorie(
      ueberschrift: 'GEIST, GEHIRN & SINN',
      buecher: [
        _LiteraturBuch(
          titel: 'Das Gehirn eines Buddha',
          autor: 'Rick Hanson',
          info:
              'Neuroplastizität und Meditation: Wie Praxis das Gehirn verändert. Populärwissenschaftlich, aber solide.',
        ),
        _LiteraturBuch(
          titel: 'Mindsight',
          autor: 'Daniel Siegel',
          info:
              'Interpersonelle Neurobiologie und Selbstwahrnehmung. Etwas anspruchsvoller, lohnt sich für Interessierte.',
        ),
      ],
    ),
    _LiteraturBuchKategorie(
      ueberschrift: 'AUFMERKSAMKEIT & FOKUS',
      buecher: [
        _LiteraturBuch(
          titel: 'Hyperfokus',
          autor: 'Chris Bailey',
          info:
              'Wie wir unsere Aufmerksamkeit bewusst steuern können — im Alltag, nicht nur auf dem Meditationskissen.',
        ),
      ],
    ),
    _LiteraturBuchKategorie(
      ueberschrift: 'GEWOHNHEITEN & VERÄNDERUNG',
      buecher: [
        _LiteraturBuch(
          titel: 'Die 1%-Methode',
          autor: 'James Clear',
          info:
              'Wie kleine, kontinuierliche Veränderungen zu großen Ergebnissen führen. Das meistgelesene Buch zum Thema Habitdesign.',
        ),
        _LiteraturBuch(
          titel: 'Die Tiny Habits Methode',
          autor: 'BJ Fogg',
          info:
              'Fogg ist Verhaltensforscher an der Stanford University. Sein Ansatz: neue Gewohnheiten an bestehende ankoppeln und so klein wie möglich anfangen.',
        ),
        _LiteraturBuch(
          titel: 'Die Macht der Gewohnheit',
          autor: 'Charles Duhigg',
          info:
              'Erklärt die Mechanik hinter Gewohnheitsschleifen (Auslöser — Routine — Belohnung). Mehr Hintergrundwissen als Anleitung — gut als Grundlage.',
        ),
      ],
    ),
  ];

  /// Kuratierte Primärliteratur — Links per DOI zur Originalpublikation.
  final List<Map<String, String>> artikel = const [
    {
      'titel': 'Mindfulness Interventions',
      'journal': 'J. D. Creswell · Annual Review of Psychology (2017)',
      'url': 'https://doi.org/10.1146/annurev-psych-042716-051139',
    },
    {
      'titel':
          'The Empirical Status of Mindfulness-Based Interventions: A Systematic Review of 44 Meta-Analyses of Randomized Controlled Trials',
      'journal': 'Goldberg et al. · Perspectives on Psychological Science (2022)',
      'url': 'https://doi.org/10.1177/1745691620968771',
    },
    {
      'titel':
          'How Does Mindfulness Meditation Work? Proposing Mechanisms of Action From a Conceptual and Neural Perspective',
      'journal': 'Hölzel et al. · Perspectives on Psychological Science (2011)',
      'url': 'https://doi.org/10.1177/1745691611419671',
    },
    {
      'titel':
          'Absence of structural brain changes from mindfulness-based stress reduction: Two combined randomized controlled trials',
      'journal': 'Kral et al. · Science Advances (2022)',
      'url': 'https://doi.org/10.1126/sciadv.abk3316',
    },
    {
      'titel':
          'A Systematic Review and Meta-analysis of the Effects of Meditation on Empathy, Compassion, and Prosocial Behaviors',
      'journal': 'Luberto et al. · Mindfulness (2018)',
      'url': 'https://doi.org/10.1007/s12671-017-0841-8',
    },
    {
      'titel': 'The neuroscience of mindfulness meditation',
      'journal': 'Tang, Hölzel & Posner · Nature Reviews Neuroscience (2015)',
      'url': 'https://doi.org/10.1038/nrn3916',
    },
    {
      'titel':
          'The Effect of Mindfulness-based Programs on Cognitive Function in Adults: A Systematic Review and Meta-analysis',
      'journal': 'Whitfield et al. · Neuropsychology Review (2021)',
      'url': 'https://doi.org/10.1007/s11065-021-09519-y',
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
            _buildSectionHeader("BÜCHER"),
            AppStyles.spacingSBox,
            Text(
              'Zum Weiterlesen nach dem Kurs. Die Titel kannst du selbst suchen — hier ohne Verlinkung zu Shops.',
              style: AppStyles.bodyStyle.copyWith(
                fontSize: 13,
                color: AppStyles.textMuted,
              ),
            ),
            AppStyles.spacingMBox,
            for (var i = 0; i < _buchKategorien.length; i++) ...[
              if (i > 0) SizedBox(height: AppStyles.spacingL),
              _buildSectionHeader(_buchKategorien[i].ueberschrift),
              AppStyles.spacingSBox,
              ..._buchKategorien[i].buecher.map(_buildBookCard),
            ],
            AppStyles.spacingMBox,
            Text(
              'Zusammengestellt von C. Hahn · MBSR-Training · 2026',
              style: AppStyles.bodyStyle.copyWith(
                fontSize: 12,
                color: AppStyles.softBrown.withValues(alpha: 0.55),
              ),
            ),
            SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
            _buildSectionHeader("FACHARTIKEL & STUDIEN"),
            AppStyles.spacingSBox,
            Text(
              'Ausgewählte Arbeiten — Karte öffnet die Originalpublikation (DOI).',
              style: AppStyles.bodyStyle.copyWith(
                fontSize: 13,
                color: AppStyles.textMuted,
              ),
            ),
            AppStyles.spacingMBox,
            ...artikel.map((art) => _buildArticleCard(art)),
            SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SectionHeaderLabel(title: title);
  }

  Widget _buildBookCard(_LiteraturBuch buch) {
    return StandardActionCard(
      title: buch.titel,
      meta: buch.autor,
      subtitle: buch.info,
      leadingIcon: Icons.book_outlined,
      accentColor: AppStyles.softBrown,
      onTap: null,
      showTrailing: false,
      alignTop: true,
      contentPadding: EdgeInsets.all(AppStyles.spacingL - AppStyles.spacingS),
      metaStyle: AppStyles.bodyStyle.copyWith(
        fontWeight: FontWeight.bold,
        color: AppStyles.sageGreen,
      ),
      subtitleStyle: AppStyles.bodyStyle.copyWith(
        fontSize: 13,
        color: AppStyles.softBrown.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, String> art) {
    return StandardActionCard(
      title: art['titel']!,
      subtitle: art['journal'],
      leadingIcon: Icons.science_outlined,
      accentColor: AppStyles.sageGreen,
      onTap: () => _oeffneUrl(art['url']!),
      trailingIcon: Icons.open_in_new,
      contentPadding: EdgeInsets.all(AppStyles.spacingL - AppStyles.spacingS),
      subtitleStyle: AppStyles.bodyStyle.copyWith(
        fontSize: 12,
        color: AppStyles.softBrown.withValues(alpha: 0.6),
      ),
    );
  }
}
