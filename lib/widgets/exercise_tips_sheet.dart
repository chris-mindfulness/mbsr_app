import 'package:flutter/material.dart';
import '../core/app_styles.dart';

enum _ExerciseTipType {
  bodyScan,
  movement,
  sitting,
  arrival,
  compassion,
  senses,
  generic,
}

class _ExerciseTipsData {
  final IconData icon;
  final Color accentColor;
  final String phaseHint;
  final List<String> orientationPoints;
  final List<String> questionPoints;

  const _ExerciseTipsData({
    required this.icon,
    required this.accentColor,
    required this.phaseHint,
    required this.orientationPoints,
    required this.questionPoints,
  });
}

class ExerciseTipsSheet {
  static Future<void> show(
    BuildContext context, {
    required String audioTitle,
    int? weekIndex,
    String? sourceLabel,
  }) {
    final data = _buildData(audioTitle, weekIndex);
    final contextLabel = sourceLabel != null && sourceLabel.isNotEmpty
        ? sourceLabel
        : (weekIndex != null ? 'Woche $weekIndex' : null);

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppStyles.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.of(sheetContext).size.height * 0.88;
        return SafeArea(
          top: true,
          child: SizedBox(
            height: maxHeight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppStyles.softBrown.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            tooltip: 'Schließen',
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: AppStyles.softBrown,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                data.icon,
                                color: data.accentColor,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tipps zu: $audioTitle',
                                  style: AppStyles.headingStyle.copyWith(
                                    color: data.accentColor,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (contextLabel != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Kontext: $contextLabel',
                              style: AppStyles.smallTextStyle.copyWith(
                                color: AppStyles.softBrown.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text(
                            data.phaseHint,
                            style: AppStyles.bodyStyle.copyWith(height: 1.5),
                          ),
                          const SizedBox(height: 20),
                          Text('Orientierung', style: AppStyles.subTitleStyle),
                          const SizedBox(height: 8),
                          ...data.orientationPoints.map(_buildBullet),
                          const SizedBox(height: 16),
                          Text(
                            'Wenn Fragen auftauchen',
                            style: AppStyles.subTitleStyle,
                          ),
                          const SizedBox(height: 8),
                          ...data.questionPoints.map(_buildBullet),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: data.accentColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: data.accentColor.withValues(alpha: 0.18),
                              ),
                            ),
                            child: Text(
                              'Du übst nicht allein: Gleichzeitig üben auch andere Menschen. Diese geteilte Menschlichkeit kann tragen.',
                              style: AppStyles.bodyStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppStyles.softBrown,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppStyles.bodyStyle)),
        ],
      ),
    );
  }

  static _ExerciseTipType _detectType(String title) {
    final t = title.toLowerCase();
    if (t.contains('body-scan')) return _ExerciseTipType.bodyScan;
    if (t.contains('sitzmeditation')) return _ExerciseTipType.sitting;
    if (t.contains('bewegung')) return _ExerciseTipType.movement;
    if (t.contains('ankommen')) return _ExerciseTipType.arrival;
    if (t.contains('mitgefühl') || t.contains('metta')) {
      return _ExerciseTipType.compassion;
    }
    if (t.contains('sinne') || t.contains('tour')) {
      return _ExerciseTipType.senses;
    }
    return _ExerciseTipType.generic;
  }

  static _ExerciseTipsData _buildData(String audioTitle, int? weekIndex) {
    switch (_detectType(audioTitle)) {
      case _ExerciseTipType.bodyScan:
        return _ExerciseTipsData(
          icon: Icons.self_improvement,
          accentColor: AppStyles.accentCyan,
          phaseHint: weekIndex != null && weekIndex <= 2
              ? 'Der Body-Scan begleitet dich durch die ersten Wochen. Wiederholung ist dabei kein Fehler — sie macht feinere Unterschiede spürbar.'
              : 'Der Body-Scan bleibt über den gesamten Kurs ein vertrauter Anker. Gerade später hilft er, wieder in den Körperkontakt zurückzufinden.',
          orientationPoints: const [
            'Es geht nicht darum, etwas Bestimmtes zu spüren — sondern darum, hinzuschauen, was da ist.',
            'Auch wenn sich wenig tut oder es langweilig wird: Das gehört dazu.',
            'Immer wieder zurückkommen ist die eigentliche Übung, nicht perfektes Dabeibleiben.',
          ],
          questionPoints: const [
            '„Schon wieder dieselbe Übung?” — ein verständlicher Gedanke, besonders am Anfang.',
            'Den Wunsch nach Abwechslung kannst du selbst als Muster bemerken.',
            'Pausen und Anpassungen sind kein Abbruch, sondern Teil der Praxis.',
          ],
        );
      case _ExerciseTipType.movement:
        return _ExerciseTipsData(
          icon: Icons.accessibility_new,
          accentColor: AppStyles.sageGreen,
          phaseHint: weekIndex == 3
              ? 'Ab dieser Woche kommt Bewegung dazu. Es geht nicht um sportliche Leistung — sondern darum, den Körper von innen heraus wahrzunehmen.'
              : 'Achtsame Bewegung ist ein direkter, körpernaher Zugang zur Achtsamkeit — in jeder Kursphase.',
          orientationPoints: const [
            'Erkunde, statt auszuführen. Neugier ist hilfreicher als Ehrgeiz.',
            'Deine Grenzen sind Orientierung, kein Hindernis.',
            'Wenn du ruhig weiteratmen kannst, passt die Intensität.',
          ],
          questionPoints: const [
            'Unsicher, ob du es „richtig” machst? Mach es kleiner, nicht perfekter.',
            'Selbstkritik taucht oft auf — du kannst sie bemerken und weitermachen.',
            'Dein Körper verdient einen sicheren, freundlichen Umgang. Immer.',
          ],
        );
      case _ExerciseTipType.sitting:
        return _ExerciseTipsData(
          icon: Icons.airline_seat_recline_normal,
          accentColor: AppStyles.accentPink,
          phaseHint: weekIndex != null && weekIndex >= 4
              ? 'Die Sitzmeditation rückt jetzt stärker in den Mittelpunkt. Mit ihr öffnet sich der Blick: vom Atem hin zu einem weiten, offenen Gewahrsein.'
              : 'Die Sitzmeditation vertieft deine Aufmerksamkeit — vom Atem als Anker bis hin zu offenem Gewahrsein.',
          orientationPoints: const [
            'Der Atem ist dein Anker. Von dort aus darfst du dich schrittweise öffnen.',
            'Gedanken und Gefühle sind Ereignisse — keine Befehle.',
            'Immer wieder zum Anker zurückkehren: Das ist die Übung.',
          ],
          questionPoints: const [
            'Wenn es zu weit wird, hilft es, zum Atem zurückzukehren.',
            'Unruhe, Müdigkeit, Abschweifen — alles normal, alles Teil der Praxis.',
            'Freundlichkeit mit dir selbst wirkt mehr als Selbstdruck.',
          ],
        );
      case _ExerciseTipType.arrival:
        return _ExerciseTipsData(
          icon: Icons.timer,
          accentColor: AppStyles.infoBlue,
          phaseHint:
              'Eine kurze Übung, um im Moment anzukommen — vor einem Gespräch, vor der Arbeit oder einfach zwischendurch.',
          orientationPoints: const [
            'Schon wenige Minuten reichen, um zur Ruhe zu kommen.',
            'Es geht um Präsenz, nicht um Leistung.',
            'Auch kurze Praxis hält die Übungshaltung lebendig.',
          ],
          questionPoints: const [
            'Wenig Zeit? Eine kurze, klare Sequenz reicht völlig.',
            'Viel Unruhe? Der Kontakt zu Füßen und Atem gibt Halt.',
            'Du musst nichts nachholen — jedes Mal ist ein frischer Anfang.',
          ],
        );
      case _ExerciseTipType.compassion:
        return _ExerciseTipsData(
          icon: Icons.favorite_border,
          accentColor: AppStyles.primaryOrange,
          phaseHint:
              'Mitgefühlsübungen stärken eine freundliche Haltung dir selbst und anderen gegenüber.',
          orientationPoints: const [
            'Der Ton darf warm und undramatisch sein.',
            'Die Wirkung zeigt sich oft leise und über Zeit.',
            'Freundlichkeit und klare Grenzen schließen sich nicht aus.',
          ],
          questionPoints: const [
            'Widerstand ist kein Problem — du darfst ihn mit Interesse anschauen.',
            'Wenn Formulierungen nicht passen, finde eigene Worte.',
            'Die Übung darf leicht bleiben. Sie muss nicht „groß” sein.',
          ],
        );
      case _ExerciseTipType.senses:
        return _ExerciseTipsData(
          icon: Icons.visibility_outlined,
          accentColor: AppStyles.softBrown,
          phaseHint:
              'Sinnesübungen bringen dich zurück ins direkte Erleben — weg vom Autopiloten.',
          orientationPoints: const [
            'Erst wahrnehmen, dann bewerten. Nicht umgekehrt.',
            'Kurze Momente im Alltag genügen als Übung.',
            'Neugier hilft mehr als Kontrolle.',
          ],
          questionPoints: const [
            'Viele Gedanken? Komm sanft zurück zu Sehen, Hören, Spüren.',
            'Wenn es sich „nach nichts” anfühlt — genau das beobachten.',
            'Sinneswahrnehmung hilft, in belastenden Momenten wieder Boden zu finden.',
          ],
        );
      case _ExerciseTipType.generic:
        return _ExerciseTipsData(
          icon: Icons.lightbulb_outline,
          accentColor: AppStyles.softBrown,
          phaseHint:
              'Eine Einladung, für einen Moment präsent zu sein und freundlich mit dir in Kontakt zu bleiben.',
          orientationPoints: [
            'Regelmäßigkeit zählt mehr als Perfektion.',
            'Finde ein Tempo, das zu dir passt.',
            'Wahrnehmen kommt vor Bewerten.',
          ],
          questionPoints: [
            'Unsicher? Kleine, klare Schritte helfen.',
            'Druck spürbar? Zurück zur Selbstfürsorge.',
            'Auch kurze Einheiten sind echte Praxis.',
          ],
        );
    }
  }
}
