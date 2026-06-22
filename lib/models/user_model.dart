/// User account model for the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class UserAccount {
  final int? id;
  final String email;
  final String masterEmail;
  final String realUsername;
  final String anonymousUsername;
  final String? customUsername;
  final String amomimusId;
  final String gender;
  final String registrationDate;
  final bool isDemo;
  final String bio;
  final String? bioExpirationDate;
  final int? bioOriginalDuration;
  final bool hasUsedBioBailout;
  final int coins;
  final int reportedCount;
  final String? lastRedeemed;
  final int dailyChatRequestsSent;
  final String? lastChatRequestDate;

  // Extended fields
  final String? dateOfBirth;
  final int totalResonatesReceived;
  final List<String> ownedStickers;
  final List<String> blockedUsers;
  final List<String> blockedBy; // NEW: Users who blocked this user
  final List<String> exBlockedUsers; // For historical blocked users
  final List<String> hiddenFeeds;
  final List<String> wishlistStickerBatches; // NEW WISHLIST DB FIELD
  final List<String> ownedStickerBatches; // TRACKS PURCHASED PACKS

  final Map<String, int> localAssignedPoints; // Maps amomimusId -> local points

  // Indicator system fields
  final int
  benevolentPoints; // 0–100 (percentage); 0-59 = CLOUDY, 60-89 = GHOST, 90-100 = NOISE
  final String indicator; // 'cloudy', 'ghost', or 'noise' (noise = admin-only)
  final String presenceStatus; // 'auto', 'online', 'invisible', 'dnd'

  UserAccount({
    this.id,
    required this.email,
    String? masterEmail,
    required this.realUsername,
    required this.anonymousUsername,
    this.customUsername,
    required this.amomimusId,
    required this.gender,
    required this.registrationDate,
    required this.isDemo,
    this.bio = "No bio yet",
    this.bioExpirationDate,
    this.bioOriginalDuration,
    this.hasUsedBioBailout = false,
    this.coins = 1240,
    this.reportedCount = 0,
    this.lastRedeemed,
    this.dailyChatRequestsSent = 0,
    this.lastChatRequestDate,
    this.dateOfBirth,
    this.totalResonatesReceived = 0,
    this.ownedStickers = const [],
    this.blockedUsers = const [],
    this.blockedBy = const [],
    this.exBlockedUsers = const [],
    this.hiddenFeeds = const [],
    this.wishlistStickerBatches = const [],
    this.ownedStickerBatches = const [],
    this.localAssignedPoints = const {},
    this.benevolentPoints = 0,
    this.indicator = 'cloudy',
    this.presenceStatus = 'auto',
  }) : masterEmail = (masterEmail == null || masterEmail.isEmpty) ? email : masterEmail;

  /// Firestore-ready: creates a [UserAccount] from a [Map].
  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      id: map['id'],
      email: map['email'],
      masterEmail: map['master_email'] ?? map['email'], // Fallback for legacy
      realUsername: map['realUsername'],
      anonymousUsername: map['anonymousUsername'],
      customUsername: map['customUsername'],
      amomimusId: map['amomimusId'],
      gender: map['gender'],
      registrationDate: map['registrationDate'],
      isDemo: map['isDemo'] == 1 || map['isDemo'] == true || (map['amomimusId'] as String? ?? '').startsWith('#AMM-'),
      bio: map['bio'] ?? "No bio yet",
      bioExpirationDate: map['bioExpirationDate'],
      bioOriginalDuration: map['bioOriginalDuration'],
      hasUsedBioBailout: map['hasUsedBioBailout'] == 1 || map['hasUsedBioBailout'] == true,
      coins: map['coins'] ?? 1240,
      reportedCount: map['reportedCount'] ?? 0,
      lastRedeemed: map['lastRedeemed'],
      dailyChatRequestsSent: map['dailyChatRequestsSent'] ?? 0,
      lastChatRequestDate: map['lastChatRequestDate'],
      dateOfBirth: map['dateOfBirth'],
      totalResonatesReceived: map['totalResonatesReceived'] ?? 0,
      ownedStickers:
          (map['ownedStickers'] as List?)?.map((e) => e as String).toList() ??
          [],
      blockedUsers:
          (map['blockedUsers'] as List?)?.map((e) => e as String).toList() ??
          [],
      blockedBy:
          (map['blockedBy'] as List?)?.map((e) => e as String).toList() ?? [],
      exBlockedUsers:
          (map['exBlockedUsers'] as List?)?.map((e) => e as String).toList() ??
          [],
      hiddenFeeds:
          (map['hiddenFeeds'] as List?)?.map((e) => e as String).toList() ?? [],
      wishlistStickerBatches:
          (map['wishlistStickerBatches'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      ownedStickerBatches:
          (map['ownedStickerBatches'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      localAssignedPoints: map['localAssignedPoints'] != null
          ? Map<String, int>.from(map['localAssignedPoints'] as Map)
          : {},
      benevolentPoints: map['benevolentPoints'] ?? 0,
      indicator: map['indicator'] ?? 'cloudy',
      presenceStatus: map['presenceStatus'] ?? 'auto',
    );
  }

  /// Firestore-ready: converts this [UserAccount] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'master_email': masterEmail,
      'realUsername': realUsername,
      'anonymousUsername': anonymousUsername,
      'customUsername': customUsername,
      'amomimusId': amomimusId,
      'gender': gender,
      'registrationDate': registrationDate,
      'isDemo': isDemo ? 1 : 0,
      'bio': bio,
      'bioExpirationDate': bioExpirationDate,
      'bioOriginalDuration': bioOriginalDuration,
      'hasUsedBioBailout': hasUsedBioBailout ? 1 : 0,
      'coins': coins,
      'reportedCount': reportedCount,
      'lastRedeemed': lastRedeemed,
      'dailyChatRequestsSent': dailyChatRequestsSent,
      'lastChatRequestDate': lastChatRequestDate,
      'dateOfBirth': dateOfBirth,
      'totalResonatesReceived': totalResonatesReceived,
      'ownedStickers': ownedStickers,
      'blockedUsers': blockedUsers,
      'blockedBy': blockedBy,
      'exBlockedUsers': exBlockedUsers,
      'hiddenFeeds': hiddenFeeds,
      'wishlistStickerBatches': wishlistStickerBatches,
      'ownedStickerBatches': ownedStickerBatches,
      'localAssignedPoints': localAssignedPoints,
      'benevolentPoints': benevolentPoints,
      'indicator': indicator,
      'presenceStatus': presenceStatus,
    };
  }

  UserAccount copyWith({
    int? id,
    String? email,
    String? masterEmail,
    String? realUsername,
    String? anonymousUsername,
    String? customUsername,
    String? amomimusId,
    String? gender,
    String? registrationDate,
    bool? isDemo,
    String? bio,
    String? bioExpirationDate,
    int? bioOriginalDuration,
    bool? hasUsedBioBailout,
    int? coins,
    int? reportedCount,
    String? lastRedeemed,
    int? dailyChatRequestsSent,
    String? lastChatRequestDate,
    String? dateOfBirth,
    int? totalResonatesReceived,
    List<String>? ownedStickers,
    List<String>? blockedUsers,
    List<String>? blockedBy,
    List<String>? exBlockedUsers,
    List<String>? hiddenFeeds,
    List<String>? wishlistStickerBatches,
    List<String>? ownedStickerBatches,
    Map<String, int>? localAssignedPoints,
    int? benevolentPoints,
    String? indicator,
    String? presenceStatus,
  }) {
    return UserAccount(
      id: id ?? this.id,
      email: email ?? this.email,
      masterEmail: masterEmail ?? this.masterEmail,
      realUsername: realUsername ?? this.realUsername,
      anonymousUsername: anonymousUsername ?? this.anonymousUsername,
      customUsername: customUsername ?? this.customUsername,
      amomimusId: amomimusId ?? this.amomimusId,
      gender: gender ?? this.gender,
      registrationDate: registrationDate ?? this.registrationDate,
      isDemo: isDemo ?? this.isDemo,
      bio: bio ?? this.bio,
      bioExpirationDate: bioExpirationDate ?? this.bioExpirationDate,
      bioOriginalDuration: bioOriginalDuration ?? this.bioOriginalDuration,
      hasUsedBioBailout: hasUsedBioBailout ?? this.hasUsedBioBailout,
      coins: coins ?? this.coins,
      reportedCount: reportedCount ?? this.reportedCount,
      lastRedeemed: lastRedeemed ?? this.lastRedeemed,
      dailyChatRequestsSent:
          dailyChatRequestsSent ?? this.dailyChatRequestsSent,
      lastChatRequestDate: lastChatRequestDate ?? this.lastChatRequestDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      totalResonatesReceived:
          totalResonatesReceived ?? this.totalResonatesReceived,
      ownedStickers: ownedStickers ?? this.ownedStickers,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      blockedBy: blockedBy ?? this.blockedBy,
      exBlockedUsers: exBlockedUsers ?? this.exBlockedUsers,
      hiddenFeeds: hiddenFeeds ?? this.hiddenFeeds,
      wishlistStickerBatches:
          wishlistStickerBatches ?? this.wishlistStickerBatches,
      ownedStickerBatches: ownedStickerBatches ?? this.ownedStickerBatches,
      localAssignedPoints: localAssignedPoints ?? this.localAssignedPoints,
      benevolentPoints: benevolentPoints ?? this.benevolentPoints,
      indicator: indicator ?? this.indicator,
      presenceStatus: presenceStatus ?? this.presenceStatus,
    );
  }

  /// A fallback empty [UserAccount] for UI contexts where no real user is available.
  static UserAccount empty() {
    return UserAccount(
      email: '',
      realUsername: '',
      anonymousUsername: '',
      amomimusId: '',
      gender: 'Amo',
      registrationDate: '',
      isDemo: false,
    );
  }
}
