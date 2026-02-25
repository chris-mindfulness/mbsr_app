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
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppStyles.softBrown.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(data.icon, color: data.accentColor, size: 28),
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
                      color: AppStyles.softBrown.withValues(alpha: 0.75),
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
                Text('Wenn Fragen auftauchen', style: AppStyles.subTitleStyle),
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
                    'Du übst nicht allein: Gleichzeitig üben auch andere Menschen achtsam. Diese geteilte Menschlichkeit kann tragen.',
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
      ),
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
            decoration: const BoxDecoration(
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
              ? 'In Woche 1 und 2 ist der Body-Scan oft die Kernübung. Ein gleichbleibender Rahmen kann helfen, Veränderungen und Muster klarer wahrzunehmen.'
              : 'Der Body-Scan bleibt über den Kurs hinweg ein stabiler Anker. Gerade später kann er helfen, wieder in den Körperkontakt zurückzufinden.',
          orientationPoints: const [
            'Nicht Intensität zählt, sondern die freundliche Rückkehr zum Spüren.',
            'Ein wiederkehrender Ablauf kann die Selbstbeobachtung verlässlicher machen.',
            'Auch neutrale oder langweilige Phasen sind Teil der Übung.',
          ],
          questionPoints: const [
            'Die Frage „Warum wieder dieselbe Übung?“ taucht häufig auf, besonders in Woche 2.',
            'Der Impuls, ständig neue Anleitungen zu suchen, kann selbst als Muster beobachtet werden.',
            'Selbstfürsorge bleibt zentral: anpassen, pausieren, weitermachen in einem stimmigen Tempo.',
          ],
        );
      case _ExerciseTipType.movement:
        return _ExerciseTipsData(
          icon: Icons.accessibility_new,
          accentColor: AppStyles.sageGreen,
          phaseHint: weekIndex == 3
              ? 'In Woche 3 steht achtsame Bewegung im Fokus. Häufig geht es weniger um „richtig ausführen“ und mehr um Grenzen, Dosierung und Körperwahrnehmung.'
              : 'Achtsame Bewegung kann in jeder Phase als körpernaher Zugang zur Achtsamkeit unterstützen.',
          orientationPoints: const [
            'Bewegung kann als Erkundung statt als Leistung verstanden werden.',
            'Grenzen geben Orientierung und sind kein Rückschritt.',
            'Ruhiges Weiteratmen ist oft ein guter Hinweis auf stimmige Dosierung.',
          ],
          questionPoints: const [
            'Wenn Unsicherheit entsteht, können kleinere Varianten und Pausen sinnvoll sein.',
            'Wenn Selbstkritik auftaucht, kann sie als mentales Ereignis bemerkt werden.',
            'Wesentlich bleibt ein würdevoller, sicherer Umgang mit dem eigenen Körper.',
          ],
        );
      case _ExerciseTipType.sitting:
        return _ExerciseTipsData(
          icon: Icons.airline_seat_recline_normal,
          accentColor: AppStyles.accentPink,
          phaseHint: weekIndex != null && weekIndex >= 4
              ? 'Ab Woche 4 wird die Sitzmeditation meist zentral. Mit ihr tritt oft auch offenes Gewahrsein stärker in den Vordergrund.'
              : 'Sitzmeditation vertieft die Aufmerksamkeitslenkung und kann schrittweise in offenes Gewahrsein übergehen.',
          orientationPoints: const [
            'Der Atem kann als Anker dienen; Öffnung kann schrittweise erfolgen.',
            'Gedanken und Gefühle können als Ereignisse wahrgenommen werden, nicht als Befehle.',
            'Die Rückkehr zum Anker ist ein Kernmoment der Übung.',
          ],
          questionPoints: const [
            'Bei offenem Gewahrsein kann ein temporärer Rückgang zum Atem stabilisieren.',
            'Unruhe, Müdigkeit oder Abschweifen sind normale Phänomene in der Praxis.',
            'Ein freundlicher Ton mit sich selbst ist oft wirksamer als Selbstdruck.',
          ],
        );
      case _ExerciseTipType.arrival:
        return _ExerciseTipsData(
          icon: Icons.timer,
          accentColor: AppStyles.infoBlue,
          phaseHint:
              'Kurze Ankommen-Übungen können als Übergang in den Moment dienen, zum Beispiel vor Gesprächen, Arbeit oder Erholung.',
          orientationPoints: const [
            'Wenige Minuten können reichen, um das Nervensystem zu beruhigen.',
            'Der Fokus liegt auf Präsenz, nicht auf besonderer Leistung.',
            'Auch kurze Praxis kann eine kontinuierliche Übungshaltung stärken.',
          ],
          questionPoints: const [
            'Wenn wenig Zeit da ist, kann eine sehr kurze, klare Sequenz hilfreich sein.',
            'Wenn viel Unruhe da ist, kann der Kontakt zu Füßen und Atem stabilisieren.',
            'Die Übung kann immer wieder neu begonnen werden, ohne „aufholen“ zu müssen.',
          ],
        );
      case _ExerciseTipType.compassion:
        return _ExerciseTipsData(
          icon: Icons.favorite_border,
          accentColor: AppStyles.primaryOrange,
          phaseHint:
              'Mitgefühlsübungen vertiefen die Haltung von Freundlichkeit gegenüber sich selbst und anderen.',
          orientationPoints: const [
            'Der Ton kann warm und undramatisch sein.',
            'Wirkung zeigt sich oft subtil und über Zeit.',
            'Selbstfreundlichkeit und Grenzen können zusammen bestehen.',
          ],
          questionPoints: const [
            'Wenn Widerstand auftaucht, kann das mit achtsamem Interesse begleitet werden.',
            'Wenn Formulierungen nicht passen, können stimmige eigene Worte gewählt werden.',
            'Die Übung darf leicht bleiben und muss nicht „groß“ erlebt werden.',
          ],
        );
      case _ExerciseTipType.senses:
        return _ExerciseTipsData(
          icon: Icons.visibility_outlined,
          accentColor: AppStyles.softBrown,
          phaseHint:
              'Sinnesübungen schärfen die direkte Wahrnehmung und reduzieren den Autopiloten.',
          orientationPoints: const [
            'Direkte Sinnesdaten können vor Bewertungen stehen.',
            'Kurze Sequenzen im Alltag genügen oft als Training.',
            'Neugier unterstützt den Zugang stärker als Kontrolle.',
          ],
          questionPoints: const [
            'Wenn viele Gedanken auftauchen, kann sanft zu Sehen, Hören, Spüren zurückgekehrt werden.',
            'Wenn es „nichts Besonderes“ wirkt, kann genau das Teil der Beobachtung sein.',
            'Sinneswahrnehmung kann helfen, in belastenden Momenten wieder Boden zu finden.',
          ],
        );
      case _ExerciseTipType.generic:
        return const _ExerciseTipsData(
          icon: Icons.lightbulb_outline,
          accentColor: AppStyles.softBrown,
          phaseHint:
              'Diese Übung kann als Einladung verstanden werden, präsent zu sein und mit sich selbst freundlich in Kontakt zu bleiben.',
          orientationPoints: [
            'Regelmäßigkeit ist meist hilfreicher als Perfektion.',
            'Ein stimmiges Tempo unterstützt Nachhaltigkeit.',
            'Wahrnehmen steht vor Bewerten.',
          ],
          questionPoints: [
            'Wenn Unsicherheit auftaucht, können kleine, klare Schritte helfen.',
            'Wenn Druck entsteht, kann der Fokus auf Selbstfürsorge zurückgeführt werden.',
            'Auch kurze Übungseinheiten sind ein valider Teil der Praxis.',
          ],
        );
    }
  }
}
