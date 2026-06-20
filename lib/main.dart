import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/services/chatmodel.dart';
import 'package:amomimus/services/account_manager.dart';
import 'package:amomimus/database/preference_handler.dart';
import 'package:amomimus/screens/splash_screen.dart'; // Add SplashScreen
import 'package:provider/provider.dart';

import 'package:amomimus/services/auth_service.dart';
import 'package:amomimus/services/local_auth_service.dart';

import 'package:amomimus/services/feed_manager.dart';
import 'package:amomimus/services/chat_request_manager.dart';
import 'package:amomimus/services/notification_manager.dart';

import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    LocaleSettings.setLocaleRaw(savedLang);
  } else {
    LocaleSettings.useDeviceLocale();
  }

  runApp(
    TranslationProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AmomimusDarkTheme()),
          Provider<AuthService>(create: (_) => LocalAuthService()),
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
              }
              return chatModel!;
            },
          ),
          ChangeNotifierProxyProvider<AccountManager, ChatRequestManager>(
            create: (context) => ChatRequestManager(),
            update: (context, auth, reqModel) {
              if (auth.currentUser != null) {
                reqModel!.setCurrentUser(auth.currentUser!.amomimusId);
              }
              return reqModel!;
            },
          ),
          ChangeNotifierProvider(
            create: (context) => FeedManager()..loadFeeds(),
          ),
          ChangeNotifierProvider(
            create: (context) => NotificationManager()..loadNotifications(),
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
          debugShowCheckedModeBanner: false,

          // FIXED: Use the dynamic instance getter we fixed earlier!
          theme: themeProvider.currentThemeData,

          // Always start with SplashScreen to handle proper session checking
          home: const SplashScreen(),
        );
      },
    );
  }
}
