import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onBackToPrivacy;

  const AboutPage({super.key, required this.isDarkMode, this.onBackToPrivacy});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final Color mainTextColor = isDarkMode
        ? Colors.white
        : const Color(0xff121212);
    final Color subTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;
    final Color cardBg = isDarkMode ? const Color(0xff1e1b24) : Colors.white;
    final Color borderColor = isDarkMode
        ? const Color(0xff3d344d)
        : const Color(0xffe1dbec);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (onBackToPrivacy != null) {
          onBackToPrivacy!();
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.alternate_email_outlined,
                  size: 64,
                  color: Color(0xff8c72c4),
                ),
                const SizedBox(height: 16),
                Text(
                  t.mobile_app,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.app_desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: subTextColor,
                    height: 1.4,
                  ),
                ),
                const Divider(height: 32, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.developer,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: mainTextColor,
                      ),
                    ),
                    const Text(
                      'Diata',
                      style: TextStyle(
                        color: Color(0xff8c72c4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.app_version,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: mainTextColor,
                      ),
                    ),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final versionStr = snapshot.hasData 
                            ? 'v${snapshot.data!.version}+${snapshot.data!.buildNumber}' 
                            : 'v...';
                        return Text(
                          versionStr,
                          style: const TextStyle(color: Color(0xfff1c66a)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
