import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/report_model.dart';
import '../models/user_indicator_model.dart';
import '../helpers/benevolent_calculator.dart';
import 'auth_service.dart';
import '../database/models/user_register_sql.dart';
class AccountManager extends ChangeNotifier {
  final AuthService authService;

  AccountManager({required this.authService});

  List<UserAccount> _accounts = [];
  UserAccount? _currentUser;
  bool _isLoading = true;

  List<UserAccount> get accounts => _accounts;
  UserAccount? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

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
    
    // Auto-select the first account if none is selected
    if (_accounts.isNotEmpty && _currentUser == null) {
      // By default, select the first demo account if available, else first dummy
      _currentUser = _accounts.firstWhere((acc) => acc.isDemo, orElse: () => _accounts.first);
    } else if (_currentUser != null) {
      // Refresh current user object from the loaded list
      final matchingAccounts = _accounts.where((acc) => acc.id == _currentUser!.id);
      if (matchingAccounts.isNotEmpty) {
        _currentUser = matchingAccounts.first;
      } else {
        _currentUser = _accounts.isNotEmpty ? _accounts.first : null;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> registerAndLogin(UserModelSql credentials, UserAccount newUser) async {
    bool isSuccess = await authService.registerAccount(credentials, newUser);
    if (!isSuccess) return false;

    // We fetch updated accounts to sync the internal state
    await loadAccounts();
    
    // Set the newly created user as the active user
    final createdUser = _accounts.firstWhere((acc) => acc.email == newUser.email, orElse: () {
      _accounts.add(newUser);
      return newUser;
    });
    switchAccount(createdUser);
    return true;
  }

  Future<bool> checkEmailExists(String email) async {
    return await authService.isEmailRegistered(email);
  }

  Future<bool> login(String email, String password) async {
    final user = await authService.login(email, password);
    if (user != null) {
      await loadAccounts();
      final loggedInUser = _accounts.firstWhere((acc) => acc.email == email, orElse: () => user);
      switchAccount(loggedInUser);
      return true;
    }
    return false;
  }

  void switchAccount(UserAccount account) {
    _currentUser = account;
    notifyListeners();
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

  Future<void> updateBio(String newBio) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(bio: newBio);

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

  Future<void> updateCoins(int amountDelta, {bool updateTimestamp = false}) async {
    if (_currentUser == null) return;
    
    final newCoins = (_currentUser!.coins + amountDelta).clamp(0, 999999);
    UserAccount updatedUser = _currentUser!.copyWith(coins: newCoins);
    
    if (updateTimestamp) {
      updatedUser = updatedUser.copyWith(lastRedeemed: DateTime.now().toIso8601String());
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

    final updatedBlocked = List<String>.from(_currentUser!.blockedUsers)..add(targetAmomimusId);
    final updatedExBlocked = List<String>.from(_currentUser!.exBlockedUsers)..removeWhere((e) => e.startsWith('$targetAmomimusId|') || e == targetAmomimusId);

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

    notifyListeners();
  }

  Future<void> unblockUser(String targetAmomimusId) async {
    if (_currentUser == null) return;
    if (!_currentUser!.blockedUsers.contains(targetAmomimusId)) return;

    final updatedBlocked = List<String>.from(_currentUser!.blockedUsers)..remove(targetAmomimusId);
    final updatedExBlocked = List<String>.from(_currentUser!.exBlockedUsers);
    
    // Remove old entry if exists
    updatedExBlocked.removeWhere((e) => e.startsWith('$targetAmomimusId|') || e == targetAmomimusId);
    
    // Add new entry with timestamp
    final timestamp = DateTime.now().toIso8601String();
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

    notifyListeners();
  }

  bool isRecentlyUnblocked(String targetAmomimusId) {
    if (_currentUser == null) return false;
    
    for (var entry in _currentUser!.exBlockedUsers) {
      if (entry.startsWith('$targetAmomimusId|')) {
        final parts = entry.split('|');
        if (parts.length == 2) {
          final unblockDate = DateTime.tryParse(parts[1]);
          if (unblockDate != null) {
            final diff = DateTime.now().difference(unblockDate);
            return diff.inDays <= 3;
          }
        }
      } else if (entry == targetAmomimusId) {
        // Legacy entry without timestamp. Treat as expired.
        return false;
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
        final diff = DateTime.now().difference(lastEdit);
        if (diff.inHours < 24) {
          return false; // Can only edit once every 24 hours
        }
      }
    }

    final updatedCreds = creds.copyWith(
      favoriteCharacter: newCharacter,
      lastFavCharEditDate: DateTime.now().toIso8601String(),
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
      final effectivePoints = math.max(targetUser?.benevolentPoints ?? 0, localPoints);
      return UserIndicatorHelper.fromBenevolentPoints(effectivePoints).name;
    }
    return globalIndicator;
  }

  UserAccount? getAccountById(String id) {
    try {
      return _accounts.firstWhere((acc) => acc.amomimusId == id || acc.id.toString() == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> submitReport(String targetId, ReportCategory category, {bool isChatBubbleReport = false}) async {
    String normalizedTargetId = targetId;
    final match = RegExp(r'#(?:YOU|AMO|AMI|AMOM)-(\d+)').firstMatch(targetId);
    if (match != null) {
      int num = int.parse(match.group(1)!);
      if (num == 100) num = 110;
      normalizedTargetId = '#AMM-$num';
    } else {
      normalizedTargetId = targetId.replaceAll(RegExp(r'#AM[OMI]+-'), '#AMM-');
    }
    final userIndex = _accounts.indexWhere((acc) => acc.amomimusId == targetId || acc.amomimusId == normalizedTargetId || acc.id.toString() == targetId);
    
    if (userIndex != -1) {
      var user = _accounts[userIndex];
      
      final newStatus = BenevolentCalculator.addReportToUser(
        currentPoints: user.benevolentPoints,
        category: category,
        isChatBubbleReport: isChatBubbleReport,
        currentIndicator: user.indicator,
      );
      
      final updatedUser = user.copyWith(
        reportedCount: user.reportedCount + 1,
        benevolentPoints: newStatus.points,
        indicator: newStatus.indicator.name,
      );
      
      try {
        await DatabaseHelper.instance.updateUser(updatedUser);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: $e ====");
      }
      
      _accounts[userIndex] = updatedUser;
      
      if (_currentUser?.id == updatedUser.id) {
        _currentUser = updatedUser;
      }
    }

    // ALWAYS update local perspective, even for dummy users (userIndex == -1)
    if (_currentUser != null && _currentUser!.amomimusId != targetId) {
      final newPointsMap = Map<String, int>.from(_currentUser!.localAssignedPoints);
      final currentLocalPoints = newPointsMap[targetId] ?? 0;
      
      final localStatus = BenevolentCalculator.addReportToUser(
        currentPoints: currentLocalPoints,
        category: category,
        isChatBubbleReport: isChatBubbleReport,
        currentIndicator: 'cloudy', // we don't care about the string here for local math
        pointMultiplier: 4.0, // Scale up local points so 5 hate speech = Ghost
      );
      
      newPointsMap[targetId] = localStatus.points;
      
      final newReporter = _currentUser!.copyWith(localAssignedPoints: newPointsMap);
      _currentUser = newReporter;
      
      try {
        await DatabaseHelper.instance.updateUser(newReporter);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: $e ====");
      }
      
      final reporterIndex = _accounts.indexWhere((acc) => acc.id == newReporter.id);
      if (reporterIndex != -1) {
        _accounts[reporterIndex] = newReporter;
      }
    }
    
    notifyListeners();
  }


  Future<void> hideFeed(String feedId) async {
    if (_currentUser == null) return;
    
    if (!_currentUser!.hiddenFeeds.contains(feedId)) {
      final updatedList = List<String>.from(_currentUser!.hiddenFeeds)..add(feedId);
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
    
    final today = DateTime.now().toIso8601String().split('T').first;
    final lastReqDate = _currentUser!.lastChatRequestDate?.split('T').first;
    int newCount = _currentUser!.dailyChatRequestsSent;
    
    if (lastReqDate != today) {
      newCount = 1;
    } else {
      newCount += 1;
    }
    
    final updatedUser = _currentUser!.copyWith(
      dailyChatRequestsSent: newCount,
      lastChatRequestDate: DateTime.now().toIso8601String(),
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
    
    final updatedUser = _currentUser!.copyWith(wishlistStickerBatches: currentList);
    
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
    final updatedList = List<String>.from(_currentUser!.ownedStickerBatches)..add(batchId);
    
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
}
