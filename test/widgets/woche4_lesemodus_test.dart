import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/app_daten.dart';
import 'package:mbsr_app/text_archiv_seite.dart';
import 'package:mbsr_app/widgets/weekly_reading_section.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Lesetexte & Textarchiv', () {
    testWidgets('leere readingCards: keine PSYCHOEDUKATION-Sektion', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WeeklyReadingSection(
                readingCards: const [],
                readingSummary: null,
                archiveEligible: false,
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

      expect(find.text('PSYCHOEDUKATION'), findsNothing);
      expect(find.text('Alle Texte im Archiv'), findsNothing);
    });

    testWidgets('WeeklyReadingSection mit Karten zeigt PSYCHOEDUKATION und Archiv-CTA', (
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

      expect(find.text('PSYCHOEDUKATION'), findsOneWidget);
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

    testWidgets('Textarchiv: alle Wochen mit Lesetexten (Archiv freigeschaltet)', (
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
      expect(find.text('Texte verfügbar'), findsNWidgets(8));
      expect(find.text('Texte folgen'), findsNothing);
      expect(find.text('folgt'), findsNothing);
      expect(find.text('Woche 1: Achtsamkeit'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Woche 8: Abschied und Neubeginn'),
        500,
      );
      expect(find.text('Woche 8: Abschied und Neubeginn'), findsOneWidget);
    });
  });
}
