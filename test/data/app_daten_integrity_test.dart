import 'package:flutter_test/flutter_test.dart';
import 'package:mbsr_app/app_daten.dart';

void main() {
  group('AppDaten Integrität', () {
    test('Mediathek-Audios haben vollständige Pflichtfelder', () {
      expect(AppDaten.mediathekAudios, isNotEmpty);

      final ids = <String>{};

      for (final audio in AppDaten.mediathekAudios) {
        final title = audio['title'];
        final duration = audio['duration'];
        final appwriteId = audio['appwrite_id'];
        final description = audio['description'];
        final pendingUpload = audio['upload_status'] == 'pending';

        expect(title, isNotNull);
        expect(title!.trim(), isNotEmpty);

        expect(duration, isNotNull);
        expect(duration!.trim(), isNotEmpty);

        expect(appwriteId, isNotNull);
        if (pendingUpload) {
          expect(
            appwriteId!.trim(),
            isEmpty,
            reason:
                'Einträge mit upload_status=pending haben noch keine appwrite_id',
          );
        } else {
          expect(appwriteId!.trim(), isNotEmpty);
          expect(
            ids.add(appwriteId),
            isTrue,
            reason: 'Doppelte appwrite_id gefunden: $appwriteId',
          );
        }

        expect(description, isNotNull);
        expect(description!.trim(), isNotEmpty);
      }
    });

    test('Wochenstruktur ist vollständig und referenziert gültige Audios', () {
      expect(AppDaten.wochenDaten.length, 8);

      final audioTitles = AppDaten.mediathekAudios
          .map((audio) => audio['title'])
          .toSet();

      for (final woche in AppDaten.wochenDaten) {
        expect((woche['n'] as String?)?.trim(), isNotEmpty);
        expect((woche['t'] as String?)?.trim(), isNotEmpty);

        final audioRefs = (woche['audioRefs'] as List<dynamic>?);
        final pdfs = (woche['pdfs'] as List<dynamic>?);
        final aufgaben = (woche['wochenAufgaben'] as List<dynamic>?);
        final readingCards = (woche['readingCards'] as List<dynamic>?);

        expect(audioRefs, isNotNull);
        expect(audioRefs, isNotEmpty);
        expect(pdfs, isNotNull);
        expect(pdfs, isNotEmpty);
        expect(aufgaben, isNotNull);
        expect(aufgaben, isNotEmpty);

        for (final ref in audioRefs!) {
          expect(
            audioTitles.contains(ref),
            isTrue,
            reason: 'Audio-Referenz nicht in Mediathek gefunden: $ref',
          );
        }

        var arbeitsblattCount = 0;
        for (final pdf in pdfs!) {
          final pdfMap = pdf as Map<String, dynamic>;
          final title = pdfMap['title'] as String?;
          final appwriteId = pdfMap['appwrite_id'] as String?;
          final kind = (pdfMap['kind'] as String?)?.trim();
          expect(title?.trim(), isNotEmpty);
          expect(appwriteId?.trim(), isNotEmpty);
          if (kind != null && kind.isNotEmpty) {
            expect(
              kind == AppDaten.pdfKindKursunterlage ||
                  kind == AppDaten.pdfKindArbeitsblatt,
              isTrue,
              reason: 'Unbekanntes PDF-kind: $kind',
            );
          }
          if (kind == AppDaten.pdfKindArbeitsblatt) {
            arbeitsblattCount++;
          }
        }
        expect(
          arbeitsblattCount,
          lessThanOrEqualTo(1),
          reason:
              'Pro Woche höchstens ein Arbeitsblatt (kind: ${AppDaten.pdfKindArbeitsblatt})',
        );

        if (readingCards != null && readingCards.isNotEmpty) {
          for (final card in readingCards) {
            final cardMap = Map<String, dynamic>.from(card as Map);
            final id = cardMap['id'] as String?;
            final title = cardMap['title'] as String?;
            final body = cardMap['body'] as String?;
            expect(id?.trim(), isNotEmpty);
            expect(title?.trim(), isNotEmpty);
            expect(body?.trim(), isNotEmpty);
          }
        }
      }
    });

    test('Tag der Achtsamkeit enthält mindestens ein PDF mit ID', () {
      final tag = AppDaten.tagDerAchtsamkeit;
      final titel = tag['titel'] as String?;
      final pdfs = tag['pdfs'] as List<dynamic>?;

      expect(titel?.trim(), isNotEmpty);
      expect(pdfs, isNotNull);
      expect(pdfs, isNotEmpty);

      for (final pdf in pdfs!) {
        final pdfMap = pdf as Map<String, dynamic>;
        expect((pdfMap['title'] as String?)?.trim(), isNotEmpty);
        expect((pdfMap['appwrite_id'] as String?)?.trim(), isNotEmpty);
        final kind = (pdfMap['kind'] as String?)?.trim();
        if (kind != null && kind.isNotEmpty) {
          expect(
            kind == AppDaten.pdfKindKursunterlage ||
                kind == AppDaten.pdfKindArbeitsblatt,
            isTrue,
          );
        }
      }
    });
  });
}
