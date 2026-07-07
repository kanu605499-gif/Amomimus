import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../services/chat_request_manager.dart';
import 'chat_home_requests_sheet.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../../services/account_manager.dart';

class ChatHomeRequestsCard extends StatelessWidget {
  final AnimationController pulseController;
  final AmomimusDarkTheme themeProvider;
  final Color dynamicAccentColor;

  const ChatHomeRequestsCard({
    super.key,
    required this.pulseController,
    required this.themeProvider,
    required this.dynamicAccentColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Consumer<ChatRequestManager>(
      builder: (context, reqManager, child) {
        final accountManager = context.read<AccountManager>();
        final blockedUsers = accountManager.currentUser?.blockedUsers ?? [];
        final blockedBy = accountManager.currentUser?.blockedBy ?? [];

        final incomingReqs = reqManager.incomingRequests.where((req) {
          return !blockedUsers.contains(req.senderId) && !blockedBy.contains(req.senderId);
        }).toList();
        if (incomingReqs.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        final totalReqs = incomingReqs.length;

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            child: InkWell(
              onTap: () => showRequestsBottomSheet(
                context,
                reqManager,
                themeProvider,
              ),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? AmomimusDarkTheme.surfaceDark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: dynamicAccentColor.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: pulseController,
                      builder: (context, child) {
                        final double angle = sin(pulseController.value * 3.14159 * 20) * 0.15;
                        return Transform.rotate(angle: angle, child: child);
                      },
                      child: Icon(
                        Icons.mark_email_unread_rounded,
                        color: dynamicAccentColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${t.chat_requests} ($totalReqs)',
                        style: TextStyle(
                          color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: dynamicAccentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: themeProvider.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
