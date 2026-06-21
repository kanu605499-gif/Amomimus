import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../helpers/gender_helpers.dart';
import '../effects/glitch_effect.dart';
import '../../services/account_manager.dart';
import 'presence_picker_capsule.dart';

class ProfileHeaderInfo extends StatelessWidget {
  final dynamic user;
  final bool isDark;
  final bool isOtherUser;
  final bool isLocked;

  const ProfileHeaderInfo({
    super.key,
    required this.user,
    required this.isDark,
    required this.isOtherUser,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    Color iconColor = GenderHelpers.getGenderColor(user.gender);
    IconData icon = GenderHelpers.getGenderIcon(user.gender);

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: iconColor, width: 2),
              ),
              child: Center(child: Icon(icon, size: 50, color: iconColor)),
            ),
            GestureDetector(
              onTap: !isOtherUser
                  ? () {
                      final box = context.findRenderObject() as RenderBox?;
                      if (box != null) {
                        PresencePickerCapsule.show(context, box);
                      }
                    }
                  : null,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AmomimusDarkTheme.backgroundDark
                        : Colors.white,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    color: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
                    child: PresencePickerCapsule.getPresenceIcon(
                      user.presenceStatus ?? 'auto',
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlitchEffect(
          isActive:
              !isLocked &&
              Provider.of<AccountManager>(
                context,
              ).isRecentlyUnblocked(user.amomimusId),
          child: Text(
            isLocked
                ? user.amomimusId
                : (!isOtherUser &&
                      user.customUsername != null &&
                      user.customUsername!.isNotEmpty)
                ? user.customUsername!
                : user.anonymousUsername,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AmomimusDarkTheme.policeLineYellow
                  : AmomimusDarkTheme.primaryPurple,
            ),
          ),
        ),
        if (!isLocked &&
            !isOtherUser &&
            user.customUsername != null &&
            user.customUsername!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            "${t.public_name}: ${user.anonymousUsername}",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
        if (!isLocked) ...[
          const SizedBox(height: 4),
          Text(
            user.amomimusId,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}
