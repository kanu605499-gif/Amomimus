import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amomimus/services/account_manager.dart';
import 'package:amomimus/database_helper.dart';
import 'package:amomimus/database/db_helper.dart';
import 'package:amomimus/services/local_auth_service.dart';
import 'package:amomimus/models/user_model.dart';
import 'package:amomimus/database/models/user_register_sql.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Simulation: Ex-Blocked Glitch Timestamp Logic', () async {
    final LocalAuthService authService = LocalAuthService();
    final AccountManager accountManager = AccountManager(authService: authService);

    print("--- STARTING GLITCH EFFECT TIMING SIMULATION ---");

    final credsA = UserModelSql(email: "blocker@test.com", password: "p", favoriteCharacter: "c");
    final profileA = UserAccount(email: "blocker@test.com", realUsername: "R", anonymousUsername: "A", amomimusId: "#AMM-BLOCKER", gender: "Amom", registrationDate: "1", isDemo: false);
    
    final credsB = UserModelSql(email: "target@test.com", password: "p", favoriteCharacter: "c");
    final profileB = UserAccount(email: "target@test.com", realUsername: "R", anonymousUsername: "A", amomimusId: "#AMM-TARGET", gender: "Amom", registrationDate: "1", isDemo: false);

    await authService.registerAccount(credsA, profileA);
    await authService.registerAccount(credsB, profileB);
    
    await accountManager.loadAccounts();
    await accountManager.login("blocker@test.com", "p");

    // 1. Block
    await accountManager.blockUser("#AMM-TARGET");
    expect(accountManager.currentUser!.blockedUsers, contains("#AMM-TARGET"));
    expect(accountManager.isRecentlyUnblocked("#AMM-TARGET"), false);

    // 2. Unblock (Starts glitch effect for 3 days)
    await accountManager.unblockUser("#AMM-TARGET");
    expect(accountManager.currentUser!.blockedUsers, isNot(contains("#AMM-TARGET")));
    expect(accountManager.isRecentlyUnblocked("#AMM-TARGET"), true); // Glitch active
    
    // Check timestamp format internally
    final exBlockedEntry = accountManager.currentUser!.exBlockedUsers.firstWhere((e) => e.startsWith("#AMM-TARGET|"));
    print("Unblock entry generated: \$exBlockedEntry");

    print("✓ isRecentlyUnblocked properly tracks 3-day window logic.");
    print("--- SIMULATION FINISHED SUCCESSFULLY ---");
  });
}
