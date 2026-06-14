import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../helpers/gender_helpers.dart';
import '../../models/user_indicator_model.dart';
import '../../services/account_manager.dart';
import '../particle_background.dart';

class ProfileIndicatorCard extends StatelessWidget {
  final dynamic user;
  final bool isDark;

  const ProfileIndicatorCard({
    super.key,
    required this.user,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final displayIndicator = context.read<AccountManager>().getDisplayIndicator(user.amomimusId, user.indicator);
    UserIndicator indicator = UserIndicatorHelper.fromValue(displayIndicator);
    String indicatorLabel = UserIndicatorHelper.getLabel(indicator);
    Color indicatorColor = UserIndicatorHelper.getColor(indicator);

    Color iconColor = GenderHelpers.getGenderColor(user.gender);
    IconData userIcon = GenderHelpers.getGenderIcon(user.gender);

    int particleCount = 20;
    double particleSpeed = 1.0;
    if (indicator == UserIndicator.ghost) {
      particleCount = 40;
      particleSpeed = 1.5;
    } else if (indicator == UserIndicator.noise) {
      particleCount = 60;
      particleSpeed = 2.0;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 120,
      decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration
          .copyWith(border: Border.all(color: indicatorColor, width: 2)),
      child: Stack(
        children: [
          // Background floating particles
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ParticleBackground(
                particleColor: indicatorColor,
                maxParticles: particleCount,
                particleSize: 4.0, // Bigger particles
                speedMultiplier: particleSpeed,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.amomimus_indicators,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      indicatorLabel,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        color:
                            indicatorColor == const Color(0xffE0E0E0) && !isDark
                            ? Colors.grey[600]
                            : indicatorColor,
                      ),
                    ),
                  ],
                ),
                Icon(userIcon, size: 36, color: iconColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
