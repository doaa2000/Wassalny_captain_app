import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app's current [Locale] and notifies listeners when it changes.
/// The chosen locale is persisted so the selection survives app restarts.
class LocaleController extends ChangeNotifier {
  static const String _prefsKey = 'app_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == 'ar';

  /// Loads the persisted locale (best-effort; defaults to English).
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? code = prefs.getString(_prefsKey);
      if (code != null && (code == 'ar' || code == 'en')) {
        _locale = Locale(code);
        notifyListeners();
      }
    } catch (_) {
      // Keep the default locale if persistence is unavailable.
    }
  }

  /// Sets the active locale and persists it.
  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == _locale.languageCode) return;
    _locale = locale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, locale.languageCode);
    } catch (_) {
      // Non-persisted selection is still applied for this session.
    }
  }
}
