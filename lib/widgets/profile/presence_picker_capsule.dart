import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../amomimusdark.dart';
import '../../services/account_manager.dart';

class PresencePickerCapsule extends StatelessWidget {
  const PresencePickerCapsule({super.key});

  /// Displays the presence picker as a transparent popup menu near the caller's position.
  static void show(BuildContext context, RenderBox buttonRenderBox) {
    final size = buttonRenderBox.size;
    final position = buttonRenderBox.localToGlobal(Offset.zero);
    
    // We position the menu right below the indicator
    final topOffset = position.dy + size.height + 8;
    double leftOffset = position.dx - 80;
    if (leftOffset < 16) leftOffset = 16;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (leftOffset > screenWidth - 216) {
          leftOffset = screenWidth - 216;
        }

        return Stack(
          children: [
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: const Material(
                color: Colors.transparent,
                child: PresencePickerCapsule(),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutBack,
            )),
            child: child,
          ),
        );
      },
    );
  }

  static Widget getPresenceIcon(String status, {double size = 12}) {
    switch (status) {
      case 'dnd':
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: size * 0.6,
              height: size * 0.15,
              color: Colors.white,
            ),
          ),
        );
      case 'invisible':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: Colors.grey, width: 2),
          ),
        );
      case 'online':
      case 'auto':
      default:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final accountManager = context.watch<AccountManager>();
    final currentStatus = accountManager.currentUser?.presenceStatus ?? 'auto';

    final isDark = themeProvider.isDarkMode;
    // Make container yellow in dark theme, white in light theme
    final bgColor = isDark 
        ? AmomimusDarkTheme.policeLineYellow
        : Colors.white.withValues(alpha: 0.95);
    final borderColor = isDark 
        ? AmomimusDarkTheme.policeLineYellow
        : Colors.black.withValues(alpha: 0.1);
    // Dark text for both since background is yellow in dark mode and white in light mode
    final textColor = isDark ? Colors.black87 : Colors.black87;

    final options = [
      {'status': 'auto', 'label': 'Automatic'},
      {'status': 'online', 'label': 'Online'},
      {'status': 'dnd', 'label': 'Do Not Disturb'},
      {'status': 'invisible', 'label': 'Invisible'},
    ];

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((opt) {
              final status = opt['status']!;
              final isSelected = currentStatus == status;
              return InkWell(
                onTap: () {
                  context.read<AccountManager>().updatePresenceStatus(status);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  color: isSelected 
                      ? Colors.black.withValues(alpha: 0.1)
                      : Colors.transparent,
                  child: Row(
                    children: [
                      getPresenceIcon(status, size: 14),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          opt['label']!,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
