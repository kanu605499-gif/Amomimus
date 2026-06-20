import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../models/user_model.dart';
import '../../services/chatmodel.dart';
import '../../services/account_manager.dart';
import '../../services/chat_request_manager.dart';
import '../report_dialog.dart';
import 'package:amomimus/utils/jelly_dialog.dart';
import '../../screens/fake_pdf_screen.dart';

class RoomChatMiniIsland extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final AmomimusDarkTheme themeProvider;
  final Color dynamicHeaderColor;
  final IconData dynamicHeaderIcon;
  final UserAccount targetAccount;
  final String targetUsername;

  const RoomChatMiniIsland({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.themeProvider,
    required this.dynamicHeaderColor,
    required this.dynamicHeaderIcon,
    required this.targetAccount,
    required this.targetUsername,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final Color dynamicOutlineColor = themeProvider.isDarkMode
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black87.withValues(alpha: 0.15);

    final Color islandBg = themeProvider.isDarkMode
        ? Colors.black54
        : const Color.fromARGB(221, 255, 255, 255);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 46,
        width: isExpanded ? 192 : 46,
        decoration: BoxDecoration(
          color: islandBg,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: dynamicOutlineColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: themeProvider.isDarkMode ? 0.2 : 0.05,
              ),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            layoutBuilder:
                (topChild, topChildKey, bottomChild, bottomChildKey) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(key: bottomChildKey, child: bottomChild),
                      Positioned(key: topChildKey, child: topChild),
                    ],
                  );
                },
            firstChild: SizedBox(
              height: 44,
              width: 44,
              child: Center(
                child: Icon(
                  dynamicHeaderIcon,
                  color: dynamicHeaderColor,
                  size: 22,
                ),
              ),
            ),
            secondChild: Container(
              width: 192,
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        dynamicHeaderIcon,
                        color: dynamicHeaderColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(height: 18, width: 1, color: dynamicOutlineColor),
                    const SizedBox(width: 4),
                    // Theme Toggle
                    IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_round,
                        size: 20,
                      ),
                      color: themeProvider.isDarkMode
                          ? AmomimusDarkTheme.policeLineYellow
                          : AmomimusDarkTheme.primaryPurple,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                    ),
                    // Search / Document Button
                    IconButton(
                      icon: const Icon(Icons.search, size: 20),
                      color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                const FakePdfScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                    // Report Button
                    IconButton(
                      icon: const Icon(Icons.report_problem_outlined, size: 20),
                      color: Colors.orangeAccent,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      onPressed: () {
                        showJellyDialog(
                          context: context,
                          builder: (context) => ReportDialog(
                            targetId: targetUsername,
                            isUserReport: true,
                          ),
                        );
                      },
                    ),
                    // Delete Chat Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.redAccent,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      onPressed: () {
                        showJellyDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            final isDark = Provider.of<AmomimusDarkTheme>(
                              context,
                              listen: false,
                            ).isDarkMode;
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: isDark
                                  ? AmomimusDarkTheme.surfaceDark
                                  : Colors.white,
                              title: Text(
                                t.delete_chat_title,
                                style: const TextStyle(
                                  color: AmomimusDarkTheme.primaryPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                t.delete_chat_room_confirm,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: Text(
                                    t.cancel,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      dialogContext,
                                    ); // close dialog
                                    context.read<ChatModel>().deleteChatForUser(
                                      targetUsername,
                                    );
                                    context
                                        .read<ChatRequestManager>()
                                        .deleteRequestWith(targetUsername);
                                    Navigator.pop(context); // exit room
                                  },
                                  child: Text(
                                    t.delete,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
