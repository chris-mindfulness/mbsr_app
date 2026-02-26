import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/app_daten.dart';
import 'package:mbsr_app/text_archiv_seite.dart';
import 'package:mbsr_app/widgets/weekly_reading_section.dart';

List<Map<String, String>> _extractReadingCards(Map<String, dynamic> weekData) {
  final raw = weekData['readingCards'];
  if (raw is! List) {
    return const [];
  }

  return raw
      .whereType<Map>()
      .map((item) => Map<String, String>.from(item.cast<String, String>()))
      .toList();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Woche 4 Lesemodus', () {
    testWidgets('zeigt Lesesektion, klappt Karten auf und navigiert ins Archiv', (
      tester,
    ) async {
      final week4 = AppDaten.wochenDaten.firstWhere((week) => week['n'] == '4');
      final readingCards = _extractReadingCards(week4);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WeeklyReadingSection(
                readingCards: readingCards,
                readingSummary: week4['readingSummary'] as String?,
                archiveEligible: week4['archiveEligible'] == true,
                readabilityPilot: true,
                showIntroSummary: false,
                showSourceRef: false,
                onOpenArchive: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('LESEN (VOLLTEXT)'), findsOneWidget);
      expect(find.text('Dem Unangenehmen zuwenden'), findsOneWidget);
      expect(
        find.text('Kalender: Automatische Stressreaktionen'),
        findsNothing,
      );
      expect(find.text('Übungen für zu Hause nach Sitzung 4'), findsNothing);
      expect(
        find.textContaining(
          'Hier findest du die Volltexte aus Sitzung 4 in weitgehend vollständiger Form',
        ),
        findsNothing,
      );

      await tester.tap(find.text('Dem Unangenehmen zuwenden'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Abneigung gespürt haben'), findsOneWidget);
      expect(find.textContaining('Quelle:'), findsNothing);
    });

    testWidgets('CTA führt ins Textarchiv', (tester) async {
      final week4 = AppDaten.wochenDaten.firstWhere((week) => week['n'] == '4');
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: SingleChildScrollView(
              child: WeeklyReadingSection(
                readingCards: _extractReadingCards(week4),
                readingSummary: week4['readingSummary'] as String?,
                archiveEligible: true,
                onOpenArchive: () {
                  navigatorKey.currentState!.push(
                    MaterialPageRoute(
                      builder: (_) => const TextArchivSeite(
                        wochenDaten: AppDaten.wochenDaten,
                        initialWeekNumber: 4,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Alle Volltexte im Archiv'));
      await tester.tap(find.text('Alle Volltexte im Archiv'));
      await tester.pumpAndSettle();

      expect(find.text('Textarchiv'), findsOneWidget);
      expect(find.text('Woche 4: Stress in Körper und Geist'), findsOneWidget);
    });

    testWidgets('Archiv zeigt Woche 4 verfügbar und andere Wochen als folgt', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TextArchivSeite(
            wochenDaten: AppDaten.wochenDaten,
            initialWeekNumber: 4,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Woche 4: Stress in Körper und Geist'), findsOneWidget);
      expect(find.text('Volltext verfügbar'), findsOneWidget);
      expect(
        find.text('Kalender: Automatische Stressreaktionen'),
        findsNothing,
      );
      expect(find.text('Übungen für zu Hause nach Sitzung 4'), findsNothing);
      expect(find.text('Woche 1: Achtsamkeit'), findsOneWidget);
      expect(find.text('folgt'), findsWidgets);
      await tester.scrollUntilVisible(
        find.text('Woche 8: Abschied und Neubeginn'),
        500,
      );
      expect(find.text('Woche 8: Abschied und Neubeginn'), findsOneWidget);
      expect(find.text('Dem Unangenehmen zuwenden'), findsOneWidget);
    });
  });
}
