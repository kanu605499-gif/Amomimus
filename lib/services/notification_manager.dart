import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
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
      
      // Check for new notifications to play sound
      bool hasNewUnread = false;
      // We only care if it's not the initial load. If _notifications is empty, it's likely initial load.
      if (_notifications.isNotEmpty) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data();
            final isRead = data?['isRead'] == true || data?['isRead'] == 1;
            if (!isRead) {
              hasNewUnread = true;
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
      
      if (hasNewUnread) {
        AudioManager().playNotifAlert();
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
    } catch (e) {
      print('Error adding notification: $e');
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