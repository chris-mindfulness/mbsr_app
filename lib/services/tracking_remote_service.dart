import 'dart:async';
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' show ExecutionStatus;
import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import '../core/app_config.dart';
import '../core/appwrite_client.dart';

/// Optionales Remote-Tracking fuer 80%-Events.
///
/// Der Service ist bewusst fail-safe:
/// - Wenn deaktiviert oder fehlerhaft, passiert nur ein frueher Return.
/// - Fehler werden nicht nach oben geworfen.
class TrackingRemoteService {
  static final TrackingRemoteService _instance =
      TrackingRemoteService._internal();
  factory TrackingRemoteService() => _instance;
  TrackingRemoteService._internal()
    : _functions = Functions(AppwriteClient().client);

  final Functions _functions;
  /// Synchrone Ausführung kann bei kaltem Start etwas dauern; zu kurz = stilles Timeout.
  static const Duration _defaultTimeout = Duration(seconds: 20);

  bool get isEnabled => AppConfig.enableRemoteTracking;

  Future<void> track80Event({
    required String audioId,
    required String audioTitle,
    required int heardSeconds,
    required int totalSeconds,
    DateTime? eventTimestampUtc,
  }) async {
    if (!isEnabled) return;
    if (audioId.trim().isEmpty || audioTitle.trim().isEmpty) return;
    if (heardSeconds <= 0 || totalSeconds <= 0) return;
    final participantRef = AuthService().currentUser?.$id.trim() ?? '';
    if (participantRef.isEmpty) return;

    final payload = <String, dynamic>{
      'audio_id': audioId.trim(),
      'audio_title': audioTitle.trim(),
      'participant_ref': participantRef,
      'heard_seconds': heardSeconds,
      'total_seconds': totalSeconds,
      'event_timestamp_utc': (eventTimestampUtc ?? DateTime.now().toUtc())
          .toIso8601String(),
      'timezone': AppConfig.trackingTimezone,
    };

    try {
      final execution = await _functions
          .createExecution(
            functionId: AppConfig.trackingFunctionId,
            body: jsonEncode(payload),
            // Synchron: Response-Body/Status stehen in der Antwort (async liefert
            // bei Client oft leere responseBody; Fehler in der Worker-Pipeline
            // bleiben unsichtbar).
            xasync: false,
          )
          .timeout(_defaultTimeout);
      if (kDebugMode) {
        if (execution.status == ExecutionStatus.failed) {
          debugPrint(
            'TrackingRemoteService: Execution failed — '
            'status=${execution.status.value} '
            'response=${execution.responseStatusCode} '
            'body=${execution.responseBody} errors=${execution.errors}',
          );
        } else if (execution.responseStatusCode >= 400) {
          debugPrint(
            'TrackingRemoteService: Execution HTTP ${execution.responseStatusCode} '
            'body=${execution.responseBody}',
          );
        }
      }
    } on TimeoutException catch (_) {
      if (kDebugMode) {
        debugPrint('TrackingRemoteService: Timeout bei Function-Aufruf');
      }
    } on AppwriteException catch (e) {
      if (kDebugMode) {
        debugPrint(
          'TrackingRemoteService: Appwrite-Fehler ${e.code} (${e.message})',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('TrackingRemoteService: Unerwarteter Fehler: $e');
      }
    }
  }
}
