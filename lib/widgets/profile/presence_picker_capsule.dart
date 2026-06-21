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
    // We center it horizontally relative to the indicator
    final leftOffset = position.dx - (120 / 2) + (size.width / 2);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: Material(
                color: Colors.transparent,
                child: const PresencePickerCapsule(),
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
        return Icon(Icons.do_not_disturb_on, color: Colors.redAccent, size: size);
      case 'invisible':
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
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
    final bgColor = isDark 
        ? Colors.black87.withValues(alpha: 0.8) 
        : Colors.white.withValues(alpha: 0.9);
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.1);
    final textColor = isDark ? Colors.white : Colors.black87;

    final options = [
      {'status': 'auto', 'label': 'Automatic'},
      {'status': 'online', 'label': 'Online'},
      {'status': 'dnd', 'label': 'Do Not Disturb'},
      {'status': 'invisible', 'label': 'Invisible'},
    ];

    return Container(
      width: 140,
      constraints: const BoxConstraints(maxHeight: 180),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
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
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: isSelected 
                        ? (isDark ? Colors.white10 : Colors.black12) 
                        : Colors.transparent,
                    child: Row(
                      children: [
                        getPresenceIcon(status, size: 14),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            opt['label']!,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
      ),
    );
  }
}
