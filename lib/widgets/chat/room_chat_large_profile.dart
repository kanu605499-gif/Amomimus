import 'dart:math';
import 'package:flutter/material.dart';
import '../../amomimusdark.dart';
import '../../models/user_model.dart';
import '../../services/chatmodel.dart';
import '../../screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../services/account_manager.dart';
import '../effects/glitch_effect.dart';
import '../../screens/fake_pdf_screen.dart';

class RoomChatLargeProfile extends StatelessWidget {
  final AmomimusDarkTheme themeProvider;
  final bool isProfileMenuExpanded;
  final Animation<double> waveController;
  final String? targetUsername;
  final Color dynamicHeaderColor;
  final IconData dynamicHeaderIcon;
  final Color currentTextSecondary;
  final Color currentText;
  final Color currentBg;
  final UserAccount targetAccount;
  final ChatPreview activeChat;
  final VoidCallback onToggleProfileMenu;
  final Function(BuildContext, String, Color) onShowMemoriesPopup;
  final Function(BuildContext, String, Color) onShowChatLogPopup;
  final bool showResetGlitch;

  const RoomChatLargeProfile({
    super.key,
    required this.themeProvider,
    required this.isProfileMenuExpanded,
    required this.waveController,
    required this.targetUsername,
    required this.dynamicHeaderColor,
    required this.dynamicHeaderIcon,
    required this.currentTextSecondary,
    required this.currentText,
    required this.currentBg,
    required this.targetAccount,
    required this.activeChat,
    required this.onToggleProfileMenu,
    required this.onShowMemoriesPopup,
    required this.onShowChatLogPopup,
    this.showResetGlitch = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color uidColor = themeProvider.isDarkMode
        ? currentTextSecondary.withValues(alpha: 0.7)
        : Colors.black45;

    final accountManager = context.watch<AccountManager>();
    final isRecentlyUnblocked = targetUsername != null
        ? accountManager.isRecentlyUnblocked(targetUsername!)
        : false;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: GlitchEffect(
        isActive: isRecentlyUnblocked || showResetGlitch,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              width: 300,
              height: isProfileMenuExpanded ? 180 : 150,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                    // Left Button 1: Profile (Left)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      left: isProfileMenuExpanded ? 34 : 128,
                      top: isProfileMenuExpanded ? 53 : 53,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isProfileMenuExpanded ? 1.0 : 0.0,
                      child: AnimatedBuilder(
                        animation: waveController,
                        builder: (context, child) {
                          final offsetY = isProfileMenuExpanded
                              ? sin(waveController.value * 2 * pi) * 4
                              : 0.0;
                          return Transform.translate(
                            offset: Offset(0, offsetY),
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (!isProfileMenuExpanded) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(targetUserId: targetUsername),
                              ),
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkMode
                                  ? Colors.black54
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: dynamicHeaderColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: themeProvider.isDarkMode ? 0.3 : 0.1,
                                  ),
                                  blurRadius: 3,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: currentText,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Right Button 1: Memories (Right)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    left: isProfileMenuExpanded ? 222 : 128,
                    top: isProfileMenuExpanded ? 53 : 53,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isProfileMenuExpanded ? 1.0 : 0.0,
                      child: AnimatedBuilder(
                        animation: waveController,
                        builder: (context, child) {
                          final offsetY = isProfileMenuExpanded
                              ? cos(waveController.value * 2 * pi) * 4
                              : 0.0;
                          return Transform.translate(
                            offset: Offset(0, offsetY),
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (!isProfileMenuExpanded) return;
                            onShowMemoriesPopup(
                              context,
                              targetUsername ?? '@partner_dev',
                              dynamicHeaderColor,
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkMode
                                  ? Colors.black54
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: dynamicHeaderColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: themeProvider.isDarkMode ? 0.3 : 0.1,
                                  ),
                                  blurRadius: 3,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.cloud_outlined,
                              color: currentText,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Right Button 2: Chat Log (Bottom)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    left: isProfileMenuExpanded ? 128 : 128,
                    top: isProfileMenuExpanded ? 131 : 53,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isProfileMenuExpanded ? 1.0 : 0.0,
                      child: AnimatedBuilder(
                        animation: waveController,
                        builder: (context, child) {
                          final offsetY = isProfileMenuExpanded
                              ? cos(waveController.value * 2 * pi) * 4
                              : 0.0;
                          return Transform.translate(
                            offset: Offset(0, offsetY),
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (!isProfileMenuExpanded) return;
                            onShowChatLogPopup(
                              context,
                              targetUsername ?? '@partner_dev',
                              dynamicHeaderColor,
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkMode
                                  ? Colors.black54
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: dynamicHeaderColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: themeProvider.isDarkMode ? 0.3 : 0.1,
                                  ),
                                  blurRadius: 3,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.history,
                              color: currentText,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Main Avatar
                  Positioned(
                    left: 106,
                    top: 31,
                    child: GestureDetector(
                      onTap: onToggleProfileMenu,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: currentBg, // add bg so shadow doesn't show through
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: dynamicHeaderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        dynamicHeaderIcon,
                        color: dynamicHeaderColor,
                        size: 46,
                      ),
                      ),
                    ),
                  ),
                  // if (activeChat.isOnline) -> Assuming there's a way to check if online
                  // (Omitted isOnline as it may depend on a specific chat model definition, but I can add it if `activeChat` has it)
                ],
              ),
            ),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(
                0,
                isProfileMenuExpanded ? 48.0 : 0.0,
                0,
              ),
              child: Column(
                children: [
                  Text(
                    (targetAccount.anonymousUsername.isNotEmpty)
                        ? targetAccount.anonymousUsername
                        : targetUsername ?? "Unknown",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    targetUsername ?? "@partner_dev",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: uidColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
