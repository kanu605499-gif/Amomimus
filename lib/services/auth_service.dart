import '../models/user_model.dart';
import '../database/models/user_register_sql.dart';

abstract class AuthService {
  /// Checks if an email is already registered.
  Future<bool> isEmailRegistered(String email);

  /// Registers a new user with login credentials and profile details.
  /// Returns true if successful, false otherwise.
  Future<bool> registerAccount(UserModelSql credentials, UserAccount profile);

  /// Logs in a user and returns their profile.
  Future<UserAccount?> login(String email, String password);

  /// Logs out the current user.
  Future<void> logout();

  /// Deletes a user account.
  Future<void> deleteAccount(String email);

  /// Updates user credentials
  Future<bool> updateCredentials(UserModelSql updatedCredentials);

  /// Gets user credentials
  Future<UserModelSql?> getCredentials(String email);
}
