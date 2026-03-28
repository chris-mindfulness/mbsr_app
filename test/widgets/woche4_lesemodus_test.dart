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

  group('Lesetexte & Textarchiv', () {
    testWidgets('leere readingCards: keine LESEN-Sektion (Woche 4)', (
      tester,
    ) async {
      final week4 = AppDaten.wochenDaten.firstWhere((week) => week['n'] == '4');
      final readingCards = _extractReadingCards(week4);
      expect(readingCards, isEmpty);

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

      expect(find.text('LESEN'), findsNothing);
      expect(find.text('Alle Texte im Archiv'), findsNothing);
    });

    testWidgets('WeeklyReadingSection mit Karten zeigt LESEN und Archiv-CTA', (
      tester,
    ) async {
      final sampleCards = [
        {
          'id': 'test-card',
          'title': 'Beispiel-Lesetext',
          'body': 'Kurzer Fließtext zum Aufklappen in der Testumgebung.',
        },
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WeeklyReadingSection(
                readingCards: sampleCards,
                readingSummary: 'Kurze Zusammenfassung für den Test.',
                archiveEligible: true,
                readabilityPilot: true,
                showIntroSummary: true,
                showSourceRef: false,
                onOpenArchive: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('LESEN'), findsOneWidget);
      expect(find.text('Beispiel-Lesetext'), findsOneWidget);
      expect(find.text('Alle Texte im Archiv'), findsOneWidget);

      await tester.tap(find.text('Beispiel-Lesetext'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Kurzer Fließtext zum Aufklappen'),
        findsOneWidget,
      );
    });

    testWidgets('CTA öffnet Textarchiv-Seite', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      final sampleCards = [
        {
          'id': 'test-card',
          'title': 'Beispiel-Lesetext',
          'body': 'Inhalt',
        },
      ];

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: SingleChildScrollView(
              child: WeeklyReadingSection(
                readingCards: sampleCards,
                readingSummary: null,
                archiveEligible: true,
                showIntroSummary: false,
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
      await tester.ensureVisible(find.text('Alle Texte im Archiv'));
      await tester.tap(find.text('Alle Texte im Archiv'));
      await tester.pumpAndSettle();

      expect(find.text('Textarchiv'), findsOneWidget);
      expect(find.text('Woche 4: Stress in Körper und Geist'), findsOneWidget);
    });

    testWidgets('Textarchiv: alle Wochen ohne freigeschaltete Lesetexte', (
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

      expect(find.text('Textarchiv'), findsOneWidget);
      expect(find.text('Woche 4: Stress in Körper und Geist'), findsOneWidget);
      expect(find.text('Texte verfügbar'), findsNothing);
      expect(find.text('Texte folgen'), findsNWidgets(8));
      expect(find.text('folgt'), findsNWidgets(8));
      expect(find.text('Woche 1: Achtsamkeit'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Woche 8: Abschied und Neubeginn'),
        500,
      );
      expect(find.text('Woche 8: Abschied und Neubeginn'), findsOneWidget);
    });
  });
}
