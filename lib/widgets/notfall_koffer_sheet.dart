import 'package:flutter/material.dart';

import '../app_daten.dart';
import '../core/app_styles.dart';
import 'sos_item_card.dart';

IconData _notfallIcon(String? key) {
  switch (key) {
    case 'self_improvement':
      return Icons.self_improvement;
    case 'favorite_outline':
      return Icons.favorite_outline;
    case 'waves':
      return Icons.waves;
    case 'air':
      return Icons.air;
    default:
      return Icons.timer;
  }
}

/// Gemeinsames Notfall-Koffer-Bottom-Sheet (Wochenansicht + Mediathek).
///
/// Kurzmeditationen kommen aus [AppDaten.notfallKofferMeditationen] und werden
/// über [onPlayNotfallAudio] direkt abgespielt (Sonderstatus).
class NotfallKofferSheet {
  NotfallKofferSheet._();

  static void show(
    BuildContext context, {
    required void Function(Map<String, String> audio) onPlayNotfallAudio,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppStyles.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (sheetContext) {
        return SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.support_agent,
                        color: AppStyles.errorRed,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Notfall-Koffer',
                        style: AppStyles.headingStyle.copyWith(
                          color: AppStyles.errorRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Erste Hilfe bei akutem Stress',
                    style: AppStyles.subTitleStyle,
                  ),
                  const SizedBox(height: 16),
                  ...AppDaten.notfallKofferMeditationen.expand((raw) {
                    final entry = Map<String, String>.from(raw);
                    final title = entry['card_title'] ?? '';
                    final description = entry['card_description'] ?? '';
                    final icon = _notfallIcon(entry['icon']);
                    return [
                      SosItemCard(
                        icon: icon,
                        title: title,
                        description: description,
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          final audio = AppDaten.notfallPlaybackForEntry(entry);
                          if (audio.isEmpty) {
                            messenger?.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Diese Übung ist noch nicht einrichtbar — '
                                  'Eintrag in den Kursdaten folgt.',
                                  style: AppStyles.bodyStyle,
                                ),
                                backgroundColor: AppStyles.softBrown,
                              ),
                            );
                            return;
                          }
                          onPlayNotfallAudio(audio);
                        },
                      ),
                      const SizedBox(height: 16),
                    ];
                  }),
                  SosItemCard(
                    icon: Icons.waves,
                    title: 'Physiologischer Seufzer',
                    description:
                        '1) Einmal durch die Nase einatmen.\n'
                        '2) Ohne auszuatmen: gleich noch einen kurzen zweiten Zug durch die Nase – die Lunge wird noch ein bisschen voller.\n'
                        '3) Dann langsam und weich durch den Mund ausatmen, wie ein erleichterter Seufzer.\n'
                        'Wichtig: Zwischen Schritt 1 und 2 keine Pause zum Ausatmen. Das Ganze ein- bis dreimal, in deinem Tempo.',
                    accentColor: AppStyles.errorRed,
                  ),
                  const SizedBox(height: 16),
                  SosItemCard(
                    icon: Icons.accessibility_new,
                    title: 'Körper spüren',
                    description:
                        'Spüre deine Füße auf dem Boden. Nimm 3 tiefe Atemzüge.',
                    accentColor: AppStyles.errorRed,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
