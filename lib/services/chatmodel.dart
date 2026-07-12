import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';
import '../models/chat_room_model.dart';
import '../models/chat_preview_model.dart';
import '../widgets/chat/delayed_sync_dialog.dart';
import '../helpers/notification_helper.dart';
import '../i18n/strings.g.dart';

import '../utils/utc_time_manager.dart';
import 'package:amomimus/utils/jelly_dialog.dart';
import 'audio_manager.dart';
import 'notification_manager.dart';
import '../models/notification_model.dart';

// Re-export so files that import chatmodel.dart still find ChatPreview
export '../models/chat_preview_model.dart';

class ChatModel extends ChangeNotifier {
  List<ChatSession> _sessions = [];
  String? _currentUserId;
  String? _currentUserName;
  StreamSubscription? _chatSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get currentUserId => _currentUserId;

  static const String _storageKey = 'amomimus_global_chats';

  ChatModel() {
    loadChats();
  }

  String _getCurrentTimeStr() {
    final now = DateTime.now();
    final hourVal = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return "$hourVal:${now.minute.toString().padLeft(2, '0')} $period";
  }

  void _checkExpirations() {
    bool changed = false;
    final now = UTCTimeManager.nowUTC();

    for (int i = 0; i < _sessions.length; i++) {
      final session = _sessions[i];
      if (session.roomExpiresAt != null) {
        final expireDate = DateTime.parse(session.roomExpiresAt!);
        if (now.isAfter(expireDate)) {
          // It's expired! We need to reset the chat.
          // Keep only pinned messages
          final remainingMessages = session.messages
              .where((m) => session.pinnedMessageIds.contains(m.id))
              .toList();

          // Only trigger a change if it actually had non-pinned messages or indicator wasn't visible for both
          final hasIndicatorForUser1 = session.resetIndicatorVisibleFor.contains(session.user1Id);
          final hasIndicatorForUser2 = session.resetIndicatorVisibleFor.contains(session.user2Id);
          if (session.messages.length != remainingMessages.length ||
              !hasIndicatorForUser1 ||
              !hasIndicatorForUser2) {
            _sessions[i] = ChatSession(
              id: session.id,
              user1Id: session.user1Id,
              user1Name: session.user1Name,
              user2Id: session.user2Id,
              user2Name: session.user2Name,
              messages: remainingMessages,
              unreadCounts: session.unreadCounts,
              pinnedMessageIds: session.pinnedMessageIds,
              createdAt: session.createdAt,
              roomStartedAt:
                  null, // Reset the timer, it will start again on next read
              roomExpiresAt: null,
              seenResetAnimationBy: const [], // Reset glitch seen status for both
              resetIndicatorVisibleFor: [session.user1Id, session.user2Id], // Show hidden text for both
              roomDeletedBy: const [],
              chatLogs: List<ChatLogEntry>.from(session.chatLogs)
                ..add(ChatLogEntry(
                  text: 'room_expired',
                  actorId: 'system',
                  timeStamp: _getCurrentTimeStr(),
                )),
            );
            changed = true;
            _updateSessionToFirestore(_sessions[i]);
          }
        }
      }
    }

    if (changed) {
      notifyListeners();
      _saveChats();
    }
  }

  List<String> _localAccountIds = [];

  void setLocalAccountIds(List<String> ids) {
    _localAccountIds = ids;
  }

  Future<void> _updateSessionToFirestore(ChatSession session) async {
    if (_localAccountIds.contains(session.user1Id) && _localAccountIds.contains(session.user2Id)) {
      print('Local Master-Sub Chat detected. Bypassing Firestore.');
      return;
    }

    try {
      await _firestore
          .collection('chat_sessions')
          .doc(session.id)
          .set(session.toMap());
    } catch (e) {
      print('Error syncing session to Firestore: $e');
    }
  }

  void _setupFirestoreListener() {
    _chatSubscription?.cancel();
    if (_currentUserId == null) return;
    _chatSubscription = _firestore
        .collection('chat_sessions')
        .where('participants', arrayContains: _currentUserId)
        .snapshots()
        .listen((snapshot) {
      final onlineSessions = snapshot.docs
          .map((doc) => ChatSession.fromMap(doc.data()))
          .where((s) => !(_localAccountIds.contains(s.user1Id) && _localAccountIds.contains(s.user2Id)))
          .toList();
          
      // Check for new chat messages
      if (_sessions.isNotEmpty) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.modified || change.type == DocumentChangeType.added) {
            final data = change.doc.data();
            if (data != null) {
              final updatedSession = ChatSession.fromMap(data);
              // Only notify if the last message is NOT from us, and we are not locally ignoring it
              if (updatedSession.messages.isNotEmpty) {
                final lastMsg = updatedSession.messages.last;
                if (lastMsg.senderId != _currentUserId && !lastMsg.isTyping) {
                  // Find if the local session had a different last message
                  final localSessionIdx = _sessions.indexWhere((s) => s.id == updatedSession.id);
                  bool isNewMessage = true;
                  if (localSessionIdx != -1) {
                    final localSession = _sessions[localSessionIdx];
                    if (localSession.messages.isNotEmpty && localSession.messages.last.id == lastMsg.id) {
                      isNewMessage = false; // We already saw this exact message
                    }
                  }
                  
                  if (isNewMessage) {
                    final senderText = lastMsg.senderName ?? 'Someone';
                    AudioManager().playChatNotif();
                    NotificationHelper.showRealtimeNotification(
                      title: '$senderText ${t.notif_chat}',
                      body: lastMsg.text,
                    );
                  }
                }
              }
            }
          }
        }
      }

