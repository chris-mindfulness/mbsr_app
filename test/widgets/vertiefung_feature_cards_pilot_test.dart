import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/app_daten.dart';
import 'package:mbsr_app/vertiefung_seite.dart';

class _PushCounterObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    pushCount += 1;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestApp({List<NavigatorObserver> observers = const []}) {
    return MaterialApp(
      navigatorObservers: observers,
      home: VertiefungSeite(
        tagDerAchtsamkeit: AppDaten.tagDerAchtsamkeit,
        zusatzUebungen: AppDaten.zusatzUebungen,
      ),
    );
  }

  group('Vertiefung Pilot: Feature-Microcards', () {
    testWidgets('zeigt die vier Feature-Karten im Infobereich', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('MBSR 8-Wochen-Kurs'), findsOneWidget);
      expect(find.text('Wissen & Hilfe'), findsOneWidget);
      expect(find.text('Textarchiv'), findsWidgets);
      expect(find.text('Literatur & Forschung'), findsOneWidget);
    });

    testWidgets('Feature-Karten sind nicht klickbar', (tester) async {
      final observer = _PushCounterObserver();

      await tester.pumpWidget(buildTestApp(observers: [observer]));
      await tester.pumpAndSettle();

      final pushesBeforeTap = observer.pushCount;
      await tester.tap(find.text('MBSR 8-Wochen-Kurs'));
      await tester.pumpAndSettle();

      expect(observer.pushCount, pushesBeforeTap);
      expect(find.text('Vertiefung'), findsOneWidget);
    });

    testWidgets('bestehende Karte Wissen & Hilfe bleibt klickbar', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Glossar und häufige Fragen'),
        300,
      );
      await tester.tap(find.text('Glossar und häufige Fragen'));
      await tester.pumpAndSettle();
      expect(find.text('Glossar'), findsOneWidget);
    });

    testWidgets('bestehende Karte Textarchiv bleibt klickbar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final textArchivCardTitle = find.text('Textarchiv').last;
      await tester.scrollUntilVisible(textArchivCardTitle, 300);
      await tester.ensureVisible(textArchivCardTitle);
      await tester.tap(textArchivCardTitle);
      await tester.pumpAndSettle();
      expect(find.text('Textarchiv'), findsWidgets);
    });
  });
}
