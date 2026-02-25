import 'dart:async';
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/appwrite_client.dart';
import '../core/app_config.dart';

/// Authentifizierungs-Service für Appwrite
///
/// Security Features:
/// - Session-basierte Authentifizierung
/// - Sichere Logout-Funktionen (einzelne oder alle Sessions)
/// - Stream für Auth-Status-Änderungen
/// - Benutzerfreundliche Fehlermeldungen
class AuthService {
  static const String _cachedUserKey = 'auth_cached_user_v1';
  static const String _cachedRoleKey = 'auth_cached_role_v1';

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _appwrite = AppwriteClient();
  final _authStateController = StreamController<models.User?>.broadcast();

  /// Stream für Auth-Status (ähnlich zum früheren authStateChanges-Verhalten)
  /// Emittiert sofort den aktuellen Status beim Abonnieren
  Stream<models.User?> get authStateChanges async* {
    yield _currentUser;
    yield* _authStateController.stream;
  }

  models.User? _currentUser;
  models.User? get currentUser => _currentUser;

  Future<void> _saveCachedUser(models.User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedUserKey, jsonEncode(user.toMap()));
  }

  Future<void> _saveCachedRole(Map<String, dynamic> roleData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedRoleKey, jsonEncode(roleData));
  }

  Future<models.User?> _loadCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_cachedUserKey);
    if (json == null || json.isEmpty) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return models.User.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _loadCachedRoleForEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_cachedRoleKey);
    if (json == null || json.isEmpty) return null;

    try {
      final map = (jsonDecode(json) as Map).cast<String, dynamic>();
      if ((map['email'] as String?) == email) return map;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _clearCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedUserKey);
    await prefs.remove(_cachedRoleKey);
  }

  Future<Map<String, dynamic>?> _loadRoleProfile(
    String email, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (kDebugMode) {
      debugPrint('🔍 Auth-Service: Lade Rollenprofil für $email...');
    }

    // 1) Primär: TablesDB (neues Schema)
    try {
      final response = await _appwrite.tablesDB
          .listRows(
            databaseId: AppConfig.databaseId,
            tableId: AppConfig.usersCollectionId,
            queries: [Query.equal('email', email), Query.limit(1)],
          )
          .timeout(timeout);

      if (response.rows.isNotEmpty) {
        final row = response.rows.first;
        await _saveCachedRole(row.data);
        if (kDebugMode) {
          debugPrint('✅ Rollenprofil via TablesDB: ${row.data['role']}');
        }
        return row.data;
      }

      if (kDebugMode) {
        debugPrint(
          'ℹ️ TablesDB ohne Treffer für $email, prüfe Legacy-Collection',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ TablesDB-Fehler beim Rollenladen: $e');
      }
    }

    // 2) Fallback: Legacy Databases/Collection
    try {
      // ignore: deprecated_member_use
      final legacyFuture = _appwrite.databases.listDocuments(
        databaseId: AppConfig.databaseId,
        collectionId: AppConfig.usersCollectionId,
        queries: [Query.equal('email', email), Query.limit(1)],
      );
      final legacy = await legacyFuture.timeout(timeout);

      if (legacy.documents.isNotEmpty) {
        final data = legacy.documents.first.data;
        await _saveCachedRole(data);
        if (kDebugMode) {
          debugPrint('✅ Rollenprofil via Legacy-Collection: ${data['role']}');
        }
        return data;
      }

      if (kDebugMode) {
        debugPrint(
          '⛔ Kein Rollenprofil in TablesDB oder Legacy-Collection für $email',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Legacy-Collection-Fehler beim Rollenladen: $e');
      }
    }

    // 3) Lokaler Cache als letzter Fallback
    final cached = await _loadCachedRoleForEmail(email);
    if (cached != null) {
      if (kDebugMode) {
        debugPrint('⚠️ Rollen-Fallback aus lokalem Cache für $email');
      }
      return cached;
    }

    return null;
  }

  Future<RoleResolution> resolveRoleForEmail({
    required String email,
    String? name,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final roleData = await _loadRoleProfile(email, timeout: timeout);
    if (roleData != null) {
      return RoleResolution(role: roleData['role'] as String?);
    }

    if (kDebugMode) {
      debugPrint('⛔ User $email hat kein Profil-Dokument');
      debugPrint(
        '⚠️ Nutze Fallback-Rolle mbsr, um Navigation nicht zu blockieren',
      );
    }

    final fallbackRole = <String, dynamic>{
      'email': email,
      'role': AppConfig.mbsrRole,
      'name': name,
    };
    await _saveCachedRole(fallbackRole);
    return const RoleResolution(role: AppConfig.mbsrRole, fromFallback: true);
  }

  /// Initialisiert den Auth-Service und prüft bestehende Session
  ///
  /// Unterscheidet zwischen:
  /// - 401 Unauthorized → wirklich ausgeloggt
  /// - Timeout/Netzwerkfehler → Retry, nicht sofort ausloggen
  Future<void> initialize() async {
    const maxRetries = 3;
    const timeout = Duration(seconds: 15);
    final cachedUser = await _loadCachedUser();

    // Frühzeitig lokalen Fallback setzen, damit bei Startfehlern kein
    // unnötiger Logout-Zustand entsteht.
    if (cachedUser != null) {
      _currentUser = cachedUser;
      if (kDebugMode) {
        debugPrint('🧠 Lokaler User-Fallback geladen: ${cachedUser.email}');
      }
    }

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        if (kDebugMode) {
          debugPrint(
            '🔐 Auth-Service: Prüfe Session (Versuch $attempt/$maxRetries)...',
          );
        }

        final user = await _appwrite.account.get().timeout(
          timeout,
          onTimeout: () {
            throw TimeoutException('Session-Prüfung dauerte zu lange');
          },
        );

        _currentUser = user;
        await _saveCachedUser(user);
        _authStateController.add(user);
        if (kDebugMode) {
          debugPrint('✅ Bestehende Session gefunden: ${user.email}');
        }
        return; // Erfolg - beende
      } on AppwriteException catch (e) {
        // 401 = wirklich keine gültige Session
        if (e.code == 401) {
          if (cachedUser != null) {
            _currentUser = cachedUser;
            _authStateController.add(cachedUser);
            if (kDebugMode) {
              debugPrint(
                '⚠️ Session-Check 401, nutze lokalen Fallback-User: ${cachedUser.email}',
              );
            }
            return;
          } else {
            if (kDebugMode) {
              debugPrint('ℹ️ Keine aktive Session (401 Unauthorized)');
            }
            _currentUser = null;
            _authStateController.add(null);
            return; // Definitiv ausgeloggt
          }
        }

        // Andere Appwrite-Fehler: bei letztem Versuch aufgeben
        if (attempt == maxRetries) {
          if (kDebugMode) {
            debugPrint(
              '⚠️ Auth-Service: Appwrite-Fehler nach $maxRetries Versuchen: ${e.message}',
            );
          }
          // Nicht ausloggen - Zustand unbekannt, behalte letzten Zustand
          _authStateController.add(_currentUser);
        }
      } on TimeoutException {
        if (kDebugMode) {
          debugPrint('⚠️ Auth-Service: Timeout (Versuch $attempt/$maxRetries)');
        }
        if (attempt == maxRetries) {
          // Nach allen Versuchen: Zustand unbekannt, behalte letzten Zustand
          if (kDebugMode) {
            debugPrint(
              '⚠️ Auth-Service: Alle Versuche fehlgeschlagen - behalte letzten Zustand',
            );
          }
          _authStateController.add(_currentUser);
        }
      } catch (e) {
        // Netzwerk- oder andere Fehler
        if (kDebugMode) {
          debugPrint(
            '⚠️ Auth-Service: Fehler (Versuch $attempt/$maxRetries): $e',
          );
        }
        if (attempt == maxRetries) {
          // Nicht ausloggen bei Netzwerkproblemen
          if (kDebugMode) {
            debugPrint(
              '⚠️ Auth-Service: Netzwerkfehler - behalte letzten Zustand',
            );
          }
          _authStateController.add(_currentUser);
        }
      }

      // Kurze Pause vor Retry (außer beim letzten Versuch)
      if (attempt < maxRetries) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  /// Alias für initialize() zur besseren Lesbarkeit
  Future<void> checkSession() => initialize();

  /// Login mit Email und Passwort
  ///
  /// Wirft [AuthException] bei Fehlern mit benutzerfreundlicher Nachricht
  Future<models.User> login({
    required String email,
    required String password,
  }) async {
    try {
      if (kDebugMode) debugPrint('🔐 Login-Versuch für: $email');

      // Erstelle Email-Password-Session
      await _appwrite.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Hole User-Daten
      final user = await _appwrite.account.get();
      _currentUser = user;
      await _saveCachedUser(user);
      _authStateController.add(user);

      if (kDebugMode) debugPrint('✅ Login erfolgreich: ${user.email}');
      return user;
    } on AppwriteException catch (e) {
      if (kDebugMode) debugPrint('❌ Login-Fehler: ${e.message}');
      throw AuthException._fromAppwriteException(e);
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Unerwarteter Login-Fehler: $e');
      throw AuthException('Ein unerwarteter Fehler ist aufgetreten.');
    }
  }

  /// Registrierung (Nur für Admin/Migration)
  /// Erstellt Auth-Account UND Datenbank-Eintrag
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String role = AppConfig.mbsrRole,
  }) async {
    try {
      if (kDebugMode) debugPrint('📝 Erstelle Account für: $email');

      // 1. Auth Account erstellen
      await _appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // 2. Datenbank-Dokument erstellen (Nur 3 Felder!)
      await _appwrite.tablesDB.createRow(
        databaseId: AppConfig.databaseId,
        tableId: AppConfig.usersCollectionId,
        rowId: ID.unique(),
        data: {'email': email, 'role': role, 'name': name},
      );

      if (kDebugMode) debugPrint('✅ Account & Profil erfolgreich erstellt');
    } on AppwriteException catch (e) {
      throw AuthException._fromAppwriteException(e);
    }
  }

  /// Logout (beendet aktuelle Session)
  Future<void> logout() async {
    try {
      if (kDebugMode) debugPrint('🔓 Logout...');

      // Lösche aktuelle Session
      await _appwrite.account.deleteSession(sessionId: 'current');

      _currentUser = null;
      await _clearCachedUser();
      _authStateController.add(null);

      if (kDebugMode) debugPrint('✅ Logout erfolgreich');
    } on AppwriteException catch (e) {
      if (kDebugMode) debugPrint('⚠️ Logout-Fehler: ${e.message}');
      // Auch bei Fehler den lokalen State zurücksetzen
      _currentUser = null;
      await _clearCachedUser();
      _authStateController.add(null);
    }
  }

  /// Logout von ALLEN Geräten (löscht alle Sessions)
  ///
  /// Nützlich bei:
  /// - Passwort-Änderung
  /// - Sicherheitsbedenken
  /// - "Alle Geräte abmelden" Funktion
  Future<void> deleteAllSessions() async {
    try {
      if (kDebugMode) debugPrint('🔓 Lösche alle Sessions...');

      final sessions = await _appwrite.account.listSessions();

      for (final session in sessions.sessions) {
        try {
          await _appwrite.account.deleteSession(sessionId: session.$id);
          if (kDebugMode) debugPrint('✅ Session gelöscht: ${session.$id}');
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ Fehler beim Löschen von Session ${session.$id}: $e');
          }
        }
      }

      _currentUser = null;
      await _clearCachedUser();
      _authStateController.add(null);

      if (kDebugMode) debugPrint('✅ Alle Sessions gelöscht');
    } on AppwriteException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Fehler beim Löschen aller Sessions: ${e.message}');
      }
      throw AuthException._fromAppwriteException(e);
    }
  }

  /// Passwort-Reset per Email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      if (kDebugMode) debugPrint('📧 Sende Passwort-Reset-Email an: $email');

      // Appwrite benötigt eine Redirect-URL für den Reset-Link
      // Diese sollte zu deiner App zurückführen
      final redirectUrl = 'https://app.mindfulpractice.de/reset-password';

      await _appwrite.account.createRecovery(email: email, url: redirectUrl);

      if (kDebugMode) debugPrint('✅ Passwort-Reset-Email gesendet');
    } on AppwriteException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Fehler beim Senden der Reset-Email: ${e.message}');
      }
      throw AuthException._fromAppwriteException(e);
    }
  }

  /// Hole aktuellen User (refresh)
  Future<models.User?> getCurrentUser() async {
    try {
      final user = await _appwrite.account.get();
      _currentUser = user;
      await _saveCachedUser(user);
      return user;
    } catch (e) {
      final cachedUser = await _loadCachedUser();
      _currentUser = cachedUser;
      return cachedUser;
    }
  }

  /// Bereinigt Ressourcen
  void dispose() {
    _authStateController.close();
  }
}

