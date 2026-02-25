import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:appwrite/models.dart' as models;
import '../services/auth_service.dart';
import '../core/app_styles.dart';
import '../splash_screen.dart';
import '../login_screen.dart';
import '../kurs_uebersicht.dart';
import '../pages/home_page.dart';
import '../audio_service.dart';
import '../web_utils.dart' show getCurrentRoute, setRoute;
import '../routing/app_router.dart';

/// Zentrale Authentifizierungs- und Routing-Komponente
///
/// Verantwortlichkeiten:
/// - Appwrite Auth-Status überwachen
/// - Rollen-Check (role: 'mbsr')
/// - Deep-Link Routing
/// - Login/Logout Events erkennen
/// - Error-Handling bei Netzwerkproblemen
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _splashFinished = false;
  String? _lastUserId; // Um Login-Events zu erkennen
  bool _isLoginEvent = false; // Flag für frischen Login
  Future<RoleResolution>? _roleFuture;
  String? _roleFutureEmail;
  String? _roleFutureName;
  StreamSubscription<models.User?>? _authSubscription;

  @override
  void initState() {
    super.initState();

    // Globaler Listener für Auth-Status (Sicherheitsnetz für Audio)
    _authSubscription = AuthService().authStateChanges.listen((user) {
      if (kDebugMode) {
        debugPrint(
          'AuthWrapper: Status-Update erhalten. User: ${user?.email ?? "ausgeloggt"}',
        );
      }
      if (user == null) {
        if (kDebugMode) {
          debugPrint('👤 Auth-Status: Abgemeldet -> Stoppe AudioService');
        }
        AudioService().stop();
      }
    });

    if (kDebugMode) {
      debugPrint('🚀 AuthWrapper gestartet (Appwrite)');
      debugPrint('📍 Aktuelle Browser-URL: ${Uri.base}');
    }

    // Wenn bereits ein User geladen ist (z. B. nach Refresh mit Cache),
    // Splash überspringen, um visuelles Zucken zu vermeiden.
    if (AuthService().currentUser != null) {
      _splashFinished = true;
      if (kDebugMode) {
        debugPrint(
          '⚡ AuthWrapper: Überspringe Startup-Splash (User bereits da)',
        );
      }
      return;
    }

    // Safety Timeout: Falls der Splash Screen nicht verschwindet
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_splashFinished) {
        if (kDebugMode) {
          debugPrint(
            '⚠️ AuthWrapper: Safety Timeout erreicht, erzwinge Splash-Ende',
          );
        }
        setState(() => _splashFinished = true);
      }
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _splashFinished = true);
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _syncRoleFuture(models.User? user) {
    if (user == null) {
      _roleFuture = null;
      _roleFutureEmail = null;
      _roleFutureName = null;
      return;
    }

    if (_roleFutureEmail == user.email && _roleFuture != null) return;
    _roleFutureEmail = user.email;
    _roleFutureName = user.name;
    _roleFuture = AuthService().resolveRoleForEmail(
      email: user.email,
      name: user.name,
    );
  }

  void _retryRoleLoad() {
    final email = _roleFutureEmail;
    if (email == null) {
      setState(() {});
      return;
    }

    setState(() {
      _roleFuture = AuthService().resolveRoleForEmail(
        email: email,
        name: _roleFutureName,
      );
    });
  }

  void _syncLoginState(models.User? user) {
    final bool isNewLogin = (_lastUserId == null && user != null);

    if (isNewLogin) {
      if (kDebugMode) {
        debugPrint('🔓 FRISCHER LOGIN erkannt! User: ${user.email}');
        debugPrint('🔓 Setze Login-Event-Flag...');
      }
      _lastUserId = user.$id;
      _isLoginEvent = true;
      return;
    }

    if (_lastUserId != null && user == null) {
      _isLoginEvent = false;
      _lastUserId = null;
      if (kDebugMode) {
        debugPrint('🔒 Logout erkannt! Setze Login-Event-Flag zurück...');
      }
      return;
    }

    _lastUserId = user?.$id;
  }

  String? _readCurrentRoute() {
    try {
      final route = getCurrentRoute();
      if (kDebugMode) {
        debugPrint('🔗 Aktuelle Route: ${route ?? "(leer)"}');
      }
      return route;
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Fehler beim Auslesen der Route: $e');
      return null;
    }
  }

  /// Bestimmt die Zielseite basierend auf Route und Auth-Status
  Widget _getTargetPage(
    String? route,
    models.User? user,
    String? role, {
    required bool isLoginEvent,
  }) {
    if (kDebugMode) {
      debugPrint(
        '🔍 _getTargetPage - User: ${user?.email ?? "nein"}, Rolle: ${role ?? "nein"}, Route: $route, LoginEvent: $isLoginEvent',
      );
    }

    // Nicht eingeloggt -> Zeige Auswahlseite (MBSRHomePage)
    // ABER: Wenn die Route /login ist, zeige direkt LoginScreen
    if (user == null) {
      if (route == '/login') {
        if (kDebugMode) debugPrint('✅ Navigation: LoginScreen (Route /login)');
        return const LoginScreen();
      }
      if (kDebugMode) {
        debugPrint('✅ Navigation: MBSRHomePage (nicht eingeloggt)');
      }
      return const MBSRHomePage();
    }

    // PRIORITÄT 1: Eingeloggt, aber keine gültige Rolle
    // WICHTIG: Kein automatisches Logout, um Refresh-Logout-Schleifen zu vermeiden.
    if (role != 'mbsr') {
      if (kDebugMode) debugPrint('⛔ Kein MBSR-Zugriff für ${user.email}');
      return _buildErrorScreen(
        title: 'Profil wird geprüft',
        message:
            'Du bist angemeldet, aber dein Kursprofil konnte noch nicht eindeutig zugeordnet werden.',
        icon: Icons.lock_outline,
      );
    }

    // PRIORITÄT 2: FRISCHER LOGIN hat absolute Priorität!
    // Nach einem Login IMMER zur Standard-Startseite, egal was in der URL steht
    if (isLoginEvent) {
      if (kDebugMode) {
        debugPrint('🚀 Frischer Login erkannt -> Zeige KursUebersicht');
        debugPrint('🚀 Ignoriere aktuelle Route: $route');
      }

      setRoute('/home'); // URL im Browser synchronisieren

      // Login-Event-Flag SOFORT zurücksetzen (nicht im PostFrameCallback)
      // Verwende Future.microtask für schnelles Reset ohne Build-Konflikt
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _isLoginEvent = false;
            if (kDebugMode) debugPrint('🔄 Login-Event-Flag zurückgesetzt');
          });
        }
      });

      // Gebe KursUebersicht direkt als Root-Widget zurück
      // KEIN Stack-Bereinigung mehr - pushReplacement hat das bereits erledigt
      return const KursUebersicht();
    }

    // PRIORITÄT 3: Wenn URL leer oder /login ist -> Normal zur KursUebersicht
    if (AppRouter.isAuthRoute(route)) {
      if (kDebugMode) {
        debugPrint('✅ Navigation: KursUebersicht (Standard-Route)');
      }
      setRoute(AppRouter.home); // URL im Browser synchronisieren
      return const KursUebersicht();
    }

    // PRIORITÄT 4: Deep-Link Navigation (nur wenn bereits eingeloggt und kein Login-Event)
    if (kDebugMode) debugPrint('🔗 Deep-Link erkannt: $route');

    try {
      // Verwende AppRouter für Widget-Auflösung
      final widget = AppRouter.getWidgetForRoute(route);

      // Synchronisiere URL
      if (route != null && route.isNotEmpty) {
        setRoute(route);
      }

      return widget;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Fehler bei Navigation: $e');
      setRoute(AppRouter.home);
      return const KursUebersicht();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<models.User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (kDebugMode) {
          debugPrint(
            'AuthWrapper: Status ist ${snapshot.connectionState} (User: ${snapshot.data?.email ?? "null"})',
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting ||
            !_splashFinished) {
          return const SplashScreen();
        }

        final user = snapshot.data;
        _syncLoginState(user);
        final currentRoute = _readCurrentRoute();

        if (user == null) {
          _syncRoleFuture(null);
          return _getTargetPage(currentRoute, null, null, isLoginEvent: false);
        }

        _syncRoleFuture(user);
        final roleFuture = _roleFuture;
        if (roleFuture == null) {
          return _buildErrorScreen(
            title: 'Technischer Fehler',
            message: 'Rollenprüfung konnte nicht gestartet werden.',
          );
        }

        // Hole User-Rolle aus Appwrite Database
        return FutureBuilder<RoleResolution>(
          future: roleFuture,
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return _buildInlineLoadingScreen();
            }

            // Fehlerbehandlung: Netzwerkprobleme vs. fehlende Daten
            if (roleSnapshot.hasError) {
              // Netzwerkfehler → Zeige Retry-Screen
              return _buildErrorScreen();
            }

            if (!roleSnapshot.hasData) {
              return _buildErrorScreen(
                title: 'Profilfehler',
                message: 'Rollenprofil konnte nicht geladen werden.',
                icon: Icons.person_off_outlined,
              );
            }

            final resolution = roleSnapshot.data!;
            if (kDebugMode && resolution.fromFallback) {
              debugPrint(
                '⚠️ Navigation mit Fallback-Rolle für ${user.email} (kein Profil gefunden)',
              );
            }

            return _getTargetPage(
              currentRoute,
              user,
              resolution.role,
              isLoginEvent: _isLoginEvent,
            );
          },
        );
      },
    );
  }

  /// Error-Screen bei Netzwerkproblemen
  Widget _buildErrorScreen({
    String title = 'Verbindungsfehler',
    String message = 'Bitte prüfe deine Internetverbindung.',
    IconData icon = Icons.cloud_off,
  }) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: Center(
        child: Padding(
          padding: AppStyles.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: AppStyles.primaryOrange),
              AppStyles.spacingLBox,
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.textDark,
                ),
              ),
              SizedBox(height: AppStyles.spacingM - AppStyles.spacingS), // 12px
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppStyles.textDark.withValues(alpha: 0.7),
                ),
              ),
              AppStyles.spacingXLBox,
              ElevatedButton.icon(
                onPressed: _retryRoleLoad,
                icon: const Icon(Icons.refresh),
                label: const Text('Erneut versuchen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: AppStyles.buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInlineLoadingScreen() {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppStyles.primaryOrange,
              ),
            ),
            AppStyles.spacingMBox,
            Text(
              'Lade Profil...',
              style: TextStyle(
                fontSize: 15,
                color: AppStyles.textDark.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
