import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';
import 'package:amomimus/models/user_model.dart';
import 'package:amomimus/database/preference_handler.dart';
import 'package:amomimus/screens/login.dart'; // Verify this is correct for AmomimusApp2
import 'package:amomimus/screens/onboarding_screen.dart';
import 'package:amomimus/screens/sticker_shop_screen.dart';
import 'package:amomimus/helpers/gender_helpers.dart';
import 'package:amomimus/screens/splash_screen.dart';
import 'package:amomimus/screens/app_documentation_screen.dart';
import 'package:amomimus/screens/app_features_screen.dart';
import 'right_options_panel.dart';

class LeftDrawerMenu extends StatelessWidget {
  final UserAccount? currentUser;
  final bool isDark;

  const LeftDrawerMenu({
    super.key,
    required this.currentUser,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final headerColor = currentUser != null
        ? GenderHelpers.getGenderColor(currentUser!.gender)
        : AmomimusDarkTheme.primaryPurple;
    final isBright = headerColor.computeLuminance() > 0.5;
    final headerTextColor = isBright ? Colors.black87 : Colors.white;
    final subTextColor = isBright ? Colors.black54 : Colors.white70;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            color: isDark
                ? AmomimusDarkTheme.backgroundDark.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.85),
            child: Column(
              children: [
                Material(
                  color: headerColor,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 70, 24, 30),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 80,
                              height: 80,
                              color: Colors.white,
                              child: Icon(
                                currentUser != null
                                    ? GenderHelpers.getGenderIcon(
                                        currentUser!.gender,
                                      )
                                    : Icons.person,
                                size: 50,
                                color: headerColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentUser?.customUsername ??
                                currentUser?.anonymousUsername ??
                                "User",
                            style: TextStyle(
                              color: headerTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (currentUser != null &&
                              currentUser!.customUsername != null &&
                              currentUser!.customUsername!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              "${t.public_name}: ${currentUser!.anonymousUsername}",
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            currentUser?.amomimusId ?? "#AMM-000",
                            style: TextStyle(color: subTextColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.storefront_outlined,
                    color: isDark
                        ? AmomimusDarkTheme.policeLineYellow
                        : AmomimusDarkTheme.primaryPurple,
                  ),
                  title: Text(
                    t.sticker_shop,
                    style: TextStyle(
                      color: isDark
                          ? AmomimusDarkTheme.policeLineYellow
                          : AmomimusDarkTheme.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StickerShopScreen(),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Icon(
                    Icons.help_outline,
                    color: isDark
                        ? AmomimusDarkTheme.textSecondary
                        : Colors.grey,
                  ),
                  title: Text(
                    t.app_doc,
                    style: TextStyle(
                      color: isDark
                          ? AmomimusDarkTheme.textPrimary
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppDocumentationScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.stars_outlined,
                    color: isDark
                        ? AmomimusDarkTheme.textSecondary
                        : Colors.grey,
                  ),
                  title: Text(
                    t.app_features_title,
                    style: TextStyle(
                      color: isDark
                          ? AmomimusDarkTheme.textPrimary
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppFeaturesScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: isDark
                        ? AmomimusDarkTheme.textSecondary
                        : Colors.grey,
                  ),
                  title: Text(
                    t.how_it_works,
                    style: TextStyle(
                      color: isDark
                          ? AmomimusDarkTheme.textPrimary
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OnboardingScreen(fromDrawer: true),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings_outlined,
                    color: isDark
                        ? AmomimusDarkTheme.textSecondary
                        : Colors.grey,
                  ),
                  title: Text(
                    t.options,
                    style: TextStyle(
                      color: isDark
                          ? AmomimusDarkTheme.textPrimary
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // close left drawer
                    showRightOptionsPanel(
                      context,
                      isDark,
                    ); // slide in right panel
                  },
                ),
                const Spacer(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    t.exit,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            const SplashScreen(isShutdown: true),
                      ),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
