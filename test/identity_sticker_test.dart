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

  test('Simulation: Identity and Sticker Ownership Verification', () async {
    final LocalAuthService authService = LocalAuthService();
    final AccountManager accountManager = AccountManager(authService: authService);
    final DatabaseHelper dbHelper = DatabaseHelper.instance;

    print("--- STARTING IDENTITY & STICKER SIMULATION ---");

    // 1. Setup Data for User A
    final credsA = UserModelSql(
      email: "userA@amomimus.com",
      password: "passwordA",
      favoriteCharacter: "Levi Ackerman"
    );
    final profileA = UserAccount(
      email: "userA@amomimus.com",
      realUsername: "Alex Alpha",
      anonymousUsername: "AlphaGhost",
      amomimusId: "#AMM-A100",
      gender: "Amom",
      registrationDate: "13/06/2026",
      isDemo: false,
      ownedStickers: ["sticker_hello", "sticker_wave"],
      ownedStickerBatches: ["batch_welcome"]
    );

    // 2. Setup Data for User B
    final credsB = UserModelSql(
      email: "userB@amomimus.com",
      password: "passwordB",
      favoriteCharacter: "Mikasa Ackerman"
    );
    final profileB = UserAccount(
      email: "userB@amomimus.com",
      realUsername: "Betty Beta",
      anonymousUsername: "BetaSpecter",
      amomimusId: "#AMM-B200",
      gender: "Ami",
      registrationDate: "14/06/2026",
      isDemo: false,
      ownedStickers: ["sticker_laugh", "sticker_cry"],
      ownedStickerBatches: ["batch_emotions"]
    );

    // Register Both Users
    await authService.registerAccount(credsA, profileA);
    await authService.registerAccount(credsB, profileB);
    print("✓ Successfully registered User A and User B with distinct stickers and identities.");

    // Validate User A via AccountManager
    await accountManager.loadAccounts();
    await accountManager.login("userA@amomimus.com", "passwordA");
    
    final loggedInA = accountManager.currentUser!;
    expect(loggedInA.email, "userA@amomimus.com");
    expect(loggedInA.realUsername, "Alex Alpha");
    expect(loggedInA.amomimusId, "#AMM-A100");
    expect(loggedInA.gender, "Amom");
    expect(loggedInA.ownedStickers, contains("sticker_hello"));
    expect(loggedInA.ownedStickers, isNot(contains("sticker_laugh"))); // Verify no leakage
    expect(loggedInA.ownedStickerBatches, contains("batch_welcome"));

    // Verify Favorite Character via Auth Service
    final fetchCredA = await authService.getCredentials("userA@amomimus.com");
    expect(fetchCredA!.favoriteCharacter, "Levi Ackerman");
    
    print("✓ User A Identity & Stickers perfectly intact and isolated.");

    // Validate User B via AccountManager
    await accountManager.login("userB@amomimus.com", "passwordB");
    
    final loggedInB = accountManager.currentUser!;
    expect(loggedInB.email, "userB@amomimus.com");
    expect(loggedInB.realUsername, "Betty Beta");
    expect(loggedInB.amomimusId, "#AMM-B200");
    expect(loggedInB.gender, "Ami");
    expect(loggedInB.ownedStickers, contains("sticker_cry"));
    expect(loggedInB.ownedStickers, isNot(contains("sticker_wave"))); // Verify no leakage
    expect(loggedInB.ownedStickerBatches, contains("batch_emotions"));

    // Verify Favorite Character via Auth Service
    final fetchCredB = await authService.getCredentials("userB@amomimus.com");
    expect(fetchCredB!.favoriteCharacter, "Mikasa Ackerman");

    print("✓ User B Identity & Stickers perfectly intact and isolated.");

    // Validate SQLite Mock Isolation directly
    final allUsers = await dbHelper.getAllUsers();
    final dbUserA = allUsers.firstWhere((u) => u.email == "userA@amomimus.com");
    final dbUserB = allUsers.firstWhere((u) => u.email == "userB@amomimus.com");

    expect(dbUserA.amomimusId, isNot(equals(dbUserB.amomimusId)));
    expect(dbUserA.ownedStickers, isNot(equals(dbUserB.ownedStickers)));
    expect(dbUserA.gender, isNot(equals(dbUserB.gender)));

    print("✓ Database-level cross-validation confirmed: No identity or sticker leakages detected.");
    print("--- SIMULATION FINISHED SUCCESSFULLY ---");
  });
}
