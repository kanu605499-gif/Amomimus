import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static late SharedPreferences _prefs;
  static const _keyIsLogin = "isLogin";
  static const _keyHasSeenOnboarding = "hasSeenOnboarding";
  static const _keyIsDarkMode = "isDarkMode";
  static const _keyLanguage = "language";

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setIsDarkMode(bool isDark) async {
    await _prefs.setBool(_keyIsDarkMode, isDark);
  }

  static bool get isDarkMode {
    return _prefs.getBool(_keyIsDarkMode) ?? true; // Default to dark mode
  }

  static Future<void> setLanguage(String lang) async {
    await _prefs.setString(_keyLanguage, lang);
  }

  static String? get language {
    return _prefs.getString(_keyLanguage);
  }

  static Future<void> setLogin(bool isLogin) async {
    await _prefs.setBool(_keyIsLogin, isLogin);
  }

  static bool get isLogin {
    return _prefs.getBool(_keyIsLogin) ?? false;
  }

  static Future<void> setHasSeenOnboarding(bool hasSeen) async {
    await _prefs.setBool(_keyHasSeenOnboarding, hasSeen);
  }

  static bool get hasSeenOnboarding {
    return _prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  static Future<void> logOut() async {
    await _prefs.remove(_keyIsLogin);
  }
}
