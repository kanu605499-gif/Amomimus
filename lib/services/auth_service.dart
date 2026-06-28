import '../models/user_model.dart';
import '../models/user_credentials_model.dart';

class GoogleAuthResult {
  final bool isNewUser;
  final UserAccount? account;
  final String? email;
  final String? name;

  GoogleAuthResult({
    required this.isNewUser,
    this.account,
    this.email,
    this.name,
  });
}

abstract class AuthService {
  /// Checks if an email is already registered.
  Future<bool> isEmailRegistered(String email);

  /// Registers a new user with login credentials and profile details.
  /// Returns the UserAccount with generated ID if successful, null otherwise.
  Future<UserAccount?> registerAccount(UserCredentialsModel credentials, UserAccount profile);

  /// Logs in a user and returns their profile.
  Future<UserAccount?> login(String email, String password);

  /// Logs out the current user.
  Future<void> logout();

  /// Deletes a user account.
  Future<void> deleteAccount(String email);

  /// Updates user credentials
  Future<bool> updateCredentials(UserCredentialsModel updatedCredentials);

  /// Gets user credentials
  Future<UserCredentialsModel?> getCredentials(String email);

  // Google Sign-In Methods
  Future<GoogleAuthResult?> loginWithGoogle();
  Future<UserAccount?> registerGoogleProfile(UserCredentialsModel credentials, UserAccount profile);
  
  // Re-authentication
  Future<bool> reauthenticate(String? password);
}
