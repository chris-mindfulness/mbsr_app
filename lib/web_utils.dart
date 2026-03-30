import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/services.dart';

import 'core/app_config.dart';

/// Redirect-URL für Appwrite [createRecovery].
///
/// **Web:** Aktuelle Origin + `/reset-password`, damit die URL in Appwrite
/// erlaubt sein kann (gleiche Domain wie die geöffnete App, z. B. Pages-URL).
/// **Nicht-Web:** [AppConfig.passwordResetRedirectUrl] (Build-Default).
String passwordResetRedirectUrlForApp() {
  if (!kIsWeb) {
    return AppConfig.passwordResetRedirectUrl;
  }
  try {
    final u = Uri.base;
    return Uri(
      scheme: u.scheme,
      host: u.host,
      port: u.hasPort ? u.port : null,
      path: '/reset-password',
    ).toString();
  } catch (_) {
    return AppConfig.passwordResetRedirectUrl;
  }
}

/// Liest die aktuelle Route aus der Browser-URL
String? getCurrentRoute() {
  if (!kIsWeb) return null;
  
  try {
    // Verwende Uri.base, um die aktuelle URL inklusive Fragment (Hash) zu lesen
    final uri = Uri.base;
    final hash = uri.fragment;
    
    if (hash.isNotEmpty) {
      final route = hash.startsWith('/') ? hash : '/$hash';
      return route;
    }
    
    final path = uri.path;
    if (path.isNotEmpty && path != '/') {
      return path;
    }
    
    return null;
  } catch (e) {
    return null;
  }
}

/// Setzt die URL im Browser (ohne Reload)
void setRoute(String route) {
  if (!kIsWeb) return;
  
  try {
    // Die sauberste Methode in Flutter, um die Browser-URL zu aktualisieren,
    // ohne den Navigator-Stack zu korrumpieren.
    SystemNavigator.routeInformationUpdated(uri: Uri.parse(route));
  } catch (e) {
    // Ignoriere Fehler - URL-Update ist optional
  }
}
