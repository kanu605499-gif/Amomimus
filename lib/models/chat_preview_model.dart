import '../models/message_model.dart';

/// UI adapter model for the chat list screen.
///
/// Wraps a list of [ChatMessage]s and provides convenient getters
/// for the last message text, timestamp, and sync state.
class ChatPreview {
  final String name;
  final String username;
  final String initialLastMessage;
  final String initialTime;
  final bool isOnline;
  final List<ChatMessage> messages;
  final int unreadCount;
  final String? roomStartedAt;
  final String? roomExpiresAt;
  final bool hasSeenResetAnimation;
  final bool isResetIndicatorVisible;
  final String? cheatDetectedUserId;
  final List<ChatMessage> allMessages;
  final String targetPresence;

  ChatPreview({
    required this.name,
    required this.username,
    required this.initialLastMessage,
    required this.initialTime,
    this.isOnline = false,
    this.messages = const [],
    this.allMessages = const [],
    this.unreadCount = 0,
    this.roomStartedAt,
    this.roomExpiresAt,
    this.hasSeenResetAnimation = false,
    this.isResetIndicatorVisible = false,
    this.cheatDetectedUserId,
    this.targetPresence = 'auto',
  });

  String get lastMessage =>
      messages.isNotEmpty ? messages.last.text : initialLastMessage;
  String get time =>
      messages.isNotEmpty ? messages.last.timeStamp : initialTime;
  ChatMessage? get lastMessageObject =>
      messages.isNotEmpty ? messages.last : null;
}
