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
  Future<bool> registerAccount(
    UserModelSql credentials,
    UserAccount profile,
  ) async {
    // If the email is already registered, this is a sub-profile creation. We must verify password.
    final bool exists = await isEmailRegistered(credentials.email ?? "");
    if (!exists) {
      // Aturan: 1 Device maksimal 3 master email
      final users = await _dbHelper.getAllUsers();
      if (users.length >= 3) {
        print("==== REGISTRATION FAILED: Limit reached (Max 3 master emails per device) ====");
        return false;
      }

      final bool isSuccess = await _dbHelper.registerUser(credentials);
      if (!isSuccess) return false;
    } else {
      // Mencegah pendaftaran email yang sama lewat halaman Sign Up (password harus cocok)
      final validUser = await _dbHelper.loginUser(credentials.email ?? "", credentials.password ?? "");
      if (validUser == null) {
        print("==== REGISTRATION FAILED: Email already registered or Invalid password ====");
        return false;
      }
    }

    // 2. Validate Binded Account Restrictions & Save Profile
    try {
      final allProfiles = await _databaseHelper.getAllUsers();
      
      // Aturan: 1 device / master email maksimal 3 akun
      final profilesUnderThisMaster = allProfiles.where((p) => p.masterEmail == credentials.email).toList();
      if (profilesUnderThisMaster.length >= 3) {
        print("==== REGISTRATION FAILED: Limit reached (Max 3 accounts per master) ====");
        return false;
      }

      // Aturan: Akun yang terdaftar (binded) ga bisa di bind ke master/batch lain
      final isIdAlreadyBound = allProfiles.any((p) => p.amomimusId == profile.amomimusId && p.masterEmail != profile.masterEmail);
      if (isIdAlreadyBound) {
        print("==== REGISTRATION FAILED: This Amomimus ID is already bound to another master account! ====");
        return false;
      }

      await _databaseHelper.createUser(profile);
      return true;
    } catch (e) {
      print("==== DB REGISTER PROFILE ERROR/SKIPPED: $e ====");
      // For web/environments where sqflite might fail, we still consider it a success locally
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
      return allProfiles.firstWhere((p) => p.masterEmail == email);
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
    // ==== [API READY] Simulate Backend Deletion ====
    // This represents the future API call to delete the master account,
    // which will also cascade to delete all sub-profiles, chat history, and tokens.
    print("==== [API READY] Sending DELETE request to /api/v1/users/$email ====");
    await Future.delayed(const Duration(seconds: 1)); // Network simulation
    print("==== [API READY] Successfully deleted user data from server ====");

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
