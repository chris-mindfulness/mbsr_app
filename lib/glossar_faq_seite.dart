import 'package:flutter/material.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class GlossarFaqSeite extends StatelessWidget {
  const GlossarFaqSeite({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppStyles.bgColor,
        appBar: AppBar(
          title: Text(
            "Wissen & Hilfe",
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
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.symmetric(horizontal: AppStyles.spacingM),
            labelColor: AppStyles.textDark,
            unselectedLabelColor: AppStyles.textDark.withValues(alpha: 0.8),
            indicatorColor: AppStyles.accentCyan,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: AppStyles.subTitleStyle.copyWith(
              fontWeight: AppStyles.fontWeightBold,
            ),
            tabs: const [
              Tab(text: "Glossar"),
              Tab(text: "Häufige Fragen"),
            ],
          ),
        ),
        body: DecorativeBlobs(
          child: TabBarView(
            children: [_buildGlossarList(context), _buildFaqList(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildGlossarList(BuildContext context) {
    final terms = [
      {
        'term': 'Achtsamkeit',
        'def':
            'Bewusst wahrnehmen, was gerade da ist: im Körper, in Gedanken, in Gefühlen und in der Umgebung. Nicht um alles gut zu finden, sondern um klarer zu sehen.',
      },
      {
        'term': 'Autopilot',
        'def':
            'Gewohnheitsmodus, in dem wir reagieren, ohne es direkt zu merken. Im Kurs lernst du, diesen Modus früher zu bemerken.',
      },
      {
        'term': 'Anker',
        'def':
            'Ein verlässlicher Aufmerksamkeitsfokus, z. B. Atem, Körperkontaktpunkte oder Geräusche, zu dem du freundlich zurückkehrst.',
      },
      {
        'term': 'Formale Praxis',
        'def':
            'Geplante Übungszeit mit klarer Form, z. B. Body-Scan, Sitzmeditation oder achtsame Bewegung.',
      },
      {
        'term': 'Informelle Praxis',
        'def':
            'Achtsamkeit im Alltag, z. B. beim Gehen, Essen, Duschen oder in Gesprächen.',
      },
      {
        'term': 'Body-Scan',
        'def':
            'Systematisches Spüren des Körpers. Nicht Leistung ist das Ziel, sondern Kontakt, Feinwahrnehmung und freundliche Rückkehr zur Erfahrung.',
      },
      {
        'term': 'Achtsame Bewegung',
        'def':
            'Langsame, bewusste Bewegungsübungen mit Fokus auf Grenzen, Dosierung und Selbstfürsorge.',
      },
      {
        'term': 'Sitzmeditation',
        'def':
            'Meditation im Sitzen mit einem Anker (oft Atem). Ab Woche 4 meist Kernübung zur Stabilisierung und Vertiefung der Aufmerksamkeit.',
      },
      {
        'term': 'Offenes Gewahrsein',
        'def':
            'Aufmerksamkeit öffnet sich über den Anker hinaus für das, was gerade deutlich ist: Körperempfindungen, Gedanken, Gefühle, Geräusche.',
      },
      {
        'term': 'Reaktivität',
        'def':
            'Schnelles automatisches Reagieren bei Stress, oft aus alten Mustern. Im Kurs übst du, den Moment zwischen Reiz und Reaktion wahrzunehmen.',
      },
      {
        'term': 'Stressreaktion',
        'def':
            'Körperliche und mentale Aktivierung bei Belastung, z. B. Anspannung, Grübeln, Unruhe oder Rückzug.',
      },
      {
        'term': 'Selbstfürsorge',
        'def':
            'Eigene Grenzen ernst nehmen und stimmige Entscheidungen treffen: anpassen, pausieren, dosieren, Unterstützung holen.',
      },
      {
        'term': 'Schwierige Kommunikation',
        'def':
            'Praxisfeld ab Woche 6: in belastenden Gesprächen bewusster sprechen, zuhören und Pausen nutzen statt automatisch zu eskalieren.',
      },
      {
        'term': 'Tag der Achtsamkeit',
        'def':
            'Längerer Übungstag in Stille mit mehreren Praxisformen. Ziel ist Kontinuität von Achtsamkeit über Übungen und Übergänge hinweg.',
      },
      {
        'term': 'Mitgefühl',
        'def':
            'Freundliche, nicht beschönigende Haltung gegenüber eigenem und fremdem Leiden. In MBSR kein Extra, sondern Teil der Grundhaltung.',
      },
    ];
    final sortedTerms = [...terms]
      ..sort((a, b) => (a['term'] ?? '').compareTo(b['term'] ?? ''));

    return ListView.separated(
      padding: AppStyles.listPadding,
      itemCount: sortedTerms.length,
      separatorBuilder: (context, index) => AppStyles.spacingMBox,
      itemBuilder: (context, index) {
        final item = sortedTerms[index];
        return _buildExpansionCard(
          context: context,
          title: item['term']!,
          body: item['def']!,
        );
      },
    );
  }

  Widget _buildFaqList(BuildContext context) {
    final faqs = [
      {
        'q': 'Ich bin sehr gestresst. Bin ich im Kurs überhaupt richtig?',
        'a':
            'Genau dafür ist der Kurs gedacht: Stressmuster erkennen, den Körper früher wahrnehmen und neue Reaktionsmöglichkeiten aufbauen. Du musst dafür nicht "ruhig" sein, um zu starten.',
      },
      {
        'q': 'Wie viel Zeit brauche ich realistisch?',
        'a':
            'Im Kurs ist regelmäßige Praxis zentral. Entscheidend ist nicht Perfektion, sondern Verlässlichkeit: lieber konstant üben als selten und zu lang.',
      },
      {
        'q': 'Was, wenn ich nicht täglich übe?',
        'a':
            'Dann steigst du wieder ein, ohne Schuldschleife. Kontinuität entsteht durch Neubeginn. Auch kurze, klare Einheiten halten die Praxis lebendig.',
      },
      {
        'q': 'Ich schweife ständig ab. Mache ich etwas falsch?',
        'a':
            'Nein. Abschweifen ist normal. Der eigentliche Trainingsmoment ist das Bemerken und freundliche Zurückkehren zum Anker.',
      },
      {
        'q': 'Warum ist der Body-Scan in Woche 1 und 2 so zentral?',
        'a':
            'Der wiederholte Ablauf hält wichtige Variablen konstant. So erkennst du Muster in Stress, Körperwahrnehmung und Reaktivität zuverlässiger.',
      },
      {
        'q': 'Soll ich zusätzlich andere Audios von YouTube/Spotify nutzen?',
        'a':
            'Zusätzlich ist möglich. Für den Kurseffekt hilft es aber, die Kernanleitungen des Kurses regelmäßig beizubehalten, damit Veränderung vergleichbar wird.',
      },
      {
        'q': 'Was mache ich bei Unruhe, Müdigkeit oder Langeweile?',
        'a':
            'Diese Reaktionen sind häufig. Du kannst Haltung anpassen, Augen öffnen, Kontaktpunkte spüren und den Umfang dosieren. Wichtig ist ein freundlicher Umgang statt Druck.',
      },
      {
        'q': 'Ich habe körperliche Beschwerden. Kann ich trotzdem mitmachen?',
        'a':
            'Ja, mit Anpassungen. In der achtsamen Bewegung gilt Selbstfürsorge: Intensität reduzieren, Varianten wählen, bei Unsicherheit pausieren.',
      },
      {
        'q': 'Was, wenn beim Üben starke Gefühle auftauchen?',
        'a':
            'Dann gilt: verlangsamen, stabilisieren, dosieren. Du kannst jederzeit pausieren, Kontakt zum Raum aufnehmen und Unterstützung ansprechen.',
      },
      {
        'q': 'Muss ich in der Gruppe persönliche Dinge erzählen?',
        'a':
            'Nein. Du entscheidest selbst, was du teilen möchtest. Achtsame Kommunikation heißt auch, eigene Grenzen zu respektieren.',
      },
      {
        'q': 'Was bringt mir der Tag der Achtsamkeit?',
        'a':
            'Der längere Übungsrahmen vertieft Kontinuität: nicht nur in formellen Übungen, sondern auch in Übergängen, Essen, Gehen und Pausen.',
      },
      {
        'q': 'Woran merke ich Fortschritt, ohne Leistungsdruck?',
        'a':
            'Typische Zeichen sind frühere Stresswahrnehmung, mehr Wahlmöglichkeiten vor Reaktionen und schnelleres Zurückfinden in den Körperkontakt.',
      },
      {
        'q': 'Was passiert nach den 8 Wochen?',
        'a':
            'Ziel ist eine tragfähige eigene Praxis. Ein einfacher Wochenplan mit realistischem Umfang hilft, die Übungen langfristig im Alltag zu halten.',
      },
      {
        'q': 'Ist MBSR eine Therapie?',
        'a':
            'MBSR ist ein strukturiertes Stressbewältigungs- und Achtsamkeitstraining. Bei akuten psychischen Krisen oder hohem Leidensdruck ist zusätzliche professionelle Behandlung wichtig.',
      },
    ];

    return ListView.separated(
      padding: AppStyles.listPadding,
      itemCount: faqs.length,
      separatorBuilder: (context, index) => AppStyles.spacingMBox,
      itemBuilder: (context, index) {
        final item = faqs[index];
        return _buildExpansionCard(
          context: context,
          title: item['q']!,
          body: item['a']!,
        );
      },
    );
  }

  Widget _buildExpansionCard({
    required BuildContext context,
    required String title,
    required String body,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.successGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        border: Border.all(
          color: AppStyles.successGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
          iconColor: AppStyles.textDark,
          collapsedIconColor: AppStyles.textDark.withValues(alpha: 0.9),
          title: Text(title, style: AppStyles.subTitleStyle),
          children: [Text(body, style: AppStyles.bodyStyle)],
        ),
      ),
    );
  }
}
