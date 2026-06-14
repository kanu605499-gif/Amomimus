import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';

class ChatHomeMiniIsland extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final AmomimusDarkTheme themeProvider;
  final Color currentSurface;
  final Color dynamicAccentColor;

  const ChatHomeMiniIsland({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.themeProvider,
    required this.currentSurface,
    required this.dynamicAccentColor,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final Color dynamicOutlineColor = themeProvider.isDarkMode
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black87.withValues(alpha: 0.15);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 46,
        width: isExpanded ? 180 : 46,
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? currentSurface.withValues(alpha: 0.9)
              : Colors.grey[100]!.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: dynamicOutlineColor, width: 1.2),
        ),
        child: isExpanded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    t.messages,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.wb_sunny_rounded
                          : Icons.nightlight_round,
                      size: 16,
                    ),
                    color: dynamicAccentColor,
                    onPressed: () =>
                        context.read<AmomimusDarkTheme>().toggleTheme(),
                  ),
                ],
              )
            : Center(
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: dynamicAccentColor,
                  size: 20,
                ),
              ),
      ),
    );
  }
}
