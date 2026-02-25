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

        expect(title, isNotNull);
        expect(title!.trim(), isNotEmpty);

        expect(duration, isNotNull);
        expect(duration!.trim(), isNotEmpty);

        expect(appwriteId, isNotNull);
        expect(appwriteId!.trim(), isNotEmpty);

        expect(description, isNotNull);
        expect(description!.trim(), isNotEmpty);

        expect(
          ids.add(appwriteId),
          isTrue,
          reason: 'Doppelte appwrite_id gefunden: $appwriteId',
        );
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

        for (final pdf in pdfs!) {
          final pdfMap = pdf as Map<String, dynamic>;
          final title = pdfMap['title'] as String?;
          final appwriteId = pdfMap['appwrite_id'] as String?;
          expect(title?.trim(), isNotEmpty);
          expect(appwriteId?.trim(), isNotEmpty);
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
      }
    });
  });
}
