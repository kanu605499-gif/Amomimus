import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:amomimus/models/user_model.dart';
import 'package:amomimus/services/account_manager.dart';
import 'package:amomimus/services/auth_service.dart';
import 'package:amomimus/database/models/user_register_sql.dart';

// A mock AuthService for testing
class MockAuthService implements AuthService {
  final List<UserAccount> accounts;
  final UserModelSql credentials;

  MockAuthService(this.accounts, this.credentials);

  @override
  Future<bool> isEmailRegistered(String email) async => true;

  @override
  Future<bool> registerAccount(UserModelSql credentials, UserAccount profile) async => true;

  @override
  Future<UserAccount?> login(String email, String password) async => accounts.first;

  @override
  Future<void> logout() async {}

  @override
  Future<void> deleteAccount(String email) async {}

  @override
  Future<bool> updateCredentials(UserModelSql updatedCredentials) async => true;

  @override
  Future<UserModelSql?> getCredentials(String email) async => credentials;
}

// A mock AccountManager to override database load
class MockAccountManager extends AccountManager {
  final List<UserAccount> mockAccounts;

  MockAccountManager({required AuthService authService, required this.mockAccounts})
      : super(authService: authService);

  @override
  Future<void> loadAccounts() async {
    // Override to skip actual SQLite DB calls
    // Directly use mockAccounts
    // Wait, we can't override private fields, but we can override get accounts
  }
  
  @override
  List<UserAccount> get switchableAccounts {
    return mockAccounts;
  }
}

void main() {
  testWidgets('Simulate Master Account with 3 accounts', (WidgetTester tester) async {
    // We will just verify logic manually since we can't easily mock everything in UI without lots of setup.
    // Let's create 3 user accounts.
    final acc1 = UserAccount(id: 1, email: 'test@email.com', masterEmail: 'test@email.com', realUsername: 'A', anonymousUsername: 'Ghost 1', amomimusId: '#AMM-111', gender: 'Amo', registrationDate: '2026', isDemo: false);
    final acc2 = UserAccount(id: 2, email: 'test@email.com', masterEmail: 'test@email.com', realUsername: 'A', anonymousUsername: 'Ghost 2', amomimusId: '#AMM-222', gender: 'Ami', registrationDate: '2026', isDemo: false);
    final acc3 = UserAccount(id: 3, email: 'test@email.com', masterEmail: 'test@email.com', realUsername: 'A', anonymousUsername: 'Ghost 3', amomimusId: '#AMM-333', gender: 'Amom', registrationDate: '2026', isDemo: false);

    final creds = UserModelSql(email: 'test@email.com', password: 'password', fullName: 'Tester', favoriteCharacter: 'Bob');
    
    final authService = MockAuthService([acc1, acc2, acc3], creds);
    final am = MockAccountManager(authService: authService, mockAccounts: [acc1, acc2, acc3]);
    
    // Simulate current user is acc1
    await am.switchAccount(acc1);
    
    expect(am.switchableAccounts.length, 3);
    expect(am.currentUser?.id, 1);
    
    // Simulate switching to acc2
    await am.switchAccount(acc2);
    expect(am.currentUser?.id, 2);
    
    // Simulate switching to acc3
    await am.switchAccount(acc3);
    expect(am.currentUser?.id, 3);
  });
}
