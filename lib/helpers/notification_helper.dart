import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('launcher_icon');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  static Future<void> showRealtimeNotification({required String title, required String body}) async {
    await initialize();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'realtime_notifs_channel',
      'Realtime Notifications',
      channelDescription: 'Instant notifications for chats and interactions',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      sound: RawResourceAndroidNotificationSound('notif_alert'),
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await _plugin.show(
      Random().nextInt(100000), // Random ID so they don't overwrite each other
      title,
      body,
      platformDetails,
    );
  }
}
