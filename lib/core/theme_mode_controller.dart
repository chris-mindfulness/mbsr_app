import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_tokens.dart';

class ThemeModeController extends ChangeNotifier {
  ThemeModeController._();

  static final ThemeModeController instance = ThemeModeController._();

  static const String _storageKey = 'app_visual_mode_v1';

  AppVisualMode _mode = AppVisualMode.calmDefault;
  bool _initialized = false;

  AppVisualMode get mode => _mode;
  bool get initialized => _initialized;

  AppThemeTokens get tokens {
    return _mode == AppVisualMode.calmDefault
        ? calmDefaultTokens
        : calmVividTokens;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved == AppVisualMode.calmVivid.name) {
      _mode = AppVisualMode.calmVivid;
    } else {
      _mode = AppVisualMode.calmDefault;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> setMode(AppVisualMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, mode.name);
  }
}
