import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../widgets/particle_background.dart';

class AppFeaturesScreen extends StatelessWidget {
  const AppFeaturesScreen({super.key});

  String _getAppFeatureTitle(int idx) {
    switch (idx) {
      case 1:
        return t.feature_1_title;
      case 2:
        return t.feature_2_title;
      case 3:
        return t.feature_3_title;
      case 4:
        return t.feature_4_title;
      case 5:
        return t.feature_5_title;
      default:
        return "";
    }
  }

  String _getAppFeatureDesc(int idx) {
    switch (idx) {
      case 1:
        return t.feature_1_desc;
      case 2:
        return t.feature_2_desc;
      case 3:
        return t.feature_3_desc;
      case 4:
        return t.feature_4_desc;
      case 5:
        return t.feature_5_desc;
      default:
        return "";
    }
  }

  String _getSystemFeatureTitle(int idx) {
    switch (idx) {
      case 1:
        return t.system_1_title;
      case 2:
        return t.system_2_title;
      case 3:
        return t.system_3_title;
      default:
        return "";
    }
  }

  String _getSystemFeatureDesc(int idx) {
    switch (idx) {
      case 1:
        return t.system_1_desc;
      case 2:
        return t.system_2_desc;
      case 3:
        return t.system_3_desc;
      default:
        return "";
    }
  }

  Widget _buildFeatureList(
      BuildContext context, int count, bool isSystem, Color textColor, Color cardColor, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: count,
      itemBuilder: (context, index) {
        final idx = index + 1;
        final title = isSystem ? _getSystemFeatureTitle(idx) : _getAppFeatureTitle(idx);
        final desc = isSystem ? _getSystemFeatureDesc(idx) : _getAppFeatureDesc(idx);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: textColor.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    iconColor: textColor,
                    collapsedIconColor: textColor.withValues(alpha: 0.7),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            desc,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isDark ? Colors.white70 : Colors.black87.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;

    final textColor = isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;
    final bgColor = isDark ? AmomimusDarkTheme.backgroundDark : Colors.white;
    final cardColor = isDark 
        ? Colors.white.withValues(alpha: 0.05) 
        : Colors.black.withValues(alpha: 0.03);
    final unselectedColor = isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.5);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: ParticleBackground(
              particleColor: textColor.withValues(alpha: 0.15),
            ),
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    t.app_features_title,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                  ),
                  bottom: TabBar(
                    labelColor: textColor,
                    unselectedLabelColor: unselectedColor,
                    indicatorColor: textColor,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(text: t.app_features_title),
                      Tab(text: t.system_features_title),
                    ],
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: TabBarView(
                      children: [
                        _buildFeatureList(context, 5, false, textColor, cardColor, isDark),
                        _buildFeatureList(context, 3, true, textColor, cardColor, isDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
