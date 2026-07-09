import 'message_model.dart';

/// Chat room (session) model for the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class ChatSession {
  final String id;
  final String user1Id;
  final String user1Name;
  final String user2Id;
  final String user2Name;
  final String user1Presence;
  final String user2Presence;
  final List<ChatMessage> messages;
  final Map<String, int> unreadCounts;
  final List<String> pinnedMessageIds; // Memories — max 9
  final String? createdAt;
  final String? roomStartedAt;
  final String? roomExpiresAt;
  final List<String> seenResetAnimationBy;
  final List<String> resetIndicatorVisibleFor;
  final String? cheatDetectedUserId;
  final List<String> roomDeletedBy;
  final List<ChatLogEntry> chatLogs;

  /// Convenience getter: returns participant IDs as a list.
  List<String> get participants => [user1Id, user2Id];

  ChatSession({
    required this.id,
    required this.user1Id,
    required this.user1Name,
    required this.user2Id,
    required this.user2Name,
    this.user1Presence = 'auto',
    this.user2Presence = 'auto',
    required this.messages,
    required this.unreadCounts,
    this.pinnedMessageIds = const [],
    this.createdAt,
    this.roomStartedAt,
    this.roomExpiresAt,
    this.seenResetAnimationBy = const [],
    this.resetIndicatorVisibleFor = const [],
    this.cheatDetectedUserId,
    this.roomDeletedBy = const [],
    this.chatLogs = const [],
  });

  /// Firestore-ready: converts this [ChatSession] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user1Name': user1Name,
      'user2Id': user2Id,
      'user2Name': user2Name,
      'user1Presence': user1Presence,
      'user2Presence': user2Presence,
      'participants': participants,
      'messages': messages.map((m) => m.toMap()).toList(),
      'unreadCounts': unreadCounts,
      'pinnedMessageIds': pinnedMessageIds,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
      'roomStartedAt': roomStartedAt,
      'roomExpiresAt': roomExpiresAt,
      'seenResetAnimationBy': seenResetAnimationBy,
      'resetIndicatorVisibleFor': resetIndicatorVisibleFor,
      'cheatDetectedUserId': cheatDetectedUserId,
      'roomDeletedBy': roomDeletedBy,
      'chatLogs': chatLogs.map((l) => l.toMap()).toList(),
    };
  }

  /// Firestore-ready: creates a [ChatSession] from a [Map].
  factory ChatSession.fromMap(Map<String, dynamic> map) {
    return ChatSession(
      id: map['id'],
      user1Id: map['user1Id'],
      user1Name: map['user1Name'],
      user2Id: map['user2Id'],
      user2Name: map['user2Name'],
      user1Presence: map['user1Presence'] ?? 'auto',
      user2Presence: map['user2Presence'] ?? 'auto',
      messages: (map['messages'] as List)
          .map((m) => ChatMessage.fromMap(m))
          .toList(),
      unreadCounts: Map<String, int>.from(map['unreadCounts']),
      pinnedMessageIds:
          (map['pinnedMessageIds'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: map['createdAt'],
      roomStartedAt: map['roomStartedAt'],
      roomExpiresAt: map['roomExpiresAt'],
      seenResetAnimationBy:
          (map['seenResetAnimationBy'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          (map['hasSeenResetAnimation'] == 1 || map['hasSeenResetAnimation'] == true
              ? [map['user1Id'] as String, map['user2Id'] as String]
              : []),
      resetIndicatorVisibleFor:
          (map['resetIndicatorVisibleFor'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          (map['isResetIndicatorVisible'] == 1 || map['isResetIndicatorVisible'] == true
              ? [map['user1Id'] as String, map['user2Id'] as String]
              : []),
      cheatDetectedUserId: map['cheatDetectedUserId'],
      roomDeletedBy:
          (map['roomDeletedBy'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      chatLogs: (map['chatLogs'] as List?)
          ?.map((e) => ChatLogEntry.fromMap(Map<String, dynamic>.from(e)))
          .toList() ??
          [],
    );
  }

  /// Backward-compatible JSON aliases.
  Map<String, dynamic> toJson() => toMap();
  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      ChatSession.fromMap(json);
}

/// Structured chat log entry class
class ChatLogEntry {
  final String text; // e.g. 'room_created', 'pin', 'unpin', 'erase', 'delete_room', 'room_expired'
  final String actorId; // ID of the user performing the action, or 'system'
  final String timeStamp; // Localized/device formatted time

  ChatLogEntry({
    required this.text,
    required this.actorId,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'actorId': actorId,
      'timeStamp': timeStamp,
    };
  }

  factory ChatLogEntry.fromMap(Map<String, dynamic> map) {
    return ChatLogEntry(
      text: map['text'] ?? '',
      actorId: map['actorId'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
    );
  }
}