/// Custom Exception für benutzerfreundliche Fehlermeldungen
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  factory AuthException.fromAppwriteException(AppwriteException e) {
    return AuthException._fromAppwriteException(e);
  }

  /// Mappt Appwrite-Fehler auf benutzerfreundliche Nachrichten
  factory AuthException._fromAppwriteException(AppwriteException e) {
    // Mappe häufige Fehler-Codes
    switch (e.code) {
      case 401: // Unauthorized
        return AuthException(
          'E-Mail oder Passwort falsch. Bitte prüfe deine Eingabe.',
        );
      case 429: // Too many requests
        return AuthException(
          'Zu viele Fehlversuche. Bitte warte einen Moment.',
        );
      case 500: // Server error
        return AuthException('Server-Fehler. Bitte versuche es später erneut.');
      case 503: // Service unavailable
        return AuthException('Service vorübergehend nicht verfügbar.');
      default:
        // Im Production-Modus keine internen Details preisgeben
        if (kDebugMode) {
          return AuthException('Fehler: ${e.message} (Code: ${e.code})');
        } else {
          return AuthException(
            'Ein Fehler ist aufgetreten. Bitte versuche es erneut.',
          );
        }
    }
  }

  @override
  String toString() => message;
}

class RoleResolution {
  final String? role;
  final bool fromFallback;

  const RoleResolution({required this.role, this.fromFallback = false});
}
