import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';
import 'app_daten.dart';
import 'widgets/pdf_link_card.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/section_header_label.dart';

typedef _DownloadRow = ({String sectionTitle, Map<String, String> pdf});

class DownloadsSeite extends StatelessWidget {
  DownloadsSeite({super.key});

  final List<_DownloadRow> _rows = _collectRows();

  static List<_DownloadRow> _collectRows() {
    final rows = <_DownloadRow>[];

    for (final woche in AppDaten.wochenDaten) {
      if (woche['downloadsAusblenden'] == true) continue;
      final n = '${woche['n'] ?? ''}';
      final t = '${woche['t'] ?? ''}';
      final sectionTitle = 'Woche $n: $t';
      final list = AppDaten.pdfMapsFromRaw(woche['pdfs'] as List<dynamic>?);
      list.sort((a, b) {
        final oa =
            AppDaten.pdfKindOf(a) == AppDaten.pdfKindArbeitsblatt ? 1 : 0;
        final ob =
            AppDaten.pdfKindOf(b) == AppDaten.pdfKindArbeitsblatt ? 1 : 0;
        return oa.compareTo(ob);
      });
      for (final pdf in list) {
        rows.add((sectionTitle: sectionTitle, pdf: pdf));
      }
    }

    final tag = AppDaten.tagDerAchtsamkeit;
    final tagTitle = '${tag['titel'] ?? 'Tag der Achtsamkeit'}';
    for (final pdf in AppDaten.pdfMapsFromRaw(tag['pdfs'] as List<dynamic>?)) {
      rows.add((sectionTitle: tagTitle, pdf: pdf));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          'Downloads',
          style: AppStyles.headingStyle.copyWith(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppStyles.softBrown,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DecorativeBlobs(
        child: ListView(
          padding: AppStyles.listPadding,
          children: [
            Text('Alle PDFs: Kursheft & Arbeitsblätter', style: AppStyles.subTitleStyle),
            AppStyles.spacingMBox,
            if (_rows.isEmpty)
              Text(
                'Noch keine Downloads verfügbar.',
                style: AppStyles.bodyStyle,
              )
            else
              ..._buildGroupedChildren(),
            AppStyles.spacingXLBox,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupedChildren() {
    final out = <Widget>[];
    String? lastSection;
    for (final row in _rows) {
      if (row.sectionTitle != lastSection) {
        lastSection = row.sectionTitle;
        if (out.isNotEmpty) {
          out.add(AppStyles.spacingMBox);
        }
        out.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SectionHeaderLabel(title: row.sectionTitle),
          ),
        );
      }
      out.add(_buildPdfCard(row.pdf));
    }
    return out;
  }

  Widget _buildPdfCard(Map<String, String> pdf) {
    final title = pdf['title'] ?? 'PDF';
    final appwriteId = pdf['appwrite_id'];
    final isPending =
        title.toLowerCase().contains('folgt') ||
        appwriteId == null ||
        appwriteId.isEmpty ||
        appwriteId == '696c0000000000000008';
    final url =
        '${AppConfig.appwriteEndpoint}/storage/buckets/${AppConfig.pdfsBucketId}/files/$appwriteId/view?project=${AppConfig.appwriteProjectId}';
    final isArbeitsblatt =
        AppDaten.pdfKindOf(pdf) == AppDaten.pdfKindArbeitsblatt;

    return PdfLinkCard(
      title: title,
      onTap: () => launchUrl(Uri.parse(url)),
      isPending: isPending,
      pendingText: 'Wird zeitnah bereitgestellt.',
      leadingIcon: isArbeitsblatt
          ? Icons.edit_note_outlined
          : Icons.description_outlined,
      leadingColor:
          isArbeitsblatt ? AppStyles.primaryOrange : AppStyles.softBrown,
      readyTrailingIcon: Icons.open_in_new,
      pendingTrailingIcon: Icons.schedule,
      layout: PdfCardLayout.row,
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      showPendingSubtitle: true,
    );
  }
}
