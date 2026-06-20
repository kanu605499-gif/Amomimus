/// Tracks a user's sticker inventory.
/// Designed for hybrid-safe usage (local SQLite caching + cloud sync).
class UserStickerInventory {
  final String userId;
  final List<String> unlockedStickerIds;
  final List<String> recentlyUsedStickerIds;
  final String? lastSyncedAt;

  UserStickerInventory({
    required this.userId,
    this.unlockedStickerIds = const [],
    this.recentlyUsedStickerIds = const [],
    this.lastSyncedAt,
  });

  /// Firestore & SQLite-ready: converts this to a Map.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'unlockedStickerIds': unlockedStickerIds,
      'recentlyUsedStickerIds': recentlyUsedStickerIds,
      'lastSyncedAt': lastSyncedAt ?? DateTime.now().toIso8601String(),
    };
  }

  /// Firestore & SQLite-ready: creates an instance from a Map.
  factory UserStickerInventory.fromMap(Map<String, dynamic> map) {
    return UserStickerInventory(
      userId: map['userId'],
      unlockedStickerIds: List<String>.from(map['unlockedStickerIds'] ?? []),
      recentlyUsedStickerIds: List<String>.from(
        map['recentlyUsedStickerIds'] ?? [],
      ),
      lastSyncedAt: map['lastSyncedAt'],
    );
  }

  /// Creates a copy of this inventory with some updated fields.
  UserStickerInventory copyWith({
    String? userId,
    List<String>? unlockedStickerIds,
    List<String>? recentlyUsedStickerIds,
    String? lastSyncedAt,
  }) {
    return UserStickerInventory(
      userId: userId ?? this.userId,
      unlockedStickerIds: unlockedStickerIds ?? this.unlockedStickerIds,
      recentlyUsedStickerIds:
          recentlyUsedStickerIds ?? this.recentlyUsedStickerIds,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
