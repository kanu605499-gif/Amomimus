import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/language/language_manager.dart';
import 'package:provider/provider.dart';

void showRightOptionsPanel(BuildContext context, bool isDark) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Options",
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return RightOptionsPanelContent(isDark: isDark);
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
  );
}

class RightOptionsPanelContent extends StatefulWidget {
  final bool isDark;
  
  const RightOptionsPanelContent({super.key, required this.isDark});

  @override
  State<RightOptionsPanelContent> createState() => _RightOptionsPanelContentState();
}

class _RightOptionsPanelContentState extends State<RightOptionsPanelContent> {
  @override
  Widget build(BuildContext context) {
    final currentLang = context.watch<LanguageManager>();
    
    return Align(
      alignment: Alignment.centerRight,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: double.infinity,
            decoration: BoxDecoration(
              color: widget.isDark ? AmomimusDarkTheme.surfaceDark.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
                  color: widget.isDark ? AmomimusDarkTheme.backgroundDark.withValues(alpha: 0.8) : Colors.grey[100]?.withValues(alpha: 0.9),
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined, color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple),
                      const SizedBox(width: 12),
                      Text(
                        currentLang.getString('options') == 'options' ? 'Options' : currentLang.getString('options'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: widget.isDark ? AmomimusDarkTheme.textSecondary : Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentLang.getString('language'),
                        style: TextStyle(
                          color: widget.isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                        ),
                      ),
                      DropdownButton<String>(
                        value: currentLang.dropdownValue,
                        dropdownColor: widget.isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                        style: TextStyle(
                          color: widget.isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                        ),
                        underline: const SizedBox(),
                        icon: Icon(Icons.arrow_drop_down, color: widget.isDark ? AmomimusDarkTheme.textSecondary : Colors.grey),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            currentLang.setLanguageFromDropdown(newValue);
                          }
                        },
                        items: <String>['Bahasa', 'English', '忍者', 'Tamriel']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.bug_report_outlined,
                    color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                  ),
                  title: Text(
                    currentLang.getString('report_bug'),
                    style: TextStyle(
                      color: widget.isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.contact_mail_outlined,
                    color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                  ),
                  title: Text(
                    currentLang.getString('contact_dev'),
                    style: TextStyle(
                      color: widget.isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
