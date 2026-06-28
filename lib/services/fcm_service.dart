import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles Firebase Cloud Messaging initialization, token management,
/// and foreground notification display for the Amomimus app.
class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'amomimus_high_importance',
    'Amomimus Notifications',
    description: 'Notifications for Amomimus app events',
    importance: Importance.high,
  );

  /// Initialize FCM: request permission, setup local notifications,
  /// and register foreground message handler.
  Future<void> init() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  /// Fetch FCM token and save it to Firestore under the user's document.
  Future<void> refreshToken(String amomimusId) async {
    try {
      final token = await _messaging.getToken();
      if (token != null && amomimusId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(amomimusId)
            .update({'fcmToken': token});
      }
    } catch (e) {
      debugPrint('==== FCM TOKEN REFRESH FAILED: $e ====');
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(amomimusId)
            .update({'fcmToken': newToken});
      } catch (e) {
        debugPrint('==== FCM TOKEN AUTO-REFRESH FAILED: $e ====');
      }
    });
  }

  /// Show a local notification banner when app is in foreground.
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    if (!Platform.isAndroid) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
      ),
    );
  }
}
