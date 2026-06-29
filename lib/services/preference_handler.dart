import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PreferenceHandler {
  static late FlutterSecureStorage _storage;
  
  static const _keyIsLogin = "isLoggedIn";
  static const _keyHasSeenOnboarding = "hasSeenOnboarding";
  static const _keyIsDarkMode = "isDarkMode";
  static const _keyLanguage = "language";
  static const _keySavedAmomimusId = "savedAmomimusId";
  static const _keySavedEmail = "savedEmail";
  static const _keyRememberMe = "rememberMe";

  // In-memory cache for synchronous getters
  static bool _cachedIsLogin = false;
  static bool _cachedHasSeenOnboarding = false;
  static bool _cachedIsDarkMode = true;
  static String? _cachedLanguage;
  static String? _cachedSavedAmomimusId;
  static String? _cachedSavedEmail;
  static bool _cachedRememberMe = false;

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static Future<void> init() async {
    _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    
    final isLoginStr = await _storage.read(key: _keyIsLogin);
    _cachedIsLogin = isLoginStr == 'true';
    
    final hasSeenStr = await _storage.read(key: _keyHasSeenOnboarding);
    _cachedHasSeenOnboarding = hasSeenStr == 'true';
    
    final isDarkStr = await _storage.read(key: _keyIsDarkMode);
    _cachedIsDarkMode = isDarkStr != 'false'; // default to true
    
    _cachedLanguage = await _storage.read(key: _keyLanguage);
    _cachedSavedAmomimusId = await _storage.read(key: _keySavedAmomimusId);
    _cachedSavedEmail = await _storage.read(key: _keySavedEmail);
    final rememberStr = await _storage.read(key: _keyRememberMe);
    _cachedRememberMe = rememberStr == 'true';
  }

  static Future<void> setIsDarkMode(bool isDark) async {
    _cachedIsDarkMode = isDark;
    await _storage.write(key: _keyIsDarkMode, value: isDark.toString());
  }

  static bool get isDarkMode => _cachedIsDarkMode;

  static Future<void> setLanguage(String lang) async {
    _cachedLanguage = lang;
    await _storage.write(key: _keyLanguage, value: lang);
  }

  static String? get language => _cachedLanguage;

  static Future<void> setLogin(bool isLogin) async {
    _cachedIsLogin = isLogin;
    await _storage.write(key: _keyIsLogin, value: isLogin.toString());
  }

  static bool get isLogin => _cachedIsLogin;

  static Future<void> setHasSeenOnboarding(bool hasSeen) async {
    _cachedHasSeenOnboarding = hasSeen;
    await _storage.write(key: _keyHasSeenOnboarding, value: hasSeen.toString());
  }

  static bool get hasSeenOnboarding => _cachedHasSeenOnboarding;

  static Future<void> setSavedAmomimusId(String id) async {
    _cachedSavedAmomimusId = id;
    await _storage.write(key: _keySavedAmomimusId, value: id);
  }

  static String? get savedAmomimusId => _cachedSavedAmomimusId;

  static Future<void> setSavedEmail(String email) async {
    _cachedSavedEmail = email;
    await _storage.write(key: _keySavedEmail, value: email);
  }

  static String? get savedEmail => _cachedSavedEmail;

  static Future<void> setRememberMe(bool remember) async {
    _cachedRememberMe = remember;
    await _storage.write(key: _keyRememberMe, value: remember.toString());
  }

  static bool get rememberMe => _cachedRememberMe;

  static Future<void> logOut() async {
    _cachedIsLogin = false;
    _cachedSavedAmomimusId = null;
    _cachedSavedEmail = null;
    await _storage.delete(key: _keyIsLogin);
    await _storage.delete(key: _keySavedAmomimusId);
    await _storage.delete(key: _keySavedEmail);
  }
}
