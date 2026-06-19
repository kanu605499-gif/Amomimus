import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';
import 'models/user_register_sql.dart';

class SqliteService {
  static final SqliteService instance = SqliteService._init();
  static Database? _database;

  SqliteService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('amomimus_hybrid.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Users table (Credentials)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        email TEXT UNIQUE,
        favorite_character TEXT,
        password TEXT,
        last_fav_char_edit_date TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // 2. Accounts table (Amomimus profiles)
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        realUsername TEXT,
        anonymousUsername TEXT,
        customUsername TEXT,
        amomimusId TEXT UNIQUE,
        gender TEXT,
        registrationDate TEXT,
        isDemo INTEGER,
        bio TEXT,
        coins INTEGER,
        reportedCount INTEGER,
        lastRedeemed TEXT,
        dailyChatRequestsSent INTEGER,
        lastChatRequestDate TEXT,
        dateOfBirth TEXT,
        totalResonatesReceived INTEGER,
        benevolentPoints INTEGER,
        indicator TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // 3. Reports table (For God Admin Power & Local Perspectives)
    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reporter_id TEXT,
        reported_id TEXT,
        category TEXT,
        points INTEGER,
        is_chat_bubble INTEGER,
        timestamp TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // 4. Blocks table
    await db.execute('''
      CREATE TABLE blocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        blocker_id TEXT,
        blocked_id TEXT,
        status TEXT, -- 'blocked' or 'ex_blocked'
        timestamp TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // 5. Items table (Stickers, Wishlists, Hidden Feeds)
    await db.execute('''
      CREATE TABLE user_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amomimusId TEXT,
        item_type TEXT, -- 'sticker', 'owned_batch', 'wishlist_batch', 'hidden_feed'
        item_id TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');
  }

  // ==========================================
  // USERS (CREDENTIALS) METHODS
  // ==========================================

  Future<bool> registerCredential(UserModelSql user) async {
    final db = await instance.database;
    try {
      final map = user.toMap();
      map['is_synced'] = 0;
      await db.insert('users', map, conflictAlgorithm: ConflictAlgorithm.fail);
      return true;
    } catch (e) {
      print("==== DB ERROR: Email may already exist ($e) ====");
      return false;
    }
  }

  Future<UserModelSql?> getCredential(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModelSql.fromMap(maps.first);
    }
    return null;
  }
  
