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

  group('Vertiefung: Bereichsstruktur und Navigation', () {
    testWidgets('zeigt die neuen Bereiche ohne redundante Übersichtskarten', (
      tester,
    ) async {
      // Hoher Viewport: gesamte ListView ohne verkettetes scrollUntilVisible
      // (sonst kann der zweite Scroll in manchen Umgebungen kein Scrollable lösen).
      tester.view.physicalSize = const Size(800, 3200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('PRAXIS VERTIEFEN'), findsWidgets);
      expect(find.text('NACHSCHLAGEN'), findsWidgets);
      expect(find.text('Gut zu wissen'), findsWidgets);
      expect(find.text('Begriffe & Fragen'), findsWidgets);
      expect(find.text('MBSR 8-Wochen-Kurs'), findsNothing);

      expect(find.text('Textarchiv'), findsWidgets);
      expect(find.text('QUELLEN'), findsWidgets);
      expect(find.text('Literatur & Forschung'), findsWidgets);
    });

    testWidgets('Gut zu wissen Karte ist klickbar', (tester) async {
      final observer = _PushCounterObserver();

      await tester.pumpWidget(buildTestApp(observers: [observer]));
      await tester.pumpAndSettle();

      final pushesBeforeTap = observer.pushCount;
      await tester.tap(find.text('Gut zu wissen'));
      await tester.pumpAndSettle();

      expect(observer.pushCount, greaterThan(pushesBeforeTap));
      expect(find.text('Gut zu wissen'), findsWidgets);
    });

    testWidgets('bestehende Karte Begriffe & Fragen bleibt klickbar', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Glossar und häufige Fragen nachschlagen'),
        300,
      );
      await tester.tap(find.text('Glossar und häufige Fragen nachschlagen'));
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
