import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification_model.dart';
import '../i18n/strings.g.dart';

@pragma('vm:entry-point')
Future<void> amowSummaryTask() async {
  // Ensure Flutter engine is initialized in the background
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase init error in background: $e');
  }
  
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('savedAmomimusId');
  if (userId == null || userId.isEmpty) return;

  // Initialize Slang translation based on device locale
  LocaleSettings.useDeviceLocale();

  final firestore = FirebaseFirestore.instance;
  final notificationsRef = firestore
      .collection('users')
      .doc(userId)
      .collection('notifications');

  // Query unread and not notified locally
  final snapshot = await notificationsRef
      .where('isRead', isEqualTo: false)
      .where('notifiedLocally', isEqualTo: false)
      .get();

  if (snapshot.docs.isEmpty) {
    // Show empty summary
    await _showLocalNotification(
      t.amow_summary_title, 
      t.amow_summary_empty,
    );
    return;
  }

  int chatCount = 0;
  int commentCount = 0;
  int resonateCount = 0;
  
  for (var doc in snapshot.docs) {
    final notif = NotificationModel.fromMap(doc.data());
    if (notif.type == NotificationType.chat || notif.type == NotificationType.chatRequest) {
      chatCount++;
    } else if (notif.type == NotificationType.comment || notif.type == NotificationType.reply) {
      commentCount++;
    } else if (notif.type == NotificationType.resonate) {
      resonateCount++;
    }
  }

  // Update them in Firestore so they don't get notified again
  final batch = firestore.batch();
  for (var doc in snapshot.docs) {
    batch.update(doc.reference, {'notifiedLocally': true});
  }
  await batch.commit();

  // Prepare message
  final title = t.amow_summary_title;
  final body = t.amow_summary_body(
    chat: chatCount,
    comment: commentCount,
    resonate: resonateCount,
  );

  await _showLocalNotification(title, body);
}

Future<void> _showLocalNotification(String title, String body) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Using the app icon
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launcher_icon');
      
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
  );
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'amow_summary_channel',
    'Amow Summaries',
    channelDescription: 'Daily summaries of your notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    sound: RawResourceAndroidNotificationSound('splash_sound'),
  );
  
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      
  await flutterLocalNotificationsPlugin.show(
    0, // ID 0 will overwrite previous summaries (which is good)
    title,
    body,
    platformChannelSpecifics,
  );
}
