/// Chat message model for the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class ChatMessage {
  final String? id;
  final String? roomId;
  final String text;
  final String senderId;
  String timeStamp;
  final bool isTyping;
  final String? senderName;
  final String? replyMessageId;
  final String? createdAt;
  bool isSynced;
  bool isPendingSlow;
  bool showSuccess;
  bool showResendOptions;
  List<String> deletedBy;
  int? sendOrder;

  ChatMessage({
    this.id,
    this.roomId,
    required this.text,
    required this.senderId,
    required this.timeStamp,
    this.isTyping = false,
    this.senderName,
    this.replyMessageId,
    this.createdAt,
    this.isSynced = true,
    this.isPendingSlow = false,
    this.showSuccess = false,
    this.showResendOptions = false,
    this.deletedBy = const [],
    this.sendOrder,
  });

  /// Firestore-ready: converts this [ChatMessage] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'text': text,
      'senderId': senderId,
      'timeStamp': timeStamp,
      'senderName': senderName,
      'replyMessageId': replyMessageId,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
      'isSynced': isSynced,
      'isPendingSlow': isPendingSlow,
      'showSuccess': showSuccess,
      'showResendOptions': showResendOptions,
      'deletedBy': deletedBy,
      'sendOrder': sendOrder,
    };
  }

  /// Firestore-ready: creates a [ChatMessage] from a [Map].
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      roomId: map['roomId'],
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
      isTyping: map['isTyping'] ?? false,
      senderName: map['senderName'],
      replyMessageId: map['replyMessageId'],
      createdAt: map['createdAt'],
      isSynced: map['isSynced'] ?? true,
      isPendingSlow: map['isPendingSlow'] ?? false,
      showSuccess: map['showSuccess'] ?? false,
      showResendOptions: map['showResendOptions'] ?? false,
      deletedBy: List<String>.from(map['deletedBy'] ?? []),
      sendOrder: map['sendOrder'],
    );
  }

  /// Backward-compatible JSON aliases.
  Map<String, dynamic> toJson() => toMap();
  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      ChatMessage.fromMap(json);
}
