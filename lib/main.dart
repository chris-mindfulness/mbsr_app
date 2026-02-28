import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, debugPrint;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'core/appwrite_client.dart';
import 'services/auth_service.dart';
import 'auth/auth_wrapper.dart';
import 'audio_service.dart';
import 'audio/bell_service.dart';
import 'services/connectivity_service.dart';
import 'core/app_styles.dart';
import 'core/theme_mode_controller.dart';

// Globaler NavigatorKey, um den Stack bei Login zu bereinigen
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Lifecycle Observer für sauberes Cleanup des AudioService
class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) debugPrint('🔄 App Lifecycle: $state');

    if (state == AppLifecycleState.detached) {
      // App wird geschlossen - AudioService sauber beenden
      if (kDebugMode) {
        debugPrint(
          '🛑 App wird geschlossen - Stoppe AudioService & BellService',
        );
      }
      AudioService().dispose();
      BellService().dispose();
    } else if (state == AppLifecycleState.paused) {
      // App geht in Hintergrund - Audio pausieren (optional)
      if (kDebugMode) debugPrint('⏸️ App in Hintergrund');
    } else if (state == AppLifecycleState.resumed) {
      // App kommt zurück in Vordergrund
      if (kDebugMode) debugPrint('▶️ App in Vordergrund');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisiere Appwrite Client
  AppwriteClient();

  // Initialisiere Auth-Service und prüfe bestehende Session
  await AuthService().initialize();

  // Lade visuelles Theme (persistente Nutzereinstellung)
  await ThemeModeController.instance.initialize();

  if (kIsWeb) {
    usePathUrlStrategy();
    // Initialisiere Connectivity-Service für Offline-Detection
    ConnectivityService.init();
  }

  // Registriere Lifecycle Observer für sauberes AudioService Cleanup
  WidgetsBinding.instance.addObserver(_AppLifecycleObserver());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeModeController.instance,
      builder: (context, _) {
        final bodyFamily = kIsWeb ? 'Helvetica Neue' : 'Nunito';
        final bodyFallback = kIsWeb
            ? const ['Helvetica', 'Arial', 'sans-serif']
            : const <String>['sans-serif'];
        final headingFamily = kIsWeb ? 'Lora' : bodyFamily;
        final headingFallback = kIsWeb
            ? const ['Georgia', 'serif']
            : const <String>[];

        final baseTheme = ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppStyles.bgColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppStyles.primaryOrange,
            surface: AppStyles.bgColor,
          ),
          fontFamily: bodyFamily,
          fontFamilyFallback: bodyFallback,
        );

        TextStyle? headingStyle(TextStyle? style) => style?.copyWith(
          fontFamily: headingFamily,
          fontFamilyFallback: headingFallback,
        );

        return MaterialApp(
          title: 'MBSR Achtsamkeitstraining',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey, // Key registrieren
          theme: baseTheme.copyWith(
            textTheme: baseTheme.textTheme.copyWith(
              displayLarge: headingStyle(baseTheme.textTheme.displayLarge),
              displayMedium: headingStyle(baseTheme.textTheme.displayMedium),
              displaySmall: headingStyle(baseTheme.textTheme.displaySmall),
              headlineLarge: headingStyle(baseTheme.textTheme.headlineLarge),
              headlineMedium: headingStyle(baseTheme.textTheme.headlineMedium),
              headlineSmall: headingStyle(baseTheme.textTheme.headlineSmall),
              titleLarge: headingStyle(baseTheme.textTheme.titleLarge),
              titleMedium: headingStyle(baseTheme.textTheme.titleMedium),
              titleSmall: headingStyle(baseTheme.textTheme.titleSmall),
            ),
          ),
          home: const AuthWrapper(),
        );
      },
    );
  }
}