  Future<UserModelSql?> getCredentialByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModelSql.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> updateCredential(UserModelSql user) async {
    final db = await instance.database;
    try {
      final map = user.toMap();
      map['is_synced'] = 0;
      final rows = await db.update(
        'users',
        map,
        where: 'email = ?',
        whereArgs: [user.email],
      );
      return rows > 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteCredential(String email) async {
    final db = await instance.database;
    await db.delete('users', where: 'email = ?', whereArgs: [email]);
  }

  // ==========================================
  // ACCOUNTS (PROFILES) METHODS
  // ==========================================

  Future<int> createAccount(UserAccount account) async {
    final db = await instance.database;
    final map = account.toMap();
    
    // Remove relational fields from map to avoid sqlite errors
    map.remove('ownedStickers');
    map.remove('blockedUsers');
    map.remove('exBlockedUsers');
    map.remove('hiddenFeeds');
    map.remove('wishlistStickerBatches');
    map.remove('ownedStickerBatches');
    map.remove('localAssignedPoints');
    map['is_synced'] = 0;

    final id = await db.insert('accounts', map, conflictAlgorithm: ConflictAlgorithm.replace);
    
    // Insert relational items
    await _syncListsToItemsTable(account.amomimusId, 'sticker', account.ownedStickers);
    await _syncListsToItemsTable(account.amomimusId, 'owned_batch', account.ownedStickerBatches);
    await _syncListsToItemsTable(account.amomimusId, 'wishlist_batch', account.wishlistStickerBatches);
    await _syncListsToItemsTable(account.amomimusId, 'hidden_feed', account.hiddenFeeds);
    
    // Insert blocks
    await _syncBlocksTable(account.amomimusId, account.blockedUsers, account.exBlockedUsers);

    return id;
  }

  Future<void> updateAccount(UserAccount account) async {
    final db = await instance.database;
    final map = account.toMap();
    
    map.remove('ownedStickers');
    map.remove('blockedUsers');
    map.remove('exBlockedUsers');
    map.remove('hiddenFeeds');
    map.remove('wishlistStickerBatches');
    map.remove('ownedStickerBatches');
    map.remove('localAssignedPoints');
    map['is_synced'] = 0; // flag for Firebase SyncService

    await db.update(
      'accounts',
      map,
      where: 'email = ?',
      whereArgs: [account.email],
    );

    // Update relational items (replacing old ones)
    await _syncListsToItemsTable(account.amomimusId, 'sticker', account.ownedStickers);
    await _syncListsToItemsTable(account.amomimusId, 'owned_batch', account.ownedStickerBatches);
    await _syncListsToItemsTable(account.amomimusId, 'wishlist_batch', account.wishlistStickerBatches);
    await _syncListsToItemsTable(account.amomimusId, 'hidden_feed', account.hiddenFeeds);
    await _syncBlocksTable(account.amomimusId, account.blockedUsers, account.exBlockedUsers);
  }

  Future<List<UserAccount>> getAllAccounts() async {
    final db = await instance.database;
    final maps = await db.query('accounts');
    
    List<UserAccount> accounts = [];
    for (var map in maps) {
      final amomimusId = map['amomimusId'] as String;
      
      // Fetch relational data
      final ownedStickers = await _getItems(amomimusId, 'sticker');
      final ownedBatches = await _getItems(amomimusId, 'owned_batch');
      final wishlistBatches = await _getItems(amomimusId, 'wishlist_batch');
      final hiddenFeeds = await _getItems(amomimusId, 'hidden_feed');
      
      final blocksData = await _getBlocks(amomimusId);
      final blockedUsers = blocksData['blocked'] ?? [];
      final exBlockedUsers = blocksData['ex_blocked'] ?? [];

      final localPoints = await _getLocalPoints(amomimusId);

      // Reconstruct map for UserAccount.fromMap
      final mutableMap = Map<String, dynamic>.from(map);
      mutableMap['ownedStickers'] = ownedStickers;
      mutableMap['ownedStickerBatches'] = ownedBatches;
      mutableMap['wishlistStickerBatches'] = wishlistBatches;
      mutableMap['hiddenFeeds'] = hiddenFeeds;
      mutableMap['blockedUsers'] = blockedUsers;
      mutableMap['exBlockedUsers'] = exBlockedUsers;
      mutableMap['localAssignedPoints'] = localPoints;

      accounts.add(UserAccount.fromMap(mutableMap));
    }

    return accounts;
  }

  Future<void> deleteAccount(String email, String amomimusId) async {
    final db = await instance.database;
    await db.delete('accounts', where: 'email = ?', whereArgs: [email]);
    await db.delete('user_items', where: 'amomimusId = ?', whereArgs: [amomimusId]);
    await db.delete('blocks', where: 'blocker_id = ?', whereArgs: [amomimusId]);
    await db.delete('reports', where: 'reporter_id = ?', whereArgs: [amomimusId]);
  }

  // ==========================================
  // RELATIONAL HELPERS
  // ==========================================

  Future<void> _syncListsToItemsTable(String amomimusId, String type, List<String> items) async {
    final db = await instance.database;
    await db.delete('user_items', where: 'amomimusId = ? AND item_type = ?', whereArgs: [amomimusId, type]);
    
    for (var item in items) {
      await db.insert('user_items', {
        'amomimusId': amomimusId,
        'item_type': type,
        'item_id': item,
        'is_synced': 0
      });
    }
  }

  Future<List<String>> _getItems(String amomimusId, String type) async {
    final db = await instance.database;
    final maps = await db.query('user_items', where: 'amomimusId = ? AND item_type = ?', whereArgs: [amomimusId, type]);
    return maps.map((m) => m['item_id'] as String).toList();
  }

  Future<void> _syncBlocksTable(String blockerId, List<String> blocked, List<String> exBlocked) async {
    final db = await instance.database;
    await db.delete('blocks', where: 'blocker_id = ?', whereArgs: [blockerId]);
    
    for (var b in blocked) {
      await db.insert('blocks', {'blocker_id': blockerId, 'blocked_id': b, 'status': 'blocked', 'timestamp': DateTime.now().toIso8601String(), 'is_synced': 0});
    }
    for (var eb in exBlocked) {
      await db.insert('blocks', {'blocker_id': blockerId, 'blocked_id': eb, 'status': 'ex_blocked', 'timestamp': DateTime.now().toIso8601String(), 'is_synced': 0});
    }
  }

  Future<Map<String, List<String>>> _getBlocks(String blockerId) async {
    final db = await instance.database;
    final maps = await db.query('blocks', where: 'blocker_id = ?', whereArgs: [blockerId]);
    
    List<String> blocked = [];
    List<String> exBlocked = [];
    
    for (var m in maps) {
      if (m['status'] == 'blocked') {
        blocked.add(m['blocked_id'] as String);
      } else {
        exBlocked.add(m['blocked_id'] as String); // Will contain targetId|timestamp if stored like that, or we handle timestamp separately
      }
    }
    return {'blocked': blocked, 'ex_blocked': exBlocked};
  }

  // ==========================================
  // REPORTS / ADMIN GOD POWER
  // ==========================================

  Future<void> addReport(String reporterId, String reportedId, String category, int points, bool isChatBubble) async {
    final db = await instance.database;
    await db.insert('reports', {
      'reporter_id': reporterId,
      'reported_id': reportedId,
      'category': category,
      'points': points,
      'is_chat_bubble': isChatBubble ? 1 : 0,
      'timestamp': DateTime.now().toIso8601String(),
      'is_synced': 0
    });
  }

  Future<Map<String, int>> _getLocalPoints(String reporterId) async {
    final db = await instance.database;
    // For localAssignedPoints, we aggregate points reported BY this user
    final maps = await db.query('reports', where: 'reporter_id = ?', whereArgs: [reporterId]);
    Map<String, int> pointsMap = {};
    for (var m in maps) {
      final rId = m['reported_id'] as String;
      final pts = m['points'] as int;
      // In the old flow, local points were scaled up * 4. We can do that aggregation here
      pointsMap[rId] = (pointsMap[rId] ?? 0) + (pts * 4); 
    }
    return pointsMap;
  }
}