      final localSessions = _sessions
          .where((s) => _localAccountIds.contains(s.user1Id) && _localAccountIds.contains(s.user2Id))
          .toList();

      final Map<String, ChatSession> merged = {};
      for (var s in localSessions) {
        merged[s.id] = s;
      }
      for (var s in onlineSessions) {
        merged[s.id] = s;
      }
      
      _sessions = merged.values.toList();
      _checkExpirations();
      _saveChats();
      notifyListeners();
    }, onError: (e) {
      print('Error listening to chat sessions: $e');
    });
  }

  Future<void> loadChats() async {
    final storage = const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    );
    final data = await storage.read(key: _storageKey);
    if (data != null && data.isNotEmpty) {
      try {
        final List decoded = jsonDecode(data);
        _sessions = decoded.map((e) => ChatSession.fromJson(e)).toList();
        _checkExpirations();
      } catch (e) {
        _sessions = [];
      }
    }
    notifyListeners();
  }

  Future<void> _saveChats() async {
    final storage = const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    );
    await storage.write(
      key: _storageKey,
      value: jsonEncode(_sessions.map((e) => e.toJson()).toList()),
    );
  }

  void setCurrentUser(String userId, [String? userName]) {
    bool changed = false;
    if (_currentUserId != userId) {
      _currentUserId = userId;
      changed = true;
      _setupFirestoreListener();
    }
    if (_currentUserName != userName) {
      _currentUserName = userName;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  String _getChatId(String id1, String id2) {
    final ids = [id1, id2];
    ids.sort();
    return ids.join('_');
  }

  List<ChatPreview> get chatList {
    if (_currentUserId == null) return [];

    // Deduplicate sessions by ID — prevents duplicate tiles when
    // Firestore snapshot and local cache both have the same session
    final Map<String, ChatSession> seenIds = {};
    for (final s in _sessions) {
      if (!seenIds.containsKey(s.id)) {
        seenIds[s.id] = s;
      } else if (s.messages.length > seenIds[s.id]!.messages.length) {
        seenIds[s.id] = s;
      }
    }

    final list = seenIds.values
        .where(
          (s) =>
              (s.user1Id == _currentUserId || s.user2Id == _currentUserId) &&
              !s.roomDeletedBy.contains(_currentUserId) &&
              (s.messages
                      .where((m) => !m.deletedBy.contains(_currentUserId))
                      .isNotEmpty ||
                  s.resetIndicatorVisibleFor.contains(_currentUserId) ||
                  (s.roomStartedAt != null &&
                      s.roomExpiresAt != null &&
                      !UTCTimeManager.nowUTC().isAfter(DateTime.tryParse(s.roomExpiresAt!) ?? DateTime.now()))),
        )
        .map((s) {
          final isUser1 = s.user1Id == _currentUserId;
          final targetId = isUser1 ? s.user2Id : s.user1Id;
          final targetName = isUser1 ? s.user2Name : s.user1Name;

          final hasSeenAnim = s.seenResetAnimationBy.contains(_currentUserId);
          final showIndicator = s.resetIndicatorVisibleFor.contains(_currentUserId);

          // If there's a cheat detection, we show a special warning
          String displayLastMsg = "";
          if (s.cheatDetectedUserId != null) {
            if (s.cheatDetectedUserId == _currentUserId) {
              displayLastMsg = "cheat_detected_warning";
            } else {
              displayLastMsg = "cheat_partner_warning";
            }
          } else if (showIndicator && !hasSeenAnim) {
            // Mask the real message if they haven't seen the reset animation yet
            displayLastMsg = "room_chat_resetted";
          } else if (showIndicator && s.messages.isEmpty) {
            displayLastMsg = "room_chat_resetted";
          }

          return ChatPreview(
            name: targetName,
            username: targetId,
            initialLastMessage: displayLastMsg,
            initialTime: "",
            isOnline: true,
            targetPresence: isUser1 ? s.user2Presence : s.user1Presence,
            messages: s.messages
                .where((m) => !m.deletedBy.contains(_currentUserId))
                .toList(),
            allMessages: s.messages,
            unreadCount: s.unreadCounts[_currentUserId!] ?? 0,
            roomStartedAt: s.roomStartedAt,
            roomExpiresAt: s.roomExpiresAt,
            hasSeenResetAnimation: hasSeenAnim,
            isResetIndicatorVisible: showIndicator,
            cheatDetectedUserId: s.cheatDetectedUserId,
          );
        })
        .toList();

    // Sort by latest message timestamp (descending)
    list.sort((a, b) {
      final timeA = a.messages.isNotEmpty
          ? (int.tryParse(a.messages.last.id?.split('_').first ?? '0') ?? 0)
          : 0;
      final timeB = b.messages.isNotEmpty
          ? (int.tryParse(b.messages.last.id?.split('_').first ?? '0') ?? 0)
          : 0;

      return timeB.compareTo(timeA);
    });

    return list;
  }

  bool hasUnreadMessages(List<String> blockedUsers, [List<String> blockedBy = const []]) {
    if (_currentUserId == null) return false;
    final visibleUsernames = chatList.map((c) => c.username).toSet();
    return _sessions.any((s) {
      if (s.user1Id != _currentUserId && s.user2Id != _currentUserId) {
        return false;
      }
      final targetId = s.user1Id == _currentUserId ? s.user2Id : s.user1Id;
      if (blockedUsers.contains(targetId)) return false;
      if (blockedBy.contains(targetId)) return false;
      if (!visibleUsernames.contains(targetId)) return false;
      return (s.unreadCounts[_currentUserId!] ?? 0) > 0;
    });
  }

  ChatPreview getChatByUsername(
    String targetUserId, {
    String targetName = "Unknown",
  }) {
    if (_currentUserId == null) {
      return ChatPreview(
        name: targetName,
        username: targetUserId,
        initialLastMessage: "",
        initialTime: "",
        isOnline: false,
        messages: [],
        unreadCount: 0,
      );
    }

    final chatId = _getChatId(_currentUserId!, targetUserId);
    var session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );

    if (session == null) {
      session = ChatSession(
        id: chatId,
        user1Id: _currentUserId!,
        user1Name: _currentUserName ?? _currentUserId!,
        user2Id: targetUserId,
        user2Name: targetName,
        messages: [],
        unreadCounts: {_currentUserId!: 0, targetUserId: 0},
        chatLogs: [
          ChatLogEntry(
            text: 'room_created',
            actorId: 'system',
            timeStamp: _getCurrentTimeStr(),
          )
        ],
      );
      _sessions.add(session);
      // Don't persist empty sessions — only save when a message is actually sent
    }

    final isUser1 = session.user1Id == _currentUserId;
    return ChatPreview(
      name: isUser1 ? session.user2Name : session.user1Name,
      username: targetUserId,
      initialLastMessage: "",
      initialTime: "",
      isOnline: true,
      messages: session.messages
          .where((m) => !m.deletedBy.contains(_currentUserId))
          .toList(),
      allMessages: session.messages,
      unreadCount: session.unreadCounts[_currentUserId!] ?? 0,
      roomStartedAt: session.roomStartedAt,
      roomExpiresAt: session.roomExpiresAt,
      hasSeenResetAnimation: session.seenResetAnimationBy.contains(_currentUserId),
      isResetIndicatorVisible: session.resetIndicatorVisibleFor.contains(_currentUserId),
      cheatDetectedUserId: session.cheatDetectedUserId,
    );
  }

  void sendMessage(
    String targetUserId,
    String text, {
    String? senderName,
    String? targetName,
    String? replyMessageId,
    BuildContext? context,
    String sourceType = 'chat',
  }) {
    if (_currentUserId == null) return;

    final chatId = _getChatId(_currentUserId!, targetUserId);
    var session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );

    if (session == null) {
      session = ChatSession(
        id: chatId,
        user1Id: _currentUserId!,
        user1Name: senderName ?? _currentUserName ?? _currentUserId!,
        user2Id: targetUserId,
        user2Name: targetName ?? targetUserId,
        messages: [],
        unreadCounts: {_currentUserId!: 0, targetUserId: 0},
        chatLogs: [
          ChatLogEntry(
            text: 'room_created',
            actorId: 'system',
            timeStamp: _getCurrentTimeStr(),
          )
        ],
      );
      _sessions.add(session);
    }

    if (_runCheatDetection(chatId)) {
      notifyListeners();
      _saveChats();
      return;
    }

    final now = DateTime.now();
    final hourVal = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final timeStr = "$hourVal:${now.minute.toString().padLeft(2, '0')} $period";

    final newMessage = ChatMessage(
      id: '${now.millisecondsSinceEpoch}_$_currentUserId',
      roomId: targetUserId,
      text: text,
      senderId: _currentUserId!,
      timeStamp: timeStr,
      senderName: senderName ?? _currentUserName ?? 'You',
      replyMessageId: replyMessageId,
      isSynced: false,
      isPendingSlow: false,
      showSuccess: false,
    );

    session.messages.add(newMessage);

    // Remove the reset indicator and show room again because a new message is sent
    final index = _sessions.indexWhere((s) => s.id == chatId);
    if (index != -1) {
      final updatedIndicators = List<String>.from(session.resetIndicatorVisibleFor)
        ..remove(_currentUserId);
      _sessions[index] = ChatSession(
        id: session.id,
        user1Id: session.user1Id,
        user1Name: session.user1Name,
        user2Id: session.user2Id,
        user2Name: session.user2Name,
        messages: session.messages,
        unreadCounts: session.unreadCounts,
        pinnedMessageIds: session.pinnedMessageIds,
        createdAt: session.createdAt,
        roomStartedAt: session.roomStartedAt,
        roomExpiresAt: session.roomExpiresAt,
        seenResetAnimationBy: session.seenResetAnimationBy,
        resetIndicatorVisibleFor: updatedIndicators,
        cheatDetectedUserId: session.cheatDetectedUserId,
        roomDeletedBy: const [], // Re-appear room for both users
        chatLogs: session.chatLogs,
      );
    }

    _saveChats();
    notifyListeners();

    // After 2 seconds, if still pending, mark as slow so UI shows "Message is pending..."
    Future.delayed(const Duration(seconds: 2), () {
      if (!newMessage.isSynced) {
        newMessage.isPendingSlow = true;
        notifyListeners();
      }
    });

    // Hybrid Sync Simulation
    _simulateSync(newMessage, context, sourceType);
  }

  void _simulateSync(
    ChatMessage message,
    BuildContext? context,
    String sourceType, {
    bool forceFail = false,
  }) async {
    bool dialogShown = false;
    bool dialogDismissed = false;

    // Timer for 7 seconds to show dialog if still pending
    Future.delayed(const Duration(seconds: 7), () {
      if (!message.isSynced &&
          !message.showResendOptions &&
          context != null &&
          context.mounted) {
        dialogShown = true;
        showJellyDialog(
          context: context,
          barrierDismissible: true,
          builder: (ctx) => DelayedSyncDialog(sourceType: sourceType),
        ).then((_) {
          // Track when dialog is dismissed
          dialogDismissed = true;
        });
      }
    });

    final bool willFail =
        forceFail || message.text.toLowerCase().contains('fail');

    if (!willFail) {
      if (_currentUserId == null || message.roomId == null) return;
      final chatId = _getChatId(_currentUserId!, message.roomId!);
      final sessionIndex = _sessions.indexWhere((s) => s.id == chatId);
      if (sessionIndex == -1) return;
      final session = _sessions[sessionIndex];

      try {
        // Eagerly increment unread count for target
        session.unreadCounts[message.roomId!] =
            (session.unreadCounts[message.roomId!] ?? 0) + 1;

        // Temporarily set isSynced = true so it is serialized correctly to Firestore
        message.isSynced = true;
        final writeFuture = _updateSessionToFirestore(session);
        // Restore isSynced = false so the UI continues to show the pending state (hourglass)
        message.isSynced = false;

        // Race Firestore write against a 9-second timeout
        await Future.any([
          writeFuture,
          Future.delayed(const Duration(seconds: 9),
              () => throw TimeoutException('Offline Sync Timeout')),
        ]);

        if (message.showResendOptions) return; // if already failed

        message.isSynced = true;

        if (message.isPendingSlow) {
          message.isPendingSlow = false;
          message.showSuccess = true;
          notifyListeners();

          // Revert success message after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            message.showSuccess = false;
            notifyListeners();
          });
        } else {
          notifyListeners();
        }

        // Only pop if dialog was shown AND hasn't already been dismissed
        if (dialogShown &&
            !dialogDismissed &&
            context != null &&
            context.mounted) {
          Navigator.of(context).pop();
        }

        // Trigger push notification for the chat message
        try {
          NotificationManager().addNotification(
            NotificationModel(
              targetUserId: message.roomId!,
              actorName: message.senderName ?? 'Someone',
              type: NotificationType.chat,
              feedId: session.id,
              message: message.text,
            ),
          );
        } catch (e) {
          print('Error triggering chat push notification: $e');
        }

        _saveChats();
      } catch (e) {
        if (!message.isSynced) {
          message.showResendOptions = true;
          notifyListeners();

          if (dialogShown &&
              !dialogDismissed &&
              context != null &&
              context.mounted) {
            Navigator.of(context).pop();
          }
          _saveChats();
        }
      }
    } else {
      // Hard fail limit: 9 seconds
      Future.delayed(const Duration(seconds: 9), () {
        if (!message.isSynced) {
          message.showResendOptions = true;
          notifyListeners();

          if (dialogShown &&
              !dialogDismissed &&
              context != null &&
              context.mounted) {
            Navigator.of(context).pop();
          }
          _saveChats();
        }
      });
    }
  }

  void deleteSelectedMessages(String targetUserId, List<String> messageIds) {
    if (_currentUserId == null) return;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return;

    // Remove pending messages completely, mark synced messages as deleted by current user
    final messagesToRemove = <ChatMessage>[];
    for (var msg in session.messages) {
      if (messageIds.contains(msg.id)) {
        if (!msg.isSynced) {
          // If not synced, remove entirely
          messagesToRemove.add(msg);
        } else {
          // If synced, mark as deleted by this user
          if (!msg.deletedBy.contains(_currentUserId!)) {
            msg.deletedBy = List.from(msg.deletedBy)..add(_currentUserId!);
          }
        }
      }
    }

    if (messagesToRemove.isNotEmpty) {
      session.messages.removeWhere((msg) => messagesToRemove.contains(msg));
    }

    _saveChats();
    notifyListeners();
    _updateSessionToFirestore(session);
  }

  void deleteChatForUser(String targetUserId) {
    if (_currentUserId == null) return;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final index = _sessions.indexWhere((s) => s.id == chatId);
    if (index == -1) return;

    final session = _sessions[index];
    
    // Keep only pinned messages (memories) and discard the rest
    final pinnedIds = session.pinnedMessageIds;
    final remainingMessages = session.messages
        .where((m) => pinnedIds.contains(m.id))
        .toList();

    // Mark the remaining pinned messages as deleted by both participants
    // so they are hidden from the main chat bubble feed for both
    for (var msg in remainingMessages) {
      if (!msg.deletedBy.contains(session.user1Id)) {
        msg.deletedBy = List.from(msg.deletedBy)..add(session.user1Id);
      }
      if (!msg.deletedBy.contains(session.user2Id)) {
        msg.deletedBy = List.from(msg.deletedBy)..add(session.user2Id);
      }
    }

    // Clear unread counts for current user
    final updatedUnread = Map<String, int>.from(session.unreadCounts);
    updatedUnread[_currentUserId!] = 0;

    // Remove current user from resetIndicatorVisibleFor
    final updatedIndicators = List<String>.from(session.resetIndicatorVisibleFor)
      ..remove(_currentUserId);

    _sessions[index] = ChatSession(
      id: session.id,
      user1Id: session.user1Id,
      user1Name: session.user1Name,
      user2Id: session.user2Id,
      user2Name: session.user2Name,
      messages: remainingMessages,
      unreadCounts: updatedUnread,
      pinnedMessageIds: session.pinnedMessageIds,
      createdAt: session.createdAt,
      roomStartedAt: session.roomStartedAt,
      roomExpiresAt: session.roomExpiresAt,
      seenResetAnimationBy: session.seenResetAnimationBy,
      resetIndicatorVisibleFor: updatedIndicators,
      cheatDetectedUserId: session.cheatDetectedUserId,
      roomDeletedBy: [session.user1Id, session.user2Id], // Divorced: hide room for both users
      chatLogs: List<ChatLogEntry>.from(session.chatLogs)
        ..add(ChatLogEntry(
          text: 'delete_room',
          actorId: _currentUserId!,
          timeStamp: _getCurrentTimeStr(),
        )),
    );

    _saveChats();
    notifyListeners();
    _updateSessionToFirestore(_sessions[index]);
  }

  Future<void> resendSelectedMessages(
    String targetUserId,
    List<String> messageIds,
    BuildContext? context,
  ) async {
    if (_currentUserId == null) return;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return;

    // Process sequentially as per user request
    int orderIndex = 1;
    for (final msgId in messageIds) {
      final msgIndex = session.messages.indexWhere((m) => m.id == msgId);
      if (msgIndex != -1) {
        final message = session.messages[msgIndex];

        if (!message.isSynced) {
          // Reset UI state
          message.showResendOptions = false;
          message.isPendingSlow = false;
          message.showSuccess = false;
          message.sendOrder = orderIndex++;

          final now = DateTime.now();
          final hourVal = now.hour % 12 == 0 ? 12 : now.hour % 12;
          final period = now.hour >= 12 ? 'PM' : 'AM';
          message.timeStamp =
              "$hourVal:${now.minute.toString().padLeft(2, '0')} $period"; // Update timestamp to now

          // Move the message to the end of the list since it's the newest now
          session.messages.removeAt(msgIndex);
          session.messages.add(message);

          notifyListeners();

          // Add 2 second delay for slow pending
          Future.delayed(const Duration(seconds: 2), () {
            if (!message.isSynced && !message.showResendOptions) {
              message.isPendingSlow = true;
              notifyListeners();
            }
          });

          // Wait 3 seconds to simulate sequential processing logic requested by user
          await Future.delayed(const Duration(seconds: 3));

          // Re-trigger sync simulation
          _simulateSync(message, context, 'chat');
        }
      }
    }
  }

  void markAsRead(String targetUserId) {
    if (_currentUserId == null) return;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final index = _sessions.indexWhere((s) => s.id == chatId);
    if (index == -1) return;

    final session = _sessions[index];
    bool changed = false;
    Map<String, int> updatedUnread = session.unreadCounts;

    // Clear unread counts
    if ((session.unreadCounts[_currentUserId!] ?? 0) > 0) {
      updatedUnread = Map<String, int>.from(session.unreadCounts);
      updatedUnread[_currentUserId!] = 0;
      changed = true;
    }

    final hasDeleted = session.roomDeletedBy.contains(_currentUserId!);
    bool isLocalChat = _localAccountIds.contains(session.user1Id) && _localAccountIds.contains(session.user2Id);
    
    bool shouldStartTimer = session.roomStartedAt == null &&
        session.messages.any((m) => m.senderId != _currentUserId);

    if (isLocalChat) {
      shouldStartTimer = shouldStartTimer && session.messages.length >= 500;
    }

    if (changed || shouldStartTimer || hasDeleted) {
      final nowUtc = UTCTimeManager.nowUTC();
      final expireUtc = UTCTimeManager.calculateExpirationDate(nowUtc);
      final updatedRoomDeletedBy = List<String>.from(session.roomDeletedBy)
        ..remove(_currentUserId!);

      _sessions[index] = ChatSession(
        id: session.id,
        user1Id: session.user1Id,
        user1Name: session.user1Name,
        user2Id: session.user2Id,
        user2Name: session.user2Name,
        messages: session.messages,
        unreadCounts: updatedUnread,
        pinnedMessageIds: session.pinnedMessageIds,
        createdAt: session.createdAt,
        roomStartedAt: shouldStartTimer ? nowUtc.toIso8601String() : session.roomStartedAt,
        roomExpiresAt: shouldStartTimer ? expireUtc.toIso8601String() : session.roomExpiresAt,
        seenResetAnimationBy: session.seenResetAnimationBy,
        resetIndicatorVisibleFor: session.resetIndicatorVisibleFor,
        cheatDetectedUserId: session.cheatDetectedUserId,
        roomDeletedBy: updatedRoomDeletedBy,
        chatLogs: session.chatLogs,
      );
      changed = true;
    }

    // Anti-cheat verification on read
    if (_runCheatDetection(chatId)) {
      changed = true;
    }

    if (changed) {
      notifyListeners();
      _saveChats();
      _updateSessionToFirestore(_sessions[index]);
    }
  }

  /// Mark animation as seen
  void markResetAnimationSeen(String targetUserId) {
    if (_currentUserId == null) return;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final index = _sessions.indexWhere((s) => s.id == chatId);

    if (index != -1) {
      final session = _sessions[index];
      if (!session.seenResetAnimationBy.contains(_currentUserId!)) {
        final updatedSeen = List<String>.from(session.seenResetAnimationBy)
          ..add(_currentUserId!);
        _sessions[index] = ChatSession(
          id: session.id,
          user1Id: session.user1Id,
          user1Name: session.user1Name,
          user2Id: session.user2Id,
          user2Name: session.user2Name,
          messages: session.messages,
          unreadCounts: session.unreadCounts,
          pinnedMessageIds: session.pinnedMessageIds,
          createdAt: session.createdAt,
          roomStartedAt: session.roomStartedAt,
          roomExpiresAt: session.roomExpiresAt,
          seenResetAnimationBy: updatedSeen,
          resetIndicatorVisibleFor: session.resetIndicatorVisibleFor,
          cheatDetectedUserId: session.cheatDetectedUserId,
          roomDeletedBy: session.roomDeletedBy,
          chatLogs: session.chatLogs,
        );
        notifyListeners();
        _saveChats();
        _updateSessionToFirestore(_sessions[index]);
      }
    }
  }

  void deleteChat(String targetUserId) {
    if (_currentUserId == null) return;

    final chatId = _getChatId(_currentUserId!, targetUserId);
    final index = _sessions.indexWhere((s) => s.id == chatId);
    if (index == -1) return;

    final session = _sessions[index];
    final isLocalChat = _localAccountIds.contains(session.user1Id) && _localAccountIds.contains(session.user2Id);
    
    if (isLocalChat) {
      _sessions.removeAt(index);
      _saveChats();
      notifyListeners();
      return;
    }

    final updatedRoomDeletedBy = List<String>.from(session.roomDeletedBy)..add(_currentUserId!);

    _sessions[index] = ChatSession(
      id: session.id,
      user1Id: session.user1Id,
      user1Name: session.user1Name,
      user2Id: session.user2Id,
      user2Name: session.user2Name,
      messages: session.messages,
      unreadCounts: session.unreadCounts,
      pinnedMessageIds: session.pinnedMessageIds,
      createdAt: session.createdAt,
      roomStartedAt: session.roomStartedAt,
      roomExpiresAt: session.roomExpiresAt,
      seenResetAnimationBy: session.seenResetAnimationBy,
      resetIndicatorVisibleFor: session.resetIndicatorVisibleFor,
      cheatDetectedUserId: session.cheatDetectedUserId,
      roomDeletedBy: updatedRoomDeletedBy,
      chatLogs: session.chatLogs,
    );

    notifyListeners();
    _saveChats();
    
    if (!isLocalChat) {
      _firestore.collection('chat_sessions').doc(chatId).delete();
    }
  }

  void clearAllChatsForUser(String userId) {
    final chatsToDelete = _sessions.where((s) => s.user1Id == userId || s.user2Id == userId).toList();
    for (var s in chatsToDelete) {
      final isLocalChat = _localAccountIds.contains(s.user1Id) && _localAccountIds.contains(s.user2Id);
      if (!isLocalChat) {
        _firestore.collection('chat_sessions').doc(s.id).delete();
      }
    }
    _sessions.removeWhere((s) => s.user1Id == userId || s.user2Id == userId);
    notifyListeners();
    _saveChats();
  }

  // ── Memories (Pinned Messages) ────────────────────────

  bool isPinned(String targetUserId, String messageId) {
    if (_currentUserId == null) return false;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return false;
    return session.pinnedMessageIds.contains(messageId);
  }

  bool pinMessage(String targetUserId, String messageId) {
    if (_currentUserId == null) return false;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return false;

    if (session.pinnedMessageIds.length >= 9) {
      return false; // Limit reached
    }

    if (!session.pinnedMessageIds.contains(messageId)) {
      // We need to reassign since the list might be unmodifiable if it's the default const []
      final updatedPins = List<String>.from(session.pinnedMessageIds);
      updatedPins.add(messageId);

      // Update session with new pins
      final index = _sessions.indexWhere((s) => s.id == chatId);
      if (index != -1) {
        // ChatSession is immutable, so we must recreate or we need to change it
        // Wait, looking at chatmodel.dart, session.messages.add() was used, so it's not immutable in practice or it is?
        // Wait, in chatmodel.dart lines 177: session.messages.add(...)
        // Let's modify ChatSession to have non-final pinnedMessageIds, OR we replace the session.
        // Actually, we can just replace the session in the list.
        _sessions[index] = ChatSession(
          id: session.id,
          user1Id: session.user1Id,
          user1Name: session.user1Name,
          user2Id: session.user2Id,
          user2Name: session.user2Name,
          messages: session.messages,
          unreadCounts: session.unreadCounts,
          pinnedMessageIds: updatedPins,
          createdAt: session.createdAt,
          roomStartedAt: session.roomStartedAt,
          roomExpiresAt: session.roomExpiresAt,
          seenResetAnimationBy: session.seenResetAnimationBy,
          resetIndicatorVisibleFor: session.resetIndicatorVisibleFor,
          cheatDetectedUserId: session.cheatDetectedUserId,
          roomDeletedBy: session.roomDeletedBy,
          chatLogs: List<ChatLogEntry>.from(session.chatLogs)
            ..add(ChatLogEntry(
              text: 'pin',
              actorId: _currentUserId!,
              timeStamp: _getCurrentTimeStr(),
            )),
        );
        notifyListeners();
        _saveChats();
        _updateSessionToFirestore(_sessions[index]);
        return true;
      }
    }
    return false;
  }

  void unpinMessage(String targetUserId, String messageId) {
    if (_currentUserId == null) return;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return;

    if (session.pinnedMessageIds.contains(messageId)) {
      final updatedPins = List<String>.from(session.pinnedMessageIds)
        ..remove(messageId);
      final index = _sessions.indexWhere((s) => s.id == chatId);
      if (index != -1) {
        _sessions[index] = ChatSession(
          id: session.id,
          user1Id: session.user1Id,
          user1Name: session.user1Name,
          user2Id: session.user2Id,
          user2Name: session.user2Name,
          messages: session.messages,
          unreadCounts: session.unreadCounts,
          pinnedMessageIds: updatedPins,
          createdAt: session.createdAt,
          roomStartedAt: session.roomStartedAt,
          roomExpiresAt: session.roomExpiresAt,
          seenResetAnimationBy: session.seenResetAnimationBy,
          resetIndicatorVisibleFor: session.resetIndicatorVisibleFor,
          cheatDetectedUserId: session.cheatDetectedUserId,
          roomDeletedBy: session.roomDeletedBy,
          chatLogs: List<ChatLogEntry>.from(session.chatLogs)
            ..add(ChatLogEntry(
              text: 'unpin',
              actorId: _currentUserId!,
              timeStamp: _getCurrentTimeStr(),
            )),
        );
        notifyListeners();
        _saveChats();
        _updateSessionToFirestore(_sessions[index]);
      }
    }
  }

  List<ChatMessage> getPinnedMessages(String targetUserId) {
    if (_currentUserId == null) return [];
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return [];

    return session.messages
        .where((m) => session.pinnedMessageIds.contains(m.id))
        .toList();
  }

  /// Meminta penghapusan memori. Ini akan langsung menyinkronkan antar klien.
  void deleteMemory(String targetUserId, String messageId) {
    if (_currentUserId == null) return;
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final index = _sessions.indexWhere((s) => s.id == chatId);
    if (index != -1) {
      final session = _sessions[index];
      if (session.pinnedMessageIds.contains(messageId)) {
        final updatedPins = List<String>.from(session.pinnedMessageIds)
          ..remove(messageId);

        _sessions[index] = ChatSession(
          id: session.id,
          user1Id: session.user1Id,
          user1Name: session.user1Name,
          user2Id: session.user2Id,
          user2Name: session.user2Name,
          messages: session.messages,
          unreadCounts: session.unreadCounts,
          pinnedMessageIds: updatedPins,
          createdAt: session.createdAt,
          roomStartedAt: session.roomStartedAt,
          roomExpiresAt: session.roomExpiresAt,
          seenResetAnimationBy: session.seenResetAnimationBy,
          resetIndicatorVisibleFor: session.resetIndicatorVisibleFor,
          cheatDetectedUserId: session.cheatDetectedUserId,
          roomDeletedBy: session.roomDeletedBy,
          chatLogs: List<ChatLogEntry>.from(session.chatLogs)
            ..add(ChatLogEntry(
              text: 'erase',
              actorId: _currentUserId!,
              timeStamp: _getCurrentTimeStr(),
            )),
        );
        notifyListeners();
        _saveChats();
        _updateSessionToFirestore(_sessions[index]);
      }
    }
  }

  /// Performs a double verification API simulation and checks for manually altered device time.
  bool _runCheatDetection(String chatId) {
    if (_currentUserId == null) return false;
    final index = _sessions.indexWhere((s) => s.id == chatId);
    if (index == -1) return false;

    final session = _sessions[index];
    if (session.messages.isEmpty) return false;

    // Check 1: Time manipulation check
    // If the device's UTC time is strangely earlier than the latest message's timestamp
    // (We assume a tolerance of 1 hour for minor sync issues)
    final latestMsg = session.messages.last;
    final latestTime = DateTime.tryParse(latestMsg.timeStamp) ?? DateTime(2000);
    final nowUtc = UTCTimeManager.nowUTC();

    bool cheatDetected = false;
    if (latestTime.difference(nowUtc).inHours > 1) {
      cheatDetected = true;
    }

    // Check 2: Server Verification Check (Simulated)
    // If we have a roomExpiresAt, and our current server time (mocked as nowUtc) is past the expiry
    if (!cheatDetected && session.roomExpiresAt != null) {
      final expiryTime =
          DateTime.tryParse(session.roomExpiresAt!) ?? DateTime(2000);
      if (nowUtc.isAfter(expiryTime)) {
        // Force destruction if not already marked
        // Force destruction if not already marked for either user
        final hasIndicatorForUser1 = session.resetIndicatorVisibleFor.contains(session.user1Id);
        final hasIndicatorForUser2 = session.resetIndicatorVisibleFor.contains(session.user2Id);
        if (!hasIndicatorForUser1 || !hasIndicatorForUser2) {
          final remainingMessages = session.messages
              .where((m) => session.pinnedMessageIds.contains(m.id))
              .toList();
          _sessions[index] = ChatSession(
            id: session.id,
            user1Id: session.user1Id,
            user1Name: session.user1Name,
            user2Id: session.user2Id,
            user2Name: session.user2Name,
            messages: remainingMessages, // keep pinned messages only
            unreadCounts: session.unreadCounts,
            pinnedMessageIds: session.pinnedMessageIds,
            createdAt: session.createdAt,
            roomStartedAt: session.roomStartedAt,
            roomExpiresAt: session.roomExpiresAt,
            seenResetAnimationBy: const [], // Reset glitch seen status for both
            resetIndicatorVisibleFor: [session.user1Id, session.user2Id], // Show hidden text for both
            cheatDetectedUserId: session.cheatDetectedUserId,
            roomDeletedBy: const [],
            chatLogs: session.chatLogs,
          );
          return true;
        }
      }
    }

    if (cheatDetected && session.cheatDetectedUserId == null) {
      // Execute the "Clean Up Job" forced destruction
      final remainingMessages = session.messages
          .where((m) => session.pinnedMessageIds.contains(m.id))
          .toList();
      _sessions[index] = ChatSession(
        id: session.id,
        user1Id: session.user1Id,
        user1Name: session.user1Name,
        user2Id: session.user2Id,
        user2Name: session.user2Name,
        messages: remainingMessages, // keep pinned messages only
        unreadCounts: session.unreadCounts,
        pinnedMessageIds: session.pinnedMessageIds,
        createdAt: session.createdAt,
        roomStartedAt: session.roomStartedAt,
        roomExpiresAt: session.roomExpiresAt,
        seenResetAnimationBy: const [], // Reset glitch seen status for both
        resetIndicatorVisibleFor: [session.user1Id, session.user2Id], // Show hidden text for both
        cheatDetectedUserId: _currentUserId, // we mark the cheater
        roomDeletedBy: const [],
        chatLogs: session.chatLogs,
      );
      return true;
    }

    return false;
  }

  /// Wipes a room due to a block event, keeping only pinned messages, and triggers red glitch.
  void wipeRoomDueToBlock(String targetAmomimusId) {
    if (_currentUserId == null) return;

    final chatId = _getChatId(_currentUserId!, targetAmomimusId);
    final index = _sessions.indexWhere((s) => s.id == chatId);
    if (index == -1) return;

    final session = _sessions[index];
    final remainingMessages = session.messages
        .where((m) => session.pinnedMessageIds.contains(m.id))
        .toList();

    _sessions[index] = ChatSession(
      id: session.id,
      user1Id: session.user1Id,
      user1Name: session.user1Name,
      user2Id: session.user2Id,
      user2Name: session.user2Name,
      messages: remainingMessages,
      unreadCounts: session.unreadCounts,
      pinnedMessageIds: session.pinnedMessageIds,
      createdAt: session.createdAt,
      roomStartedAt: session.roomStartedAt,
      roomExpiresAt: session.roomExpiresAt,
      seenResetAnimationBy: const [], // Neither has seen the new block glitch yet
      resetIndicatorVisibleFor: [session.user1Id, session.user2Id], // Indicator is visible for both so blocked user can see it
      cheatDetectedUserId: "BLOCKED_RED", // Special flag for Red Glitch
      roomDeletedBy: const [],
      chatLogs: session.chatLogs,
    );
    notifyListeners();
    _saveChats();
  }

  List<ChatLogEntry> getChatLogs(String targetUserId) {
    if (_currentUserId == null) return [];
    final chatId = _getChatId(_currentUserId!, targetUserId);
    final session = _sessions.cast<ChatSession?>().firstWhere(
      (s) => s?.id == chatId,
      orElse: () => null,
    );
    if (session == null) return [];
    return session.chatLogs;
  }
  Future<void> updatePresenceInSessions(String userId, String newStatus) async {
    if (_currentUserId == null || _currentUserId != userId) return;

    final batch = FirebaseFirestore.instance.batch();
    bool hasUpdates = false;

    for (int i = 0; i < _sessions.length; i++) {
      final session = _sessions[i];
      if (session.user1Id == userId || session.user2Id == userId) {
        // Update local session
        final isUser1 = session.user1Id == userId;
        _sessions[i] = ChatSession(
          id: session.id,
          user1Id: session.user1Id,
          user1Name: session.user1Name,
          user2Id: session.user2Id,
          user2Name: session.user2Name,
          user1Presence: isUser1 ? newStatus : session.user1Presence,
          user2Presence: isUser1 ? session.user2Presence : newStatus,
          messages: session.messages,
          unreadCounts: session.unreadCounts,
          pinnedMessageIds: session.pinnedMessageIds,
          createdAt: session.createdAt,
          roomStartedAt: session.roomStartedAt,
          roomExpiresAt: session.roomExpiresAt,
          seenResetAnimationBy: session.seenResetAnimationBy,
          resetIndicatorVisibleFor: session.resetIndicatorVisibleFor,
          cheatDetectedUserId: session.cheatDetectedUserId,
          roomDeletedBy: session.roomDeletedBy,
          chatLogs: session.chatLogs,
        );

        // Prepare Firestore update
        final docRef = FirebaseFirestore.instance.collection('chat_sessions').doc(session.id);
        batch.update(docRef, {
          isUser1 ? 'user1Presence' : 'user2Presence': newStatus,
        });
        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      notifyListeners();
      _saveChats();
      try {
        await batch.commit();
      } catch (e) {
        print("Failed to sync presence batch to Firestore: \$e");
      }
    }
  }
}
