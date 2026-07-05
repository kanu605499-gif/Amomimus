import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../amomimusdark.dart';

import '../report_bug_dialog.dart';
import '../../screens/contact_developers_screen.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../../services/preference_handler.dart';

class RightOptionsPanel extends StatefulWidget {
  final bool isDark;

  const RightOptionsPanel({super.key, required this.isDark});

  @override
  State<RightOptionsPanel> createState() => _RightOptionsPanelState();
}

class _RightOptionsPanelState extends State<RightOptionsPanel> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            color: widget.isDark
                ? AmomimusDarkTheme.backgroundDark.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.85),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: widget.isDark
                              ? AmomimusDarkTheme.policeLineYellow
                              : AmomimusDarkTheme.primaryPurple,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          t.options,
                          style: TextStyle(
                            color: widget.isDark
                                ? AmomimusDarkTheme.textPrimary
                                : Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: widget.isDark
                                ? AmomimusDarkTheme.textSecondary
                                : Colors.grey,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: widget.isDark ? Colors.white12 : Colors.black12,
                    height: 1,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.contact_mail_outlined,
                            color: widget.isDark
                                ? AmomimusDarkTheme.policeLineYellow
                                : AmomimusDarkTheme.primaryPurple,
                          ),
                          title: Text(
                            t.contact_dev,
                            style: TextStyle(
                              color: widget.isDark
                                  ? AmomimusDarkTheme.textPrimary
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactDevelopersScreen(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.bug_report_outlined,
                            color: widget.isDark
                                ? AmomimusDarkTheme.policeLineYellow
                                : AmomimusDarkTheme.primaryPurple,
                          ),
                          title: Text(
                            t.report_bug,
                            style: TextStyle(
                              color: widget.isDark
                                  ? AmomimusDarkTheme.textPrimary
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) => const ReportBugDialog(),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.language,
                            color: widget.isDark
                                ? AmomimusDarkTheme.policeLineYellow
                                : AmomimusDarkTheme.primaryPurple,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                t.language,
                                style: TextStyle(
                                  color: widget.isDark
                                      ? AmomimusDarkTheme.textPrimary
                                      : Colors.black,
                                ),
                              ),
                              PopupMenuButton<String>(
                                position: PopupMenuPosition.under,
                                color: widget.isDark
                                    ? AmomimusDarkTheme.surfaceDark
                                    : Colors.white,
                                constraints: const BoxConstraints(
                                  maxHeight: 156,
                                ),
                                initialValue: () {
                                  final loc = LocaleSettings.currentLocale;
                                  if (loc == AppLocale.id) return 'Bahasa';
                                  if (loc == AppLocale.ja) return '忍者';
                                  if (loc == AppLocale.de) return 'Deutsch';
                                  if (loc == AppLocale.th) return 'ภาษาไทย';
                                  if (loc == AppLocale.tamriel) return 'Tamriel';
                                  return 'English';
                                }(),
                                onSelected: (String newValue) {
                                  setState(() {
                                    if (newValue == 'Bahasa') {
                                      LocaleSettings.setLocale(AppLocale.id);
                                      PreferenceHandler.setLanguage('id');
                                    } else if (newValue == '忍者') {
                                      LocaleSettings.setLocale(AppLocale.ja);
                                      PreferenceHandler.setLanguage('ja');
                                    } else if (newValue == 'Deutsch') {
                                      LocaleSettings.setLocale(AppLocale.de);
                                      PreferenceHandler.setLanguage('de');
                                    } else if (newValue == 'ภาษาไทย') {
                                      LocaleSettings.setLocale(AppLocale.th);
                                      PreferenceHandler.setLanguage('th');
                                    } else if (newValue == 'Tamriel') {
                                      LocaleSettings.setLocale(AppLocale.tamriel);
                                      PreferenceHandler.setLanguage('tamriel');
                                    } else {
                                      LocaleSettings.setLocale(AppLocale.en);
                                      PreferenceHandler.setLanguage('en');
                                    }
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return <String>[
                                    'Bahasa',
                                    'Deutsch',
                                    'English',
                                    'ภาษาไทย',
                                    '忍者',
                                    'Tamriel',
                                  ].map((String value) {
                                    return PopupMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: widget.isDark
                                              ? AmomimusDarkTheme.textPrimary
                                              : Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      () {
                                        final loc =
                                            LocaleSettings.currentLocale;
                                        if (loc == AppLocale.id)
                                          return 'Bahasa';
                                        if (loc == AppLocale.ja) return '忍者';
                                        if (loc == AppLocale.de)
                                          return 'Deutsch';
                                        if (loc == AppLocale.th)
                                          return 'ภาษาไทย';
                                        if (loc == AppLocale.tamriel)
                                          return 'Tamriel';
                                        return 'English';
                                      }(),
                                      style: TextStyle(
                                        color: widget.isDark
                                            ? AmomimusDarkTheme.textPrimary
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: widget.isDark
                                          ? AmomimusDarkTheme.textSecondary
                                          : Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showRightOptionsPanel(BuildContext context, bool isDark) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'right_options',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: RightOptionsPanel(isDark: isDark),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: child,
      );
    },
  );
}
