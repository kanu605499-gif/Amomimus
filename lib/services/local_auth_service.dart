import '../database/db_helper.dart';
import '../database_helper.dart';
import '../models/user_model.dart';
import '../database/models/user_register_sql.dart';
import 'auth_service.dart';

class LocalAuthService implements AuthService {
  final DBHelper _dbHelper = DBHelper();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<bool> isEmailRegistered(String email) async {
    final users = await _dbHelper.getAllUsers();
    return users.any((u) => u.email == email);
  }

  @override
  Future<bool> registerAccount(UserModelSql credentials, UserAccount profile) async {
    // 1. Save login credentials to SharedPreferences (DBHelper)
    final bool isSuccess = await _dbHelper.registerUser(credentials);
    if (!isSuccess) return false;

    // 2. Save complete profile (Amomus ID, avatar, etc.) to SQLite (DatabaseHelper)
    try {
      await _databaseHelper.createUser(profile);
      return true;
    } catch (e) {
      print("==== DB REGISTER PROFILE SKIPPED: $e ====");
      // For web/environments where sqflite might fail, we still consider it a success locally 
      // since the login credentials were saved.
      return true; 
    }
  }

  @override
  Future<UserAccount?> login(String email, String password) async {
    // 1. Verify credentials using SharedPreferences DB
    final credentials = await _dbHelper.loginUser(email, password);
    if (credentials == null) return null;

    // 2. Fetch the complete profile from SQLite
    try {
      final allProfiles = await _databaseHelper.getAllUsers();
      return allProfiles.firstWhere((p) => p.email == email);
    } catch (e) {
      print("==== DB FETCH PROFILE FAILED: $e ====");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    // No session management needed for local mock. AccountManager handles the in-memory state.
  }

  @override
  Future<void> deleteAccount(String email) async {
    await _dbHelper.deleteUser(email);
    try {
      await _databaseHelper.deleteUser(email);
    } catch (e) {
      print("==== DB DELETE PROFILE SKIPPED: $e ====");
    }
  }

  @override
  Future<bool> updateCredentials(UserModelSql updatedCredentials) async {
    return await _dbHelper.updateCredentials(updatedCredentials);
  }

  @override
  Future<UserModelSql?> getCredentials(String email) async {
    final users = await _dbHelper.getAllUsers();
    try {
      return users.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }
}
