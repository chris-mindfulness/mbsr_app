import 'app_config.dart';

/// Appwrite Storage-URLs (Audio-Bucket), zentral für Stream und Download.
class AppwriteStorageUrls {
  AppwriteStorageUrls._();

  static String _audioFileBase(String fileId) =>
      '${AppConfig.appwriteEndpoint}/storage/buckets/'
      '${AppConfig.audiosBucketId}/files/$fileId';

  /// Wiedergabe im Player (inline).
  static String audioFileViewUrl(String fileId) =>
      '${_audioFileBase(fileId)}/view?project=${AppConfig.appwriteProjectId}';

  /// Download im Browser (Content-Disposition: attachment).
  static String audioFileDownloadUrl(String fileId) =>
      '${_audioFileBase(fileId)}/download?project=${AppConfig.appwriteProjectId}';
}
