import 'sqlite_service.dart';
import 'models/user_register_sql.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<List<UserModelSql>> getAllUsers() async {
    final db = await SqliteService.instance.database;
    final maps = await db.query('users');
    return maps.map((e) => UserModelSql.fromMap(e)).toList();
  }

  Future<bool> registerUser(UserModelSql pengguna) async {
    return await SqliteService.instance.registerCredential(pengguna);
  }

  Future<UserModelSql?> loginUser(String email, String password) async {
    return await SqliteService.instance.getCredential(email, password);
  }

  Future<int> deleteUser(String email) async {
    try {
      await SqliteService.instance.deleteCredential(email);
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> updateCredentials(UserModelSql updatedUser) async {
    return await SqliteService.instance.updateCredential(updatedUser);
  }
}
