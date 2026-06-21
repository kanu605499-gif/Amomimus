import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../widgets/particle_background.dart';

class AppDocumentationScreen extends StatelessWidget {
  const AppDocumentationScreen({super.key});

  String _getDocTitle(int idx) {
    switch (idx) {
      case 1:
        return t.doc_rule_1_title;
      case 2:
        return t.doc_rule_2_title;
      case 3:
        return t.doc_rule_3_title;
      case 4:
        return t.doc_rule_4_title;
      case 5:
        return t.doc_rule_5_title;
      case 6:
        return t.doc_rule_6_title;
      case 7:
        return t.doc_rule_7_title;
      case 8:
        return t.doc_rule_8_title;
      case 9:
        return t.doc_rule_9_title;
      case 10:
        return t.doc_rule_10_title;
      default:
        return "";
    }
  }

  String _getDocDesc(int idx) {
    switch (idx) {
      case 1:
        return t.doc_rule_1_desc;
      case 2:
        return t.doc_rule_2_desc;
      case 3:
        return t.doc_rule_3_desc;
      case 4:
        return t.doc_rule_4_desc;
      case 5:
        return t.doc_rule_5_desc;
      case 6:
        return t.doc_rule_6_desc;
      case 7:
        return t.doc_rule_7_desc;
      case 8:
        return t.doc_rule_8_desc;
      case 9:
        return t.doc_rule_9_desc;
      case 10:
        return t.doc_rule_10_desc;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;

    final textColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final bgColor = isDark ? AmomimusDarkTheme.backgroundDark : Colors.white;
    final cardColor = isDark 
        ? Colors.white.withValues(alpha: 0.05) 
        : Colors.black.withValues(alpha: 0.03);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: ParticleBackground(
              particleColor: textColor.withValues(alpha: 0.15),
            ),
          ),
          Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  t.doc_title,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: textColor),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              t.doc_category_legal,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(10, (index) {
              final idx = index + 1;
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
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          iconColor: textColor,
                          collapsedIconColor: textColor.withValues(alpha: 0.7),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          title: Text(
                            _getDocTitle(idx),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _getDocDesc(idx),
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87.withValues(alpha: 0.7),
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
            }),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "© 2026 Amomimus. All Rights Reserved.",
                style: TextStyle(
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
