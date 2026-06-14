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

  test('Simulation: 5 Accounts Signup -> Block -> Delete', () async {
    final LocalAuthService authService = LocalAuthService();
    final AccountManager accountManager = AccountManager(authService: authService);
    final DatabaseHelper dbHelper = DatabaseHelper.instance;

    print("--- STARTING SIMULATION ---");

    // 1. Sign up 5 accounts
    List<UserAccount> profiles = [];
    for (int i = 1; i <= 5; i++) {
      String email = "test$i@example.com";
      String pass = "password$i";
      String amomimusId = "#TEST-${100 + i}";

      final creds = UserModelSql(
        email: email,
        password: pass,
        favoriteCharacter: "Char$i"
      );

      final profile = UserAccount(
        email: email,
        realUsername: "User $i",
        anonymousUsername: "Anon $i",
        amomimusId: amomimusId,
        gender: "Amo",
        registrationDate: "13/06/2026",
        isDemo: false
      );

      final success = await authService.registerAccount(creds, profile);
      expect(success, true);
      profiles.add(profile);
    }
    print("✓ Successfully registered 5 accounts.");

    // 2. Login with Account 1
    await accountManager.loadAccounts();
    final loginSuccess = await accountManager.login("test1@example.com", "password1");
    expect(loginSuccess, true);
    print("✓ Logged in as User 1 (${accountManager.currentUser?.email}).");

    // 3. User 1 blocks User 2 and User 3
    final user2 = profiles[1].amomimusId;
    final user3 = profiles[2].amomimusId;
    
    await accountManager.blockUser(user2);
    await accountManager.blockUser(user3);
    
    // Verify blocking locally
    expect(accountManager.currentUser?.blockedUsers.contains(user2), true);
    expect(accountManager.currentUser?.blockedUsers.contains(user3), true);

    // Verify it is saved in DatabaseHelper
    final allProfilesAfterBlock = await dbHelper.getAllUsers();
    final dbUser1 = allProfilesAfterBlock.firstWhere((p) => p.email == "test1@example.com");
    expect(dbUser1.blockedUsers.contains(user2), true);
    expect(dbUser1.blockedUsers.contains(user3), true);
    print("✓ User 1 successfully blocked User 2 ($user2) and User 3 ($user3). Persistence verified.");

    // 4. Delete Account 4
    await accountManager.login("test4@example.com", "password4");
    
    await accountManager.deleteAccount("test4@example.com");

    // Verify Account 4 is deleted
    final allProfilesAfterDelete = await dbHelper.getAllUsers();
    final hasUser4 = allProfilesAfterDelete.any((p) => p.email == "test4@example.com");
    expect(hasUser4, false);
    
    final dbHelperCreds = DBHelper();
    final allCredsAfterDelete = await dbHelperCreds.getAllUsers();
    final hasCreds4 = allCredsAfterDelete.any((c) => c.email == "test4@example.com");
    expect(hasCreds4, false);
    
    print("✓ User 4 successfully deleted from database (both SQLite and SharedPreferences mock).");

    // 5. Unblock User 2 (Testing ex_blocked list)
    await accountManager.login("test1@example.com", "password1");
    await accountManager.unblockUser(user2);
    
    expect(accountManager.currentUser?.blockedUsers.contains(user2), false);
    expect(accountManager.currentUser?.exBlockedUsers.any((e) => e.startsWith('$user2|') || e == user2), true);

    final finalProfiles = await dbHelper.getAllUsers();
    final finalDbUser1 = finalProfiles.firstWhere((p) => p.email == "test1@example.com");
    expect(finalDbUser1.blockedUsers.contains(user2), false);
    expect(finalDbUser1.exBlockedUsers.any((e) => e.startsWith('$user2|') || e == user2), true);
    print("✓ User 1 successfully unblocked User 2 ($user2). Moved to exBlockedUsers. Persistence verified.");

    print("--- SIMULATION FINISHED SUCCESSFULLY ---");
  });
}
