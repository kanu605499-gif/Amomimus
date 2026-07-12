import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../helpers/notification_helper.dart';
import '../i18n/strings.g.dart';
import 'audio_manager.dart';

class NotificationManager extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _currentUserId;
  StreamSubscription? _notifSubscription;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  static const String _notificationsKey = 'amomimus_app_notifications';

  NotificationManager();

  void setCurrentUser(String userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      _setupFirestoreListener();
    }
  }

  void _setupFirestoreListener() {
    _notifSubscription?.cancel();
    if (_currentUserId == null) return;

    _notifSubscription = _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('notifications')
        .snapshots()
        .listen((snapshot) {
      
      // Check for new notifications to play sound and show banner
      bool hasNewUnread = false;
      NotificationModel? latestNewNotif;
      
      // We only care if it's not the initial load. If _notifications is empty, it's likely initial load.
      if (_notifications.isNotEmpty) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data();
            if (data != null) {
              final notif = NotificationModel.fromMap(data);
              if (!notif.isRead) {
                hasNewUnread = true;
                latestNewNotif = notif;
              }
            }
          }
        }
      }

      _notifications = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data()))
          .toList();

      _notifications.sort((a, b) =>
          DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
          
      _saveNotifications(); // Backup to local cache
      notifyListeners();
      
      if (hasNewUnread && latestNewNotif != null) {
        AudioManager().playNotifAlert();
        NotificationHelper.showRealtimeNotification(
          title: t.amow_summary_title,
          body: latestNewNotif.message,
        );
      }
    }, onError: (e) {
      print('Error listening to notifications: $e');
    });
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    final storage = const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    );
    final String? data = await storage.read(key: _notificationsKey);

    if (data != null && data.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        _notifications = decoded
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } catch (e) {
        print('Error decoding notifications: $e');
        _notifications = [];
      }
    } else {
      _notifications = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    final storage = const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    );
    await storage.write(
      key: _notificationsKey,
      value: jsonEncode(_notifications.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> addNotification(NotificationModel notification) async {
    // Send to Firestore directly. The listener on the target device will pick it up.
    // If we are sending it to ourselves, our own listener will pick it up.
    try {
      await _firestore
          .collection('users')
          .doc(notification.targetUserId)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toMap());
          
      // Trigger Vercel Push Notification API
      await _triggerPushNotification(notification);
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  Future<void> _triggerPushNotification(NotificationModel notification) async {
    try {
      // 1. Get Target User's FCM Token
      final targetUserDoc = await _firestore.collection('users').doc(notification.targetUserId).get();
      if (!targetUserDoc.exists) return;
      
      final targetUserData = targetUserDoc.data() as Map<String, dynamic>;
      final targetFcmToken = targetUserData['fcmToken'];
      final targetLanguage = targetUserData['language'] ?? 'en';
      
      if (targetFcmToken == null || targetFcmToken.isEmpty) return;

      // Do not send push notifications for block/unblock events
      if (notification.type == NotificationType.blocked || 
          notification.type == NotificationType.unblocked) {
        return;
      }

      // Translate dynamically to target user's language
      final targetLocale = AppLocaleUtils.parse(targetLanguage);
      final tTarget = await targetLocale.build();
      
      String translatedBody = notification.message; // Fallback
      switch (notification.type) {
        case NotificationType.resonate:
          translatedBody = '${notification.actorName} ${tTarget.notif_resonate}';
          break;
        case NotificationType.comment:
          translatedBody = '${notification.actorName} ${tTarget.notif_comment}';
          break;
        case NotificationType.reply:
          translatedBody = '${notification.actorName} ${tTarget.notif_reply}';
          break;
        case NotificationType.chat:
          translatedBody = '${notification.actorName} ${tTarget.notif_chat}';
          break;
        case NotificationType.chatRequest:
          translatedBody = '${notification.actorName} ${tTarget.notif_chat_request}';
          break;
        case NotificationType.bioExpiry:
          translatedBody = tTarget.notif_bio_expiry;
          break;
        default:
          break;
      }

      // 2. Prepare payload
      // Provide your actual Vercel endpoint URL and Secret Key here
      const String vercelEndpoint = 'https://amomimus-api.vercel.app/api/sendNotification';
      const String apiSecretKey = 'YOUR_SUPER_SECRET_API_KEY_HERE';

      final payload = {
        'fcmToken': targetFcmToken,
        'title': 'Amomimus',
        'body': translatedBody,
        'data': {
          'type': notification.type.name,
          'feedId': notification.feedId,
        }
      };

      // 3. Send HTTP POST
      final response = await http.post(
        Uri.parse(vercelEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiSecretKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        print('FCM API Error: ${response.body}');
      }
    } catch (e) {
      print('Error triggering push notification: $e');
    }
  }

  List<NotificationModel> getNotificationsForUser(String userId) {
    // We already filter via Firestore query, but this keeps the exact same public API structure
    return _notifications.where((n) => n.targetUserId == userId).toList()..sort(
      (a, b) =>
          DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)),
    );
  }

  int getUnreadCountForUser(String userId) {
    return _notifications
        .where((n) => n.targetUserId == userId && !n.isRead)
        .length;
  }

  Future<void> markAllAsReadForUser(String userId) async {
    if (_currentUserId == null) return;
    bool hasChanges = false;
    
    // Batch update to Firestore for efficiency
    final batch = _firestore.batch();
    
    for (var n in _notifications) {
      if (n.targetUserId == userId && !n.isRead) {
        n.isRead = true;
        hasChanges = true;
        final docRef = _firestore
            .collection('users')
            .doc(_currentUserId)
            .collection('notifications')
            .doc(n.id);
        batch.update(docRef, {'isRead': true});
      }
    }
    
    if (hasChanges) {
      notifyListeners();
      _saveNotifications(); // Local cache update
      try {
        await batch.commit();
      } catch (e) {
        print('Error marking notifications as read: $e');
      }
    }
  }

  Future<void> clearAll() async {
    final storage = const flutter_secure_storage.FlutterSecureStorage(
      aOptions: flutter_secure_storage.AndroidOptions(encryptedSharedPreferences: true)
    );
    await storage.delete(key: _notificationsKey);
    _notifications.clear();
    notifyListeners();
    // We optionally could delete from Firestore here, but UI might not expect a hard delete.
    // We'll leave it as a local clear for now to match old behavior.
  }

  @override
  void dispose() {
    _notifSubscription?.cancel();
    super.dispose();
  }
}