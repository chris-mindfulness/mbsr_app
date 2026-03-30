import 'package:flutter/foundation.dart';

/// Löst ein Rebuild von [AuthWrapper] aus, wenn sich nur die Browser-URL ändert
/// (ohne Auth-Stream-Event), z. B. nach Passwort-Reset → /login.
class AuthRouteRefresh extends ChangeNotifier {
  AuthRouteRefresh._();
  static final AuthRouteRefresh instance = AuthRouteRefresh._();

  void bump() => notifyListeners();
}
