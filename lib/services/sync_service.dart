import 'package:flutter/foundation.dart' show debugPrint;
import '../database/sqlite_service.dart';

class SyncService {
  static final SyncService instance = SyncService._init();

  SyncService._init();

  /// Mock function to simulate syncing local SQLite data to a backend like Firebase.
  /// Call this when the app is online or periodically.
  Future<void> syncOfflineData() async {
    final db = await SqliteService.instance.database;

    // 1. Sync Reports
    final unsyncedReports = await db.query('reports', where: 'is_synced = 0');
    if (unsyncedReports.isNotEmpty) {
      debugPrint(
        "==== SYNCING ${unsyncedReports.length} REPORTS TO FIREBASE ====",
      );
      // TODO: FirebaseFirestore.instance.collection('reports').add(...)

      // Mark as synced locally
      for (var report in unsyncedReports) {
        await db.update(
          'reports',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [report['id']],
        );
      }
    }

    // 2. Sync Accounts (Indicator, BenevolentPoints, Bio, etc)
    final unsyncedAccounts = await db.query('accounts', where: 'is_synced = 0');
    if (unsyncedAccounts.isNotEmpty) {
      debugPrint(
        "==== SYNCING ${unsyncedAccounts.length} ACCOUNTS TO FIREBASE ====",
      );
      // TODO: FirebaseFirestore.instance.collection('users').doc(amomimusId).set(...)

      for (var acc in unsyncedAccounts) {
        await db.update(
          'accounts',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [acc['id']],
        );
      }
    }

    // 3. Sync Blocks
    final unsyncedBlocks = await db.query('blocks', where: 'is_synced = 0');
    if (unsyncedBlocks.isNotEmpty) {
      debugPrint(
        "==== SYNCING ${unsyncedBlocks.length} BLOCKS TO FIREBASE ====",
      );
      // TODO: Push blocks
      for (var b in unsyncedBlocks) {
        await db.update(
          'blocks',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [b['id']],
        );
      }
    }

    // 4. Sync Items
    final unsyncedItems = await db.query('user_items', where: 'is_synced = 0');
    if (unsyncedItems.isNotEmpty) {
      debugPrint("==== SYNCING ${unsyncedItems.length} ITEMS TO FIREBASE ====");
      for (var item in unsyncedItems) {
        await db.update(
          'user_items',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [item['id']],
        );
      }
    }
  }

  /// An admin or cloud function could call something like this to forcefully
  /// update a user's indicator.
  Future<void> receiveAdminIndicatorUpdate(
    String amomimusId,
    String newIndicator,
    int newPoints,
  ) async {
    final db = await SqliteService.instance.database;
    await db.update(
      'accounts',
      {
        'indicator': newIndicator,
        'benevolentPoints': newPoints,
        'is_synced': 1,
      },
      where: 'amomimusId = ?',
      whereArgs: [amomimusId],
    );
  }
}
