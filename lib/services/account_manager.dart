import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'preference_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure_storage;
import '../database_helper.dart';
import '../models/report_model.dart';
import '../models/user_indicator_model.dart';
import '../helpers/benevolent_calculator.dart';
import '../models/user_credentials_model.dart';
import 'auth_service.dart';
import 'background_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/secure_time.dart';

class AccountManager extends ChangeNotifier {
  Future<void> _persistAndNotify(UserAccount updatedUser) async {
    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: \$e ====");
    }

    if (_currentUser?.id == updatedUser.id) {
      _currentUser = updatedUser;
    }

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
  }
  final AuthService authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AccountManager({required this.authService});

  List<UserAccount> _accounts = [];
  UserAccount? _currentUser;
  bool _isLoading = true;

  List<UserAccount> get accounts => _accounts;
  UserAccount? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  bool get isMasterProfile {
    if (_currentUser == null || _currentUser!.isDemo) return false;
    final masterAccs = _accounts.where((acc) => acc.masterEmail == _currentUser!.masterEmail).toList();
    if (masterAccs.isEmpty) return false;
    return masterAccs.first.amomimusId == _currentUser!.amomimusId;
  }

  List<UserAccount> get switchableAccounts {
    if (_currentUser == null) return [];
    final realAccounts = _accounts
        .where((acc) => !acc.isDemo && acc.masterEmail == _currentUser!.masterEmail)
        .toList();
    if (realAccounts.length > 3) {
      return realAccounts.sublist(0, 3);
    }
    return realAccounts;
  }

  Future<void> loadAccounts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _accounts = await DatabaseHelper.instance.getAllUsers();
    } catch (e) {
      // sqflite not supported on web — use empty list
      print("==== DB LOAD SKIPPED (possibly web): $e ====");
      _accounts = [];
    }

    // Auto-select based on savedAmomimusId in PreferenceHandler
    final savedAmomimusId = PreferenceHandler.savedAmomimusId;
    final savedEmail = PreferenceHandler.savedEmail;

    if (savedAmomimusId != null && savedAmomimusId.isNotEmpty) {
      final matchingAccounts = _accounts.where(
        (acc) => acc.amomimusId == savedAmomimusId,
      );
      if (matchingAccounts.isNotEmpty) {
        _currentUser = matchingAccounts.first;
      }
    } else if (savedEmail != null && savedEmail.isNotEmpty) {
      // Fallback for older version
      final matchingAccounts = _accounts.where(
        (acc) => acc.email.toLowerCase() == savedEmail.toLowerCase(),
      );
      if (matchingAccounts.isNotEmpty) {
        _currentUser = matchingAccounts.first;
      }
    }

    if (_accounts.isNotEmpty && _currentUser == null) {
      // By default, select the first demo account if available, else first dummy
      _currentUser = _accounts.firstWhere(
        (acc) => acc.isDemo,
        orElse: () => _accounts.first,
      );
    } else if (_currentUser != null) {
      // Refresh current user object from the loaded list
      final matchingAccounts = _accounts.where(
        (acc) => acc.id == _currentUser!.id,
      );
      if (matchingAccounts.isNotEmpty) {
        _currentUser = matchingAccounts.first;
      }
    }

    _isLoading = false;
    notifyListeners();

    // Fetch and save FCM token on load for the current user
    if (_currentUser != null && !_currentUser!.isDemo) {
      _updateFcmToken(_currentUser!);
    }
  }

  Future<bool> registerAndLogin(
    UserCredentialsModel credentials,
    UserAccount newUser,
  ) async {
    final createdProfile = await authService.registerAccount(credentials, newUser);
    if (createdProfile == null) return false;

    // We fetch updated accounts to sync the internal state
    await loadAccounts();

    // Set the newly created user as the active user
    final createdUser = _accounts.firstWhere(
      (acc) => acc.amomimusId == createdProfile.amomimusId,
      orElse: () => createdProfile,
    );
    await switchAccount(createdUser);
    return true;
  }

  Future<GoogleAuthResult?> loginWithGoogle() async {
    final result = await authService.loginWithGoogle();
    if (result != null && !result.isNewUser && result.account != null) {
      await loadAccounts();
      final loggedInUser = _accounts.firstWhere(
        (acc) => acc.amomimusId == result.account!.amomimusId,
        orElse: () => result.account!,
      );
      await switchAccount(loggedInUser);
    }
    return result;
  }

  Future<bool> registerGoogleAccount(UserCredentialsModel credentials, UserAccount newUser) async {
    final createdProfile = await authService.registerGoogleProfile(credentials, newUser);
    if (createdProfile == null) return false;
    await loadAccounts();
    final createdUser = _accounts.firstWhere(
      (acc) => acc.amomimusId == createdProfile.amomimusId,
      orElse: () => createdProfile,
    );
    await switchAccount(createdUser);
    return true;
  }

  Future<bool> reauthenticate(String? password) async {
    return await authService.reauthenticate(password);
  }

  Future<bool> checkEmailExists(String email) async {
    return await authService.isEmailRegistered(email);
  }

  Future<bool> login(String email, String password) async {
    final user = await authService.login(email, password);
    if (user != null) {
      await loadAccounts();
      final loggedInUser = _accounts.firstWhere(
        (acc) => acc.masterEmail == email,
        orElse: () => user,
      );
      await switchAccount(loggedInUser);
      return true;
    }
    return false;
  }

  Future<void> switchAccount(UserAccount account) async {
    // Use the canonical object from _accounts if it exists
    final canonical = _accounts.cast<UserAccount?>().firstWhere(
      (acc) => acc?.amomimusId == account.amomimusId,
      orElse: () => null,
    );
    _currentUser = canonical ?? account;
    notifyListeners();
    
    // Persist the switch
    await PreferenceHandler.setLogin(true);
    await PreferenceHandler.setSavedEmail(account.email);
    await PreferenceHandler.setSavedAmomimusId(account.amomimusId);
    await PreferenceHandler.setRememberMe(true);

    // Save FCM token for the newly switched account
    await _updateFcmToken(account);
  }

  Future<void> _updateFcmToken(UserAccount account) async {
    try {
      final messaging = FirebaseMessaging.instance;
      // Request permission (important for iOS and Android 13+)
      await messaging.requestPermission();
      final token = await messaging.getToken();
      if (token != null) {
        // Update local user object
        final updatedUser = account.copyWith(fcmToken: token);
        await DatabaseHelper.instance.updateUser(updatedUser);
        
        // Update in Firestore
        final query = await _firestore.collection('users')
            .where('amomimusId', isEqualTo: account.amomimusId)
            .get();
        if (query.docs.isNotEmpty) {
          await query.docs.first.reference.update({
            'fcmToken': token,
            'language': updatedUser.language,
          });
        }
      }
    } catch (e) {
      print("==== FCM TOKEN UPDATE FAILED: $e ====");
    }
  }

  Future<void> updateLanguage(String lang) async {
    if (_currentUser == null || _currentUser!.isDemo) return;
    
    try {
      // Update local user object
      final updatedUser = _currentUser!.copyWith(language: lang);
      _currentUser = updatedUser;
      await DatabaseHelper.instance.updateUser(updatedUser);
      notifyListeners();
      
      // Update in Firestore
      final query = await _firestore.collection('users')
          .where('amomimusId', isEqualTo: updatedUser.amomimusId)
          .get();
      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({'language': lang});
      }
    } catch (e) {
      print("==== LANGUAGE UPDATE FAILED: $e ====");
    }
  }

  Future<void> deleteAccount(String email) async {
    try {
      await authService.deleteAccount(email);
    } catch (e) {
      print("==== DB DELETE SKIPPED: $e ====");
    }

    await loadAccounts();
    if (_currentUser?.email == email) {
      if (_accounts.isNotEmpty) {
        _currentUser = _accounts.first;
      } else {
        _currentUser = null;
      }
      notifyListeners();
    }
  }

  Future<bool> updateBio(String newBio, int durationDays) async {
    if (_currentUser == null) return false;

    final expirationDate = SecureTime.now().add(Duration(days: durationDays)).toIso8601String();

    bool shouldResetBailout = false;
    if (_currentUser!.bioExpirationDate != null) {
      final expDate = DateTime.tryParse(_currentUser!.bioExpirationDate!);
      if (expDate != null && expDate.isBefore(SecureTime.now())) {
        shouldResetBailout = true;
      }
    }

    final updatedUser = _currentUser!.copyWith(
      bio: newBio,
      bioExpirationDate: expirationDate,
      bioOriginalDuration: durationDays,
      hasUsedBioBailout: shouldResetBailout ? false : _currentUser!.hasUsedBioBailout,
    );

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
    return true;
  }

  Future<bool> bailoutBio() async {
    if (_currentUser == null) return false;
    if (_currentUser!.hasUsedBioBailout) return false;

    int cost = (_currentUser!.bioOriginalDuration ?? 0) <= 7 ? 500 : 0;
    if (_currentUser!.coins < cost) {
      return false; // Not enough coins
    }

    final newCoins = _currentUser!.coins - cost;

    final updatedUser = _currentUser!.copyWith(
      coins: newCoins,
      hasUsedBioBailout: true,
      bioExpirationDate: null,
    );

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
    return true;
  }

  Future<bool> submitBugReport(String category, String description) async {
    if (_currentUser == null) return false;

    final now = SecureTime.now();
    final lastDateStr = _currentUser!.lastBugReportDate;
    int currentCount = _currentUser!.bugReportWeeklyCount;

    // Reset counter if more than 7 days have passed
    if (lastDateStr != null) {
      final lastDate = DateTime.tryParse(lastDateStr);
      if (lastDate != null && now.difference(lastDate).inDays >= 7) {
        currentCount = 0;
      }
    }

    // Enforce 3 reports per week limit
    if (currentCount >= 3) return false;

    // Submit to Firestore
    try {
      await _firestore.collection('bug_reports').add({
        'userId': _currentUser!.amomimusId,
        'anonymousUsername': _currentUser!.anonymousUsername,
        'category': category,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending', // pending | reviewed | resolved
      });
    } catch (e) {
      return false;
    }

    // Update local user counter
    final updated = _currentUser!.copyWith(
      bugReportWeeklyCount: currentCount + 1,
      lastBugReportDate: now.toIso8601String(),
    );
    await _persistAndNotify(updated);
    return true;
  }

  Future<void> updateCoins(
    int amountDelta, {
    bool updateTimestamp = false,
  }) async {
    if (_currentUser == null) return;

    final newCoins = (_currentUser!.coins + amountDelta).clamp(0, 999999);
    UserAccount updatedUser = _currentUser!.copyWith(coins: newCoins);

    if (updateTimestamp) {
      updatedUser = updatedUser.copyWith(
        lastRedeemed: SecureTime.now().toIso8601String(),
      );
    }

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;

    // Update the list as well
    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
  }

  Future<void> blockUser(String targetAmomimusId) async {
    if (_currentUser == null) return;
    if (_currentUser!.blockedUsers.contains(targetAmomimusId)) return;

    final updatedBlocked = List<String>.from(_currentUser!.blockedUsers)
      ..add(targetAmomimusId);
    final updatedExBlocked = List<String>.from(_currentUser!.exBlockedUsers)
      ..removeWhere(
        (e) => e.startsWith('$targetAmomimusId|') || e == targetAmomimusId,
      );

    final updatedUser = _currentUser!.copyWith(
      blockedUsers: updatedBlocked,
      exBlockedUsers: updatedExBlocked,
    );

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;
    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) _accounts[index] = updatedUser;

    // Also update the target account's blockedBy list
    final targetAccount = getAccountById(targetAmomimusId);
    if (targetAccount != null &&
        !targetAccount.blockedBy.contains(_currentUser!.amomimusId)) {
      final updatedBlockedBy = List<String>.from(targetAccount.blockedBy)
        ..add(_currentUser!.amomimusId);
      final updatedTarget = targetAccount.copyWith(blockedBy: updatedBlockedBy);
      try {
        await DatabaseHelper.instance.updateUser(updatedTarget);
      } catch (e) {
        print("==== DB UPDATE TARGET SKIPPED: $e ====");
      }
      final targetIdx = _accounts.indexWhere((acc) => acc.id == updatedTarget.id);
      if (targetIdx != -1) _accounts[targetIdx] = updatedTarget;
    }

    notifyListeners();
  }

  Future<void> unblockUser(String targetAmomimusId) async {
    if (_currentUser == null) return;
    if (!_currentUser!.blockedUsers.contains(targetAmomimusId)) return;

    final updatedBlocked = List<String>.from(_currentUser!.blockedUsers)
      ..remove(targetAmomimusId);
    final updatedExBlocked = List<String>.from(_currentUser!.exBlockedUsers);

    // Remove old entry if exists
    updatedExBlocked.removeWhere(
      (e) => e.startsWith('$targetAmomimusId|') || e == targetAmomimusId,
    );

    // Add new entry with timestamp
    final timestamp = SecureTime.now().toIso8601String();
    updatedExBlocked.add('$targetAmomimusId|$timestamp');

    final updatedUser = _currentUser!.copyWith(
      blockedUsers: updatedBlocked,
      exBlockedUsers: updatedExBlocked,
    );

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;
    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) _accounts[index] = updatedUser;

    // Also remove currentUser from target's blockedBy list
    final targetAccount = getAccountById(targetAmomimusId);
    if (targetAccount != null &&
        targetAccount.blockedBy.contains(_currentUser!.amomimusId)) {
      final updatedBlockedBy = List<String>.from(targetAccount.blockedBy)
        ..remove(_currentUser!.amomimusId);
      final updatedTarget = targetAccount.copyWith(blockedBy: updatedBlockedBy);
      try {
        await DatabaseHelper.instance.updateUser(updatedTarget);
      } catch (e) {
        print("==== DB UPDATE TARGET SKIPPED: $e ====");
      }
      final targetIdx = _accounts.indexWhere((acc) => acc.id == updatedTarget.id);
      if (targetIdx != -1) _accounts[targetIdx] = updatedTarget;
    }

    notifyListeners();
  }

  bool isBlockedBy(String targetAmomimusId) {
    if (_currentUser == null) return false;
    final targetAccount = getAccountById(targetAmomimusId);
    if (targetAccount == null) return false;
    return targetAccount.blockedUsers.contains(_currentUser!.amomimusId);
  }

  bool isRecentlyUnblocked(String targetAmomimusId) {
    return getUnblockTimeRemaining(targetAmomimusId) != null;
  }

  Duration? getUnblockTimeRemaining(String targetAmomimusId) {
    if (_currentUser == null) return null;

    for (var entry in _currentUser!.exBlockedUsers) {
      if (entry.startsWith('$targetAmomimusId|')) {
        final parts = entry.split('|');
        if (parts.length == 2) {
          final unblockDate = DateTime.tryParse(parts[1]);
          if (unblockDate != null) {
            final diff = SecureTime.now().difference(unblockDate);
            if (diff.inHours < 72) {
              return const Duration(hours: 72) - diff;
            }
          }
        }
      }
    }
    return null;
  }

  bool isRecentlyUnblockedByTarget(String myAmomimusId, String targetAmomimusId) {
    final targetAccount = getAccountById(targetAmomimusId);
    if (targetAccount == null) return false;

    for (var entry in targetAccount.exBlockedUsers) {
      if (entry.startsWith('$myAmomimusId|')) {
        final parts = entry.split('|');
        if (parts.length == 2) {
          final unblockDate = DateTime.tryParse(parts[1]);
          if (unblockDate != null) {
            final diff = SecureTime.now().difference(unblockDate);
            if (diff.inHours < 72) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Future<bool> updateFavoriteCharacter(String newCharacter) async {
    if (_currentUser == null) return false;
    final creds = await authService.getCredentials(_currentUser!.email);
    if (creds == null) return false;

    // Check last edit date
    if (creds.lastFavCharEditDate != null) {
      final lastEdit = DateTime.tryParse(creds.lastFavCharEditDate!);
      if (lastEdit != null) {
        final diff = SecureTime.now().difference(lastEdit);
        if (diff.inHours < 24) {
          return false; // Can only edit once every 24 hours
        }
      }
    }

    final updatedCreds = creds.copyWith(
      favoriteCharacter: newCharacter,
      lastFavCharEditDate: SecureTime.now().toIso8601String(),
    );

    return await authService.updateCredentials(updatedCreds);
  }

  Future<bool> resetPassword(String newPassword) async {
    if (_currentUser == null) return false;
    final creds = await authService.getCredentials(_currentUser!.email);
    if (creds == null) return false;

    final updatedCreds = creds.copyWith(password: newPassword);
    return await authService.updateCredentials(updatedCreds);
  }

  String getDisplayIndicator(String targetId, String globalIndicator) {
    if (_currentUser == null) return globalIndicator;

    // Use max to prevent double-counting local points that are already in global points
    final localPoints = _currentUser!.localAssignedPoints[targetId] ?? 0;
    if (localPoints > 0) {
      final targetUser = getAccountById(targetId);
      final effectivePoints = math.max(
        targetUser?.benevolentPoints ?? 0,
        localPoints,
      );
      return UserIndicatorHelper.fromBenevolentPoints(effectivePoints).name;
    }
    return globalIndicator;
  }

  UserAccount? getAccountById(String id) {
    try {
      return _accounts.firstWhere(
        (acc) => acc.amomimusId == id || acc.id.toString() == id,
      );
    } catch (_) {
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════
  // PRESENCE SYSTEM
  // ══════════════════════════════════════════════════════════

  Future<void> updatePresenceStatus(String status) async {
    if (_currentUser == null) return;
    
    final updatedUser = _currentUser!.copyWith(
      presenceStatus: status,
      presenceUpdatedAt: SecureTime.now().toIso8601String(),
    );
    
    await _persistAndNotify(updatedUser);
  }

  // ══════════════════════════════════════════════════════════
  // REPORT TOKEN SYSTEM (v2)
  // ══════════════════════════════════════════════════════════

  static const String _reportTokenKey = 'amomimus_report_tokens';

  /// Loads the current report token state from secure storage.
  Future<Map<String, dynamic>> _loadReportTokens() async {
    final data = await const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    ).read(key: _reportTokenKey);
    
    if (data == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(data));
    } catch (_) {
      return {};
    }
  }

  /// Saves report token state to secure storage.
  Future<void> _saveReportTokens(Map<String, dynamic> tokens) async {
    await const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    ).write(key: _reportTokenKey, value: jsonEncode(tokens));
  }

  /// Gets daily report counts by category for today.
  Map<ReportCategory, int> _getDailyReportCounts(Map<String, dynamic> tokens) {
    final today = SecureTime.now().toIso8601String().split('T').first;
    final storedDate = tokens['date'] as String?;

    if (storedDate != today) return {}; // New day, reset counts

    return {
      ReportCategory.spamHarassment:
          (tokens['spam_daily'] as int?) ?? 0,
      ReportCategory.inappropriateContent:
          (tokens['inappropriate_daily'] as int?) ?? 0,
      ReportCategory.hateSpeech:
          (tokens['hate_speech_daily'] as int?) ?? 0,
    };
  }

  /// Gets weekly hate speech report count.
  int _getWeeklyHateSpeechCount(Map<String, dynamic> tokens) {
    final weeklyList = (tokens['hate_speech_weekly_dates'] as List<dynamic>?) ?? [];
    final oneWeekAgo = SecureTime.now().subtract(const Duration(days: 7));

    int count = 0;
    for (final dateStr in weeklyList) {
      final date = DateTime.tryParse(dateStr.toString());
      if (date != null && date.isAfter(oneWeekAgo)) count++;
    }
    return count;
  }

  /// Gets total daily reports across all categories.
  int _getTotalDailyReports(Map<ReportCategory, int> dailyCounts) {
    return dailyCounts.values.fold(0, (sum, count) => sum + count);
  }

  /// Checks if report is allowed and returns reason if blocked.
  /// Returns null if allowed.
  Future<String?> checkReportAllowed(ReportCategory category) async {
    final tokens = await _loadReportTokens();
    final dailyCounts = _getDailyReportCounts(tokens);
    final weeklyHateSpeech = _getWeeklyHateSpeechCount(tokens);
    final totalDaily = _getTotalDailyReports(dailyCounts);

    return BenevolentCalculator.checkReportTokens(
      category: category,
      dailyReportsByCategory: dailyCounts,
      weeklyHateSpeechCount: weeklyHateSpeech,
      totalDailyReports: totalDaily,
    );
  }

  /// Returns remaining report tokens for UI display.
  Future<Map<String, int>> getRemainingReportTokens() async {
    final tokens = await _loadReportTokens();
    final dailyCounts = _getDailyReportCounts(tokens);
    final weeklyHateSpeech = _getWeeklyHateSpeechCount(tokens);
    final totalDaily = _getTotalDailyReports(dailyCounts);

    return BenevolentCalculator.getRemainingTokens(
      dailyReportsByCategory: dailyCounts,
      weeklyHateSpeechCount: weeklyHateSpeech,
      totalDailyReports: totalDaily,
    );
  }

  /// Records a report token consumption.
  Future<void> _consumeReportToken(ReportCategory category) async {
    final tokens = await _loadReportTokens();
    final today = SecureTime.now().toIso8601String().split('T').first;
    final storedDate = tokens['date'] as String?;

    // Reset daily counts if new day
    if (storedDate != today) {
      tokens['date'] = today;
      tokens['spam_daily'] = 0;
      tokens['inappropriate_daily'] = 0;
      tokens['hate_speech_daily'] = 0;
    }

    // Increment category count
    switch (category) {
      case ReportCategory.spamHarassment:
        tokens['spam_daily'] = ((tokens['spam_daily'] as int?) ?? 0) + 1;
        break;
      case ReportCategory.inappropriateContent:
        tokens['inappropriate_daily'] =
            ((tokens['inappropriate_daily'] as int?) ?? 0) + 1;
        break;
      case ReportCategory.hateSpeech:
        tokens['hate_speech_daily'] =
            ((tokens['hate_speech_daily'] as int?) ?? 0) + 1;
        // Also track weekly
        final weeklyList =
            List<String>.from((tokens['hate_speech_weekly_dates'] as List<dynamic>?) ?? []);
        weeklyList.add(SecureTime.now().toIso8601String());
        // Prune entries older than 7 days
        final oneWeekAgo = SecureTime.now().subtract(const Duration(days: 7));
        weeklyList.removeWhere((d) {
          final date = DateTime.tryParse(d);
          return date != null && date.isBefore(oneWeekAgo);
        });
        tokens['hate_speech_weekly_dates'] = weeklyList;
        break;
    }

    await _saveReportTokens(tokens);
  }

  // ══════════════════════════════════════════════════════════
  // SUBMIT REPORT (v2 — with token system)
  // ══════════════════════════════════════════════════════════

  /// Submits a report against a target user.
  /// Returns a String reason if blocked by token limits (meaning only local report was applied), or null on success.
  Future<String?> submitReport(
    String targetId,
    ReportCategory category, {
    bool isChatBubbleReport = false,
    String? description,
  }) async {
    // 1. Check token limits for GLOBAL submission
    final blockReason = await checkReportAllowed(category);

    // 2. Normalize target ID
    String normalizedTargetId = targetId;
    final match = RegExp(r'#(?:YOU|AMO|AMI|AMOM)-(\d+)').firstMatch(targetId);
    if (match != null) {
      int num = int.parse(match.group(1)!);
      if (num == 100) num = 110;
      normalizedTargetId = '#AMM-\$num';
    } else {
      normalizedTargetId = targetId.replaceAll(RegExp(r'#AM[OMI]+-'), '#AMM-');
    }

    // 3. ALWAYS update local perspective, so user can protect themselves even without tokens
    if (_currentUser != null && _currentUser!.amomimusId != targetId) {
      final newPointsMap = Map<String, int>.from(
        _currentUser!.localAssignedPoints,
      );
      final currentLocalPoints = newPointsMap[targetId] ?? 0;

      final localStatus = BenevolentCalculator.addReportToUser(
        currentPoints: currentLocalPoints,
        category: category,
        isChatBubbleReport: isChatBubbleReport,
        currentIndicator: 'cloudy',
        pointMultiplier: 4.0,
      );

      newPointsMap[targetId] = localStatus.points;

      final newReporter = _currentUser!.copyWith(
        localAssignedPoints: newPointsMap,
      );
      _currentUser = newReporter;

      try {
        await DatabaseHelper.instance.updateUser(newReporter);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: \$e ====");
      }

      final reporterIndex = _accounts.indexWhere(
        (acc) => acc.id == newReporter.id,
      );
      if (reporterIndex != -1) {
        _accounts[reporterIndex] = newReporter;
      }
    }

    // 4. If global tokens are exhausted, return early here. 
    // Local points are saved, but global target points remain unchanged.
    if (blockReason != null) {
      notifyListeners();
      return blockReason;
    }

    // 5. Apply to global target user
    final reporterPoints = _currentUser?.benevolentPoints ?? 0;
    final userIndex = _accounts.indexWhere(
      (acc) =>
          acc.amomimusId == targetId ||
          acc.amomimusId == normalizedTargetId ||
          acc.id.toString() == targetId,
    );

    if (userIndex != -1) {
      var user = _accounts[userIndex];

      final existingReportCount = user.reportedCount;

      final newStatus = BenevolentCalculator.addReportToUser(
        currentPoints: user.benevolentPoints,
        category: category,
        isChatBubbleReport: isChatBubbleReport,
        currentIndicator: user.indicator,
        existingReportCount: existingReportCount,
        reporterBenevolentPoints: reporterPoints,
      );

      final updatedUser = user.copyWith(
        reportedCount: user.reportedCount + 1,
        benevolentPoints: newStatus.points,
        indicator: newStatus.indicator.name,
      );

      try {
        await DatabaseHelper.instance.updateUser(updatedUser);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: \$e ====");
      }

      _accounts[userIndex] = updatedUser;

      // Note: we don't update _currentUser here because we just updated it above for local perspective
    }

    // 6. Consume report token
    await _consumeReportToken(category);

    // 7. Save detailed report to Firebase 'reports' collection
    if (_currentUser != null) {
      try {
        final reportModel = ReportModel(
          reporterId: _currentUser!.amomimusId,
          reportedUserId: normalizedTargetId,
          category: category,
          description: description ?? '',
          reportedMessageId: isChatBubbleReport ? targetId : null,
          createdAt: SecureTime.now().toIso8601String(),
        );

        await _firestore.collection('reports').add(reportModel.toMap());
      } catch (e) {
        print("==== FIREBASE REPORT LOG FAILED: $e ====");
      }
    }

    notifyListeners();
    return null; // Success
  }

  Future<void> hideFeed(String feedId) async {
    if (_currentUser == null) return;

    if (!_currentUser!.hiddenFeeds.contains(feedId)) {
      final updatedList = List<String>.from(_currentUser!.hiddenFeeds)
        ..add(feedId);
      final updatedUser = _currentUser!.copyWith(hiddenFeeds: updatedList);

      try {
        await DatabaseHelper.instance.updateUser(updatedUser);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: $e ====");
      }

      _currentUser = updatedUser;

      final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
      if (index != -1) {
        _accounts[index] = updatedUser;
      }

      notifyListeners();
    }
  }

  Future<void> incrementChatRequestCount() async {
    if (_currentUser == null) return;

    final today = SecureTime.now().toIso8601String().split('T').first;
    final lastReqDate = _currentUser!.lastChatRequestDate?.split('T').first;
    int newCount = _currentUser!.dailyChatRequestsSent;

    if (lastReqDate != today) {
      newCount = 1;
    } else {
      newCount += 1;
    }

    final updatedUser = _currentUser!.copyWith(
      dailyChatRequestsSent: newCount,
      lastChatRequestDate: SecureTime.now().toIso8601String(),
    );

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
  }

  Future<void> toggleWishlistBatch(String batchId) async {
    if (_currentUser == null) return;

    final currentList = List<String>.from(_currentUser!.wishlistStickerBatches);
    if (currentList.contains(batchId)) {
      currentList.remove(batchId);
    } else {
      currentList.add(batchId);
    }

    final updatedUser = _currentUser!.copyWith(
      wishlistStickerBatches: currentList,
    );

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
  }

  Future<bool> purchaseStickerBatch(String batchId, int cost) async {
    if (_currentUser == null) return false;

    if (_currentUser!.coins < cost) {
      return false; // Not enough coins
    }

    if (_currentUser!.ownedStickerBatches.contains(batchId)) {
      return false; // Already owned
    }

    final newCoins = _currentUser!.coins - cost;
    final updatedList = List<String>.from(_currentUser!.ownedStickerBatches)
      ..add(batchId);

    final updatedUser = _currentUser!.copyWith(
      coins: newCoins,
      ownedStickerBatches: updatedList,
    );

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: $e ====");
    }

    _currentUser = updatedUser;

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await authService.logout();
    _currentUser = null;
    _accounts.clear();
    await PreferenceHandler.setLogin(false);
    await PreferenceHandler.setSavedEmail('');
    await PreferenceHandler.setSavedAmomimusId('');
    notifyListeners();
  }
}
