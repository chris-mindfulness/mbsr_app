import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Zentrale App-Konfiguration
///
/// Enthält alle sensiblen Daten und Endpoints
/// In Production sollten diese Werte aus Environment-Variablen geladen werden
class AppConfig {
  // Appwrite Configuration
  static String get appwriteEndpoint =>
      dotenv.env['APPWRITE_ENDPOINT'] ?? 'https://api.mindfulpractice.de/v1';
  static String get appwriteProjectId =>
      dotenv.env['APPWRITE_PROJECT_ID'] ?? '696befd00018180d10ff';

  // Database IDs
  static const String databaseId = 'mbsr_database';

  // Collection IDs
  static const String usersCollectionId = 'users';
  static const String kursDatenCollectionId = 'kurs_daten';

  // Storage Bucket IDs
  static const String contentBucketId = 'mbsr_content';
  static const String audiosBucketId = 'mbsr_content';
  static const String pdfsBucketId = 'mbsr_content';

  // App-spezifische Konstanten
  static const String appName = 'MBSR Achtsamkeitstraining';
  static const String mbsrRole = 'mbsr';

  // Verhindere Instanziierung
  AppConfig._();
}
