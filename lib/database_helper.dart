import 'models/user_model.dart';
import 'database/sqlite_service.dart';
import 'database/models/user_register_sql.dart';
export 'models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  // Set this to false in production to disable dummy generation
  static const bool enableDummies = true;

  Future<void> _seedDummiesIfNeeded() async {
    if (!enableDummies) return;

    // Check if db is empty
    final existing = await SqliteService.instance.getAllAccounts();
    if (existing.isEmpty) {
      List<UserAccount> dummies = [
        UserAccount(
          id: 1,
          email: 'dummy1@amomimus.com',
          realUsername: 'DummyOne',
          anonymousUsername: 'Ghost1',
          customUsername: null,
          amomimusId: '#AMM-101',
          gender: 'Amo',
          registrationDate: '01/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 2,
          email: 'dummy2@amomimus.com',
          realUsername: 'DummyTwo',
          anonymousUsername: 'Shadow2',
          customUsername: null,
          amomimusId: '#AMM-102',
          gender: 'Amom',
          registrationDate: '02/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 3,
          email: 'dummy3@amomimus.com',
          realUsername: 'DummyThree',
          anonymousUsername: 'Specter3',
          customUsername: null,
          amomimusId: '#AMM-103',
          gender: 'Ami',
          registrationDate: '03/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 4,
          email: 'dummy4@amomimus.com',
          realUsername: 'DummyFour',
          anonymousUsername: 'Phantom4',
          customUsername: null,
          amomimusId: '#AMM-104',
          gender: 'Amo',
          registrationDate: '04/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 5,
          email: 'dummy5@amomimus.com',
          realUsername: 'DummyFive',
          anonymousUsername: 'Spirit5',
          customUsername: null,
          amomimusId: '#AMM-105',
          gender: 'Amom',
          registrationDate: '05/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 6,
          email: 'dummy6@amomimus.com',
          realUsername: 'DummySix',
          anonymousUsername: 'Wraith6',
          customUsername: null,
          amomimusId: '#AMM-106',
          gender: 'Ami',
          registrationDate: '06/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 7,
          email: 'dummy7@amomimus.com',
          realUsername: 'DummySeven',
          anonymousUsername: 'Ghoul7',
          customUsername: null,
          amomimusId: '#AMM-107',
          gender: 'Amo',
          registrationDate: '07/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 8,
          email: 'dummy8@amomimus.com',
          realUsername: 'DummyEight',
          anonymousUsername: 'Banshee8',
          customUsername: null,
          amomimusId: '#AMM-108',
          gender: 'Amom',
          registrationDate: '08/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 9,
          email: 'dummy9@amomimus.com',
          realUsername: 'DummyNine',
          anonymousUsername: 'Poltergeist9',
          customUsername: null,
          amomimusId: '#AMM-109',
          gender: 'Ami',
          registrationDate: '09/01/2026',
          isDemo: false,
        ),
        UserAccount(
          id: 10,
          email: 'dummy10@amomimus.com',
          realUsername: 'DummyTen',
          anonymousUsername: 'Apparition10',
          customUsername: null,
          amomimusId: '#AMM-110',
          gender: 'Amo',
          registrationDate: '10/01/2026',
          isDemo: false,
        ),
      ];
      for (var d in dummies) {
        await SqliteService.instance.createAccount(d);
      }

      // ── SEED GOOGLE PLAY TEST ACCOUNT ──
      final playTestEmail = 'satarnusdiata@gmail.com';
      final playTestCred = UserModelSql(
        fullName: 'Google Reviewer',
        email: playTestEmail,
        favoriteCharacter: 'Amo',
        password: 'k4nuulquiorr4',
      );
      final playTestAcc = UserAccount(
        email: playTestEmail,
        realUsername: 'Google Reviewer',
        anonymousUsername: 'ReviewerAmo',
        customUsername: null,
        amomimusId: '#AMM-999',
        gender: 'Amo',
        registrationDate: '01/01/2026',
        isDemo: false,
        dateOfBirth: '01/01/1990',
      );
      await SqliteService.instance.registerCredential(playTestCred);
      await SqliteService.instance.createAccount(playTestAcc);
    }
  }

  Future<int> createUser(UserAccount user) async {
    await _seedDummiesIfNeeded();
    final newId = await SqliteService.instance.createAccount(user);
    return newId;
  }

  Future<void> deleteUser(String email) async {
    // Note: We need amomimusId to clear relational tables properly.
    // For now we get the account first.
    final accounts = await getAllUsers();
    final target = accounts.where((e) => e.email == email).firstOrNull;
    if (target != null) {
      await SqliteService.instance.deleteAccount(email, target.amomimusId);
    }
  }

  Future<void> updateUser(UserAccount user) async {
    await SqliteService.instance.updateAccount(user);
  }

  Future<List<UserAccount>> getAllUsers() async {
    await _seedDummiesIfNeeded();
    return await SqliteService.instance.getAllAccounts();
  }

  Future<void> clearAll() async {
    final db = await SqliteService.instance.database;
    await db.delete('accounts');
    await db.delete('user_items');
    await db.delete('blocks');
    await db.delete('reports');
  }
}
