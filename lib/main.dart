import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/services/chatmodel.dart';
import 'package:amomimus/services/account_manager.dart';
import 'package:amomimus/services/preference_handler.dart';
import 'package:amomimus/screens/splash_screen.dart'; // Add SplashScreen
import 'package:amomimus/widgets/update_checker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:amomimus/services/auth_service.dart';
import 'package:amomimus/services/firebase_auth_service.dart';

import 'package:amomimus/services/feed_manager.dart';
import 'package:amomimus/services/chat_request_manager.dart';
import 'package:amomimus/services/notification_manager.dart';
import 'package:amomimus/helpers/notification_helper.dart';

import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

Future<void> runAmomimusApp(FirebaseOptions options) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: options,
  );
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Tangkap sinyal FCM saat aplikasi sedang terbuka di layar (Foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      NotificationHelper.showRealtimeNotification(
        title: message.notification!.title ?? 'Amomimus',
        body: message.notification!.body ?? '',
      );
    }
  });
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  await initializeDateFormatting('id_ID', null);
  await PreferenceHandler.init();

  final savedLang = PreferenceHandler.language;
  if (savedLang != null) {
    if (savedLang == 'tm') {
      LocaleSettings.setLocaleRaw('tamriel');
      PreferenceHandler.setLanguage('tamriel');
    } else {
      LocaleSettings.setLocaleRaw(savedLang);
    }
  } else {
    LocaleSettings.useDeviceLocale();
  }

  runApp(
    TranslationProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AmomimusDarkTheme()),
          Provider<AuthService>(create: (_) => FirebaseAuthService()),
          ChangeNotifierProxyProvider<AuthService, AccountManager>(
            create: (context) =>
                AccountManager(authService: context.read<AuthService>())
                  ..loadAccounts(),
            update: (context, authService, previous) =>
                previous ?? AccountManager(authService: authService)
                  ..loadAccounts(),
          ),
          ChangeNotifierProxyProvider<AccountManager, ChatModel>(
            create: (context) => ChatModel(),
            update: (context, auth, chatModel) {
              if (auth.currentUser != null) {
                chatModel!.setCurrentUser(
                  auth.currentUser!.amomimusId,
                  auth.currentUser!.anonymousUsername,
                );
                chatModel.setLocalAccountIds(
                  auth.accounts
                      .where((a) => a.masterEmail == auth.currentUser!.masterEmail)
                      .map((a) => a.amomimusId)
                      .toList(),
                );
              }
              return chatModel!;
            },
          ),
          ChangeNotifierProxyProvider<AccountManager, ChatRequestManager>(
            create: (context) => ChatRequestManager(),
            update: (context, auth, reqModel) {
              if (auth.currentUser != null) {
                reqModel!.setCurrentUser(
                  auth.currentUser!.amomimusId,
                  auth.accounts
                      .where((a) => a.masterEmail == auth.currentUser!.masterEmail)
                      .map((a) => a.amomimusId)
                      .toList(),
                );
              }
              return reqModel!;
            },
          ),
          ChangeNotifierProvider(
            create: (context) => FeedManager()..loadFeeds(),
          ),
          ChangeNotifierProxyProvider<AccountManager, NotificationManager>(
            create: (context) => NotificationManager()..loadNotifications(),
            update: (context, auth, notifManager) {
              if (auth.currentUser != null) {
                notifManager!.setCurrentUser(auth.currentUser!.amomimusId);
              }
              return notifManager!;
            },
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXED: Wrap MaterialApp in a Consumer to guarantee responsive UI updates
    return Consumer<AmomimusDarkTheme>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: globalNavigatorKey,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [updateNavigatorObserver],
          builder: (context, child) {
            return CustomUpdateChecker(
              navigatorKey: globalNavigatorKey,
              child: child!,
            );
          },

          // FIXED: Use the dynamic instance getter we fixed earlier!
          theme: themeProvider.currentThemeData,

          // Always start with SplashScreen to handle proper session checking
          home: const SplashScreen(),
        );
      },
    );
  }
}
