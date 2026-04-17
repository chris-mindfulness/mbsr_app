/// Zentrale App-Konfiguration
///
/// Enthält alle sensiblen Daten und Endpoints
/// In Production sollten diese Werte via `--dart-define` gesetzt werden.
class AppConfig {
  // Appwrite Configuration
  static const String appwriteEndpoint = String.fromEnvironment(
    'APPWRITE_ENDPOINT',
    defaultValue: 'https://api.mindfulpractice.de/v1',
  );
  static const String appwriteProjectId = String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
    defaultValue: '696befd00018180d10ff',
  );
  static const bool enableRemoteTracking = bool.fromEnvironment(
    'APP_ENABLE_REMOTE_TRACKING',
    defaultValue: false,
  );
  static const String trackingFunctionId = String.fromEnvironment(
    'APP_TRACKING_FUNCTION_ID',
    defaultValue: 'track_80_event',
  );
  static const String trackingTimezone = String.fromEnvironment(
    'APP_TRACKING_TIMEZONE',
    defaultValue: 'Europe/Berlin',
  );

  /// Ziel-URL nach Passwort-Reset (Appwrite `createRecovery`).
  ///
  /// Nur per `--dart-define=APP_PASSWORD_RESET_REDIRECT_URL=...` überschreiben.
  /// Niemals aus Nutzereingaben setzen. In Appwrite muss die exakte URL erlaubt sein.
  static const String passwordResetRedirectUrl = String.fromEnvironment(
    'APP_PASSWORD_RESET_REDIRECT_URL',
    defaultValue: 'https://app.mindfulpractice.de/reset-password',
  );

  // Database IDs
  static const String databaseId = 'mbsr_database';

  // Collection IDs
  static const String usersCollectionId = 'users';
  static const String kursDatenCollectionId = 'kurs_daten';
  static const String audioDailyAggregateTableId = 'audio_daily_aggregate';
  static const String slotDailyAggregateTableId = 'slot_daily_aggregate';
  static const String weeklyDistributionAggregateTableId =
      'weekly_distribution_aggregate';

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
