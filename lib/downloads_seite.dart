import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';
import 'app_daten.dart';
import 'widgets/decorative_blobs.dart';

class DownloadsSeite extends StatelessWidget {
  DownloadsSeite({super.key});

  final List<Map<String, String>> _pdfs = _collectPdfs();

  static List<Map<String, String>> _collectPdfs() {
    final pdfs = <Map<String, String>>[];

    for (final woche in AppDaten.wochenDaten) {
      final entries = woche['pdfs'];
      if (entries is List) {
        for (final entry in entries) {
          if (entry is Map) {
            final title = entry['title'];
            final appwriteId = entry['appwrite_id'];
            if (title is String && appwriteId is String) {
              pdfs.add({'title': title, 'appwrite_id': appwriteId});
            }
          }
        }
      }
    }

    final tagPdfs = AppDaten.tagDerAchtsamkeit['pdfs'];
    if (tagPdfs is List) {
      for (final entry in tagPdfs) {
        if (entry is Map) {
          final title = entry['title'];
          final appwriteId = entry['appwrite_id'];
          if (title is String && appwriteId is String) {
            pdfs.add({'title': title, 'appwrite_id': appwriteId});
          }
        }
      }
    }

    return pdfs;
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
          icon: const Icon(
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
            Text('Alle Kursunterlagen & PDFs', style: AppStyles.subTitleStyle),
            AppStyles.spacingMBox,
            if (_pdfs.isEmpty)
              Text(
                'Noch keine Downloads verfügbar.',
                style: AppStyles.bodyStyle,
              )
            else
              ..._pdfs.map(_buildPdfCard),
            AppStyles.spacingXLBox,
          ],
        ),
      ),
    );
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

    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: isPending ? null : () => launchUrl(Uri.parse(url)),
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        child: Padding(
          padding: AppStyles.cardPadding,
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppStyles.softBrown.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppStyles.softBrown,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppStyles.subTitleStyle),
                    if (isPending) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Wird zeitnah bereitgestellt.',
                        style: AppStyles.bodyStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                isPending ? Icons.schedule : Icons.open_in_new,
                color: AppStyles.borderColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
